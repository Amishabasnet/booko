import 'package:booko/features/auth/domain/usecases/login_usecase.dart';
import 'package:booko/features/auth/domain/usecases/register_usecase.dart';
import 'package:booko/features/auth/presentation/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final authViewmodelProvider = NotifierProvider<AuthViewmodel, AuthState>(
  AuthViewmodel.new,
);

class AuthViewmodel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.watch(registerUsecaseProvider);
    _loginUsecase = ref.watch(loginUsecaseProvider);
    return const AuthState(status: AuthStatus.initial);
  }

  /// Register user
  Future<void> register({
    required String name,
    required String email,
    String? phoneNumber,
    String? dob,
    String? gender,
    required String password,
    required String username,
  }) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      isLoading: true,
      clearErrorMessage: true,
    );

    final params = RegisterUsecaseParams(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      dob: dob,
      gender: gender,
      password: password,
    );

    final result = await _registerUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(
          status: AuthStatus.registered,
          isLoading: false,
          clearErrorMessage: true,
        );
      },
    );
  }

  /// Login user
  Future<void> login({required String email, required String password}) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      isLoading: true,
      clearErrorMessage: true,
    );

    final params = LoginUsecaseParams(email: email, password: password);

    final result = await _loginUsecase(params);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.error,
          isLoading: false,
          errorMessage: failure.message,
          clearAuthEntity: true,
        );
      },
      (authEntity) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          isLoading: false,
          authEntity: authEntity,
          clearErrorMessage: true,
        );
      },
    );
  }

  /// Logout user
  void logout() {
    state = const AuthState(
      status: AuthStatus.unauthenticated,
      isLoading: false,
      errorMessage: null,
      authEntity: null,
    );
  }

  /// Reset only error
  void resetError() {
    state = state.copyWith(clearErrorMessage: true);
  }

  /// Reset whole auth state
  void resetState() {
    state = const AuthState(
      status: AuthStatus.initial,
      isLoading: false,
      errorMessage: null,
      authEntity: null,
    );
  }
}
