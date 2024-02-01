import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/features/featured/domain/repository/featured_repository.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/cubit/latest_releases_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/error_mock.dart';
import '../../mocks/game_response_mock.dart';
import 'latest_releases_cubit_test.mocks.dart';

@GenerateMocks([FeaturedRepository])
void main() {
  late FeaturedRepository featuredRepository;
  late LatestReleasesCubit latestReleasesCubit;

  setUp(() {
    featuredRepository = MockFeaturedRepository();

    GetIt.I.registerSingleton(featuredRepository);

    latestReleasesCubit = LatestReleasesCubit();
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(featuredRepository);
  });

  test('initial state is empty LatestReleasesState', () {
    expect(
      latestReleasesCubit.state,
      const LatestReleasesState(),
    );
  });

  blocTest(
    // ignore: lines_longer_than_80_chars
    'emits LatestReleasesState with loading then LatestReleasesState with success when fetchLatestReleases is called',
    setUp: () {
      when(featuredRepository.fetchLatestReleases())
          .thenAnswer((_) async => Right(mockGamesResponse));
    },
    build: () => latestReleasesCubit,
    act: (cubit) async => latestReleasesCubit.fetchLatestReleases(),
    expect: () => [
      const LatestReleasesState(status: LatestReleasesStatus.loading),
      LatestReleasesState(
        status: LatestReleasesStatus.success,
        games: mockGamesResponse,
      ),
    ],
  );

  blocTest(
    // ignore: lines_longer_than_80_chars
    'emits LatestReleasesState with loading then LatestReleasesState with failure when fetchLatestReleases is called',
    setUp: () {
      when(featuredRepository.fetchLatestReleases())
          .thenAnswer((_) async => Left(mockResponseError));
    },
    build: () => latestReleasesCubit,
    act: (cubit) async => latestReleasesCubit.fetchLatestReleases(),
    expect: () => [
      const LatestReleasesState(status: LatestReleasesStatus.loading),
      LatestReleasesState(
        status: LatestReleasesStatus.failed,
        error: mockResponseError,
      ),
    ],
  );
}
