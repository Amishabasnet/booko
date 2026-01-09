import 'package:booko/features/auth/domain/entities/auth_entity.dart';
import 'package:equatable/equatable.dart';

enum AuthStatus { initial, loading, authenticated, registered, error }

class AuthState extends Equatable {
  final AuthStatus status;
  final bool isLoading;
  final String? errorMessage;
  final AuthEntity? authEntity;

  const AuthState({
    this.status = AuthStatus.initial,
    this.isLoading = false,
    this.errorMessage,
    this.authEntity,
  });

  AuthState copyWith({
    AuthStatus? status,
    bool? isLoading,
    String? errorMessage,
    AuthEntity? authEntity,
  }) {
    return AuthState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      authEntity: authEntity ?? this.authEntity,
    );
  }

  @override
  List<Object?> get props => [status, isLoading, errorMessage, authEntity];
}
