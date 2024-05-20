// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'e_id.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EId _$EIdFromJson(Map<String, dynamic> json) => EId(
      id: json['_id'] as String?,
      eName: json['eName'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$EIdToJson(EId instance) => <String, dynamic>{
      '_id': instance.id,
      'eName': instance.eName,
      'email': instance.email,
    };
