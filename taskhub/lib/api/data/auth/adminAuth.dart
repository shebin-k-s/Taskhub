import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskhub/api/url/url.dart';
import 'package:taskhub/main.dart';

abstract class AdminAuthApiCalls {
  Future<int> adminLogin(String email, String password);
  Future<int> adminSignup(
      String eName, String email, String password, List skills);
}

class AdminAuthDB extends AdminAuthApiCalls {
  final dio = Dio();
  final url = Url();

  AdminAuthDB() {
    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
    );
  }

  @override
  Future<int> adminLogin(String email, String password) async {
    print(email);
    try {
      final response = await dio.post(
        url.adminLogin,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.data);
        final name = responseData['name'];
        final email = responseData['email'];
        final admin = responseData['admin'];

        final _sharedPref = await SharedPreferences.getInstance();
        await _sharedPref.setString(NAME, name);
        await _sharedPref.setString(EMAIL, email);
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
  Future<int> adminSignup(
      String eName, String email, String password, List skills) async {
    try {
      final response = await dio.post(
        url.adminSignup,
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
