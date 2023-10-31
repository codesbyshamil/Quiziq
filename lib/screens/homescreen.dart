// ignore_for_file: unused_local_variable

import 'package:Quiz/categories/Maths.dart';
import 'package:Quiz/categories/Movie.dart';
import 'package:Quiz/categories/Science.dart';
import 'package:Quiz/categories/Sports.dart';
import 'package:Quiz/categories/Tech.dart';
//import 'package:Quiz/main.dart';
import 'package:Quiz/provider/provider.dart';
import 'package:Quiz/screens/leaderboard.dart';
//import 'package:Quiz/screens/leaderboard.dart';
import 'package:Quiz/screens/profilescreen.dart';
import 'package:Quiz/screens/results.dart';
// import 'package:Quiz/screens/test.dart';
import 'package:flutter/material.dart';
import 'package:Quiz/categories/Gk.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_switch/animated_switch.dart';
import 'package:local_auth/local_auth.dart';

// ignore: must_be_immutable
class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

String username = "";
// String firstName = "";

class _HomepageState extends State<Homepage> {
  String firstName = '';
  final LocalAuthentication auth = LocalAuthentication();
  // ignore: unused_field
  bool _isAuthenticating = false;
  // ignore: unused_field
  String _authorized = 'Not Authorized';
  bool fingerprintAuthEnabled = false;
  // ignore: unused_field
  bool? _canCheckBiometrics;
  _SupportState _supportState = _SupportState.unknown;

  @override
  void initState() {
    super.initState();
    // getUsername();
    loadFingerprintAuthPreference();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
  }

  // ignore: unused_element
  Future<void> _checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
      print(e);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _authenticate() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool fingerprintAuthEnabled =
    //     prefs.getBool('fingerprint_auth_enabled') ?? false;

    // if (!fingerprintAuthEnabled) {
    //   setState(() {
    //     _authorized = 'Fingerprint authentication is not enabled.';
    //   });
    //   return;
    // }

