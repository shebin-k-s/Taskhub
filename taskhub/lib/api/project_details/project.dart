import 'package:json_annotation/json_annotation.dart';

import 'co_worker.dart';
import 'p_id.dart';

part 'project.g.dart';

@JsonSerializable()
class Project {
  String? status;
  @JsonKey(name: '_id')
  String? id;
  PId? pId;
  String? techName;
  DateTime? startDate;
  DateTime? endDate;
  List<CoWorker>? coWorkers;

  Project({
    this.status,
    this.id,
    this.pId,
    this.techName,
    this.startDate,
    this.endDate,
    this.coWorkers,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return _$ProjectFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
