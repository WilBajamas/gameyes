---
name: flutter-widget-testing
description: Write, review, and simplify Flutter widget tests that protect meaningful user-visible behaviour and component contracts without coupling to implementation details. Use when creating or revising testWidgets tests, deciding whether a widget needs tests, or replacing overcomplicated image and asynchronous test setup.
---

# Flutter Widget Testing

## Core principle

Test behaviour, not implementation.

Make every widget test read like a short description of something a user can observe or a caller can rely on. Protect outcomes such as conditional content, interaction, state changes, navigation, accessibility, and explicit component contracts.

Do not reverse-engineer the widget tree or reproduce internal framework behaviour merely to increase coverage.

Prefer the simplest test that would fail if the intended behaviour regressed.

## Decide whether to create a test file

Before creating a widget test, ask:

> Does this widget own meaningful behaviour or a contract worth protecting?

Meaningful targets include:

- Content that changes with input or state.
- User interaction and its observable result.
- Loading, success, empty, and error states owned by the widget.
- Navigation, focus, validation, or accessibility behaviour.
- An explicit component contract that could meaningfully regress.

If the answer is no, do not create a widget test file.

A widget existing, containing code, or lowering a coverage percentage is not sufficient justification. A passive wrapper that only forwards text, padding, theme values, or children usually needs no dedicated test. Its behaviour may already be covered by a parent feature test.

## Write tests for humans

Use a concise Given/When/Then mindset:

- **Given:** Arrange only the state and dependencies relevant to the behaviour.
- **When:** Perform one meaningful user action or state transition.
- **Then:** Assert the observable outcome or public contract.

The comments themselves are optional. Prefer code clear enough that these phases are obvious.

Name tests as behaviour statements:

```text
shows <outcome> when <condition>
hides <outcome> when <condition>
calls <callback> when <action>
navigates to <destination> when <action>
```

For example:

```dart
testWidgets('shows retry action when loading fails', (tester) async {
  // ...
});

testWidgets('calls onSelected when the tile is tapped', (tester) async {
  // ...
});
```

Avoid names that describe construction or internals:

```text
builds correctly
contains a Row
invokes imageBuilder
renders without errors
```

## Keep setup proportional

Start with `pumpWidget`, a small subject builder, one action, and direct expectations. Add machinery only when the behaviour genuinely requires it.

Avoid by default:

- Handcrafted image bytes used only to make an image decoder succeed.
- `Completer` objects used to orchestrate implementation timing.
- Arbitrary `Future.delayed` calls.
- Repeated pumps with guessed durations.
- Zones or `runZonedGuarded` used to suppress incidental errors.
- Manually extracting or invoking internal builders or callbacks.
- Deep descendant finders that mirror the current widget hierarchy.
- Mocks and stubs unrelated to the behaviour under test.

These techniques are not forbidden. Use one only when:

1. The widget owns the corresponding contract.
2. Simpler public interaction cannot exercise it.
3. The extra setup is essential to prove the behaviour.

State the reason in a short comment when it is not self-evident.

### Image behaviour

Control the image-loading boundary rather than simulating image internals.

Prefer an injectable image widget, loader, provider, or small fake that directly represents loading, success, or failure.

Use real encoded image bytes only when image decoding itself is the responsibility under test. A tile that displays artwork usually does not own that responsibility.

Do not add a production abstraction solely to satisfy a trivial test. If no suitable public seam exists, consider testing the behaviour at the feature boundary that owns it.

### Asynchronous behaviour

Wait for a meaningful state:

```dart
await tester.tap(find.text('Load more'));
await tester.pump();
await tester.pumpAndSettle();

expect(find.text('Next page'), findsOneWidget);
```

Use a precise `pump(duration)` only when elapsed time is part of the public behaviour, such as a debounce or animation contract.

Never add a delay merely to make a flaky test pass.

## Assert observable outcomes

Prefer assertions about:

- Text, labels, controls, and semantic information visible to the user.
- Presence or absence caused by a meaningful condition.
- Enabled, disabled, selected, focused, loading, empty, or error states.
- Callbacks caused by user interaction.
- Navigation or another externally observable effect.

Avoid asserting:

