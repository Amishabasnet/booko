import 'package:booko/core/constants/hive_table_constants.dart';
import 'package:booko/features/auth/data/models/auth_hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// Provider
final hiveServiceProvider = Provider<AuthHiveService>((ref) {
  return AuthHiveService();
});

class AuthHiveService {
  Box<AuthHiveModel>? _authBox;

  /// Initialize Hive and open boxes
  Future<void> init() async {
    await Hive.initFlutter();

    _registerAdapters();
    await _openBoxes();
    await insertDummyUsers();
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
  }

  /// Get Auth box safely
  Box<AuthHiveModel> get authBox {
    if (_authBox == null || !_authBox!.isOpen) {
      throw Exception('Hive box not initialized. Call init() first.');
    }
    return _authBox!;
  }

  // ==================== CRUD Operations ====================

  /// Add user (register)
  Future<AuthHiveModel> registerUser(AuthHiveModel user) async {
    await authBox.put(user.username, user);
    return user;
  }

  /// Login user
  Future<AuthHiveModel?> loginUser(String email, String password) async {
    final matches = authBox.values.where(
      (u) => u.email == email && u.password == password,
    );
    if (matches.isNotEmpty) return matches.first;
    return null;
  }

  /// Logout user
  Future<void> logoutUser(String username) async {
    await authBox.delete(username);
  }

  /// Get all users
  List<AuthHiveModel> getAllUsers() {
    return authBox.values.toList();
  }

  /// Get user by username
  AuthHiveModel? getUserByUsername(String username) {
    return authBox.get(username);
  }

  /// Update user
  Future<bool> updateUser(AuthHiveModel user) async {
    if (authBox.containsKey(user.username)) {
      await authBox.put(user.username, user);
      return true;
    }
    return false;
  }

  /// Delete user
  Future<void> deleteUser(String username) async {
    await authBox.delete(username);
  }

  /// Delete all users
  Future<void> deleteAllUsers() async {
    await authBox.clear();
  }

  /// Insert dummy users (for testing/demo)
  Future<void> insertDummyUsers() async {
    if (authBox.isNotEmpty) return;

    final dummyUsers = [
      AuthHiveModel(
        fullName: 'Admin User',
        email: 'admin@booko.com',
        username: 'admin',
        dob: '2002-01-30',
        gender: 'Male',
        password: 'admin123',
      ),
      AuthHiveModel(
        fullName: 'Test User',
        email: 'test@booko.com',
        username: 'testuser',
        dob: '2001-06-17',
        gender: 'Female',
        password: 'test123',
      ),
    ];

    for (var user in dummyUsers) {
      await authBox.put(user.username, user);
    }
  }

  /// Close Hive
  Future<void> close() async {
    await Hive.close();
  }
}
