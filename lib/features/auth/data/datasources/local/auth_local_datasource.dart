import 'package:booko/core/services/hive/hive_service.dart';
import 'package:booko/features/auth/data/datasources/remote/auth_datasource.dart';
import 'package:booko/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return AuthLocalDatasource(hiveService: hiveService);
});

class AuthLocalDatasource implements IAuthDatasource {
  final HiveService _hiveService;

  AuthLocalDatasource({required HiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<AuthHiveModel> login(String email, String password) async {
    try {
      final user = _hiveService.loginUser(email, password);
      if (user != null) {
        return user;
      } else {
        throw Exception('Invalid email or password');
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _hiveService.logoutUser();
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> register(AuthHiveModel model) async {
    try {
      await _hiveService.registerUser(model);
      return true;
    } catch (_) {
      return false;
    }
  }
}
