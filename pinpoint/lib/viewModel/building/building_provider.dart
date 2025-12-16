
 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/data/datasource/building/building_service.dart';
import 'package:pinpoint/model/building/building_dto.dart';
import 'package:pinpoint/model/building/floor_dto.dart';
import 'package:pinpoint/model/building/room_dto.dart';
import 'package:pinpoint/model/building/room_map_dto.dart';
import 'package:pinpoint/repository/building/building_repository.dart';
import 'package:pinpoint/viewModel/dio/dio_provider.dart';
import 'package:pinpoint/viewModel/storage/secure_storage_provider.dart';

final buildingServiceProvider = Provider<BuildingService>((ref) {
  return BuildingService(ref.watch(dioProvider));
});

 final buildingRepositoryProvider = Provider<BuildingRepository>((ref) {
  return BuildingRepository(
    ref.watch(buildingServiceProvider),
    ref.watch(secureStorageProvider),
  );
});

 
// Controller to manage the list of buildings
class BuildingController extends AutoDisposeAsyncNotifier<List<BuildingDto>> {
  @override
  Future<List<BuildingDto>> build() async {
    final storage = ref.watch(secureStorageProvider);
    final instituteId = await storage.userId;  
    if (instituteId == null) {
      throw Exception("User not logged in or institute ID not found.");
    }
    final repository = ref.watch(buildingRepositoryProvider);
    return repository.getBuildingsByInstitute(instituteId);
  }
}

 final buildingControllerProvider =
    AutoDisposeAsyncNotifierProvider<BuildingController, List<BuildingDto>>(() {
  return BuildingController();
});

 final buildingDetailProvider =
    FutureProvider.autoDispose.family<BuildingDto, String>((ref, buildingId) {
  final repository = ref.watch(buildingRepositoryProvider);
  return repository.getBuildingById(buildingId);
});

 final floorsProvider =
    FutureProvider.autoDispose.family<List<FloorDto>, String>((ref, buildingId) {
  final repository = ref.watch(buildingRepositoryProvider);
  return repository.getFloorsByBuilding(buildingId);
});

final roomsProvider =
    FutureProvider.autoDispose.family<List<RoomDto>, int>((ref, floorLevel) {
  final repository = ref.watch(buildingRepositoryProvider);
  return repository.getRoomsByFloor(floorLevel);
});

final roomMapProvider =
    FutureProvider.autoDispose.family<List<RoomMapDto>, String>((ref, buildingId) {
  final repository = ref.watch(buildingRepositoryProvider);
  return repository.getRoomsForMap(buildingId);
});

