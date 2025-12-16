import 'package:json_annotation/json_annotation.dart';

part 'room_dto.g.dart';

@JsonSerializable()
class RoomDto {
  final String id;
  final String name;
  final String type;
  final int floorLevel;

 
  RoomDto({
    required this.id,
    required this.name,
    required this.type,
    required this.floorLevel,
   });

  factory RoomDto.fromJson(Map<String, dynamic> json) => _$RoomDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RoomDtoToJson(this);
}
