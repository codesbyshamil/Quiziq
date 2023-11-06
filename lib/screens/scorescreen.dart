import 'package:Quiziq/screens/results.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Quiziq/screens/homescreen.dart';
import 'package:intl/intl.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  _ScorePageState createState() =>
      _ScorePageState(category: category, score: score);
}

class _ScorePageState extends State<ScorePage> {
  late String category;
  late int score;
  _ScorePageState({
    required this.category,
    required this.score,
  });

  CollectionReference Results =
      FirebaseFirestore.instance.collection('Results');

  bool _isMounted = true;
  List<int> userScores = [];
  // List<String> categories = [];
  // List<String> storedTimes = [];
  int index = 0;
  String Datetime1 = '';
  // int index1 = 10;
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
      _fetchUserData();
    }
  }

  // void SaveResult() {
  //   // ignore: unused_local_variable

  //   DateTime now = DateTime.now();
  //   String formattedDateTime = DateFormat('HH:mm:ss a dd/MM/yyyy ').format(now);

  //   final Data = {
  //     'Score': '$score',
  //     'Category': '$category',
  //     'Datetime': '$formattedDateTime'
  //   };
  //   Results.add(Data);
  // }
  // Future<void> SaveResult(String userId, int Score, String category) async {
  //   DateTime now = DateTime.now();
  //   String formattedDateTime = DateFormat('HH:mm:ss a dd/MM/yyyy ').format(now);
  //   await FirebaseFirestore.instance.collection('Results').doc(userId).set({
  //     'Score': '$score',
  //     'Category': '$category',
  //     'Datetime': '$formattedDateTime' // Timestamp when the result is stored
  //   });
  // }
  Future<void> _fetchUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _user = auth.currentUser;
    setState(() {}); // Update the UI after fetching user data
  }

  late User? _user;
  String username = "";
  Future<void> SaveResult(String userId, int Score, String category) async {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('dd/MM/yyyy HH:mm:ss a').format(now);
    final userDoc =
        FirebaseFirestore.instance.collection('Results').doc(userId);
    final userDocSnap = await userDoc.get();

    if (!userDocSnap.exists) {
      await userDoc.set({
        'results': [],
        'name': _user != null ? '${_user!.displayName}' : username,
      });
    }

    await userDoc.update({
      'results': FieldValue.arrayUnion([
        {
          'Score': '$score',
          'Category': '$category',
          'Datetime': '$formattedDateTime'
        }
      ])
    });
  }
  // Future<void> SaveResult(String userId, int Score, String category) async {
  //   DateTime now = DateTime.now();
  //   String formattedDateTime = DateFormat('dd/MM/yyyy HH:mm:ss a').format(now);
  //   await FirebaseFirestore.instance.collection('Results').doc(userId).update({
  //     'results': FieldValue.arrayUnion([
  //       {
  //         'Score': '$score',
  //         'Category': '$category',
  //         'Datetime': '$formattedDateTime'
  //       }
  //     ])
  //   });
  // }

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
                  onPressed: () async {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      // If the user is logged in, store the result
                      await SaveResult(user.uid, score, category);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Result stored for the user'),
                      ));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('User not logged in'),
                      ));
                    }
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => Homepage(),
                      ),
                    );

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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty('Category', Category));
  }
}
