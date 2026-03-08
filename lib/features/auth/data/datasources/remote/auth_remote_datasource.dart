import 'dart:developer';

import 'package:booko/core/api/api_client.dart';
import 'package:booko/core/api/api_endpoints.dart';
import 'package:booko/core/services/storage/user_session_service.dart';
import 'package:booko/features/auth/data/datasources/auth_datasource.dart';
import 'package:booko/features/auth/data/models/auth_api_model.dart';
import 'package:booko/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final userSessionService = ref.watch(UserSessionServiceProvider);

  return AuthRemoteDatasource(
    apiClient: apiClient,
    userSessionService: userSessionService,
  );
});

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    throw UnimplementedError();
  }

  // ================= LOGIN =================
  @override
  Future<AuthApiModel?> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.userLogin,
        data: {'email': email, 'password': password},
      );

      log('Login API response: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;

        final user = AuthApiModel.fromJson(data);

        final hiveModel = AuthHiveModel.fromApiModel(user);

        await _userSessionService.saveUserSession(
          userId: hiveModel.authId ?? '',
          email: hiveModel.email,
          name: hiveModel.name,
          dob: hiveModel.dob,
          gender: hiveModel.gender,
          phoneNumber: hiveModel.phoneNumber,
          hiveModel: hiveModel,
        );

        return user;
      } else if (response.data != null && response.data['success'] == false) {
        log('Login failed: ${response.data['message']}');
        return null;
      } else {
        log('Unexpected login response: ${response.data}');
        return null;
      }
    } catch (e, st) {
      log('Login exception', error: e, stackTrace: st);
      return null;
    }
  }

  // ================= REGISTER =================
  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.userRegister,
        data: user.toJson(),
      );

      log('Register API response: ${response.data}');

      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final registeredUser = AuthApiModel.fromJson(data);

        final hiveModel = AuthHiveModel.fromApiModel(registeredUser);

        await _userSessionService.saveUserSession(
          userId: hiveModel.authId ?? '',
          email: hiveModel.email,
          name: hiveModel.name,
          dob: hiveModel.dob,
          gender: hiveModel.gender,
          phoneNumber: hiveModel.phoneNumber,
          hiveModel: hiveModel,
        );

        return registeredUser;
      } else {
        log('Register failed: ${response.data['message']}');
        return user;
      }
    } catch (e, st) {
      log('Register exception', error: e, stackTrace: st);
      return user;
    }
  }
}
