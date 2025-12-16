
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:pinpoint/data/datasource/institute/institute_service.dart';
import 'package:pinpoint/model/institute/institute.dart';
import 'package:pinpoint/model/institute/institute_request.dart';
import 'package:pinpoint/repository/institute/institute_repository.dart';
import 'package:pinpoint/viewModel/dio/dio_provider.dart';
import 'package:pinpoint/viewModel/storage/secure_storage_provider.dart';




final instituteApiProvider = Provider<InstituteApi>((ref) {
  return InstituteApi(ref.watch(dioProvider));
});

final instituteRepositoryProvider = Provider<InstituteRepository>((ref) {
  return InstituteRepository(
    ref.watch(instituteApiProvider),
  );
});

 
class InstituteController extends AutoDisposeAsyncNotifier<InstituteResponse> {
  @override
  Future<InstituteResponse> build() async {
     final repository = ref.watch(instituteRepositoryProvider);
     final storageService = ref.read(secureStorageProvider); 
final response= await repository.getInstitute();

   await storageService.saveUserId(response.id??'');
      return response;
  }

   Future<void> updateInstitute(InstituteRequest request) async {
    final repository = ref.read(instituteRepositoryProvider);
    
     state = const AsyncLoading();
    
     state = await AsyncValue.guard(() async {
      await repository.updateInstitute(request);
       return repository.getInstitute();
    });
  }
}

 final instituteControllerProvider =
    AutoDisposeAsyncNotifierProvider<InstituteController, InstituteResponse>(() {
  return InstituteController();
});
