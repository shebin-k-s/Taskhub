// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'co_worker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoWorker _$CoWorkerFromJson(Map<String, dynamic> json) => CoWorker(
      status: json['status'] as String?,
      id: json['_id'] as String?,
      eId: json['eId'] == null
          ? null
          : EId.fromJson(json['eId'] as Map<String, dynamic>),
      techName: json['techName'] as String?,
    );

Map<String, dynamic> _$CoWorkerToJson(CoWorker instance) => <String, dynamic>{
      'status': instance.status,
      '_id': instance.id,
      'eId': instance.eId,
      'techName': instance.techName,
    };
