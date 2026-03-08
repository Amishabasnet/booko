import 'package:booko/core/error/failures.dart';
import 'package:booko/core/services/connectivity/network_info.dart';
import 'package:booko/features/auth/data/datasources/auth_datasource.dart';
import 'package:booko/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:booko/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:booko/features/auth/data/models/auth_api_model.dart';
import 'package:booko/features/auth/domain/entities/auth_entity.dart';
import 'package:booko/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.watch(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.watch(authRemoteDatasourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return AuthRepository(
    authDatasource: authDatasource,
    authRemoteDatasource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDatasource _authDatasource;
  final IAuthRemoteDatasource _authRemoteDatasource;
  final INetworkInfo _networkInfo;

  AuthRepository({
    required IAuthLocalDatasource authDatasource,
    required IAuthRemoteDatasource authRemoteDatasource,
    required INetworkInfo networkInfo,
  }) : _authDatasource = authDatasource,
       _authRemoteDatasource = authRemoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      if (await _networkInfo.isConnected) {
        // Try remote login first
        final remoteUser = await _authRemoteDatasource.login(email, password);
        if (remoteUser != null) {
          // Save user locally for offline use
          await _authDatasource.saveUser(remoteUser);
          return Right(remoteUser.toEntity());
        }
        return Left(ApiFailure('No user found or invalid credentials'));
      } else {
        // Fallback to local login
        final localUser = await _authDatasource.login(email, password);
        if (localUser != null) {
          return Right(localUser.toEntity());
        }
        return Left(
          LocalDatabaseFailure(
            'No local user found. Please connect to the internet.',
          ),
        );
      }
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      final result = await _authDatasource.logout();
      return result
          ? const Right(true)
          : Left(LocalDatabaseFailure('Logout failed'));
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    try {
      // Convert entity to API model
      final apiModel = AuthApiModel.fromEntity(entity);

      // Call remote datasource if connected
      final response = await _authRemoteDatasource.register(apiModel);

      // Save user locally regardless of network response
      final userToSave =
          response ?? apiModel; // fallback to API model if response null
      await _authDatasource.saveUser(userToSave);

      return const Right(true);
    } catch (e) {
      return Left(ApiFailure(e.toString()));
    }
  }
}
