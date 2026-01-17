import 'package:booko/core/services/hive/hive_service.dart';
import 'package:booko/core/services/storage/user_session_service.dart';
import 'package:booko/features/auth/data/datasources/remote/auth_datasource.dart';
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

class AuthLocalDatasource implements IAuthDatasource {
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
          fullName: user.fullName,
          dob: user.dob,
          gender: user.gender,
          phoneNumber: user.phoneNumber,
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
}
