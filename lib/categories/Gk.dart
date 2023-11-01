// ignore_for_file: deprecated_member_use

import 'package:Quiz/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:Quiz/screens/scorescreen.dart';
import 'package:vibration/vibration.dart';

class Quiz extends StatefulWidget {
  const Quiz({Key? key}) : super(key: key);

  @override
  State<Quiz> createState() => _QuizState();
}

class _QuizState extends State<Quiz> {
  late CountDownController _countDownController;
  @override
  void initState() {
    super.initState();
    // Initialize the controller in the 'initState' method
    _countDownController = CountDownController();
  }

  int score = 0;
  int currentQuestionIndex = 0;
  String Category = 'Gk';

  final List<Map<String, dynamic>> quizData = [
    {
      'questioncount': 'Question 1',
      'question': 'Which is the largest district in Kerala State?',
      'answers': [
        '(a) Malappuram',
        '(b) Thrissur',
        '(c) Idukki',
        '(d) Palakkad'
      ],
      'correctanswer': '(c) Idukki',
    },
    {
      'questioncount': 'Question 2',
      'question': 'Who was the first Chief Minister of Kerala?',
      'answers': [
        '(a) Pattam Thanupillai',
        '(b) E.M.S Namboodiripad',
        '(c) R. Shankar',
        '(d) C. Achutha Menon'
      ],
      'correctanswer': '(b) E.M.S Namboodiripad',
    },
    {
      'questioncount': 'Question 3',
      'question':
          'Boat races of Kerala are a special feature of which festival?',
      'answers': ['(a) Pongal', '(b) Onam', '(c) Ugadi', '(d) Bihu'],
      'correctanswer': '(b) Onam',
    },
    {
      'questioncount': 'Question 4',
      'question': 'Who is the leader of salt sathyagraha in Kerala?',
      'answers': [
        '(a) K. Kelappan',
        '(b) Shastri Tirth',
        '(c) M. K. Menon',
        '(d) Sree Narayana Guru'
      ],
      'correctanswer': '(a) K. Kelappan',
    },
    {
      'questioncount': 'Question 5',
      'question': 'Who is the first governor of Kerala?',
      'answers': [
        '(a) Burgula Ramakrishna Rao',
        '(b) V. V. Giri',
        '(c) jith Prasad Jain',
        '(d) Bhagwan Sahay'
      ],
      'correctanswer': '(a) Burgula Ramakrishna Rao',
    },
  ];

  String selectedAnswer = ""; // Reset selected answer.
  bool isCorrect = false;
  bool showingCorrectAnswer = false;
  int countdownDuration = 30;

  // Create unique GlobalKey for CircularCountDownTimer
  GlobalKey<CircularCountDownTimerState> timerKey =
      GlobalKey<CircularCountDownTimerState>();

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    // final providers = Provider.of<Providers>(context);
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
                        color: Color.fromARGB(248, 230, 225, 224),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(60),
                        ),
                      ),
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: IconButton(
                                  onPressed: () {
                                    _onBackPressed();
                                  },
                                  icon: Icon(
                                    Icons.arrow_back,
                                    size: 30,
                                    color: Colors.black,
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
                          color: Color.fromARGB(255, 240, 180, 17),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
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
                                color: Color.fromARGB(255, 242, 239, 239),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Container(
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
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                textAlign: TextAlign.center,
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
                                      : Color.fromARGB(255, 240, 180, 17),
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
                                        fontSize: 23,
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
        backgroundColor: Color.fromARGB(248, 244, 241, 241),
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
            navigateToScorePage();
          }
        });
      });
    }
  }

  void navigateToScorePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ScorePage(
          score: score,
          resetQuiz: resetQuiz,
          category: Category,
        ),
      ),
    );
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      score = 0;
      showingCorrectAnswer = false;
      selectedAnswer = "";
      countdownDuration = 30;
    });
    timerKey = GlobalKey<CircularCountDownTimerState>();
  }

  // To reset the countdown timer, recreate the entire widget

  void category() {
    Category = 'Gk';
  }
}
