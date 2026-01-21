import 'package:booko/core/services/hive/hive_service.dart';
import 'package:booko/core/services/storage/user_session_service.dart';
import 'package:booko/features/auth/data/datasources/auth_datasource.dart';
import 'package:booko/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.read(hiveServiceProvider);
  final UserSessionService = ref.read(UserSessionServiceProvider);
  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: UserSessionService,
  );
});

class AuthLocalDatasource implements IAuthLocalDatasource {
  final AuthHiveService _hiveService;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required AuthHiveService hiveService,
    required UserSessionService userSessionService,
  }) : _hiveService = hiveService,
       _userSessionService = userSessionService;

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = await _hiveService.login(email, password);
      // save user details to share prefs
      if (user != null) {
        await _userSessionService.saveUserSession(
          userId: user.authId!,
          email: user.email,
          name: user.name,
          dob: user.dob,
          gender: user.gender,
          phoneNumber: user.phoneNumber,
          hiveModel: null,
        );
      }
      return user;
    } catch (e) {
      return null;
    }
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

  @override
  Future<bool> deleteUser(String authId) {
    // TODO: implement deleteUser
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<AuthHiveModel?> updateUser(AuthHiveModel model) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }

  @override
  Future<bool> updatedUser(AuthHiveModel user) {
    // TODO: implement updatedUser
    throw UnimplementedError();
  }
}
