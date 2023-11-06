import 'package:Quiziq/screens/homescreen.dart';
import 'package:Quiziq/screens/results.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Providers extends ChangeNotifier {
  Color _currentColor = Colors.blue;
  Color get currentColor => _currentColor;

  int currentQuestionIndex = 0;
  int score = 0;
  bool isCorrect = false;
  bool showingCorrectAnswer = false;
  String selectedAnswer = "";
  List<Map<String, dynamic>> quizData = []; // Your quiz data goes here

  void handleAnswer(String selectedAnswer) {
    if (currentQuestionIndex < quizData.length) {
      final correctAnswer =
          quizData[currentQuestionIndex]['correctanswer'] as String;
      final isAnswerCorrect = selectedAnswer == correctAnswer;

      isCorrect = isAnswerCorrect;
      showingCorrectAnswer = true;
      this.selectedAnswer = selectedAnswer;

      if (!isAnswerCorrect) {
        // Vibrate when the answer is incorrect
        Vibration.vibrate(duration: 500);
      }

      if (isAnswerCorrect) {
        score += 10;
      }

      Future.delayed(
        Duration(seconds: 1),
        () {
          currentQuestionIndex++;
          showingCorrectAnswer = false;
          this.selectedAnswer = "";

          if (currentQuestionIndex == quizData.length) {
            // You can add your navigation logic here or call a function to navigate.
          }

          notifyListeners(); // Notify listeners to rebuild the UI
        },
      );
    }
  }

  void changeColor(Color newColor) {
    _currentColor = newColor;
    notifyListeners();
  }

  Future<void> getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final storedCategories = prefs.getStringList('storedCategories') ?? [];
    categories = storedCategories;
    notifyListeners();
  }

  void getUsername() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    username = logindata.getString('username') ?? "";
    notifyListeners();
  }

  Future<void> getUserScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userScoresString = prefs.getString('user_scores');
    if (userScoresString != null) {
      userScores =
          userScoresString.split(',').map((s) => int.tryParse(s) ?? 0).toList();
    }
    notifyListeners();
  }

  Future<void> loadStoredTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTimesList = prefs.getStringList('storedTimes');
    storedTimes = storedTimesList ?? []; // Initialize as an empty list if null
    notifyListeners();
  }

  // void clearResults() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove('user_scores');
  //   prefs.remove('category');
  //   prefs.remove('storedTimes');
  //   userScores.clear();
  //   categories.clear;
  //   storedTimes.clear();
  //   notifyListeners();
  // }

  void sortResults(String option) {
    var sortByOption = option;
    if (sortByOption == 'Normal') {
      // Sort in normal order
      storedTimes.sort();
    } else {
      // Sort by last played (descending order)
      storedTimes.sort((a, b) => b.compareTo(a));
    }
    notifyListeners();
  }
}

class UserPreferencesProvider extends ChangeNotifier {
  late SharedPreferences logindata;

  UserPreferencesProvider() {
    initialize();
  }

  String? _username;

  String? get username => _username;

  void initialize() async {
    logindata = await SharedPreferences.getInstance();
    _username = logindata.getString('username');
    notifyListeners();
  }

  Future<void> saveUsername(String newUsername) async {
    logindata.setString('username', newUsername);
    _username = newUsername;
    notifyListeners();
  }
}
