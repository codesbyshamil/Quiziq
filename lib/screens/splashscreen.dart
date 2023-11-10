import 'package:Quiziq/screens/connectivity.dart';
import 'package:Quiziq/screens/homescreen.dart';
import 'package:Quiziq/screens/loginscreen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool? isNewUser;
  int score = 0;
  @override
  void initState() {
    super.initState();
    checkIfAlreadyLogin();
  
  }

 
  Future<void> checkIfAlreadyLogin() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    await Future.delayed(Duration(seconds: 2));

    if (user != null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Homepage(enableFingerprint: true)));
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset('assets/images/logo122.png'),
      logoWidth: 300,
      backgroundColor: Color.fromARGB(255, 39, 151, 242),
      showLoader: true,
      loaderColor: const Color.fromARGB(255, 255, 255, 255),
      loadingText: Text("Loading...", style: TextStyle(color: Colors.white)),
      durationInSeconds: 2,
    );
  }
}
