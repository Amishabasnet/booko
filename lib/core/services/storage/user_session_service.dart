import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/shared_prefs_provider.dart';

final UserSessionServiceProvider = Provider<UserSessionService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider); // reads SAME provider
  return UserSessionService(prefs: prefs);
});

class UserSessionService {
  final SharedPreferences _prefs;

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserName = 'user_name';
  static const String _keyUserPhoneNumber = 'user_phone_number';
  static const String _keyUserDOB = 'user_DOB';
  static const String _keyUserGender = 'user_gender';

  Future<void> saveUserSession({
    required String userId,
    required String? email,
    required String name,
    required String? dob,
    required String? gender,
    required String? phoneNumber,
    required dynamic hiveModel,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserName, name);

    if (email != null) {
      await _prefs.setString(_keyUserEmail, email);
    } else {
      await _prefs.remove(_keyUserEmail);
    }

    if (dob != null) {
      await _prefs.setString(_keyUserDOB, dob);
    } else {
      await _prefs.remove(_keyUserDOB);
    }

    if (gender != null) {
      await _prefs.setString(_keyUserGender, gender);
    } else {
      await _prefs.remove(_keyUserGender);
    }

    if (phoneNumber != null) {
      await _prefs.setString(_keyUserPhoneNumber, phoneNumber);
    } else {
      await _prefs.remove(_keyUserPhoneNumber);
    }
  }

  Future<void> clearUserSession() async {
    await _prefs.setBool(_keyIsLoggedIn, false);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserName);
    await _prefs.remove(_keyUserPhoneNumber);
    await _prefs.remove(_keyUserDOB);
    await _prefs.remove(_keyUserGender);
    await _prefs.remove('token');
  }

  Future<void> saveToken(String token) async {
    await _prefs.setString('token', token);
  }

  String? getToken() => _prefs.getString('token');

  bool isUserLoggedIn() => _prefs.getBool(_keyIsLoggedIn) ?? false;

  String? getUserId() => _prefs.getString(_keyUserId);
  String? getUserEmail() => _prefs.getString(_keyUserEmail);
  String? getUserFullName() => _prefs.getString(_keyUserName);
  String? getUserPhoneNumber() => _prefs.getString(_keyUserPhoneNumber);
  String? getUserDOB() => _prefs.getString(_keyUserDOB);
  String? getUserGender() => _prefs.getString(_keyUserGender);

  Future<String?> getName() async => getUserFullName();
  Future<String?> getEmail() async => getUserEmail();
  Future<String?> getPhoneNumber() async => getUserPhoneNumber();
  Future<String?> getDob() async => getUserDOB();
  Future<String?> getGender() async => getUserGender();

  Future<dynamic> getUserSession() async {}
}
