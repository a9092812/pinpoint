// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminResponse _$AdminResponseFromJson(Map<String, dynamic> json) =>
    AdminResponse(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      name: json['name'] as String?,
      role: json['role'] as String,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      instituteId: json['instituteId'] as String,
      batches: (json['batches'] as List<dynamic>)
          .map((e) => BatchListResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      notices: (json['notices'] as List<dynamic>)
          .map((e) => NoticeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      isVerified: json['verified'] as bool,
    );

Map<String, dynamic> _$AdminResponseToJson(AdminResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'name': instance.name,
      'role': instance.role,
      'address': instance.address,
      'instituteId': instance.instituteId,
      'batches': instance.batches,
      'notices': instance.notices,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'verified': instance.isVerified,
    };
