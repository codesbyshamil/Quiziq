import 'package:Quiz/screens/homescreen.dart';
import 'package:Quiz/screens/loginscreen.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
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
    var loginData = await SharedPreferences.getInstance();
    isNewUser = loginData.getBool('login');

    await Future.delayed(Duration(seconds: 2));

    if (isNewUser == null || isNewUser == true) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => LoginPage(),
      ));
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Homepage()));
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
