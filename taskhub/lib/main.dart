import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskhub/Screens/splash_screen/splash_screen.dart';

const NAME = 'User Name';
const EMAIL = 'Email';
const ADMIN = "Admin";
const EID = "EmpId";
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
            color: Colors.black,
            foregroundColor: Colors.white,
          ),
          textTheme: const TextTheme(
              bodyMedium: TextStyle(color: Colors.white),
              bodyLarge: TextStyle(color: Colors.white)),
          splashFactory: NoSplash.splashFactory),
      home: const SplashScreen(),
    );
  }
}
