import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question.dart';

class ApiService {
  static const String _baseUrl = 'https://opentdb.com/api.php';
  static const String _queryParams =
      '?amount=10&category=9&difficulty=easy&type=multiple';

  Future<List<Question>> fetchQuestions() async {
    try {
      final uri = Uri.parse('$_baseUrl$_queryParams');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>;
        return results
            .map((item) => Question.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch questions: $e');
    }
  }
}
