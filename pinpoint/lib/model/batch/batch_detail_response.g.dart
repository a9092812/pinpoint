// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatchDetailResponse _$BatchDetailResponseFromJson(Map<String, dynamic> json) =>
    BatchDetailResponse(
      id: json['id'] as String?,
      name: json['name'] as String,
      code: json['code'] as String,
      students: (json['students'] as List<dynamic>?)
              ?.map((e) => BatchUser.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      admins: (json['admins'] as List<dynamic>?)
              ?.map((e) => BatchAdmin.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      timetableId: json['timetableId'] as String?,
    );

Map<String, dynamic> _$BatchDetailResponseToJson(
        BatchDetailResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'students': instance.students,
      'admins': instance.admins,
      'timetableId': instance.timetableId,
    };

BatchUser _$BatchUserFromJson(Map<String, dynamic> json) => BatchUser(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$BatchUserToJson(BatchUser instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
    };

BatchAdmin _$BatchAdminFromJson(Map<String, dynamic> json) => BatchAdmin(
      id: json['id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$BatchAdminToJson(BatchAdmin instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
