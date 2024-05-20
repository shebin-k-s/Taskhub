import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:taskhub/api/employee_model/employee.dart';
import 'package:taskhub/api/employee_model/employee_model.dart';
import 'package:taskhub/api/project_details/project.dart';
import 'package:taskhub/api/project_details/project_details.dart';

import 'package:taskhub/api/url/url.dart';

abstract class Admin {
  Future<List<Employee>?>? getEmployees();
  Future<int> addEmployee(
      String eName, String password, String email, List skills);
  Future<int> addProject(String pName, String startDate, String endDate,
      List durations, List skills);
}

class AdminDB extends Admin {
  final Dio dio = Dio();
  final Url url = Url();

  AdminDB() {
    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
    );
  }

  @override
  Future<List<Employee>?>? getEmployees() async {
    try {
      final result = await dio.get(url.getAllEmployee);
      if (result.data != null) {
        final resultAsJson = jsonDecode(result.data);
        final employees = EmployeeModel.fromJson(resultAsJson);
        print(employees);
        return employees.employees;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<List<Project>> getAllProjects() async {
    try {
      final result = await dio.get(url.getAllProjects);
      if (result.data != null) {
        final resultAsJson = jsonDecode(result.data);
        final projects = ProjectDetails.fromJson(resultAsJson);
        print(projects.projects);
        return projects.projects ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Future<int> addEmployee(
      String eName, String password, String email, List skills) async {
    try {
      final response = await dio.post(
        url.employeeSignup,
        data: {
          'eName': eName,
          'email': email,
          'password': password,
          'skills': skills
        },
      );

      return response.statusCode ?? -1;
    } catch (e) {
      print(e);
      if (e is DioException && e.response != null) {
        return e.response!.statusCode ?? -1;
      } else {
        return -1;
      }
    }
  }

  @override
  Future<int> addProject(String pName, String startDate, String endDate,
      List duration, List skills) async {
    try {
      final response = await dio.post(
        url.addProject,
        data: {
          'pName': pName,
          'startDate': startDate,
          'endDate': endDate,
          'durations': duration,
          'skills': skills
        },
      );

      return response.statusCode ?? -1;
    } catch (e) {
      print(e);
      if (e is DioException && e.response != null) {
        return e.response!.statusCode ?? -1;
      } else {
        return -1;
      }
    }
  }
}
