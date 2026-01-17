import 'package:booko/features/auth/data/models/auth_api_model.dart';
import 'package:booko/features/auth/data/models/auth_hive_model.dart';

abstract class IAuthLocalDatasource {
  Future<AuthHiveModel?> login(String email, String password);
  Future<bool> logout();
  Future<bool> register(AuthHiveModel model);
  Future<AuthHiveModel?> getCurrentUser();
  Future<AuthHiveModel?> updateUser(AuthHiveModel model);
  Future<AuthHiveModel?> getUserById(String authId);
  Future<bool> deleteUser(String authId);
  Future<bool> updatedUser(AuthHiveModel user);
}

abstract interface class IAuthRemoteDatasource {
  Future<AuthApiModel?> login(String email, String password);
  Future<AuthApiModel> register(AuthApiModel model);
  Future<AuthApiModel?> getUserById(String authId);
}
