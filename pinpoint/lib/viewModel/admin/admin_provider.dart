
// Provider for your Retrofit AdminService
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/DTO/auth.dart';
import 'package:pinpoint/data/datasource/admin/admin_service.dart';
import 'package:pinpoint/model/admin/admin_request.dart';
import 'package:pinpoint/model/admin/admin_response.dart';
import 'package:pinpoint/repository/admin/admin_repository.dart';
 import 'package:pinpoint/viewModel/dio/dio_provider.dart';
import 'package:pinpoint/viewModel/storage/secure_storage_provider.dart';

final adminServiceProvider = Provider<AdminService>((ref) {
  return AdminService(ref.watch(dioProvider));
});

// Provider for the AdminRepository
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(ref.watch(adminServiceProvider));
});
 
 class AdminController extends AutoDisposeAsyncNotifier<List<AdminResponse>> {
  @override
  Future<List<AdminResponse>> build() async {
    final storage = ref.watch(secureStorageProvider);
    final instituteId = await storage.userId;

    if (instituteId == null) {
      throw Exception("User not logged in or institute ID not found.");
    }

    final repository = ref.watch(adminRepositoryProvider);
    return repository.getAdminsByInstitute(instituteId);
  }
Future<void> createAdmin(AdminRequest request) async {
  final adminRepository = ref.read(adminRepositoryProvider);
  String? createdAdminId;

  try {
    // Step 0: Check if email already exists
    try {
      final existingAdmin = await adminRepository.getAdminByEmail(request.email!);
      if (existingAdmin != null) {
        throw Exception("Admin with this email already exists.");
      }
    } catch (_) {
      // ignore, means admin does not exist
    }

    // Step 1: Call the existing createAdmin from AdminService
    final authReq = AuthRequest.forRegister(
      email: request.email,
      phone: request.phone,
      password: request.password,
      role: "ADMIN",
    );
    await adminRepository.createAdmin(authReq);

    // Step 2: Fetch by email to get the ID
    final createdAdmin = await adminRepository.getAdminByEmail(request.email!);
    createdAdminId = createdAdmin.id;

    // Step 3: Update extra details if needed
    await adminRepository.updateAdmin(createdAdminId, request);

    // Refresh state
    ref.invalidateSelf();
  } catch (e) {
    // Rollback if partially created
    if (createdAdminId != null) {
      try {
        await adminRepository.deleteAdmin(createdAdminId);
        print("Rollback: Deleted admin $createdAdminId");
      } catch (rollbackError) {
        print("Rollback failed: $rollbackError");
      }
    }
    rethrow;
  }
}


  Future<void> updateAdmin(String adminId, AdminRequest request) async {
    final repository = ref.read(adminRepositoryProvider);
    try {
      await repository.updateAdmin(adminId, request);
      ref.invalidateSelf();
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> deleteAdmin(String adminId) async {
    final repository = ref.read(adminRepositoryProvider);
    try {
      state = state.whenData(
        (admins) => admins.where((admin) => admin.id != adminId).toList(),
      );
      await repository.deleteAdmin(adminId);
    } catch (e) {
      print(e);
      ref.invalidateSelf();
      rethrow;
    }
  }
}


 final adminControllerProvider = AutoDisposeAsyncNotifierProvider<AdminController, List<AdminResponse>>(() {
  return AdminController();
});

 
final adminDetailProvider = FutureProvider.autoDispose.family<AdminResponse, String>((ref, adminId) {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.getAdminById(adminId);
});
