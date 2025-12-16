import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'room_map_dto.g.dart';

@JsonSerializable()
class RoomMapDto {
  final String id;
  final String name;
  final String type;
  final int floorLevel;

   final String geometry;

  RoomMapDto({
    required this.id,
    required this.name,
    required this.type,
    required this.floorLevel,
    required this.geometry,
  });

  factory RoomMapDto.fromJson(Map<String, dynamic> json) =>
      _$RoomMapDtoFromJson(json);

   Map<String, dynamic> get geoJson =>
      jsonDecode(geometry) as Map<String, dynamic>;
}
