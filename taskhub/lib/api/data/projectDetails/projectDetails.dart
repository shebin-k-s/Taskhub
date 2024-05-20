import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:taskhub/api/project_details/project.dart';

import 'package:taskhub/api/project_details/project_details.dart';
import 'package:taskhub/api/url/url.dart';

abstract class Projectdetails {
  Future<List<Project>> getProjects(String eId, String status);
}

class ProjectdetailsDB extends Projectdetails {
  final dio = Dio();
  final url = Url();

  ProjectdetailsDB() {
    dio.options = BaseOptions(
      baseUrl: url.baseUrl,
      responseType: ResponseType.plain,
    );
  }

  @override
  Future<List<Project>> getProjects(String eId, String status) async {
    try {
      final result =
          await dio.get(url.getProjectsForEmp + '?eId=${eId}&status=${status}');

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
}
