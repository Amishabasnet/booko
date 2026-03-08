import 'package:booko/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:booko/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileLocalDataSourceProvider = Provider<ProfileLocalDataSourceImpl>((
  ref,
) {
  throw UnimplementedError(
    'profileLocalDataSourceProvider must be overridden in main.dart',
  );
});

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSourceImpl>((
  ref,
) {
  throw UnimplementedError(
    'profileRemoteDataSourceProvider must be overridden in main.dart',
  );
});
