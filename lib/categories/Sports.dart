import 'package:Quiziq/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:Quiziq/screens/scorescreen.dart';
import 'package:vibration/vibration.dart';

class Sports extends StatefulWidget {
  const Sports({super.key});

  @override
  State<Sports> createState() => _SportsState();
}

class _SportsState extends State<Sports> {
  late CountDownController _countDownController;
  @override
  void initState() {
    super.initState();
    // Initialize the controller in the 'initState' method
    _countDownController = CountDownController();
  }

  int score = 0;
  int currentQuestionIndex = 0;
  String Category = 'Sports';
  final List<Map<String, dynamic>> quizData = [
    {
      'questioncount': 'Question 1',
      'question': 'Who is known as "The Sultan of Swing" in cricket?',
      'answers': [
        '(a) Sachin Tendulkar',
        '(b) Wasim Akram',
        '(c) Ricky Ponting',
        '(d) Jacques Kallis'
      ],
      'correctanswer': '(b) Wasim Akram',
    },
    {
      'questioncount': 'Question 2',
      'question': '2016 Summer Olympics host city?',
      'answers': [
        '(a) Rio de Janeiro',
        '(b) Tokyo',
        '(c) London',
        '(d) Beijing'
      ],
      'correctanswer': '(a) Rio de Janeiro',
    },
    {
      'questioncount': 'Question 3',
      'question': 'Country known for ice hockey dominance?',
      'answers': [
        '(a) Canada',
        '(b) Russia',
        '(c) United States',
        '(d) Sweden'
      ],
      'correctanswer': '(a) Canada',
    },
    {
      'questioncount': 'Question 4',
      'question': 'Most Grand Slam titles in men\'s singles?',
      'answers': [
        '(a) Roger Federer',
        '(b) Rafael Nadal',
        '(c) Novak Djokovic',
        '(d) Pete Sampras'
      ],
      'correctanswer': '(c) Novak Djokovic',
    },
    {
      'questioncount': 'Question 5',
      'question': '2018 FIFA World Cup winner?',
      'answers': ['(a) Brazil', '(b) Germany', '(c) France', '(d) Argentina'],
      'correctanswer': '(c) France',
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
    // ignore: deprecated_member_use
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
                              padding: const EdgeInsets.all(8.0),
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
                          color: Color.fromARGB(255, 17, 241, 178),
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
                              color: Color.fromARGB(255, 255, 255, 255),
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
                            width: 350,
                            child: Text(
                              currentQuestionIndex < quizData.length
                                  ? quizData[currentQuestionIndex]['question']
                                  : 'Quiz Completed',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
                                      : Color.fromARGB(255, 12, 233, 170),
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
        // ignore: deprecated_member_use
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
                  Homepage();
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
      timerKey = GlobalKey<
          CircularCountDownTimerState>(); // Reset the countdown duration // Create a new GlobalKey
    });
  }

  void category() {
    setState(() {
      Category = 'Sports';
    });
  }

  // Future<void> saveQuizData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setInt('score', score);
  //   prefs.setInt('correctAnswers', currentQuestionIndex);
  //   prefs.setInt('wrongAnswers', quizData.length - currentQuestionIndex);
  //   prefs.setString('lastQuizDateTime', DateTime.now().toString());
  // }
}
