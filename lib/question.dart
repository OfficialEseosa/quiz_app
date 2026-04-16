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
    List<String> allOptions = List<String>.from(json['incorrect_answers']);
    allOptions.add(json['correct_answer'] as String);
    allOptions.shuffle();

    return Question(
      question: json['question'] as String,
      correctAnswer: json['correct_answer'] as String,
      options: allOptions,
    );
  }
}
