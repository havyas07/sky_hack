import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sky_hack/constants.dart';

// FIX: Updated data model for fill-in-the-blank questions
class _QuizQuestion {
  final String question;
  final String answer;

  _QuizQuestion({
    required this.question,
    required this.answer,
  });
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<_QuizQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _isLoading = true;
  String _errorMessage = '';

  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchQuizQuestions();
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  Future<void> _fetchQuizQuestions() async {
    final apiKey = dotenv.env['COHERE_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      setState(() {
        _errorMessage = "API key not found. Please add COHERE_API_KEY to your .env file.";
        _isLoading = false;
      });
      return;
    }

    // FIX: Updated prompt for fill-in-the-blank questions
    const String prompt =
        'Generate a clean JSON array of 5 unique, space-themed fill-in-the-blank quiz questions. Each question MUST be a JSON object with two keys: "question" (a string) and "answer" (a short, one or two-word string answer). Do not include any text or characters outside of the main JSON array.';

    try {
      final response = await http.post(
        Uri.parse('https://api.cohere.ai/v1/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'message': prompt,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final text = body['text'];

        final jsonString = text.replaceAll("```json", "").replaceAll("```", "").trim();
        final questionsJson = jsonDecode(jsonString) as List;

        setState(() {
          _questions = questionsJson.map((q) {
            return _QuizQuestion(
              question: q['question'],
              answer: q['answer'], // Use 'answer' instead of 'correctAnswer'
            );
          }).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load quiz data: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error fetching quiz: $e";
        _isLoading = false;
      });
    }
  }

  // FIX: Logic to check the typed answer
  void _submitAnswer() {
    final userAnswer = _answerController.text.trim();
    if (userAnswer.toLowerCase() == _questions[_currentQuestionIndex].answer.toLowerCase()) {
      _score++;
    }
    _answerController.clear();

    setState(() {
      _currentQuestionIndex++;
    });
  }

  void _resetQuiz() {
    setState(() {
      _currentQuestionIndex = 0;
      _score = 0;
      _isLoading = true;
      _errorMessage = '';
      _fetchQuizQuestions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SPACE QUIZ')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kNeonBlue))
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(_errorMessage, style: const TextStyle(color: Colors.redAccent), textAlign: TextAlign.center),
                ))
              : _currentQuestionIndex < _questions.length
                  ? _buildQuizView()
                  : _buildScoreView(),
    );
  }

  // FIX: Updated UI with a TextField and Submit button
  Widget _buildQuizView() {
    final question = _questions[_currentQuestionIndex];
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${_currentQuestionIndex + 1}/${_questions.length}',
            style: const TextStyle(color: kNeonGreen, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            question.question,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _answerController,
            decoration: const InputDecoration(labelText: 'Your Answer'),
            onSubmitted: (_) => _submitAnswer(),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitAnswer,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('SUBMIT'),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Quiz Complete!', style: TextStyle(fontSize: 32, color: kAquaGlow, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Text('Your Score: $_score / ${_questions.length}', style: const TextStyle(fontSize: 24, color: Colors.white)),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: _resetQuiz,
            icon: const Icon(Icons.refresh),
            label: const Text('Take Another Quiz'),
          ),
        ],
      ),
    );
  }
}
