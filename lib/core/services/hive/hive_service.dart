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
  Future<void> init() async {
    await Hive.initFlutter();
    _registerAdapters();
    await _openBoxes();
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
    // Save user under email key
    await authBox.put(user.email, user);

    // Optional: double-check the save
    final savedUser = authBox.get(user.email);
    if (savedUser == null) {
      throw Exception('Failed to save user: ${user.email}');
    }

    return savedUser;
  }

  /// Login user
  Future<AuthHiveModel?> login(String email, String password) async {
    final user = authBox.get(email);

    if (user == null) return null; // user not registered

    if (user.password != password) return null; // wrong password

    // Save session
    await sessionBox.put(currentUserKey, user.email);

    return user;
  }

  /// Logout user (clear session only)
  Future<void> logoutUser() async {
    await sessionBox.delete(currentUserKey);
  }

  /// Get current logged-in user
  AuthHiveModel? getCurrentUser() {
    final email = sessionBox.get(currentUserKey);
    if (email == null) return null;
    return authBox.get(email);
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

  /// Close Hive
  Future<void> close() async {
    await _authBox?.close();
    await _sessionBox?.close();
  }

  /// Save user to Hive
  Future<void> saveUser(AuthHiveModel hiveModel) async {
    await authBox.put(hiveModel.email, hiveModel);
  }

  /// Get user by ID (email in this case)
  Future<AuthHiveModel?> getUserById(String userId) async {
    try {
      return authBox.get(userId);
    } catch (_) {
      return null;
    }
  }
}
