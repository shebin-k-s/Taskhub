import 'package:json_annotation/json_annotation.dart';

import 'e_id.dart';

part 'co_worker.g.dart';

@JsonSerializable()
class CoWorker {
  String? status;
  @JsonKey(name: '_id')
  String? id;
  EId? eId;
  String? techName;

  CoWorker({this.status, this.id, this.eId, this.techName});

  factory CoWorker.fromJson(Map<String, dynamic> json) {
    return _$CoWorkerFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CoWorkerToJson(this);
}
