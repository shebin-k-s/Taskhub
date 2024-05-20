import 'package:json_annotation/json_annotation.dart';

import 'employee.dart';

part 'employee_model.g.dart';

@JsonSerializable()
class EmployeeModel {
  List<Employee>? employees;

  EmployeeModel({this.employees});

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return _$EmployeeModelFromJson(json);
  }

  Map<String, dynamic> toJson() => _$EmployeeModelToJson(this);
}
