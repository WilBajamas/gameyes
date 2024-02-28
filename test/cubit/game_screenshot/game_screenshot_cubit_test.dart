import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repository/game_screenshots_repository.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_screenshot_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/error_mock.dart';
import '../../mocks/screenshot_respone_mock.dart';
import 'game_screenshot_cubit_test.mocks.dart';

@GenerateMocks([GameScreenshotsRepository])
void main() {
  late GameScreenshotsRepository gameScreenshotRepository;
  late GameScreenshotCubit gameScreenshotCubit;

  setUp(() {
    gameScreenshotRepository = MockGameScreenshotsRepository();

    GetIt.I.registerSingleton(gameScreenshotRepository);

    gameScreenshotCubit = GameScreenshotCubit();
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(gameScreenshotRepository);
  });

  test('initial state is empty GameScreenshotState', () {
    expect(
      gameScreenshotCubit.state,
      const GameScreenshotState(),
    );
  });

  blocTest(
    // ignore: lines_longer_than_80_chars
    'emits GameScreenshotState with loading then GameScreenshotState with success when fetchGameScreenshots is called',
    setUp: () {
      when(gameScreenshotRepository.fetchGameScreenshots(slug: 'slug'))
          .thenAnswer((_) async => Right(mockScreenshotResponse));
    },
    build: () => gameScreenshotCubit,
    act: (cubit) async => cubit.fetchGameScreenshots(slug: 'slug'),
    expect: () => [
      const GameScreenshotState(),
      GameScreenshotState(
        status: ScreenshotsStatus.success,
        response: mockScreenshotResponse,
      ),
    ],
  );

  blocTest(
    // ignore: lines_longer_than_80_chars
    'emits GameScreenshotState with loading then GameScreenshotState with failed when fetchGameScreenshots is called',
    setUp: () {
      when(gameScreenshotRepository.fetchGameScreenshots(slug: 'slug'))
          .thenAnswer((_) async => Left(mockResponseError));
    },
    build: () => gameScreenshotCubit,
    act: (cubit) async => cubit.fetchGameScreenshots(slug: 'slug'),
    expect: () => [
      const GameScreenshotState(),
      GameScreenshotState(
        status: ScreenshotsStatus.failure,
        error: mockResponseError,
      ),
    ],
  );
}
