import 'package:flutter/material.dart';
import 'package:taskhub/api/data/admin/admin.dart';
import 'package:taskhub/widgets/snackbar_message/snackbar_message.dart';

class ProjectScreen extends StatelessWidget {
  ProjectScreen({Key? key});
  TextEditingController projectNameController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController skillController = TextEditingController();

  TextEditingController durationController = TextEditingController();

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
        'Add New Project',
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
                controller: projectNameController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Project Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: startDateController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: endDateController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: skillController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Skill (Comma-separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: durationController,
                style: const TextStyle(
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: 'Duration (Comma-separated)',
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
              String projectName = projectNameController.text;
              String startDate = startDateController.text;
              String endDate = endDateController.text;
              List<String> skills = skillController.text
                  .split(',')
                  .map((skill) => skill.trim())
                  .toList();
              List<int> durations = durationController.text
                  .split(',')
                  .map((value) => int.tryParse(value.trim()) ?? 0)
                  .toList();

              var _errorMessage = "";
              int statusCode = await AdminDB().addProject(
                projectName,
                startDate,
                endDate,
                durations,
                skills,
              );

              if (statusCode == 200) {
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
