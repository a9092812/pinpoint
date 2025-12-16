import 'package:json_annotation/json_annotation.dart';
import 'package:pinpoint/model/building/room_dto.dart';
import 'floor_dto.dart';

part 'building_dto.g.dart';

@JsonSerializable()
class BuildingDto {
  final String id;
  final String? name;
  final int? baseAltitude;
  final int? ceilHeight;
  final List<FloorDto>? floors;

  BuildingDto({
    required this.id,
    this.name,
    this.baseAltitude,
    this.ceilHeight,
    this.floors,
  });

  factory BuildingDto.fromJson(Map<String, dynamic> json) => _$BuildingDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BuildingDtoToJson(this);

    factory BuildingDto.getMockData({required String id, required String name}) {
    return BuildingDto(
      id: id,
      name: name,
      baseAltitude: 10,
      ceilHeight: 4,
      floors: [
        FloorDto(id: 'floor-0', level: 0, rooms: [
          RoomDto(id: 'room-001', name: 'Lobby', type: 'Common Area', floorLevel: 0),
          RoomDto(id: 'room-002', name: 'Office 101', type: 'Office', floorLevel: 0),
        ]),
        FloorDto(id: 'floor-1', level: 1, rooms: [
           RoomDto(id: 'room-101', name: 'Conference Room A', type: 'Meeting', floorLevel: 1),
        ]),
      ],
    );
  }
}
