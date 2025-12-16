import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/data/datasource/user/user_service.dart';
import 'package:pinpoint/model/user/user_detail_dto.dart';
import 'package:pinpoint/model/user/user_list_dto.dart';
 import 'package:pinpoint/repository/user/user_repository';
  import 'package:pinpoint/viewModel/dio/dio_provider.dart';

 
/// Provider for the UserApiService.
/// It depends on the globally configured Dio instance from your timetable providers.
final userApiServiceProvider = Provider<UserApiService>((ref) {
  // Re-use the existing dioProvider to ensure interceptors are shared
  final dio = ref.watch(dioProvider);
  return UserApiService(dio);
});

/// Provider for the UserRepository.
/// It depends on the UserApiService to perform network requests.
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final userApiService = ref.watch(userApiServiceProvider);
  return UserRepository(userApiService);
});


 
/// Fetches the list of all users for a specific institute or admin.
/// The `.family` modifier allows you to pass the institute/admin ID when watching the provider.
final usersProvider = FutureProvider.family<List<UserListDto>, String>((ref, instituteOrAdminId) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getAllUsers(instituteOrAdminId);
});

/// Fetches the detail for a SINGLE user using their ID.
final userDetailProvider = FutureProvider.family<UserDetailDto, String>((ref, userId) {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getUserById(userId);
});
