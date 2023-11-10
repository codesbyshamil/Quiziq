// ignore_for_file: deprecated_member_use

import 'package:Quiziq/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:Quiziq/screens/scorescreen.dart';
import 'package:vibration/vibration.dart';

class Movie extends StatefulWidget {
  const Movie({super.key});

  @override
  State<Movie> createState() => _MovieState();
}

class _MovieState extends State<Movie> {
  late CountDownController _countDownController;
  @override
  void initState() {
    super.initState();
    // Initialize the controller in the 'initState' method
    _countDownController = CountDownController();
  }

  int score = 0;
  int currentQuestionIndex = 0;
  String category = 'Movie';
  final List<Map<String, dynamic>> quizData = [
    {
      'questioncount': 'Q1',
      'question': 'Who is the director of the Malayalam movie "Drishyam"?',
      'answers': [
        '(a) Jeethu Joseph',
        '(b) Priyadarshan',
        '(c) Anjali Menon',
        '(d) Aashiq Abu'
      ],
      'correctanswer': '(a) Jeethu Joseph',
    },
    {
      'questioncount': 'Q2',
      'question': 'Which Malayalam actor is known as "Lalettan"?',
      'answers': [
        '(a) Mammootty',
        '(b) Mohanlal',
        '(c) Dulquer Salmaan',
        '(d) Fahadh Faasil'
      ],
      'correctanswer': '(b) Mohanlal',
    },
    {
      'questioncount': 'Q3',
      'question':
          'Which Malayalam movie won the National Film Award Film in 2020?',
      'answers': [
        '(a) Jallikattu',
        '(b) Kumbalangi Nights',
        '(c) Lucifer',
        '(d) Uyare'
      ],
      'correctanswer': '(a) Jallikattu',
    },
    {
      'questioncount': 'Q4',
      'question': 'Who played the lead role in the movie "Premam"?',
      'answers': [
        '(a) Nivin Pauly',
        '(b) Dulquer Salmaan',
        '(c) Fahadh Faasil',
        '(d) Prithviraj Sukumaran'
      ],
      'correctanswer': '(a) Nivin Pauly',
    },
  ];

  String selectedAnswer = ""; // Reset selected answer.
  bool isCorrect = false;
  bool showingCorrectAnswer = false;
  int countdownDuration = 50;

  // Create unique GlobalKey for CircularCountDownTimer
  GlobalKey<CircularCountDownTimerState> timerKey =
      GlobalKey<CircularCountDownTimerState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 380,
                      height: 258,
                      margin: EdgeInsets.only(top: 10),
                      decoration: ShapeDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: IconButton(
                                  onPressed: () {
                                    _onBackPressed();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    size: 30,
                                  )),
                            )
                          ]),
                    ),
                    Positioned(
                      bottom: -40,
                      right: 20,
                      left: 20,
                      child: Container(
                        width: 250,
                        height: 235,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Color.fromARGB(255, 145, 222, 236),
                          shadows: [
                            BoxShadow(
                              color: Color.fromARGB(255, 191, 191, 191),
                              blurRadius: 15,
                              offset: Offset(4, 4),
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              SizedBox(
                                child: CircularCountDownTimer(
                                  controller: _countDownController,
                                  key: timerKey, // Add this key
                                  width: 80,
                                  height: 80,
                                  duration: 30,
                                  fillColor: Color.fromARGB(255, 237, 150, 84),
                                  ringColor: Color.fromARGB(255, 96, 94, 94),
                                  onComplete: () {
                                    // Timer completed, show correct answer and move to the next question.
                                    navigateToScorePage();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 120),
                          alignment: Alignment.center,
                          child: Text(
                            currentQuestionIndex < quizData.length
                                ? quizData[currentQuestionIndex]
                                    ['questioncount']
                                : 'Quiz Completed',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 200),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 320,
                              child: Center(
                                child: Text(
                                  currentQuestionIndex < quizData.length
                                      ? quizData[currentQuestionIndex]
                                          ['question']
                                      : 'Quiz Completed',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 70),
                Container(
                  child: Column(
                    children: (currentQuestionIndex < quizData.length
                            ? quizData[currentQuestionIndex]['answers']
                                as List<String>
                            : ['Quiz Completed'])
                        .map((answer) {
                      return TextButton(
                        onPressed: () {
                          if (!showingCorrectAnswer) {
                            handleAnswer(answer);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 350,
                            height: 48,
                            decoration: ShapeDecoration(
                              color: selectedAnswer == answer
                                  ? (isCorrect ? Colors.green : Colors.red)
                                  : Color.fromARGB(255, 255, 255, 255),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 2,
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  color: selectedAnswer == answer
                                      ? (isCorrect ? Colors.green : Colors.red)
                                      : Color(0xFFA32EC1),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: Row(
                                children: [
                                  SizedBox(width: 5),
                                  Text(
                                    answer,
                                    style: TextStyle(
                                        fontSize: 25,
                                        color:
                                            Color.fromARGB(255, 80, 93, 100)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (showingCorrectAnswer)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Text(
                        isCorrect
                            ? 'Correct Answer!'
                            : 'Correct Answer: ${quizData[currentQuestionIndex]['correctanswer']}',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    _countDownController.pause();
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            title: Text('Confirm Exit'),
            content: Text(
              'Do you want to exit the quiz',
              style: TextStyle(fontSize: 18),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  _countDownController.resume();
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  _countDownController
                      .pause(); // Pause the timer only when exiting
                  // Navigator.of(context).pop(true);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          Homepage(enableFingerprint: true), // Navigate to the QuizPage
                    ),
                  ); // Allow back button press
                },
                child: Text('Yes'),
              ),
            ],
          ),
        );
      },
    );
  }

  void handleAnswer(String selectedAnswer) {
    if (currentQuestionIndex < quizData.length) {
      final correctAnswer =
          quizData[currentQuestionIndex]['correctanswer'] as String;
      final isAnswerCorrect = selectedAnswer == correctAnswer;

      setState(() {
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
      });

      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          currentQuestionIndex++;
          showingCorrectAnswer = false;
          this.selectedAnswer = "";

          if (currentQuestionIndex == quizData.length) {
            navigateToScorePage();
          }
        });
      });
    }
  }

  void navigateToScorePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            ScorePage(score: score, resetQuiz: resetQuiz, category: category),
      ),
    );
  }

  void Category() {
    setState(() {
      category = 'Movie';
    });
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      showingCorrectAnswer = false;
      selectedAnswer = "";
      countdownDuration = 50;
      timerKey = GlobalKey<
          CircularCountDownTimerState>(); // Reset the countdown duration // Create a new GlobalKey
    });
  }
}
