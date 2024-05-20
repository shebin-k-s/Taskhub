import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskhub/api/url/url.dart';
import 'package:taskhub/main.dart';

abstract class EmployeeAuthApiCalls {
  Future<int> employeeLogin(String email, String password);
  Future<int> employeeSignup(
      String eName, String email, String password, List skills);
}

class EmployeeAuthDB extends EmployeeAuthApiCalls {
  final dio = Dio();
  final url = Url();

  EmployeeAuthDB() {
    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
    );
  }

  @override
  Future<int> employeeLogin(String email, String password) async {
    try {
      final response = await dio.post(
        url.employeeLogin,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.data);
        final name = responseData['name'];
        final email = responseData['email'];
        final eId = responseData['eId'];
        final admin = responseData['admin'];

        final _sharedPref = await SharedPreferences.getInstance();
        await _sharedPref.setString(NAME, name);
        await _sharedPref.setString(EMAIL, email);
        await _sharedPref.setString(EID, eId);
        await _sharedPref.setBool(ADMIN, admin);

        return response.statusCode ?? -1;
      } else {
        return response.statusCode ?? -1;
      }
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
  Future<int> employeeSignup(
      String eName, String email, String password, List skills) async {
    try {
      final response = await dio.post(
        url.employeeSignup,
        data: {
          'eName': eName,
          'email': email,
          'password': password,
          'skills': skills,
        },
      );

      return response.statusCode ?? -1;
    } catch (e) {
      if (e is DioException && e.response != null) {
        return e.response!.statusCode ?? -1;
      } else {
        return -1;
      }
    }
  }
}
