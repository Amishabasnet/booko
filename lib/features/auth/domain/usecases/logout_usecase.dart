import 'package:booko/core/error/failures.dart';
import 'package:booko/features/auth/data/repositories/auth_repository.dart';
import 'package:booko/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for logout usecase
final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LogoutUsecase(authRepository: authRepository);
});

class LogoutUsecase {
  final IAuthRepository _authRepository;

  LogoutUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  /// Executes logout
  /// Clears tokens, local storage, and user session
  Future<Either<Failure, bool>> call() async {
    final result = await _authRepository.logout();

    return result.fold((failure) => Left(failure), (_) => const Right(true));
  }
}
