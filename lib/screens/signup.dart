import 'package:Quiziq/screens/homescreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Color.fromARGB(255, 66, 66, 66)),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
        BorderSide(color: Color.fromARGB(255, 158, 160, 161), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  late String username;
  bool showSpinner = false;
  String errormsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Lottie.asset('assets/lottie/animation_loh2nws6.json'),
                    Center(
                      child: Text(
                        "Register Account",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        email = value;
                        // Do something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your email',
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        password = value;
                        // Do something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your Password',
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        username = value;
                        // Do something with the user input.
                      },
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your Username',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(errormsg),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                            email: email,
                            password: password,
                          );
                          // ignore: unnecessary_null_comparison
                          if (newUser != null) {
                            // Additional code to set the username after registration
                            await _auth.currentUser!
                                .updateDisplayName(username);

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Homepage(),
                              ),
                            );
                          }
                        } catch (e) {
                          print(e);
                          setState(() {
                            errormsg = '$e';
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('$e'),
                            ));
                          });
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      },
                      child: Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     final displayName = user!.displayName ?? 'User';

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Screen'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Welcome, $displayName!',
//               style: TextStyle(fontSize: 20),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 FirebaseAuth.instance.signOut();
//                 Navigator.pushReplacementNamed(context, 'login_screen');
//               },
//               child: Text('Log Out'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
