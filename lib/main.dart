import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class Quiz {
  String title;
  List<Question> questions;

  Quiz({required this.title, required this.questions});
}

class Question {
  String text;
  List<String> options;
  int correctOptionIndex;

  Question({required this.text, required this.options, required this.correctOptionIndex});
}

class UserAnswer {
  int questionIndex;
  int selectedOptionIndex;

  UserAnswer({required this.questionIndex, required this.selectedOptionIndex});
}

class Result {
  int correctAnswers;
  int totalQuestions;

  Result({required this.correctAnswers, required this.totalQuestions});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Quiz> quizzes = [
    Quiz(
      title: 'General Knowledge',
      questions: [
        Question(
          text: 'What is the capital of France?',
          options: ['Berlin', 'Madrid', 'Paris', 'London'],
          correctOptionIndex: 2,
        ),
        Question(
          text: 'Which planet is known as the Red Planet?',
          options: ['Mars', 'Venus', 'Jupiter', 'Saturn'],
          correctOptionIndex: 0,
        ),
        Question(
          text: 'In which year did World War II end?',
          options: ['1943', '1945', '1947', '1950'],
          correctOptionIndex: 1,
        ),
        Question(
          text: 'Who wrote the play "Romeo and Juliet"?',
          options: ['Charles Dickens', 'William Shakespeare', 'Jane Austen', 'Leo Tolstoy'],
          correctOptionIndex: 1,
        ),
        Question(
          text: 'What is the largest mammal on Earth?',
          options: ['Elephant', 'Blue Whale', 'Giraffe', 'Polar Bear'],
          correctOptionIndex: 1,
        ),
        // Add more questions as needed
      ],
    ),
    // Add more quizzes as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: ListView.builder(
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(quizzes[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(quiz: quizzes[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  final Quiz quiz;

  QuizScreen({required this.quiz});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  List<UserAnswer?> userAnswers = [];

  void submitAnswer(int selectedOptionIndex) {
    setState(() {
      userAnswers.add(UserAnswer(
        questionIndex: currentQuestionIndex,
        selectedOptionIndex: selectedOptionIndex,
      ));
      if (currentQuestionIndex < widget.quiz.questions.length - 1) {
        currentQuestionIndex++;
      } else {
        // User has completed all questions
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(
              quiz: widget.quiz,
              userAnswers: userAnswers,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Question currentQuestion = widget.quiz.questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz: ${widget.quiz.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${widget.quiz.questions.length}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 8),
            Text(
              currentQuestion.text,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Column(
              children: List.generate(
                currentQuestion.options.length,
                    (index) => ListTile(
                  title: Text(currentQuestion.options[index]),
                  onTap: () {
                    submitAnswer(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final Quiz quiz;
  final List<UserAnswer?> userAnswers;

  ResultScreen({required this.quiz, required this.userAnswers});

  Result calculateResult() {
    int correctAnswers = 0;
    for (int i = 0; i < quiz.questions.length; i++) {
      if (userAnswers[i]?.selectedOptionIndex == quiz.questions[i].correctOptionIndex) {
        correctAnswers++;
      }
    }

    return Result(correctAnswers: correctAnswers, totalQuestions: quiz.questions.length);
  }

  @override
  Widget build(BuildContext context) {
    Result result = calculateResult();

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You scored ${result.correctAnswers} out of ${result.totalQuestions}!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
