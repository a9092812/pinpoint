import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/DTO/auth.dart';
import 'package:pinpoint/data/datasource/auth/auth_service.dart';
import 'package:pinpoint/data/network/interseptor/auth_dio_intersecptor.dart';
import 'package:pinpoint/repository/storage/secure_storage_service.dart';
import 'package:pinpoint/viewModel/storage/secure_storage_provider.dart';

final authProvider = Provider<AuthController>((ref) {
  final storage = ref.read(secureStorageProvider); 

  final dio = Dio();
  dio.interceptors.add(AuthInterceptor(storage)); 

  final authService = AuthService(dio);

  return AuthController(
    authService: authService,
    storageService: storage,
  );
});


class AuthController {
  final AuthService authService;
  final SecureStorageService storageService;

  AuthController({
    required this.authService,
    required this.storageService,
  });

  Future<String?> login(String email, String password) async {
    try {
      final authReq = AuthRequest.forLogin(email: email, password: password);
      final response = await authService.login(authReq);

      if (response.response.statusCode == 200 && response.data.jwt != null) {
        await storageService.saveAuthData(
          jwt: response.data.jwt!,
          role: response.data.role ?? '',
          userEmail: response.data.email ?? '',
        );
        return null;
      } else {
        return response.data.message ?? response.data.error ?? "Login failed";
      }
    } catch (e) {
      debugPrint(e.toString());
      return "Login exception: $e";
    }
  }

  Future<String?> register(AuthRequest request) async {
    try {
      final response = await authService.register(request);
      if (response.response.statusCode == 200) {
        return null;
      } else {
        return response.data.message ?? response.data.error ?? "Registration failed";
      }
    } catch (e) {
      return "Registration exception: $e";
    }
  }

  Future<void> logout() async {
    await storageService.clearAll();
    debugPrint("logout called");
  }

  Future<bool> isLoggedIn() async {
    return await storageService.isLoggedIn();
  }
}
