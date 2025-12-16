// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'institute.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstituteResponse _$InstituteResponseFromJson(Map<String, dynamic> json) =>
    InstituteResponse(
      id: json['id'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      name: json['name'] as String?,
      geoJsonUrl: json['geoJsonUrl'] as String?,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      isVerified: json['verified'] as bool?,
      baseAltitude: json['baseAltitude'] as String?,
    );

Map<String, dynamic> _$InstituteResponseToJson(InstituteResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'phone': instance.phone,
      'name': instance.name,
      'geoJsonUrl': instance.geoJsonUrl,
      'address': instance.address,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'verified': instance.isVerified,
      'baseAltitude': instance.baseAltitude,
    };
