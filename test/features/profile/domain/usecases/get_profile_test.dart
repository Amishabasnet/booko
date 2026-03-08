import 'package:booko/features/profile/domain/entities/profile_entity.dart';
import 'package:booko/features/profile/domain/repositories/profile_repository.dart';
import 'package:booko/features/profile/domain/usecases/get_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late GetProfile useCase;
  late MockProfileRepository mockRepo;

  setUp(() {
    mockRepo = MockProfileRepository();
    useCase = GetProfile(mockRepo);
  });

  final tProfile = ProfileEntity(
    fullName: 'Test User',
    email: 'test@gmail.com',
    phone: '1234567890',
    dob: DateTime(1990, 1, 1),
    gender: 'Male',
  );

  test('should get profile from repository', () async {
    // arrange
    when(() => mockRepo.getProfile()).thenAnswer((_) async => tProfile);

    // act
    final result = await useCase();

    // assert
    expect(result, tProfile);
    verify(() => mockRepo.getProfile()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
