import 'package:booko/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity?> getProfile(); // nullable (first time)
  Future<void> saveProfile(ProfileEntity profile);
  Future<void> clearProfile();
}
