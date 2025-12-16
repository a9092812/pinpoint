 
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinpoint/data/network/interseptor/auth_dio_intersecptor.dart';
import 'package:pinpoint/viewModel/storage/secure_storage_provider.dart';
 
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();
  
   final storageService = ref.watch(secureStorageProvider);

   dio.interceptors.add(AuthInterceptor(storageService));
  
   dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));

  return dio;
});