import 'package:booko/features/auth/data/models/auth_hive_model.dart';

abstract class IAuthDatasource {
  Future<AuthHiveModel?> login(String email, String password);
  Future<bool> logout();
  Future<bool> register(AuthHiveModel model);
}