- Incidental widget structure.
- Exact nesting.
- Private state.
- Execution of internal callbacks.
- Implementation-specific widget counts.
- Styling or layout that is not an explicit contract.

## Inspect widget properties only when appropriate

Using `tester.widget<T>()` is acceptable when a widget property is the clearest representation of a public or user-relevant contract that cannot be asserted more naturally.

Acceptable examples include:

- A button is disabled because `onPressed` is null.
- An image exposes the required semantic label.
- A field uses the required keyboard type.
- A password field obscures sensitive text.
- A reusable design-system component promises a public configuration.

```dart
final button = tester.widget<ElevatedButton>(find.text('Save'));

expect(button.onPressed, isNull);
```

Do not inspect properties merely to duplicate constructor arguments or freeze internal styling and layout.

Prefer interaction when it communicates the contract more clearly. For example, tap the control and assert the result instead of inspecting its callback.

## Good example

```dart
testWidgets('shows retry action when loading fails', (tester) async {
  var retried = false;

  await tester.pumpWidget(
    MaterialApp(
      home: ResultsView.error(
        onRetry: () => retried = true,
      ),
    ),
  );

  expect(find.text('Could not load results'), findsOneWidget);
  expect(find.text('Retry'), findsOneWidget);

  await tester.tap(find.text('Retry'));

  expect(retried, isTrue);
});
```

This test describes a visible state and proves the result of a user action. It does not depend on layout, private methods, or asynchronous plumbing.

### Testing an image through a public boundary

```dart
testWidgets('shows artwork when the image succeeds', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: CoverTile(
        imageBuilder: (_) => const Placeholder(
          key: Key('artwork'),
        ),
      ),
    ),
  );

  expect(find.byKey(const Key('artwork')), findsOneWidget);
});
```

Use the project’s actual public seam or test override. The important point is to represent the successful state directly rather than manually performing image decoding.

## Overcoupled example

```dart
testWidgets('renders imageBuilder', (tester) async {
  final bytes = Uint8List.fromList(<int>[
    // Encoded image bytes...
  ]);
  final completer = Completer<ImageInfo>();

  await runZonedGuarded(() async {
    await tester.pumpWidget(buildSubject(bytes));

    final cachedImage =
        tester.widget<DefaultCachedNetworkImage>(
      find.byType(DefaultCachedNetworkImage),
    );

    final built = cachedImage.imageBuilder!(
      tester.element(
        find.byType(DefaultCachedNetworkImage),
      ),
      MemoryImage(bytes),
    );

    await tester.pumpWidget(built);
    await Future<void>.delayed(
      const Duration(milliseconds: 100),
    );

    expect(find.byType(Image), findsOneWidget);

    completer.complete(/* ... */);
  }, (_, __) {});
});
```

Do not write this for a widget whose contract is simply “show artwork on success.”

The test is coupled to:

- Encoded image bytes.
- Image decoding.
- Arbitrary timing.
- An internal builder.
- A specific image implementation.
- Manual callback invocation.
- Error suppression.

A harmless implementation refactor could break this test while the user-visible behaviour remains correct. Suppressing errors could also allow a real defect to pass.

## Avoid structural assertions

Do not mirror the widget hierarchy:

```dart
expect(
  find.descendant(
    of: find.byType(Row),
    matching: find.descendant(
      of: find.byType(Padding),
      matching: find.byType(Text),
    ),
  ),
  findsOneWidget,
);
```

If the contract is that the title is visible, write:

```dart
expect(find.text('Games'), findsOneWidget);
```

Only assert structure when structure itself is an explicit contract, such as semantics, focus order, or a reusable layout component with documented guarantees.

## Review checklist

Before keeping a widget test, verify:

- The widget owns meaningful behaviour or a contract.
- The test name states the condition and observable outcome.
- The setup contains only what that behaviour needs.
- The action uses the public UI whenever possible.
- The expectations protect outcomes rather than tree structure.
- No arbitrary timing, swallowed errors, or manual internal invocation hides the intent.
- A reader can understand the test without decoding a wall of machinery.
- Removing the behaviour would make the test fail.
- Refactoring the implementation without changing behaviour would not make the test fail.

If these conditions cannot be met, simplify the test, move it to the correct owning boundary, or do not create it.