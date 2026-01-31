import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/local/profile_local_datasource.dart';
import '../models/profile_hive_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource local;

  ProfileRepositoryImpl({required this.local});

  @override
  Future<ProfileEntity?> getProfile() async {
    final data = await local.getProfile();
    if (data == null) return null;

    return ProfileEntity(
      name: data.name,
      email: data.email,
      phoneNumber: data.phoneNumber,
      dob: data.dob,
      gender: data.gender,
      imagePath: data.imagePath,
    );
  }

  @override
  Future<void> saveProfile(ProfileEntity profile) async {
    final model = ProfileHiveModel(
      name: profile.name,
      email: profile.email,
      phoneNumber: profile.phoneNumber,
      dob: profile.dob,
      gender: profile.gender,
      imagePath: profile.imagePath,
    );
    await local.saveProfile(model);
  }

  @override
  Future<void> clearProfile() => local.clearProfile();
}
