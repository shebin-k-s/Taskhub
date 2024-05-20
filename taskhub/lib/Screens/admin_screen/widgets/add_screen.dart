import 'package:flutter/material.dart';
import 'package:taskhub/api/data/admin/admin.dart';
import 'package:taskhub/widgets/snackbar_message/snackbar_message.dart';

class AddScreen extends StatelessWidget {
  AddScreen({Key? key});
  TextEditingController eNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController skillsController = TextEditingController();
  List<String> skills = [];

  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<String> _errorMessage = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 20.0,
      ),
      title: const Text(
        'Add New Employee',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: eNameController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Employee Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: skillsController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Skills (Comma-separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              ValueListenableBuilder(
                valueListenable: _errorMessage,
                builder: (context, value, child) {
                  if (value.length != 0) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              FocusScope.of(context).unfocus();
              // Retrieve values from text fields
              String eName = eNameController.text;
              String email = emailController.text;
              String password = passwordController.text;
              List<String> skills = skillsController.text
                  .split(',')
                  .map((skill) => skill.trim())
                  .toList();
              var _errorMessage = "";
              int statusCode =
                  await AdminDB().addEmployee(eName, password, email, skills);
              if (statusCode == 201) {
                Navigator.of(context).pop();
              } else {
                _errorMessage = "Internal server error";
                snackbarMessage(context, _errorMessage);
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          ),
          child: const Text(
            'Add',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
