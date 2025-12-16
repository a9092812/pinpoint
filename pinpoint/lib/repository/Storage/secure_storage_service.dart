import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _jwtKey = 'jwt_token';
  static const _userRoleKey = 'user_role';
  static const _userIdKey = 'user_id';
    static const _userEmail = 'user_email';


  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveAuthData({
    required String jwt,
    required String role,
    required String userEmail,
  }) async {
    await _storage.write(key: _jwtKey, value: jwt);
    await _storage.write(key: _userRoleKey, value: role);
    await _storage.write(key: _userEmail, value: userEmail);
  }

   Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<String?> get jwt async => await _storage.read(key: _jwtKey);
  Future<String?> get role async => await _storage.read(key: _userRoleKey);
  Future<String?> get userEmail async => await _storage.read(key: _userEmail);
    Future<String?> get userId async => await _storage.read(key: _userIdKey);


  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<bool> isLoggedIn() async {
    final token = await jwt;
    return token != null && token.isNotEmpty;
  }
}
