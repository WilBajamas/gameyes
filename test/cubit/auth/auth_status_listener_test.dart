import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/route/auth_status_listener.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/auth_status_entity.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/observe_auth_status_use_case.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/auth_mock.dart';
import 'auth_status_listener_test.mocks.dart';

@GenerateMocks([ObserveAuthStatusUseCase])
void main() {
  late MockObserveAuthStatusUseCase useCase;
  late StreamController<AuthStatusEntity> controller;
  late AuthStatusListener listener;

  setUp(() {
    useCase = MockObserveAuthStatusUseCase();
    controller = StreamController<AuthStatusEntity>.broadcast();
    when(useCase()).thenAnswer((_) => controller.stream);
    listener = AuthStatusListener(useCase);
  });

  tearDown(() async {
    await controller.close();
  });

  test('should report signed out when no status has been emitted yet', () {
    expect(listener.isSignedIn, isFalse);
  });

  test('should report signed in when a signed-in status is emitted', () async {
    listener.start();

    controller.add(mockDiscordSignedInStatus);
    await pumpEventQueue();

    expect(listener.isSignedIn, isTrue);
  });

  test(
    'should report signed out when a signed-out status is emitted',
    () async {
      listener.start();

      controller.add(mockDiscordSignedInStatus);
      await pumpEventQueue();
      controller.add(mockSignedOutStatus);
      await pumpEventQueue();

      expect(listener.isSignedIn, isFalse);
    },
  );

  test('should subscribe once when start is called twice', () {
    listener.start();
    listener.start();

    verify(useCase()).called(1);
  });

  test('should react to a later emission when several arrive', () async {
    listener.start();

    controller.add(mockDiscordSignedInStatus);
    await pumpEventQueue();
    controller.add(mockSignedOutStatus);
    await pumpEventQueue();
    controller.add(mockGoogleSignedInStatus);
    await pumpEventQueue();

    expect(listener.isSignedIn, isTrue);
  });

  test('should notify listeners when the status changes', () async {
    listener.start();
    var notified = 0;
    listener.addListener(() => notified++);

    controller.add(mockDiscordSignedInStatus);
    await pumpEventQueue();

    expect(notified, 1);
  });

  test(
    'should not notify listeners when the same status is emitted again',
    () async {
      listener.start();
      controller.add(mockDiscordSignedInStatus);
      await pumpEventQueue();

      var notified = 0;
      listener.addListener(() => notified++);
      controller.add(mockGoogleSignedInStatus);
      await pumpEventQueue();

      expect(notified, 0);
    },
  );

  test('should report signed out when the stream emits an error', () async {
    listener.start();

    controller.add(mockDiscordSignedInStatus);
    await pumpEventQueue();
    controller.addError(Exception('stream failure'));
    await pumpEventQueue();

    expect(listener.isSignedIn, isFalse);
  });

  test('should stop listening when disposed', () async {
    listener.start();
    listener.dispose();

    controller.add(mockDiscordSignedInStatus);
    await pumpEventQueue();

    expect(listener.isSignedIn, isFalse);
  });
}
