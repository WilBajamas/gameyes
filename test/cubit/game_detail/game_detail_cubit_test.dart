import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/domain/repositories/game_detail_repository.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubits/game_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubits/game_detail_state.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/error_mock.dart';
import '../../mocks/game_detail_response_mock.dart';
import 'game_detail_cubit_test.mocks.dart';

@GenerateMocks([GameDetailRepository])
void main() {
  late GameDetailRepository gameDetailRepository;
  late GameDetailCubit gameDetailCubit;

  setUp(() {
    gameDetailRepository = MockGameDetailRepository();

    GetIt.I.registerSingleton(gameDetailRepository);

    gameDetailCubit = GameDetailCubit(
      id: 88,
      gameDetailRepository: gameDetailRepository,
    );
  });

  tearDown(() {
    GetIt.instance.reset();
    reset(gameDetailRepository);
  });

  test('initial state is empty GameDetailState', () {
    expect(
      gameDetailCubit.state,
      const GameDetailState(),
    );
  });

  blocTest(
    // ignore: lines_longer_than_80_chars
    'emits GameDetailState with loading then GameDetailState with success when fetchGameDetail is called',
    setUp: () {
      when(
        gameDetailRepository.fetchGameDetail(
          id: 1,
        ),
      ).thenAnswer((_) async => Success(mockGameDetailResponse.toEntity()));
    },
    build: () => gameDetailCubit,
    act: (cubit) async => gameDetailCubit.fetchGameDetail(
      id: 1,
    ),
    expect: () => [
      const GameDetailState(status: GameDetailStatus.loading),
      GameDetailState(
        status: GameDetailStatus.success,
        game: mockGameDetailResponse.toEntity(),
      ),
    ],
  );

  blocTest(
    // ignore: lines_longer_than_80_chars
    'emits GameDetailState with loading then GameDetailState with failure when fetchGameDetail is called',
    setUp: () {
      when(
        gameDetailRepository.fetchGameDetail(
          id: 1,
        ),
      ).thenAnswer((_) async => Failure(mockResponseError));
    },
    build: () => gameDetailCubit,
    act: (cubit) async => gameDetailCubit.fetchGameDetail(
      id: 1,
    ),
    expect: () => [
      const GameDetailState(status: GameDetailStatus.loading),
      GameDetailState(
        status: GameDetailStatus.failed,
        error: mockResponseError,
      ),
    ],
  );
}
