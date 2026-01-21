import 'package:booko/core/constants/hive_table_constants.dart';
import 'package:booko/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// Provider
final hiveServiceProvider = Provider<AuthHiveService>((ref) {
  return AuthHiveService();
});

class AuthHiveService {
  Box<AuthHiveModel>? _authBox;
  Box<String>? _sessionBox;

  static const String sessionBoxName = 'sessionBox';
  static const String currentUserKey = 'current_user';

  /// Initialize Hive and open boxes
  Future<void> init({bool insertDummy = true}) async {
    await Hive.initFlutter();

    _registerAdapters();
    await _openBoxes();

    if (insertDummy) {
      await insertDummyUsers();
    }
  }

  /// Register Hive adapters
  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstant.authTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }
  }

  /// Open Hive boxes
  Future<void> _openBoxes() async {
    _authBox ??= await Hive.openBox<AuthHiveModel>(HiveTableConstant.authTable);

    _sessionBox ??= await Hive.openBox<String>(sessionBoxName);
  }

  /// Get Auth box safely
  Box<AuthHiveModel> get authBox {
    if (_authBox == null || !_authBox!.isOpen) {
      throw Exception('Hive box not initialized. Call init() first.');
    }
    return _authBox!;
  }

  /// Get Session box safely
  Box<String> get sessionBox {
    if (_sessionBox == null || !_sessionBox!.isOpen) {
      throw Exception('Session box not initialized. Call init() first.');
    }
    return _sessionBox!;
  }

  // ==================== AUTH OPERATIONS ====================

  /// Register user
  Future<AuthHiveModel> registerUser(AuthHiveModel user) async {
    await authBox.put(user.email, user);
    return user;
  }

  /// Login user
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = authBox.values.firstWhere(
        (u) => u.email == email && u.password == password,
      );

      // Save session
      await sessionBox.put(currentUserKey, user.email);
      return user;
    } catch (_) {
      return null;
    }
  }

  /// Logout user (clear session only)
  Future<void> logoutUser() async {
    await sessionBox.delete(currentUserKey);
  }

  /// Get current logged-in user
  AuthHiveModel? getCurrentUser() {
    final username = sessionBox.get(currentUserKey);
    if (username == null) return null;
    return authBox.get(username);
  }

  // ==================== USER MANAGEMENT ====================

  List<AuthHiveModel> getAllUsers() => authBox.values.toList();

  AuthHiveModel? getUserByUsername(String username) {
    return authBox.get(username);
  }

  Future<bool> updateUser(AuthHiveModel user) async {
    if (authBox.containsKey(user.email)) {
      await authBox.put(user.email, user);
      return true;
    }
    return false;
  }

  Future<void> deleteUser(String username) async {
    await authBox.delete(username);
  }

  Future<void> deleteAllUsers() async {
    await authBox.clear();
  }

  /// Insert dummy users (for testing/demo)
  Future<void> insertDummyUsers() async {
    if (authBox.isNotEmpty) return;

    final dummyUsers = [
      AuthHiveModel(
        name: 'Admin User',
        email: 'admin@booko.com',
        phoneNumber: '9874563210',
        dob: '2002-01-30',
        gender: 'Male',
        password: 'admin123',
      ),
      AuthHiveModel(
        name: 'Test User',
        email: 'test@booko.com',
        phoneNumber: '9863254170',
        dob: '2001-06-17',
        gender: 'Female',
        password: 'test123',
      ),
    ];

    for (var user in dummyUsers) {
      await authBox.put(user.email, user);
    }
  }

  /// Close Hive
  Future<void> close() async {
    await _authBox?.close();
    await _sessionBox?.close();
  }
}
