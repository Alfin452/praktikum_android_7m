import 'package:flutter/material.dart';
import 'package:praktikum_android_7m/home_screen.dart';
import 'package:praktikum_android_7m/profile.dart';
import 'package:praktikum_android_7m/question_screen.dart';
import 'package:praktikum_android_7m/result_screen.dart';
import 'package:praktikum_android_7m/services/question_api_service.dart';
import 'package:praktikum_android_7m/models/quiz_question.dart';

class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  var activeScreen = 'start-screen';
  List<String> selectedAnswer = [];
  List<QuizQuestion> questions = [];
  bool isLoading = false;
  String? errorMessage;

  void chooseAnswer(String answer) {
    selectedAnswer.add(answer);

    if (selectedAnswer.length == questions.length) {
      setState(() {
        activeScreen = 'result-screen';
      });
    }
  }
  Future<void> switchScreen() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final apiService = QuestionApiService();
      final fetchedQuestions = await apiService.fetchQuestions();

      setState(() {
        questions = fetchedQuestions;
        activeScreen = 'questions-screen';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load questions: $e';
        isLoading = false;
      });
    }
  }
  Future<void> restartQuiz() async {
    setState(() {
      selectedAnswer = [];
      isLoading = true;
      errorMessage = null;
    });

    try {
      final apiService = QuestionApiService();
      final fetchedQuestions = await apiService.fetchQuestions();

      setState(() {
        questions = fetchedQuestions;
        activeScreen = 'questions-screen';
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load questions: $e';
        isLoading = false;
      });
    }
  }
  void profileScreen() {
    setState(() {
      selectedAnswer = [];
      activeScreen = 'profile-screen';
    });
  }
  @override
  Widget build(context) {
    Widget screenWidget;

    if (isLoading) {
      screenWidget = const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    } else if (errorMessage != null) {
      screenWidget = Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    errorMessage = null;
                  });
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      );
    } else {
      screenWidget = HomeScreen(
        startQuiz: switchScreen,
        profile: profileScreen,
      );
    }
    if (!isLoading && errorMessage == null) {
      if (activeScreen == 'questions-screen') {
        screenWidget = QuestionsScreen(
          onSelectedAnswer: chooseAnswer, 
          questions: questions,
        );
      }

      if (activeScreen == 'result-screen') {
        screenWidget = ResultScreen(
          chosenAnswers: selectedAnswer, 
          onRestart: restartQuiz,
          questions: questions,
        );
      }

      if (activeScreen == 'profile-screen') {
        screenWidget = const Profile();
      }
    }

    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.deepPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}