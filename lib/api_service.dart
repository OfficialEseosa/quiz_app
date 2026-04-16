import 'dart:convert';
import 'package:http/http.dart' as http;
import 'question.dart';

class ApiService {
  static const String _baseUrl = 'https://opentdb.com/api.php';
  static const String _queryParams =
      '?amount=10&category=9&difficulty=easy&type=multiple';
}
