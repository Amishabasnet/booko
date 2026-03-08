import 'package:booko/core/error/failures.dart';
import 'package:booko/features/auth/domain/entities/auth_entity.dart';
import 'package:booko/features/auth/domain/repositories/auth_repository.dart';
import 'package:booko/features/auth/domain/usecases/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late LoginUsecase useCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = LoginUsecase(authRepository: mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tLoginParams = LoginUsecaseParams(email: tEmail, password: tPassword);
  const tAuthEntity = AuthEntity(
    authId: '1',
    name: 'Test User',
    email: tEmail,
    password: tPassword,
  );

  test('should call login on the repository', () async {
    // arrange
    when(() => mockAuthRepository.login(any(), any()))
        .thenAnswer((_) async => const Right(tAuthEntity));

    // act
    final result = await useCase(tLoginParams);

    // assert
    expect(result, const Right(tAuthEntity));
    verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return failure when login fails', () async {
    // arrange
    final tFailure = ApiFailure('Login failed');
    when(() => mockAuthRepository.login(any(), any()))
        .thenAnswer((_) async => Left(tFailure));

    // act
    final result = await useCase(tLoginParams);

    // assert
    expect(result, Left(tFailure));
    verify(() => mockAuthRepository.login(tEmail, tPassword)).called(1);
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
