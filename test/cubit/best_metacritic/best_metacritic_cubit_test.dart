import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/best_metacritic_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/error_mock.dart';
import '../../mocks/game_response_mock.dart';
import 'best_metacritic_cubit_test.mocks.dart';

@GenerateMocks([FeaturedRepository])
void main() {
  late FeaturedRepository featuredRepository;
  late BestMetacriticCubit bestMetacriticCubit;

  setUp(() {
    featuredRepository = MockFeaturedRepository();

    GetIt.I.registerSingleton(featuredRepository);

    bestMetacriticCubit = BestMetacriticCubit();
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(featuredRepository);
  });

  test('initial state is empty BestMetacriticState', () {
    expect(
      bestMetacriticCubit.state,
      const BestMetacriticState(),
    );
  });

  blocTest(
    // ignore: lines_longer_than_80_chars
    'emits BestMetacriticState with loading then BestMetacriticState with success when fetchBestMetacritic is called',
    setUp: () {
      when(featuredRepository.fetchBestMetacritic())
          .thenAnswer((_) async => Right(mockGamesResponse));
    },
    build: () => bestMetacriticCubit,
    act: (cubit) async => bestMetacriticCubit.fetchBestMetacritic(),
    expect: () => [
      const BestMetacriticState(status: BestMetacriticStatus.loading),
      BestMetacriticState(
        status: BestMetacriticStatus.success,
        games: mockGamesResponse,
      ),
    ],
  );

  blocTest(
    // ignore: lines_longer_than_80_chars
    'emits BestMetacriticState with loading then BestMetacriticState with failure when fetchBestMetacritic is called',
    setUp: () {
      when(
        featuredRepository.fetchBestMetacritic(),
      ).thenAnswer((_) async => Left(mockResponseError));
    },
    build: () => bestMetacriticCubit,
    act: (cubit) async => bestMetacriticCubit.fetchBestMetacritic(),
    expect: () => [
      const BestMetacriticState(status: BestMetacriticStatus.loading),
      BestMetacriticState(
        status: BestMetacriticStatus.failed,
        error: mockResponseError,
      ),
    ],
  );
}
