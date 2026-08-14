---
name: flutter-widget-testing
description: Write, review, and simplify Flutter widget tests that protect meaningful user-visible behaviour and component contracts without coupling to implementation details. Use when creating or revising testWidgets tests, deciding whether a widget needs tests, or replacing overcomplicated image and asynchronous test setup.
---

# Flutter Widget Testing

## Core principle

Test behaviour, not implementation.

Make every widget test read like a description of something a user can observe or a caller can rely on. Protect outcomes such as conditional content, interaction, state changes, navigation, accessibility, and explicit component contracts.

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

Do not add Given, When, Then, Arrange, Act, or Assert comments.

Do not use comments to explain what a test is doing. The test name, setup, action, and expectations must communicate the behaviour clearly without commentary.

If a test needs comments to make its purpose or setup understandable, simplify or redesign the test.

Name tests as detailed behaviour statements:

```text
shows <outcome> when <condition>
hides <outcome> when <condition>
calls <callback> when <action>
navigates to <destination> when <action>
```

For example:

```dart
testWidgets('shows retry action when loading fails', (tester) async {
  // Test body
});

testWidgets('calls onSelected when the tile is tapped', (tester) async {
  // Test body
});
```

The placeholder comments above demonstrate the naming format only. Do not include them in real tests.

Avoid vague or implementation-focused names:

```text
builds correctly
contains a Row
invokes imageBuilder
renders without errors
works as expected
```

## Keep setup proportional

Start with `pumpWidget`, a small subject builder, one action, and direct expectations. Add only the setup required by the behaviour.

Do not use:

- `Completer` to control widget-test timing or manufacture asynchronous states.
- Handcrafted or embedded encoded image bytes.
- `Uint8List.fromList` containing GIF, PNG, JPEG, or other image data.
- `MemoryImage` created from fake bytes solely to make decoding succeed.
- Manual invocation of image builders, placeholder builders, error builders, or internal callbacks.
- Arbitrary `Future.delayed` calls.
- Repeated pumps with guessed durations.
- Zones or `runZonedGuarded` used to suppress errors.
- Deep descendant finders that mirror the widget hierarchy.
- Mocks and stubs unrelated to the behaviour being tested.

These techniques make tests harder to read and couple them to implementation details rather than behaviour.

### Do not manufacture image-loading success

Never create fake encoded image data like this:

```dart
final _fakeImageBytes = Uint8List.fromList([
  0x47,
  0x49,
  0x46,
  0x38,
  0x39,
  0x61,
  0x01,
  0x00,
  0x01,
  0x00,
  0x80,
  0x00,
  0x00,
  0xFF,
  0xFF,
  0xFF,
  0x00,
  0x00,
  0x00,
  0x21,
  0xF9,
  0x04,
  0x01,
  0x00,
  0x00,
  0x00,
  0x00,
  0x2C,
  0x00,
  0x00,
  0x00,
  0x00,
  0x01,
  0x00,
  0x01,
  0x00,
  0x00,
  0x02,
  0x02,
  0x44,
  0x01,
  0x00,
  0x3B,
]);
```

Do not extract an image widget and invoke its builder manually:

```dart
Future<Widget> pumpLoadedArtwork(
  WidgetTester tester,
  CoverTileSize size,
) async {
  await tester.pumpWidget(
    buildSubject(
      size: size,
      imageUrl: 'https://example.com/cover.png',
    ),
  );

  final dcni = tester.widget<DefaultCachedNetworkImage>(
    find.byType(DefaultCachedNetworkImage),
  );

  final context = tester.element(
    find.byType(DefaultCachedNetworkImage),
  );

  final artwork = dcni.imageBuilder!(
    context,
    MemoryImage(_fakeImageBytes),
  );

  await tester.pumpWidget(wrap(artwork));

  return artwork;
}
```

This does not test how a user or caller interacts with `CoverTile`. It extracts an implementation detail, manually calls it, and then tests the resulting widget in isolation.

It is coupled to:

