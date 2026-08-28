import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/repositories/library_repository.dart';
import 'package:gaming_library_assessment_flutter/features/library/domain/use_cases/remove_library_entry_use_case.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remove_library_entry_use_case_test.mocks.dart';

@GenerateMocks([LibraryRepository])
void main() {
  late MockLibraryRepository repository;
  late RemoveLibraryEntryUseCase useCase;

  setUp(() {
    provideDummy<Result<void>>(const Success(null));
    repository = MockLibraryRepository();
    GetIt.I.registerSingleton<LibraryRepository>(repository);
    useCase = RemoveLibraryEntryUseCase(repository);
  });

  tearDown(() async {
    await GetIt.instance.reset();
    reset(repository);
  });

  test('should forward the game id to the repository', () async {
    when(
      repository.remove(igdbId: 42),
    ).thenAnswer((_) async => const Success(null));

    final result = await useCase(igdbId: 42);

    expect(result, isA<Success<void>>());
    verify(repository.remove(igdbId: 42));
  });

  test('should return the repository failure unchanged', () async {
    when(
      repository.remove(igdbId: 42),
    ).thenAnswer((_) async => Failure(const ErrorType.notAllowed()));

    final result = await useCase(igdbId: 42);

    expect(result, isA<Failure<void>>());
    expect((result as Failure<void>).error, const ErrorType.notAllowed());
  });
}
