import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../domain/entities/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity?> getProfile();
  Future<void> saveProfile(ProfileEntity profile);
  Future<void> deleteProfile();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
    required this.tokenProvider,
  });

  final http.Client client;
  final String baseUrl;

  /// Return auth token string (or null if not logged in)
  final Future<String?> Function() tokenProvider;

  Uri _uri(String path) => Uri.parse('$baseUrl$path');

  Future<Map<String, String>> _headers() async {
    final token = await tokenProvider();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  // ✅ Change these if your backend endpoints differ:
  static const _profilePath = '/users/profile';

  ProfileEntity _fromJson(Map<String, dynamic> json) {
    // If your API is {data:{...}}, use: final m = json['data'] as Map<String,dynamic>;
    final fullName = (json['fullName'] ?? json['name'] ?? '').toString();
    final email = (json['email'] ?? '').toString();
    final phone = (json['phone'] ?? json['phoneNumber'] ?? '').toString();
    final gender = (json['gender'] ?? 'Female').toString();

    // dob may be ISO string OR "dd-mm-yyyy"
    final dobRaw = (json['dob'] ?? json['dateOfBirth'] ?? '').toString();
    final parsedDob =
        DateTime.tryParse(dobRaw) ??
        _tryParseDdMmYyyy(dobRaw) ??
        DateTime(2000, 1, 1);

    return ProfileEntity(
      fullName: fullName,
      email: email,
      phone: phone,
      dob: parsedDob,
      gender: gender,
    );
  }

  Map<String, dynamic> _toJson(ProfileEntity e) {
    return {
      'fullName': e.fullName,
      'email': e.email,
      'phone': e.phone,
      'dob': e.dob.toUtc().toIso8601String(),
      'gender': e.gender,
    };
  }

  DateTime? _tryParseDdMmYyyy(String s) {
    final parts = s.split('-');
    if (parts.length != 3) return null;
    final dd = int.tryParse(parts[0]);
    final mm = int.tryParse(parts[1]);
    final yy = int.tryParse(parts[2]);
    if (dd == null || mm == null || yy == null) return null;
    return DateTime(yy, mm, dd);
  }

  @override
  Future<ProfileEntity?> getProfile() async {
    final res = await client.get(_uri(_profilePath), headers: await _headers());

    if (res.statusCode == 404) return null;
    if (res.statusCode != 200) {
      throw Exception('Remote getProfile failed: ${res.statusCode}');
    }

    final decoded = jsonDecode(res.body);

    // supports: {"fullName":...} OR {"data":{...}}
    if (decoded is Map<String, dynamic>) {
      final map = (decoded['data'] is Map<String, dynamic>)
          ? decoded['data'] as Map<String, dynamic>
          : decoded;

      return _fromJson(map);
    }

    throw Exception('Unexpected response format');
  }

  @override
  Future<void> saveProfile(ProfileEntity profile) async {
    final res = await client.put(
      _uri(_profilePath),
      headers: await _headers(),
      body: jsonEncode(_toJson(profile)),
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Remote saveProfile failed: ${res.statusCode}');
    }
  }

  @override
  Future<void> deleteProfile() async {
    final res = await client.delete(
      _uri(_profilePath),
      headers: await _headers(),
    );

    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Remote deleteProfile failed: ${res.statusCode}');
    }
  }
}
