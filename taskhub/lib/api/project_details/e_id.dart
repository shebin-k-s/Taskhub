import 'package:json_annotation/json_annotation.dart';

part 'e_id.g.dart';

@JsonSerializable()
class EId {
  @JsonKey(name: '_id')
  String? id;
  String? eName;
  String? email;

  EId({this.id, this.eName, this.email});

  factory EId.fromJson(Map<String, dynamic> json) => _$EIdFromJson(json);

  Map<String, dynamic> toJson() => _$EIdToJson(this);
}
