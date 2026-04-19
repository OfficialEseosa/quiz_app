import 'package:flutter/material.dart';
import 'api_service.dart';
import 'question.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final ApiService _apiService = ApiService();

  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _answered = false;
  String? _selectedAnswer;
  bool _isLoading = true;
  String? _errorMessage;

  static const Color _background = Color(0xFF1A237E);

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final questions = await _apiService.fetchQuestions();
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not load questions. Check your connection.';
        _isLoading = false;
      });
    }
  }

  void _handleAnswer(String selected) {
    if (_answered) return;
    setState(() {
      _answered = true;
      _selectedAnswer = selected;
      if (selected == _questions[_currentQuestionIndex].correctAnswer) {
        _score++;
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _answered = false;
      _selectedAnswer = null;
      _questions = [];
    });
    _loadQuestions();
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _answered = false;
        _selectedAnswer = null;
      });
    } else {
      setState(() {
        _currentQuestionIndex = _questions.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: _background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Loading questions...',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (_currentQuestionIndex >= _questions.length && _questions.isNotEmpty) {
      final percentage = (_score / _questions.length * 100).round();
      return Scaffold(
        backgroundColor: _background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber, size: 80),
                const SizedBox(height: 24),
                const Text(
                  'Quiz Complete!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '$_score / ${_questions.length}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  '$percentage%',
                  style: TextStyle(
                    color: percentage >= 70
                        ? Colors.greenAccent
                        : Colors.orangeAccent,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  percentage >= 70 ? 'Great job!' : 'Keep practising!',
                  style:
                      const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _restartQuiz,
                  icon: const Icon(Icons.replay),
                  label: const Text('Play Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        backgroundColor: _background,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, color: Colors.white70, size: 56),
                const SizedBox(height: 16),
                const Text(
                  'Could not load questions',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _loadQuestions,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Score: $_score',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_currentQuestionIndex + 1} / ${_questions.length}',
                style:
                    const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestionIndex + 1) / _questions.length,
              backgroundColor: Colors.white24,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 20),
            Card(
              color: Colors.white.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  question.question,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ...question.options.map((option) {
              Color bgColor = Colors.white.withValues(alpha: 0.15);
              Color fgColor = Colors.white;
              if (_answered) {
                if (option == question.correctAnswer) {
                  bgColor = Colors.green.shade600;
                } else if (option == _selectedAnswer) {
                  bgColor = Colors.red.shade600;
                }
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ElevatedButton(
                  onPressed:
                      _answered ? null : () => _handleAnswer(option),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor,
                    foregroundColor: fgColor,
                    disabledBackgroundColor: bgColor,
                    disabledForegroundColor: fgColor,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    textStyle: const TextStyle(fontSize: 15),
                  ),
                  child: Text(option),
                ),
              );
            }),
            if (_answered) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _nextQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: Text(
                  _currentQuestionIndex < _questions.length - 1
                      ? 'Next Question'
                      : 'See Results',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
