import 'package:dio/dio.dart';
import 'package:pinpoint/model/building/building_dto.dart';
import 'package:pinpoint/model/building/floor_dto.dart';
import 'package:pinpoint/model/building/room_dto.dart';
import 'package:pinpoint/model/building/room_map_dto.dart';
import 'package:pinpoint/model/message_response.dart';
import 'package:pinpoint/resources/constant/string/appString.dart';
import 'package:retrofit/retrofit.dart';

part 'building_service.g.dart';

@RestApi(baseUrl: AppString.baseUrl)
abstract class BuildingService {
  factory BuildingService(Dio dio, {String baseUrl}) = _BuildingService;

  @GET("/api/buildings/institute/{instituteId}")
  Future<List<BuildingDto>> getBuildingsByInstitute(
    @Path("instituteId") String instituteId,
    @Header("Authorization") String token,
  );

  @GET("/api/buildings/{buildingId}")
  Future<BuildingDto> getBuildingById(
    @Path("buildingId") String id,
    @Header("Authorization") String token,
  );

  // Added this method for updating altitude
  @PUT("/api/buildings/{buildingId}/altitude")
Future<MessageResponse> updateBaseAltitude(
  @Path("buildingId") String buildingId,
  @Query("name") String name,          
  @Query("baseAltitude") int baseAltitude,
  @Query("ceilHeight") int ceilHeight,
  @Header("Authorization") String token,
);


  @GET("/api/floors/building/{buildingId}")
  Future<List<FloorDto>> getFloorsByBuilding(
    @Path("buildingId") String buildingId,
  );

  @GET("/api/rooms/building/{buildingId}")
  Future<List<RoomDto>> getRoomsByBuilding(
    @Path("buildingId") String buildingId,
    @Header("Authorization") String token,
  );

  @GET("/api/rooms/floor/{floorLevel}")
  Future<List<RoomDto>> getRoomsByFloor(
    @Path("floorLevel") int floorLevel,
    @Header("Authorization") String token,
  );

  @GET("/api/rooms/building/{buildingId}/map")
Future<List<RoomMapDto>> getRoomsForMap(
  @Path("buildingId") String buildingId,
  @Header("Authorization") String token,
);

}