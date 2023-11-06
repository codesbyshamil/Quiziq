// ignore_for_file: deprecated_member_use

import 'package:Quiziq/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:Quiziq/screens/scorescreen.dart';
import 'package:vibration/vibration.dart';

class Maths extends StatefulWidget {
  const Maths({super.key});

  @override
  State<Maths> createState() => _MathsState();
}

class _MathsState extends State<Maths> {
  late CountDownController _countDownController;
  @override
  void initState() {
    super.initState();
    // Initialize the controller in the 'initState' method
    _countDownController = CountDownController();
  }

  int score = 0;
  int currentQuestionIndex = 0;
  String category = 'Maths';
  final List<Map<String, dynamic>> quizData = [
    {
      'questioncount': 'Question 1',
      'question': 'What is the result of 7 multiplied by 8?',
      'answers': ['(a) 42', '(b) 48', '(c) 56', '(d) 64'],
      'correctanswer': '(b) 48',
    },
    {
      'questioncount': 'Question 2',
      'question': 'Simplify the expression: 2x + 5 - 3x + 7',
      'answers': ['(a) 4x + 2', '(b) -x + 12', '(c) -x + 2', '(d) -x + 5'],
      'correctanswer': '(d) -x + 5',
    },
    {
      'questioncount': 'Question 3',
      'question': 'What is the square root of 144?',
      'answers': ['(a) 9', '(b) 12', '(c) 16', '(d) 18'],
      'correctanswer': '(b) 12',
    },
    {
      'questioncount': 'Question 4',
      'question': 'What is 3 + 5?',
      'answers': ['(a) 7', '(b) 8', '(c) 9', '(d) 10'],
      'correctanswer': '(b) 8',
    },
    {
      'questioncount': 'Question 5',
      'question': 'What is the value of π (pi) approximately equal to?',
      'answers': ['(a) 3.14', '(b) 3.1416', '(c) 3.142', '(d) 22/7'],
      'correctanswer': '(a) 3.14',
    }
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
                                  fillColor: Color.fromARGB(255, 83, 131, 235),
                                  ringColor: Color.fromARGB(255, 109, 106, 106),
                                  onComplete: () {
                                    // Timer completed, show correct answer and move to the next question.
                                    navigateToScorePage(1);
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
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 200),
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 320,
                            child: Text(
                              currentQuestionIndex < quizData.length
                                  ? quizData[currentQuestionIndex]['question']
                                  : 'Quiz Completed',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
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
                          Homepage(), // Navigate to the QuizPage
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
            navigateToScorePage(1);
          }
        });
      });
    }
  }

  void navigateToScorePage(int scr) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) =>
            ScorePage(score: score, resetQuiz: resetQuiz, category: category),
      ),
    );
  }

  void Category() {
    setState(() {
      category = 'Maths';
    });
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      showingCorrectAnswer = false;
      selectedAnswer = "";
      countdownDuration = 50;
      // Reset the countdown duration // Create a new GlobalKey
    });
    timerKey = GlobalKey<CircularCountDownTimerState>();
  }
}
