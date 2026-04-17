import 'package:html_unescape/html_unescape.dart';

class Question {
  final String question;
  final String correctAnswer;
  final List<String> options;

  Question({
    required this.question,
    required this.correctAnswer,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final unescape = HtmlUnescape();

    final correct = unescape.convert(json['correct_answer'] as String);

    List<String> allOptions = (json['incorrect_answers'] as List<dynamic>)
        .map((s) => unescape.convert(s as String))
        .toList();
    allOptions.add(correct);
    allOptions.shuffle();

    return Question(
      question: unescape.convert(json['question'] as String),
      correctAnswer: correct,
      options: allOptions,
    );
  }
}
