import 'package:json_annotation/json_annotation.dart';

import 'project.dart';

part 'project_details.g.dart';

@JsonSerializable()
class ProjectDetails {
  List<Project>? projects;

  ProjectDetails({this.projects});

  factory ProjectDetails.fromJson(Map<String, dynamic> json) {
    return _$ProjectDetailsFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProjectDetailsToJson(this);
}