    // The rest of your authentication logic remains the same.
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });

      authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to see results',
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );

      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(
        () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');

    if (authenticated) {

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Result(),
        ),
      );
    }
  }

  void loadFingerprintAuthPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      fingerprintAuthEnabled =
          prefs.getBool('fingerprint_auth_enabled') ?? false;
    });
  }

  List<int> userScores = [];
  late SharedPreferences logindata;

  Future<int> getTotalScoreFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int totalScore = prefs.getInt('total_score') ?? 0;
    return totalScore;
  }

  Future<int> getLastStoredScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userScoresString = prefs.getString('user_scores') ?? '';
    List<int> userScores =
        userScoresString.split(',').map((s) => int.tryParse(s) ?? 0).toList();

    if (userScores.isNotEmpty) {
      return userScores.last;
    } else {
      return 0; // Return a default value if there are no scores stored yet
    }
  }

  // void getUsername() async {
  //   SharedPreferences logindata = await SharedPreferences.getInstance();
  //   setState(() {
  //     username = logindata.getString('username') ?? "";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    Provider.of<Providers>(context).getUsername();
    return FutureBuilder<int>(
        future: getTotalScoreFromSharedPreferences(),
        builder: (context, snapshot) {
          int totalScore = snapshot.data ?? 0;
          return FutureBuilder<int>(
              future: getLastStoredScore(),
              builder: (context, lastStoredScoreSnapshot) {
                int lastStoredScore = lastStoredScoreSnapshot.data ?? 0;
                return Scaffold(
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        Consumer<Providers>(
                            builder: (context, Providers, child) {
                          // Providers.getUsername;
                          return Container(
                            color: Providers.currentColor,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(25),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 28),
                                    width: double.infinity,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: AnimatedSwitch(
                                                      width:
                                                          70, // Set the desired width
                                                      height:
                                                          30, // Set the desired height

                                                      onChanged: (bool state) {
                                                        final newColor =
                                                            Color.fromRGBO(
                                                          Providers.currentColor
                                                                  .red +
                                                              30,
                                                          Providers.currentColor
                                                                  .green -
                                                              10,
                                                          Providers.currentColor
                                                                  .blue +
                                                              20,
                                                          1.0,
                                                        );
                                                        Providers.changeColor(
                                                            newColor);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              
                                              Container(
                                                child: Text(
                                                  'Hi, $username',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 35,
                                                    color: Color.fromARGB(
                                                        255, 243, 240, 240),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                child: Text(
                                                  'Let’s make this day productive',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color.fromARGB(
                                                          255, 248, 246, 241)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Profile()),
                                            );
                                          },
                                          child: Container(
                                            width: 60,
                                            height: 60,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/profile1.png'),
                                                  fit: BoxFit.cover),
                                              color: Colors.transparent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 327,
                                      height: 70,
                                      decoration: ShapeDecoration(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        shadows: [
                                          BoxShadow(
                                            color: Color(0x14000000),
                                            blurRadius: 18,
                                            offset: Offset(4, 4),
                                            spreadRadius: 0,
                                          ),
                                        ],
                                      ),
                                      child: Row(children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 10),
                                          child: Row(children: [
                                            Image.asset(
                                                'assets/images/trophy.png',
                                                width: 50),
                                            Column(
                                              children: [
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 30),
                                                  child: Text(
                                                    'Previous Score',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontSize: 15,
                                                      height: 0.05,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 20),
                                                  child: Text(
                                                    '$lastStoredScore',
                                                    style: TextStyle(
                                                      color: Color(0xFF3EB7D3),
                                                      fontSize: 18,
                                                      height: 0.05,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 5),
                                            VerticalDivider(
                                              width: 20,
                                              thickness: 0.5,
                                              indent: 20,
                                              endIndent: 12,
                                              color: Colors.grey,
                                            ),
                                            Image.asset(
                                                'assets/images/coin.png',
                                                width: 50),
                                            Column(
                                              children: [
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: 30),
                                                    child: Text(
                                                      'Total Score',
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontSize: 15,
                                                        height: 0.05,
                                                      ),
                                                    )),
                                                Container(
                                                  margin:
                                                      EdgeInsets.only(top: 20),
                                                  child: Text(
                                                    '$totalScore',
                                                    style: TextStyle(
                                                      color: Color(0xFF3EB7D3),
                                                      fontSize: 18,
                                                      height: 0.05,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ]),
                                        ),
                                      ]),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (_supportState ==
                                            _SupportState.unsupported) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Result(),
                                            ),
                                          );
                                          print('not have fingrprint');
                                        } else {
                                          _authenticate();
                                          print('hi');
                                        }
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x14000000),
                                              blurRadius: 18,
                                              offset: Offset(4, 4),
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.restore),
                                              SizedBox(width: 5),
                                              Text(
                                                'Results',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    GestureDetector(
                                      onTap: () {
                                        // _authenticate();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Leaderboard(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 150,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0x14000000),
                                              blurRadius: 18,
                                              offset: Offset(4, 4),
                                              spreadRadius: 0,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.leaderboard),
                                              SizedBox(width: 5),
                                              Text(
                                                'Leaderboard',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                              ],
                            ),
                          );
                        }),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 20, top: 20),
                              child: Text(
                                'Select Category',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 15, 15, 15),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Quiz(), // Navigate to the QuizPage
                                  ),
                                );
                              },
                              child: Container(
                                width: 155,
                                height: 155,
                                decoration: ShapeDecoration(
                                  color: Color.fromARGB(
                                      255, 240, 180, 17), // Blue color for GK
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x1E000000),
                                      blurRadius: 12,
                                      offset: Offset(4, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                    Image.asset('assets/images/gk5.png',
                                        width: 80),
                                    SizedBox(height: 10),
                                    Text(
                                      'GK',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Sports(), // Navigate to the QuizPage
                                  ),
                                );
                              },
                              child: Container(
                                width: 155,
                                height: 155,
                                decoration: ShapeDecoration(
                                  color: Color.fromARGB(255, 40, 220,
                                      169), // Green color for Sports
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x1E000000),
                                      blurRadius: 12,
                                      offset: Offset(4, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                    Image.asset('assets/images/ball.png'),
                                    SizedBox(height: 10),
                                    Text(
                                      'Sports',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Science(), // Navigate to the QuizPage
                                  ),
                                );
                              },
                              child: Container(
                                width: 155,
                                height: 155,
                                decoration: ShapeDecoration(
                                  color: Color.fromARGB(255, 235, 11,
                                      11), // Red color for Science
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x1E000000),
                                      blurRadius: 12,
                                      offset: Offset(4, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                    Image.asset('assets/images/science.png'),
                                    SizedBox(height: 10),
                                    Text(
                                      'Science',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(235, 255, 255, 255),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Maths(), // Navigate to the QuizPage
                                  ),
                                );
                              },
                              child: Container(
                                width: 155,
                                height: 155,
                                decoration: ShapeDecoration(
                                  color: Color.fromARGB(255, 35, 203,
                                      245), // Cyan color for Maths
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x1E000000),
                                      blurRadius: 12,
                                      offset: Offset(4, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                    Image.asset('assets/images/calculator.png'),
                                    SizedBox(height: 10),
                                    Text(
                                      'Maths',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(235, 255, 255, 255),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Tech(), // Navigate to the QuizPage
                                  ),
                                );
                              },
                              child: Container(
                                width: 155,
                                height: 155,
                                decoration: ShapeDecoration(
                                  color: Color.fromARGB(255, 159, 65,
                                      241), // Purple color for Tech
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x1E000000),
                                      blurRadius: 12,
                                      offset: Offset(4, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                    Image.asset(
                                      'assets/images/techl212.png',
                                      width: 150,
                                      height: 100,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Tech',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(235, 255, 255, 255),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Movie(),
                                  ),
                                );
                              },
                              child: Container(
                                width: 155,
                                height: 155,
                                decoration: ShapeDecoration(
                                  color: Color.fromARGB(255, 232, 66,
                                      174), // Pink color for Movie
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  shadows: [
                                    BoxShadow(
                                      color: Color(0x1E000000),
                                      blurRadius: 12,
                                      offset: Offset(4, 4),
                                      spreadRadius: 0,
                                    )
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 10, 0, 0)),
                                    Image.asset('assets/images/movie2.png',
                                        width: 90),
                                    SizedBox(height: 10),
                                    Text(
                                      'Movie',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(235, 255, 255, 255),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              });
        });
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
