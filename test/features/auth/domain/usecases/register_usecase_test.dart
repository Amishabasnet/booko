import 'package:booko/core/error/failures.dart';
import 'package:booko/features/auth/domain/entities/auth_entity.dart';
import 'package:booko/features/auth/domain/repositories/auth_repository.dart';
import 'package:booko/features/auth/domain/usecases/register_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = RegisterUsecase(authRepository: mockAuthRepository);
    
    // Fallback for AuthEntity if needed for any(that: ...)
    registerFallbackValue(
      const AuthEntity(
        authId: '1',
        name: 'test',
        email: 'test@gmail.com',
        password: 'password',
      ),
    );
  });

  const tParams = RegisterUsecaseParams(
    name: 'Test User',
    email: 'test@example.com',
    password: 'password123',
    phoneNumber: '1234567890',
    dob: '1990-01-01',
    gender: 'Male',
  );

  const tAuthEntity = AuthEntity(
    authId: null,
    name: 'Test User',
    email: 'test@example.com',
    phoneNumber: '1234567890',
    dob: '1990-01-01',
    gender: 'Male',
    password: 'password123',
    token: null,
  );

  test('should call register on the repository', () async {
    // arrange
    when(() => mockAuthRepository.register(any()))
        .thenAnswer((_) async => const Right(true));

    // act
    final result = await useCase(tParams);

    // assert
    expect(result, const Right(true));
    verify(() => mockAuthRepository.register(tAuthEntity)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return failure when registration fails in repository', () async {
    // arrange
    final tFailure = LocalDatabaseFailure('Registration failed');
    when(() => mockAuthRepository.register(any()))
        .thenAnswer((_) async => Left(tFailure));

    // act
    final result = await useCase(tParams);

    // assert
    expect(result, Left(tFailure));
    verify(() => mockAuthRepository.register(tAuthEntity)).called(1);
  });

  test('should return failure when repository returns false (not saved)', () async {
    // arrange
    when(() => mockAuthRepository.register(any()))
        .thenAnswer((_) async => const Right(false));

    // act
    final result = await useCase(tParams);

    // assert
    expect(result, isA<Left>());
    verify(() => mockAuthRepository.register(tAuthEntity)).called(1);
  });
}
