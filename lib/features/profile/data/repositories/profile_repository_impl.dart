import 'package:booko/features/profile/data/datasources/profile_local_datasource.dart';
import 'package:booko/features/profile/data/datasources/profile_remote_datasource.dart';

import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_hive_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl({required this.local, required this.remote});

  final ProfileLocalDataSource local;
  final ProfileRemoteDataSource remote;

  ProfileEntity _fromHive(ProfileHiveModel m) => ProfileEntity(
    fullName: m.fullName,
    email: m.email,
    phone: m.phone,
    dob: m.dob,
    gender: m.gender,
  );

  ProfileHiveModel _toHive(ProfileEntity e) => ProfileHiveModel(
    fullName: e.fullName,
    email: e.email,
    phone: e.phone,
    dob: e.dob,
    gender: e.gender, myTickets: [],
  );

  /// ✅ Local-first, remote-refresh (best effort)
  @override
  Future<ProfileEntity?> getProfile() async {
    final localModel = await local.getProfile();
    final localEntity = localModel == null ? null : _fromHive(localModel);

    try {
      final remoteEntity = await remote.getProfile();
      if (remoteEntity == null) return localEntity;

      await local.saveProfile(_toHive(remoteEntity));
      return remoteEntity;
    } catch (_) {
      return localEntity;
    }
  }

  /// ✅ Save to remote first; cache locally if remote succeeds
  @override
  Future<void> saveProfile(ProfileEntity profile) async {
    await remote.saveProfile(profile);
    await local.saveProfile(_toHive(profile));
  }

  /// ✅ Delete remote first; then local
  @override
  Future<void> deleteProfile() async {
    await remote.deleteProfile();
    await local.deleteProfile();
  }
}
