import 'package:booko/core/api/api_client.dart';
import 'package:booko/core/api/api_endpoints.dart';
import 'package:booko/core/services/storage/user_session_service.dart';
import 'package:booko/features/auth/data/datasources/auth_datasource.dart';
import 'package:booko/features/auth/data/models/auth_api_model.dart';
import 'package:booko/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final userSessionService = ref.read(UserSessionServiceProvider);

  return AuthRemoteDatasource(
    apiClient: apiClient,
    userSessionService: userSessionService,
  );
});

class AuthRemoteDatasource implements IAuthRemoteDatasource {
  late final ApiClient _apiClient;
  late final UserSessionService _userSessionService;

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    // TODO: implement getUserById
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

      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;

        final user = AuthApiModel.fromJson(data);

        // ✅ convert API model → Hive model
        final hiveModel = AuthHiveModel.fromApiModel(user);

        // ✅ Save REAL user session (not empty values)
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
      }

      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // ================= REGISTER =================
  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    final response = await _apiClient.post(
      ApiEndpoints.userRegister,
      data: user.toJson(),
    );

    if (response.data['success'] == true) {
      final data = response.data['data'] as Map<String, dynamic>;

      final registeredUser = AuthApiModel.fromJson(data);

      // ✅ ALSO SAVE SESSION AFTER REGISTER
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
    }

    return user;
  }
}
