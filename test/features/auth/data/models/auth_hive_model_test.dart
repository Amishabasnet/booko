import 'package:booko/features/auth/data/models/auth_hive_model.dart';
import 'package:booko/features/auth/domain/entities/auth_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tAuthEntity = AuthEntity(
    authId: '1',
    name: 'Test User',
    email: 'test@example.com',
    phoneNumber: '1234567890',
    dob: '1990-01-01',
    gender: 'Male',
    password: 'password123',
  );

  final tAuthHiveModel = AuthHiveModel(
    authId: '1',
    name: 'Test User',
    email: 'test@example.com',
    phoneNumber: '1234567890',
    dob: '1990-01-01',
    gender: 'Male',
    password: 'password123',
  );

  test('should return a valid AuthHiveModel from AuthEntity', () {
    // act
    final result = AuthHiveModel.fromEntity(tAuthEntity);

    // assert
    expect(result.authId, tAuthHiveModel.authId);
    expect(result.name, tAuthHiveModel.name);
    expect(result.email, tAuthHiveModel.email);
    expect(result.phoneNumber, tAuthHiveModel.phoneNumber);
    expect(result.dob, tAuthHiveModel.dob);
    expect(result.gender, tAuthHiveModel.gender);
    expect(result.password, tAuthHiveModel.password);
  });

  test('should return a valid AuthEntity from AuthHiveModel', () {
    // act
    final result = tAuthHiveModel.toEntity();

    // assert
    expect(result, tAuthEntity);
  });
}
