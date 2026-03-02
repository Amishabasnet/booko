import 'package:hive/hive.dart';
import '../models/profile_hive_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileHiveModel?> getProfile();
  Future<void> saveProfile(ProfileHiveModel model);
  Future<void> deleteProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileLocalDataSourceImpl(this.box);

  final Box<ProfileHiveModel> box;
  static const _key = 'profile';

  @override
  Future<ProfileHiveModel?> getProfile() async => box.get(_key);

  @override
  Future<void> saveProfile(ProfileHiveModel model) async {
    await box.put(_key, model);
  }

  @override
  Future<void> deleteProfile() async {
    await box.delete(_key);
  }
}
