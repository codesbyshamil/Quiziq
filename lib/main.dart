import 'package:Quiz/firebase_options.dart';
import 'package:Quiz/provider/provider.dart';
// import 'package:Quiz/screens/googleauth.dart';
import 'package:Quiz/screens/splashscreen.dart';
import 'package:flutter/material.dart';
// import 'package:Quiz/screens/splashscreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Future<void> clearSharedPreferences() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Providers(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          appBarTheme: AppBarTheme(
              color: Colors.blue,
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 20)),
          dialogTheme: DialogTheme(
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
            backgroundColor: Colors.white,
          ),
          popupMenuTheme: PopupMenuThemeData(
            color: Colors.white,
          ),
        ),
        title: 'Quiziq',
        home: SplashPage(),
      ),
    );
  }
}
