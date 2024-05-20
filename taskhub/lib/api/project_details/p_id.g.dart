// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'p_id.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PId _$PIdFromJson(Map<String, dynamic> json) => PId(
      id: json['_id'] as String?,
      pName: json['pName'] as String?,
    )
      ..startDate = json['startDate'] as String?
      ..endDate = json['endDate'] as String?;

Map<String, dynamic> _$PIdToJson(PId instance) => <String, dynamic>{
      '_id': instance.id,
      'pName': instance.pName,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
    };
