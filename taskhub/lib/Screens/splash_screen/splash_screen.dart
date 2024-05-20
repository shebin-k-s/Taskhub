import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskhub/Screens/admin_screen/admin_screen.dart';
import 'package:taskhub/Screens/auth_screen/auth_screen.dart';
import 'package:taskhub/Screens/employee_screen/employee_screen.dart';
import 'package:taskhub/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    UserLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "Task Hub",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void UserLoggedIn() async {
    final _sharedPref = await SharedPreferences.getInstance();
    final _userLoggedIn = _sharedPref.getBool(ADMIN);

    if (_userLoggedIn == null) {
      await Future.delayed(Duration(milliseconds: 3000));
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (ctx) => AuthScreen(),
        ),
      );
    } else {
      if (_userLoggedIn) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => AdminScreen(),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (ctx) => EmployeeScreen(),
          ),
        );
      }
    }
  }
}
