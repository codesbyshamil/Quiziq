// import 'package:Quiz/screens/signupscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Quiz/screens/homescreen.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int score = 0;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late SharedPreferences loginData;
  late bool newUser;
  String errorMessage = ''; // Added for error message

  @override
  void initState() {
    super.initState();
    checkIfAlreadyLoggedIn();
  }

  void checkIfAlreadyLoggedIn() async {
    loginData = await SharedPreferences.getInstance();
    newUser = (loginData.getBool('login') ?? true);

    if (!newUser) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 39, 151, 242),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Image.asset('assets/images/icon1.png'),
                  height: 280,
                ),
                SizedBox(height: 15),
                Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    cursorColor: Color.fromARGB(255, 31, 30, 30),
                    controller: usernameController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Username',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Color.fromARGB(255, 255, 255, 255)),
                  ),
                  onPressed: () {
                    String username = usernameController.text;
                    String password = passwordController.text;

                    if (username.isNotEmpty && password.isNotEmpty) {
                      if (isValidLogin(username, password)) {
                        print('Successful');
                        loginData.setBool('login', false);
                        loginData.setString('username', username);

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Homepage(),
                          ),
                        );
                      } else {
                        setState(() {
                          errorMessage = 'Incorrect username/password';
                        });
                      }
                    } else {
                      setState(() {
                        errorMessage = 'Please enter username and password';
                      });
                    }
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Color.fromARGB(255, 7, 89, 231),
                    ),
                  ),
                ),
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: Color.fromARGB(255, 237, 18, 2),
                    fontSize: 16,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Dont have an account'),
                    TextButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SignUpPage(),
                        //   ),
                        // );
                      },
                      child: Text(
                        'signup',
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidLogin(String username, String password) {
    if (username == "shamil" && password == "123") {
      return true;
    } else {
      return false;
    }
  }
}
