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
  final AuthHiveService _hiveService;

  AuthLocalDatasource({required AuthHiveService hiveService})
    : _hiveService = hiveService;

  @override
  Future<AuthHiveModel> login(String email, String password) async {
    final user = await _hiveService.loginUser(email, password);
    if (user != null) {
      return user;
    }
    throw Exception('Invalid email or password');
  }

  @override
  Future<bool> logout() async {
    await _hiveService.logoutUser();
    return true;
  }

  @override
  Future<bool> register(AuthHiveModel model) async {
    await _hiveService.registerUser(model);
    return true;
  }
}
