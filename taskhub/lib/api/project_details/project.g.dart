// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      status: json['status'] as String?,
      id: json['_id'] as String?,
      pId: json['pId'] == null
          ? null
          : PId.fromJson(json['pId'] as Map<String, dynamic>),
      techName: json['techName'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      coWorkers: (json['coWorkers'] as List<dynamic>?)
          ?.map((e) => CoWorker.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'status': instance.status,
      '_id': instance.id,
      'pId': instance.pId,
      'techName': instance.techName,
      'startDate': instance.startDate?.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'coWorkers': instance.coWorkers,
    };
