import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/most_anticipated_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/error_mock.dart';
import '../../mocks/game_response_mock.dart';
import 'most_anticipated_cubit_test.mocks.dart';

@GenerateMocks([FeaturedRepository])
void main() {
  late FeaturedRepository featuredRepository;
  late MostAnticipatedCubit mostAnticipatedCubit;

  setUp(() {
    featuredRepository = MockFeaturedRepository();

    GetIt.I.registerSingleton(featuredRepository);

    mostAnticipatedCubit = MostAnticipatedCubit();
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(featuredRepository);
  });

  test('initial state is empty MostAnticipatedState', () {
    expect(
      mostAnticipatedCubit.state,
      const MostAnticipatedState(),
    );
  });

  blocTest(
    // ignore: lines_longer_than_80_chars
    'emits MostAnticipatedState with loading then MostAnticipatedState with success when fetchMostAnticipated is called',
    setUp: () {
      when(featuredRepository.fetchMostAnticipated())
          .thenAnswer((_) async => Right(mockGamesResponse));
    },
    build: () => mostAnticipatedCubit,
    act: (cubit) async => mostAnticipatedCubit.fetchMostAnticipated(),
    expect: () => [
      const MostAnticipatedState(status: MostAnticipatedStatus.loading),
      MostAnticipatedState(
        status: MostAnticipatedStatus.success,
        games: mockGamesResponse,
      ),
    ],
  );

  blocTest(
    // ignore: lines_longer_than_80_chars
    'emits MostAnticipatedState with loading then MostAnticipatedState with failed when fetchMostAnticipated is called',
    setUp: () {
      when(featuredRepository.fetchMostAnticipated())
          .thenAnswer((_) async => Left(mockResponseError));
    },
    build: () => mostAnticipatedCubit,
    act: (cubit) async => mostAnticipatedCubit.fetchMostAnticipated(),
    expect: () => [
      const MostAnticipatedState(status: MostAnticipatedStatus.loading),
      MostAnticipatedState(
        status: MostAnticipatedStatus.failed,
        error: mockResponseError,
      ),
    ],
  );
}
