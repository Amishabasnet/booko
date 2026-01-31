import 'package:booko/features/profile/data/models/profile_hive_model.dart';
import 'package:hive/hive.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileHiveModel?> getProfile();
  Future<void> saveProfile(ProfileHiveModel model);
  Future<void> clearProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  static const _boxName = 'profileBox';
  static const _key = 'profile';

  Box<ProfileHiveModel> get _box => Hive.box<ProfileHiveModel>(_boxName);

  @override
  Future<ProfileHiveModel?> getProfile() async {
    return _box.get(_key);
  }

  @override
  Future<void> saveProfile(ProfileHiveModel model) async {
    await _box.put(_key, model);
  }

  @override
  Future<void> clearProfile() async {
    await _box.delete(_key);
  }
}