- `DefaultCachedNetworkImage`.
- The presence and signature of `imageBuilder`.
- Image decoding.
- `MemoryImage`.
- The current widget hierarchy.
- The implementation of `CoverTile`.

A harmless refactor could break this test even when the observable behaviour remains correct.

If `CoverTile` only delegates image loading and rendering to another component, do not reproduce that component’s internals in the `CoverTile` test.

Instead:

- Test behaviour that `CoverTile` owns.
- Control the image state through an existing public boundary.
- Test image-loading behaviour in the component that owns it.
- Test the complete behaviour at the parent feature boundary.
- Do not create the test if no meaningful `CoverTile` behaviour remains.

Do not add a production abstraction solely to make a trivial test possible.

### Do not use completers

Do not use `Completer` to force loading, success, failure, or timing states in ordinary widget tests.

Avoid patterns such as:

```dart
final completer = Completer<void>();

await tester.pumpWidget(
  buildSubject(future: completer.future),
);

completer.complete();

await tester.pump();
```

Represent the required state directly through the widget’s public inputs or existing dependency boundary.

If asynchronous orchestration is the main thing being tested, place that test at the layer responsible for the asynchronous contract rather than forcing it through an unrelated presentational widget.

### Asynchronous behaviour

Wait for meaningful framework state:

```dart
await tester.tap(find.text('Load more'));
await tester.pumpAndSettle();

expect(find.text('Next page'), findsOneWidget);
```

Use a precise `pump(duration)` only when elapsed time is part of public behaviour, such as a documented debounce or animation duration.

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
testWidgets('disables save when the form is invalid', (tester) async {
  await tester.pumpWidget(
    buildSubject(isValid: false),
  );

  final button = tester.widget<ElevatedButton>(
    find.widgetWithText(ElevatedButton, 'Save'),
  );

  expect(button.onPressed, isNull);
});
```

Do not inspect properties merely to duplicate constructor arguments or freeze internal styling and layout.

Do not use `tester.widget<T>()` to retrieve a widget so its internal builder or callback can be invoked manually.

Prefer interaction when it communicates the contract more clearly. Tap the control and assert its observable result instead of extracting and invoking its callback.

## Good examples

### Conditional behaviour and interaction

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

This test describes a visible state and proves the result of a user action. It does not depend on layout, private methods, completers, fake bytes, or asynchronous plumbing.

### Conditional rendering

```dart
testWidgets('hides remove action when removal is not allowed', (tester) async {
  await tester.pumpWidget(
    buildSubject(canRemove: false),
  );

  expect(find.text('Remove'), findsNothing);
});
```

### Callback behaviour

```dart
testWidgets('calls onSelected when the tile is tapped', (tester) async {
  var selected = false;

  await tester.pumpWidget(
    buildSubject(
      onSelected: () => selected = true,
    ),
  );

  await tester.tap(find.byType(CoverTile));

  expect(selected, isTrue);
});
```

## Overcoupled tests

Do not write tests that:

- Decode fake images to trigger a builder.
- Retrieve a production widget and manually invoke one of its properties.
- Replace the subject with the widget returned by an internal builder.
- Use completers to manufacture a state transition.
- Suppress exceptions through a zone.
- Wait for arbitrary durations.
- Assert internal layout instead of visible outcomes.

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

Only assert structure when the structure is itself an explicit contract, such as semantics or focus order.

## Review checklist

Before keeping a widget test, verify:

- The widget owns meaningful behaviour or a contract.
- The test name states the condition and observable outcome in detail.
- The test is understandable without comments.
- The setup contains only what the behaviour needs.
- The action uses the public UI whenever possible.
- The expectations protect outcomes rather than tree structure.
- The test contains no completers.
- The test contains no fake encoded image bytes.
- The test does not manually invoke internal builders or callbacks.
- The test contains no arbitrary delays or swallowed errors.
- Removing the behaviour would make the test fail.
- Refactoring the implementation without changing behaviour would not make the test fail.

If these conditions cannot be met, simplify the test, move it to the correct owning boundary, or do not create it.