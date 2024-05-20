import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:taskhub/Screens/admin_screen/admin_screen.dart';
import 'package:taskhub/Screens/employee_screen/employee_screen.dart';
import 'package:taskhub/api/data/auth/adminAuth.dart';
import 'package:taskhub/api/data/auth/employeeAuth.dart';
import 'package:taskhub/widgets/snackbar_message/snackbar_message.dart';

class AuthScreen extends StatelessWidget {
  AuthScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final ValueNotifier<bool> admin = ValueNotifier(false);
  final ValueNotifier<bool> _isLoading = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(179, 43, 42, 42),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Color.fromARGB(179, 82, 82, 82),
                          radius: 48,
                          child: Icon(
                            Icons.person,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(179, 82, 82, 82),
                            label: const Text(
                              'Email ID',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.white,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color.fromARGB(179, 82, 82, 82),
                            label: const Text(
                              'Password',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            hintStyle: TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            prefixIcon: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }

                            return null;
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: _isLoading,
                          builder: (context, value, child) {
                            if (value) {
                              return const Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  CircularProgressIndicator(),
                                ],
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ValueListenableBuilder(
                            valueListenable: admin,
                            builder: (context, value, child) {
                              return Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      login(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      backgroundColor:
                                          Color.fromARGB(179, 82, 82, 82),
                                    ),
                                    child: const Text(
                                      "Login",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 30),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () => admin.value = !value,
                                        child: Text(
                                          value
                                              ? "Login As Employee "
                                              : "Login As Admin ",
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login(BuildContext ctx) async {
    if (_formKey.currentState!.validate()) {
      _isLoading.value = true;
      final _email = _emailController.text;
      final _password = _passwordController.text;
      var _errorMessage;
      if (admin.value) {
        final _statusCode = await AdminAuthDB().adminLogin(_email, _password);
        if (_statusCode == 200) {
          Navigator.of(ctx).pushReplacement(
            MaterialPageRoute(builder: (context) => AdminScreen()),
          );
        } else if (_statusCode == 404) {
          _errorMessage = "Email doesn't exist";
        } else if (_statusCode == 401) {
          _errorMessage = "Incorrect Password";
        } else {
          _errorMessage = "Internal server error";
        }
      } else {
        final _statusCode =
            await EmployeeAuthDB().employeeLogin(_email, _password);
        if (_statusCode == 200) {
          Navigator.of(ctx).pushReplacement(
            MaterialPageRoute(builder: (context) => EmployeeScreen()),
          );
        } else if (_statusCode == 404) {
          _errorMessage = "Email doesn't exist";
        } else if (_statusCode == 401) {
          _errorMessage = "Incorrect Password";
        } else {
          _errorMessage = "Internal server error";
        }
      }

      snackbarMessage(ctx, _errorMessage);
      _isLoading.value = false;
    }
  }
}
