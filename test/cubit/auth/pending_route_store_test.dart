import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/route/pending_route_store.dart';

void main() {
  late PendingRouteStore store;

  setUp(() => store = PendingRouteStore());

  const firstRoute = PageRouteInfo<void>('FirstRoute');
  const secondRoute = PageRouteInfo<void>('SecondRoute');

  test('should return null when nothing has been remembered', () {
    expect(store.take(), isNull);
  });

  test('should return the remembered route when take is called', () {
    store.remember(firstRoute);

    expect(store.take(), firstRoute);
  });

  test('should keep only the latest route when remember is called twice', () {
    store.remember(firstRoute);
    store.remember(secondRoute);

    expect(store.take(), secondRoute);
  });

  test(
    'should return null on a second take when the route was already taken',
    () {
      store.remember(firstRoute);
      store.take();

      expect(store.take(), isNull);
    },
  );
}
