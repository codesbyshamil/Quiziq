import 'package:Quiz/screens/results.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Quiz/screens/homescreen.dart';
import 'package:intl/intl.dart';

class ScorePage extends StatefulWidget {
  final int score;
  final String category;
  final Function() resetQuiz;

  ScorePage({
    required this.score,
    required this.category,
    required this.resetQuiz,
  });

  @override
  _ScorePageState createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  bool _isMounted = true;
  List<int> userScores = [];
  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (_isMounted) {
      saveQuizResult();
      // saveCategory();
      storeTime();
      TotalScore();
      addCategory();
    }
  }

  Future<void> saveQuizResult() async {
    if (_isMounted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userScoresString = prefs.getString('user_scores');

      if (userScoresString != null) {
        userScores = userScoresString
            .split(',')
            .map((s) => int.tryParse(s) ?? 0)
            .toList();
      }
      userScores.add(widget.score);

      prefs.setString('user_scores', userScores.join(','));
    }
  }

  Future<void> addCategory() async {
    final prefs = await SharedPreferences.getInstance();
    final storedCategories = prefs.getStringList('storedCategories') ?? [];
    storedCategories.add(widget.category);
    await prefs.setStringList('storedCategories', storedCategories);
  }

  Future<void> TotalScore() async {
    if (_isMounted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int totalScore = prefs.getInt('total_score') ?? 0;
      totalScore += widget.score;
      prefs.setInt('total_score', totalScore);
    }
  }

  // Future<void> saveCategory() async {
  //   if (_isMounted) {
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('category', widget.category);
  //   }
  // }

  Future<void> storeTime() async {
    if (_isMounted) {
      final now = DateTime.now();
      final formatter = DateFormat('hh:mm:ss a dd/MM/yyyy');
      final formattedDateTime = formatter.format(now);
      final prefs = await SharedPreferences.getInstance();
      final storedTimes = prefs.getStringList('storedTimes') ?? [];
      storedTimes.add(formattedDateTime);
      await prefs.setStringList('storedTimes', storedTimes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            resultPhrase,
            SizedBox(height: 15),
            Text(
              'Score:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '${widget.score}/50',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 61, 167, 243),
                  ),
                  onPressed: () {},
                  child: Row(
                    children: [
                      Icon(Icons.refresh, size: 20, color: Colors.white),
                      Text(
                        'Play Again',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 61, 167, 243),
                  ),
                  onPressed: () {
                    if (_isMounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => Homepage(),
                        ),
                      );
                    }
                    print('$userScores');
                    print('$categories');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.home, size: 20, color: Colors.white),
                      Text(
                        'Home',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get resultPhrase {
    String imagepath;

    if (widget.score >= 30) {
      imagepath = 'assets/images/passed1.png';
    } else {
      imagepath = 'assets/images/failed.png';
    }

    return Column(
      children: [
        Image.asset(
          imagepath,
          width: 300.0,
          height: 150.0,
        ),
      ],
    );
  }
}
