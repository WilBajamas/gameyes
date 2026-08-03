import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_state.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'welcome_cubit_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences preferences;

  setUp(() {
    preferences = MockSharedPreferences();
  });

  tearDown(() async {
    reset(preferences);
    await GetIt.instance.reset();
  });

  test('starts on the first step before the user takes an action', () {
    expect(WelcomeCubit(preferences).state, const WelcomeState());
  });

  blocTest<WelcomeCubit, WelcomeState>(
    'moves to the second step without writing the seen flag',
    build: () => WelcomeCubit(preferences),
    act: (cubit) => cubit.next(),
    expect: () => [const WelcomeState(step: WelcomeStep.two)],
    verify: (_) {
      verifyNever(preferences.setBool(StorageConstants.firstUseKey, true));
    },
  );

  blocTest<WelcomeCubit, WelcomeState>(
    'moves back to the first step without writing the seen flag',
    build: () => WelcomeCubit(preferences),
    seed: () => const WelcomeState(step: WelcomeStep.two),
    act: (cubit) => cubit.back(),
    expect: () => [const WelcomeState()],
    verify: (_) {
      verifyNever(preferences.setBool(StorageConstants.firstUseKey, true));
    },
  );

  blocTest<WelcomeCubit, WelcomeState>(
    'writes the seen flag only when the flow finishes',
    build: () {
      when(
        preferences.setBool(StorageConstants.firstUseKey, true),
      ).thenAnswer((_) async => true);
      return WelcomeCubit(preferences);
    },
    act: (cubit) => cubit.finish(),
    expect: () => [const WelcomeState(status: WelcomeStatus.finished)],
    verify: (_) {
      verify(preferences.setBool(StorageConstants.firstUseKey, true)).called(1);
    },
  );
}
