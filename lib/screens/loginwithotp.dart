import 'package:Quiziq/screens/connectivity.dart';
import 'package:Quiziq/screens/homescreen.dart';
import 'package:Quiziq/screens/loginscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _smsCodeController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String verificationId = '';
  bool otpSent = false; // To track if OTP has been sent
  bool showSpinner = false;
  String connectionStatus = 'Unknown';
  Future<bool> checkPhoneNumberInFirestore(String phoneNumber) async {
    try {
      // Check if the provided phone number exists in Firestore
      QuerySnapshot querySnapshot = await _firestore
          .collection('Results')
          .where('PhoneNumber', isEqualTo: phoneNumber)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        connectionStatus = 'No internet connection';
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => InternetCheckWidget(),
        ));
      });
    } else {}
  }

  Future<void> verifyPhone() async {
    bool phoneNumberExists =
        await checkPhoneNumberInFirestore('+91${_phoneNumberController.text}');

    if (!phoneNumberExists) {
      setState(() {
        errorMsg = 'Please register your phone number';
        showSpinner = false;
      });
      return;
    }
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      _auth.signInWithCredential(authResult);
    };
    setState(() {
      showSpinner = true;
    });

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      print('Error: ${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int? forceResend]) {
      this.verificationId = verId;
      print('SMS sent to $verId');
      setState(() {
        otpSent = true;
        showSpinner = false;
      });
    } as PhoneCodeSent;

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91${_phoneNumberController.text}',
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationFailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout,
      );
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        errorMsg = 'Error occurred: $e';
        ;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        size: 30,
                        color: Colors.black,
                      )),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          otpSent
                              ? Lottie.asset(
                                  'assets/lottie/animation_log0bztv.json',
                                  width: 280,
                                  height: 280)
                              : Lottie.asset(
                                  'assets/lottie/animation_lofz8wqx.json',
                                  width: 300,
                                  height: 300),
                          // Lottie.network(
                          //     'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json'),
                          otpSent
                              ? Text(
                                  "OTP Sent to ${_phoneNumberController.text}",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                )
                              : Text(
                                  "Phone Verification",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                          otpSent
                              ? Text(
                                  'Enter OTP To Continue',
                                  style: TextStyle(
                                      color:
                                          const Color.fromARGB(255, 4, 4, 4)),
                                )
                              : Text(
                                  "Enter Your Number to Continue",
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                          SizedBox(height: 10),
                          otpSent
                              ? Pinput(
                                  length: 6,
                                  controller: _smsCodeController,
                                  showCursor: true,
                                  onCompleted: (pin) => print(pin),
                                )
                              : Container(
                                  height: 55,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        width: 40,
                                        child: TextField(
                                          controller: countryController,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "|",
                                        style: TextStyle(
                                            fontSize: 33, color: Colors.grey),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          controller: _phoneNumberController,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Phone Number",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(height: 5),
                          Text(otpSent ? errorMessage : errorMsg,
                              style: TextStyle(color: Colors.red)),
                          SizedBox(height: 5),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.white, // Change the color here
                              ),
                              elevation: MaterialStateProperty.all<double>(4),
                            ),
                            onPressed: otpSent ? signInWithOTP : verifyPhone,
                            child: Text(otpSent ? 'Verify Otp' : 'Send OTP'),
                          ),
                          // SizedBox(height: 10),
                          // Text(otpSent ? errorMessage : errorMsg),
                          // if (otpSent) // Conditionally show OTP input field
                          //   Padding(
                          //     padding: const EdgeInsets.all(15.0),
                          //     child: Column(
                          //       children: [
                          //         Text(
                          //           'Enter OTP',
                          //           style: TextStyle(fontSize: 15),
                          //         ),
                          //         SizedBox(height: 10),
                          //         Pinput(
                          //           length: 6,
                          //           controller: _smsCodeController,
                          //           showCursor: true,
                          //           onCompleted: (pin) => print(pin),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // SizedBox(height: 20),
                          // if (otpSent) // Conditionally show verify button
                          //   ElevatedButton(
                          //     onPressed: signInWithOTP,
                          //     child: Text('Verify OTP'),
                          //   ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String errorMessage = '';
  String errorMsg = '';
  Future<void> signInWithOTP() async {
    try {
      AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: _smsCodeController.text,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;

      if (user != null) {
        String phoneNumber = '+91${_phoneNumberController.text}';

        QuerySnapshot querySnapshot = await _firestore
            .collection('Results')
            .where('PhoneNumber', isEqualTo: phoneNumber)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // User with the provided phone number exists
          String userId = querySnapshot.docs.first.id;

          // Accessing user data from Firestore
          var userData = querySnapshot.docs.first.data();

          // Now userData contains all the information about the user
          print('User logged in with ID: $userId');
          print('User Data: $userData');

          // Navigate to the home screen after successful login
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Homepage(enableFingerprint: true),
            ),
          );
        } else {
          // User with the provided phone number doesn't exist
          print('User with this phone number does not exist');
          setState(() {
            errorMessage = 'Invalid OTP or User not found.';
          });
        }
      } else {
        // Handle the case when user is null
        print('User is null');
        setState(() {
          errorMessage = 'Invalid OTP, Please try again.';
        });
      }
    } catch (e) {
      print('Failed to sign in: $e');
      setState(() {
        errorMessage = 'Invalid OTP, Please try again.';
      });
    }
  }
}
