import 'package:dio/dio.dart';
import 'package:pinpoint/data/datasource/building/building_service.dart';
import 'package:pinpoint/model/building/building_dto.dart';
import 'package:pinpoint/model/building/floor_dto.dart';
import 'package:pinpoint/model/building/room_dto.dart';
import 'package:pinpoint/model/building/room_map_dto.dart';
import 'package:pinpoint/model/message_response.dart';
import 'package:pinpoint/repository/storage/secure_storage_service.dart';

class BuildingRepository {
  final BuildingService _buildingService;
  final SecureStorageService _storageService;

  BuildingRepository(this._buildingService, this._storageService);

  Future<String> _getToken() async {
    final token = await _storageService.jwt;
    if (token == null) throw Exception('Authentication token not found.');
    return 'Bearer $token';
  }

  Future<List<BuildingDto>> getBuildingsByInstitute(String instituteId) async {
    try {
      final token = await _getToken();
      return await _buildingService.getBuildingsByInstitute(instituteId, token);
    } on DioException catch (e) {
      throw Exception('Failed to fetch buildings: ${e.message}');
    }
  }

  Future<BuildingDto> getBuildingById(String buildingId) async {
    try {
      final token = await _getToken();
      return await _buildingService.getBuildingById(buildingId, token);
    } on DioException catch (e) {
      throw Exception('Failed to fetch building details: ${e.message}');
    }
  }
  
  // Added this method
 Future<MessageResponse> updateBaseAltitude(
    String buildingId,
    String name,              // ✅ add
    int baseAltitude,
    int ceilHeight,
) async {
  try {
    final token = await _getToken();
    return await _buildingService.updateBaseAltitude(
      buildingId,
      name,
      baseAltitude,
      ceilHeight,
      token,
    );
  } on DioException catch (e) {
    throw Exception('Failed to update building: ${e.message}');
  }
}


  Future<List<RoomDto>> getRoomsByFloor(int floorLevel) async {
  try {
    final token = await _getToken();
    return await _buildingService.getRoomsByFloor(floorLevel, token);
  } on DioException catch (e) {
    throw Exception('Failed to fetch rooms by floor: ${e.message}');
  }
}

Future<List<RoomMapDto>> getRoomsForMap(String buildingId) async {
  try {
    final token = await _getToken();
    return await _buildingService.getRoomsForMap(buildingId, token);
  } on DioException catch (e) {
    throw Exception('Failed to load room geometry: ${e.message}');
  }
}


  Future<List<FloorDto>> getFloorsByBuilding(String buildingId) async {
    try {
      return await _buildingService.getFloorsByBuilding(buildingId);
    } on DioException catch (e) {
      throw Exception('Failed to fetch floors: ${e.message}');
    }
  }

  Future<List<RoomDto>> getRoomsByBuilding(String buildingId) async {
    try {
      final token = await _getToken();
      return await _buildingService.getRoomsByBuilding(buildingId, token);
    } on DioException catch (e) {
      throw Exception('Failed to fetch rooms: ${e.message}');
    }
  }
}