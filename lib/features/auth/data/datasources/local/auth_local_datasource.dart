import 'package:booko/core/services/hive/hive_service.dart';
import 'package:booko/core/services/storage/user_session_service.dart';
import 'package:booko/features/auth/data/datasources/auth_datasource.dart';
import 'package:booko/features/auth/data/models/auth_api_model.dart';
import 'package:booko/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  final userSessionService = ref.watch(UserSessionServiceProvider);

  return AuthLocalDatasource(
    hiveService: hiveService,
    userSessionService: userSessionService,
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
    final user = await _hiveService.login(email, password);
    if (user != null) {
      await _userSessionService.saveUserSession(
        userId: user.authId ?? '',
        email: user.email,
        name: user.name,
        dob: user.dob,
        gender: user.gender,
        phoneNumber: user.phoneNumber,
        hiveModel: user,
      );
    }
    return user;
  }

  @override
  Future<bool> logout() async {
    await _hiveService.logoutUser();
    await _userSessionService.clearUserSession();
    return true;
  }

  @override
  Future<bool> register(AuthHiveModel model) async {
    await _hiveService.registerUser(model);
    await saveUser(AuthApiModel.fromHiveModel(model));
    return true;
  }

  @override
  Future<void> saveUser(AuthApiModel response) async {
    final hiveModel = AuthHiveModel(
      authId: response.id,
      name: response.name,
      email: response.email,
      phoneNumber: response.phoneNumber,
      dob: response.dob?.toIso8601String(),
      gender: response.gender,
      password: response.password,
    );

    await _hiveService.saveUser(hiveModel);

    await _userSessionService.saveUserSession(
      userId: hiveModel.authId ?? '',
      email: hiveModel.email,
      name: hiveModel.name,
      dob: hiveModel.dob,
      gender: hiveModel.gender,
      phoneNumber: hiveModel.phoneNumber,
      hiveModel: hiveModel,
    );
  }

  @override
  Future<AuthHiveModel?> getCurrentUser() async {
    final session = await _userSessionService.getUserSession();
    if (session == null) return null;
    return await _hiveService.getUserById(session.userId);
  }

  @override
  Future<AuthHiveModel?> getUserById(String authId) async {
    return await _hiveService.getUserById(authId);
  }

  @override
  Future<AuthHiveModel?> updateUser(AuthHiveModel model) async {
    await _hiveService.updateUser(model);
    await saveUser(AuthApiModel.fromHiveModel(model));
    return model;
  }

  @override
  Future<bool> updatedUser(AuthHiveModel user) async {
    await _hiveService.updateUser(user);
    await saveUser(AuthApiModel.fromHiveModel(user));
    return true;
  }

  @override
  Future<bool> deleteUser(String authId) async {
    await _hiveService.deleteUser(authId);
    await _userSessionService.clearUserSession();
    return true;
  }
}
