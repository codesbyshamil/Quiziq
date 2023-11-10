import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:Quiziq/screens/homescreen.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
  bool showSpinner = false;

  bool _isMounted = true;
  List<int> userScores = [];
  int index = 0;

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (_isMounted) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _user = auth.currentUser;
    setState(() {}); // Update the UI after fetching user data
  }

  late User? _user;
  String username = "";

  Future<void> SaveResult(String userId, int Score, String category) async {
    DateTime now = DateTime.now();
    String formattedDateTime = DateFormat('dd/MM/yyyy hh:mm:ss a').format(now);
    final userDoc =
        FirebaseFirestore.instance.collection('Results').doc(userId);
    final userDocSnap = await userDoc.get();

    if (!userDocSnap.exists) {
      await userDoc.set({
        'results': [],
        'Name': _user != null ? '${_user!.displayName}' : username,
        'Email': '${_user!.email}',
        // 'Phone Number':
        //     _user?.phoneNumber != null ? '${_user!.phoneNumber}' : '',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
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
                      setState(() {
                        showSpinner = true;
                      });
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        await SaveResult(user.uid, score, category);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Result stored for the user'),
                        ));
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Homepage(enableFingerprint: true),
                          ),
                        );
                        setState(() {
                          showSpinner = false;
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('User not logged in'),
                        ));
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => Homepage(enableFingerprint: kIsWeb),
                          ),
                        );
                      }
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
