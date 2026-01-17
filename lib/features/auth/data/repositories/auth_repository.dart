import 'package:booko/core/error/failures.dart';
import 'package:booko/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:booko/features/auth/data/datasources/remote/auth_datasource.dart';
import 'package:booko/features/auth/data/models/auth_hive_model.dart';
import 'package:booko/features/auth/domain/entities/auth_entity.dart';
import 'package:booko/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.watch(authLocalDatasourceProvider);
  return AuthRepository(authDatasource: authDatasource);
});

class AuthRepository implements IAuthRepository {
  late final IAuthDatasource _authDatasource;
  AuthRepository({required IAuthDatasource authDatasource})
    : _authDatasource = authDatasource;

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      return _authDatasource.login(email, password).then((model) {
        final entity = model?.toEntity();
        return Right(entity!);
      });
    } catch (e) {
      return Future.value(Left(LocalDatabaseFailure(message: e.toString())));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authDatasource.logout();
      if (result) {
        return Right(true);
      } else {
        return Left(LocalDatabaseFailure(message: 'Logout failed'));
      }
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    try {
      final model = AuthHiveModel.fromEntity(entity);
      final result = await _authDatasource.register(model);
      if (result) {
        return Right(true);
      } else {
        return Left(LocalDatabaseFailure(message: 'Registration failed'));
      }
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
