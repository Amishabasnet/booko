import 'package:booko/core/error/failures.dart';
import 'package:booko/core/services/connectivity/network_info.dart';
import 'package:booko/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:booko/features/auth/data/datasources/auth_datasource.dart';
import 'package:booko/features/auth/data/datasources/remote/auth_remote_datasource.dart';
import 'package:booko/features/auth/data/models/auth_api_model.dart';
import 'package:booko/features/auth/domain/entities/auth_entity.dart';
import 'package:booko/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.watch(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.watch(authRemoteDatasourceProvider);
  final networkInfo = ref.watch(networkInfoProvider); // INetworkInfo

  return AuthRepository(
    authDatasource: authDatasource,
    authRemoteDatasource: authRemoteDatasource,
    networkInfo: networkInfo, // now matches INetworkInfo
  );
});

class AuthRepository implements IAuthRepository {
  final IAuthLocalDatasource _authDatasource;
  final IAuthRemoteDatasource _authRemoteDatasource;
  final INetworkInfo _networkInfo; // <-- interface type

  AuthRepository({
    required IAuthLocalDatasource authDatasource,
    required IAuthRemoteDatasource authRemoteDatasource,
    required INetworkInfo networkInfo, // <-- interface type
  }) : _authDatasource = authDatasource,
       _authRemoteDatasource = authRemoteDatasource,
       _networkInfo = networkInfo;

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
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(entity);
        await _authRemoteDatasource.register(apiModel);
        return Right(true);
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      final existingUser = await _authDatasource.getCurrentUser();
      if (existingUser != null) {
        return Left(LocalDatabaseFailure(message: 'User already exists'));
      } else {
        // No network & user doesn't exist
        return Left(LocalDatabaseFailure(message: 'No internet connection'));
      }
    }
  }
}
