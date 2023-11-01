// import 'package:Quiz/screens/signupscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';
// import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
                  height: 200,
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
                InkWell(
                  child: Container(
                    width: 150,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    child: Center(
                      child: Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 7, 89, 231),
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
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
                  // child: Text(
                  //   "Login",
                  //   style: TextStyle(
                  //     color: Color.fromARGB(255, 7, 89, 231),
                  //   ),
                  // ),
                ),
                SizedBox(height: 10),
                Text(
                  errorMessage,
                  style: TextStyle(
                    color: Color.fromARGB(255, 183, 29, 18),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                Text('____Signup with____'),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: const Color.fromARGB(255, 255, 255, 255)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: 30.0,
                                width: 30.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/google.png'),
                                      fit: BoxFit.cover),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ))),
                      onTap: () async {
                        UserCredential? userCredential =
                            await signInWithGoogle();
                        if (userCredential != true) {
                          // Successful sign-in
                          print(
                              "User signed in: ${userCredential.user!.displayName}");
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Homepage(),
                            ),
                          );
                        } else {
                          // Sign-in failed
                          print("Failed to sign in with Google");
                        }
                      },
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: const Color.fromARGB(255, 255, 255, 255)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: 40.0,
                                width: 40.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/fb.png'),
                                      fit: BoxFit.cover),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              // Text(
                              //   'Sign in with Google',
                              //   style: TextStyle(
                              //       fontSize: 16.0,
                              //       fontWeight: FontWeight.bold,
                              //       color: Color.fromARGB(255, 0, 0, 0)),
                              // ),
                            ],
                          ))),
                      onTap: () async {
                        // UserCredential? userCredential =
                        //     await signInWithGoogle();
                        // if (userCredential != true) {
                        //   // Successful sign-in
                        //   print(
                        //       "User signed in: ${userCredential.user!.displayName}");
                        // } else {
                        //   // Sign-in failed
                        //   print("Failed to sign in with Google");
                        // }
                      },
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              color: const Color.fromARGB(255, 255, 255, 255)),
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                height: 30.0,
                                width: 30.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/images/git.png'),
                                      fit: BoxFit.cover),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              // Text(
                              //   'Sign in with Google',
                              //   style: TextStyle(
                              //       fontSize: 16.0,
                              //       fontWeight: FontWeight.bold,
                              //       color: Color.fromARGB(255, 0, 0, 0)),
                              // ),
                            ],
                          ))),
                      onTap: () async {
                        UserCredential? userCredential =
                            await signInWithGitHub();
                        if (userCredential != true) {
                          // Successful sign-in
                          print(
                              "User signed in: ${userCredential.user!.displayName}");
                        } else {
                          // Sign-in failed
                          print("Failed to sign in with Google");
                        }
                      },
                    ),
                  ],
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
                ),
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

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGitHub() async {
    // Create a GitHubSignIn instance
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: 'ede3e911adc22407f26a',
        clientSecret: 'e43b47a6556d632a66f78b5d7474ae70e57652cb',
        redirectUrl: 'https://my-project.firebaseapp.com/__/auth/handler');

    // Trigger the sign-in flow
    final result = await gitHubSignIn.signIn(context);

    // Create a credential from the access token
    final githubAuthCredential =
        GithubAuthProvider.credential(result.token as String);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(githubAuthCredential);
  }
}
