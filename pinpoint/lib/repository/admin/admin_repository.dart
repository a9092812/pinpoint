
import 'package:dio/dio.dart';
import 'package:pinpoint/DTO/auth.dart';
import 'package:pinpoint/data/datasource/admin/admin_service.dart';
import 'package:pinpoint/model/admin/admin_request.dart';
import 'package:pinpoint/model/admin/admin_response.dart';

class AdminRepository {
  final AdminService _adminService;

  AdminRepository(this._adminService);

   Future<List<AdminResponse>> getAdminsByInstitute(String instituteId) async {
    try {
      final response = await _adminService.getAdminsByInstitute(instituteId);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch admins: ${e.message}');
    }
  }

   Future<AdminResponse> getAdminById(String adminId) async {
    try {
      final response = await _adminService.getAdminById(adminId);
      return response.data;
    } on DioException catch (e) {
      throw Exception('Failed to fetch admin details: ${e.message}');
    }
  }

  Future<void> createAdmin(AuthRequest request) async {
  try {
    await _adminService.createAdmin(request);
  } on DioException catch (e) {
    throw Exception('Failed to create admin: ${e.message}');
  }
}


Future<AdminResponse> getAdminByEmail(String email) async {
  try {
    final response = await _adminService.getAdminByEmail(email);
    return response.data;
  } on DioException catch (e) {
    throw Exception('Failed to fetch admin by email: ${e.message}');
  }
}


   Future<void> updateAdmin(String adminId, AdminRequest request) async {
    try {
      await _adminService.updateAdmin(adminId, request);
    } on DioException catch (e) {
      throw Exception('Failed to update admin: ${e.message}');
    }
  }

   Future<void> deleteAdmin(String adminId) async {
    try {
      await _adminService.deleteAdmin(adminId);
    } on DioException catch (e) {
      throw Exception('Failed to delete admin: ${e.message}');
    }
  }
}
