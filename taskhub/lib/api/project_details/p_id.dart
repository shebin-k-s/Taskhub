import 'package:json_annotation/json_annotation.dart';

part 'p_id.g.dart';

@JsonSerializable()
class PId {
  @JsonKey(name: '_id')
  String? id;
  String? pName;
  String? startDate;
  String? endDate;
  

  PId({this.id, this.pName});

  factory PId.fromJson(Map<String, dynamic> json) => _$PIdFromJson(json);

  Map<String, dynamic> toJson() => _$PIdToJson(this);
}
