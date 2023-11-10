//import 'package:Quiz/screens/test.dart';
// import 'package:Quiziq/provider/provider.dart';
import 'package:animated_switch/animated_switch.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Quiziq/screens/loginscreen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late String username = '';
  late String phonenumber = '';

  late User? _user;
  TextEditingController _phoneController = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  // ignore: unused_field
  bool? _canCheckBiometrics;
  bool fingerprintAuthEnabled = false;
  _SupportState _supportState = _SupportState.unknown;
  String? _userPhoneNumber;

  bool isInitialized = false;
  String userId = '';
  @override
  void initState() {
    super.initState();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() => _supportState = isSupported
              ? _SupportState.supported
              : _SupportState.unsupported),
        );
    _fetchUserData();
    checkPhoneNumberInFirestore(userId);
    _checkFingerprintAuthPreference();
  }

  Future<void> _checkFingerprintAuthPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool enabled = prefs.getBool('fingerprint_auth_enabled') ?? false;
    setState(() {
      fingerprintAuthEnabled = enabled;
    });
  }

  Future<void> _fetchUserData() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _user = auth.currentUser;
    setState(() {}); // Update the UI after fetching user data
  }

  Future<void> SaveNumber(String userId, int phoneNumber) async {
    final userDoc =
        FirebaseFirestore.instance.collection('Results').doc(userId);
    final userDocSnap = await userDoc.get();

    if (!userDocSnap.exists) {
      await userDoc.set({
        'PhoneNumber': '${_phoneController.text}',
      });
    } else {
      await userDoc.update({
        'PhoneNumber': '${_phoneController.text}',
      });
    }

    // After saving, update the UI to reflect the changes
    await checkPhoneNumberInFirestore(userId);
  }

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

  void Enablefinger() {
    print('fingerprint enabled');
  }

  Future<void> checkPhoneNumberInFirestore(String userId) async {
    // Replace 'Results' with the actual name of your Firestore collection
    // and 'document_id' with the actual document ID
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Results')
        .doc(userId)
        .get();

    // Check if the document exists and contains a phone number
    if (snapshot.exists) {
      setState(() {
        _userPhoneNumber = snapshot.data()?['PhoneNumber'];
      });
    }
  }

  void saveFingerprintAuthPreference(bool enabled) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fingerprint_auth_enabled', enabled);
  }

  Future<void> clearpreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_scores');
    prefs.remove('category');
    prefs.remove('storedTimes');
    prefs.remove('total_score');
  }

  Future<void> clearpreference1() async {
    var prefManager = await SharedPreferences.getInstance();
    await prefManager.clear();
  }

  Future<void> showChangeUsernameDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_user?.phoneNumber != null
              ? 'Change Mobile number'
              : 'Add Mobile number'),
          content: TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Mobile Number',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  setState(() {
                    SaveNumber(user.uid, hashCode);
                  });
                } else {}
                Navigator.of(context).pop();

                print('Error');
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String? photoUrl = user?.photoURL;
    // Provider.of<Providers>(context).getUsername();
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 27, 139, 231),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              if (value == '1') {
                clearpreference();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: '1',
                child: Text('Clear Cache'),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(251, 250, 250, 250),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: photoUrl != null
                                    ? NetworkImage(photoUrl)
                                    : AssetImage('assets/images/profile1.png')
                                        as ImageProvider,
                              ),
                              // Container(
                              //   margin: EdgeInsets.only(top: 10),
                              //   width: 100,
                              //   height: 100,
                              //   decoration: BoxDecoration(
                              //     shape: BoxShape.circle,
                              //     image: DecorationImage(
                              //       image: AssetImage(
                              //           'assets/images/profile1.png'),
                              //     ),
                              //     color: Colors.amber,
                              //   ),
                              // ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  children: [
                                    Text(
                                      _user != null
                                          ? '${_user!.displayName}'
                                          : '$username',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 41, 39, 39),
                                      ),
                                    ),
                                    Text('Beginner')
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: Color.fromARGB(255, 225, 113, 15),
                        thickness: 0.8,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Settings',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 60,
                          width: 270,
                          child: Column(
                            children: <Widget>[
                              Text(
                                  'Enable fingerprint authentication to view results'),
                              if (_supportState == _SupportState.unsupported)
                                const Text(
                                  'fingerprint is not supported',
                                  style: TextStyle(color: Colors.red),
                                ),
                            ],
                          ),
                        ),
                        IgnorePointer(
                          ignoring: _supportState == _SupportState.unsupported,
                          child: AnimatedSwitch(
                            value: fingerprintAuthEnabled,
                            width: 60, // Set the desired width
                            height: 30, // Set the desired height
                            onChanged: (Value) {
                              setState(() {
                                fingerprintAuthEnabled = Value;
                                // Save the preference to shared preferences.
                                saveFingerprintAuthPreference(Value);
                                
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          showChangeUsernameDialog(context);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.person),
                            Text(
                              _userPhoneNumber != null
                                  ? 'Change Mobile number'
                                  : 'Add Mobile number',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 20, 20, 20)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil<void>(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => LoginPage()),
                        ModalRoute.withName('/'),
                      );
                      signOut();
                    },
                    child: Row(
                      children: [
                        Icon(Icons.logout),
                        Text(
                          'LogOut',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 5, 5, 5)),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // Sign out from Firebase
      await _auth.signOut();

      await googleSignIn.signOut();
    } catch (e) {
      print("Error occurred during sign-out: $e");
    }
  }
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}
