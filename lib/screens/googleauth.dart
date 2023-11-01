import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
class googleauth extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> _signInWithGoogle() async {
    try {
      // Trigger the Google Sign In process
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        // Obtain the GoogleSignInAuthentication object
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        // Create a new credential using the GoogleAuthProvider
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with the Google Auth credentials
        return await _auth.signInWithCredential(credential);
      }
    } catch (e) {
      print("Google Sign In error: $e");
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google SignIn with Firebase'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            UserCredential? userCredential = await _signInWithGoogle();
            if (userCredential != null) {
              // Successful sign-in
              print("User signed in: ${userCredential.user!.displayName}");
            } else {
              // Sign-in failed
              print("Failed to sign in with Google");
            }
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}