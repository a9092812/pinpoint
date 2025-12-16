// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_map_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomMapDto _$RoomMapDtoFromJson(Map<String, dynamic> json) => RoomMapDto(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      floorLevel: (json['floorLevel'] as num).toInt(),
      geometry: json['geometry'] as String,
    );

Map<String, dynamic> _$RoomMapDtoToJson(RoomMapDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'floorLevel': instance.floorLevel,
      'geometry': instance.geometry,
    };
