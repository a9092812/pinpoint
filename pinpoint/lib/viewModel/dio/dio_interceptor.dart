// lib/viewModel/dio/auth_interceptor.dart

import 'package:dio/dio.dart';
import 'package:pinpoint/repository/storage/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService;

  AuthInterceptor(this._storageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get the JWT from secure storage
    final token = await _storageService.jwt;

    // If the token exists, add it to the Authorization header
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Continue with the request
    return super.onRequest(options, handler);
  }
}