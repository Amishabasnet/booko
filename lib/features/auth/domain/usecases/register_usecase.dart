import 'package:booko/core/error/failures.dart';
import 'package:booko/features/auth/data/repositories/auth_repository.dart';
import 'package:booko/features/auth/domain/entities/auth_entity.dart';
import 'package:booko/features/auth/domain/repositories/auth_repository.dart';
import 'package:booko/features/auth/domain/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterUsecaseParams extends Equatable {
  final String name;
  final String email;
  final String? phoneNumber;
  final String? dob;
  final String? gender;
  final String password;

  const RegisterUsecaseParams({
    required this.name,
    required this.email,
    this.phoneNumber,
    this.dob,
    this.gender,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password, name, phoneNumber, dob, gender];
}

//Provider for register usecase
final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

class RegisterUsecase
    implements UseCaseWithParams<bool, RegisterUsecaseParams> {
  final IAuthRepository _authRepository;

  RegisterUsecase({required IAuthRepository authRepository})
    : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call(RegisterUsecaseParams params) {
    final entity = AuthEntity(
      authId: null,
      name: params.name,
      email: params.email,
      phoneNumber: params.phoneNumber,
      dob: params.dob,
      gender: params.gender,
      password: params.password,
    );
    return _authRepository.register(entity);
  }
}
