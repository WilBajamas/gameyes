---
name: flutter-widget-testing
description: Write, review, and simplify Flutter widget tests that protect meaningful user-visible behaviour and public component contracts without coupling to implementation details. Use when deciding whether a Flutter widget needs tests, creating or revising testWidgets tests, reviewing excessive coverage, or replacing overcomplicated image, theme, layout, and asynchronous test setup.
---

# Flutter Widget Testing

## Test behaviour, not implementation

Make each test describe something a user can observe or a caller can rely on. Protect meaningful conditional content, interaction, state changes, navigation, accessibility, and explicit component contracts.

Prefer the simplest test that would fail if the intended behaviour regressed but continue to pass after an implementation-only refactor.

Do not reproduce widget source code as assertions. Do not test Flutter itself.

## Decide whether to create a test file

Before creating a widget test, ask:

> Does this widget own meaningful behaviour or a public contract worth protecting?

Create tests for behaviour such as:

- content that changes with an input or state;
- a user action and its observable result;
- loading, success, empty, or error states owned by the widget;
- enabled, disabled, selected, focused, or validated states;
- navigation or accessibility behaviour;
- a documented component contract that could meaningfully regress.

If the answer is no, do not create a test file for the widget. Having code or lowering a coverage percentage is not sufficient justification.

Do not give a passive wrapper a dedicated test merely because it forwards text, dimensions, padding, theme values, or children. Cover it through the feature that owns the behaviour when appropriate.

## Judge ownership before testing

Identify which layer owns the behaviour.

- Test image loading, caching, and decoding in the image-loading component.
- Test a parent widget's choice between an image and a fallback in the parent widget.
- Test navigation in the component that initiates it.
- Test pure data transformations with unit tests rather than widget tests.
- Do not test visual composition by duplicating styling code as property assertions.

Do not force another component's internals through the widget under test.

## Use a human-readable format

Use a concise Given/When/Then mindset:

- Given only the state and dependencies required by the behaviour.
- When one meaningful action or state transition occurs.
- Then assert the observable outcome or public contract.

Do not add Given/When/Then, Arrange/Act/Assert, or explanatory comments. The test name and code must make the behaviour clear. If comments are required to understand the test, simplify it.

Name tests as detailed behaviour statements:

```text
shows <outcome> when <condition>
hides <outcome> when <condition>
calls <callback> when <action>
navigates to <destination> when <action>
uses <public contract> for <condition>
```

Good names include:

```dart
testWidgets('shows retry action when loading fails', (tester) async {});
testWidgets('calls onSelected when the tile is tapped', (tester) async {});
testWidgets('hides the status at mini size', (tester) async {});
```

Avoid vague or implementation-focused names such as `builds correctly`, `renders`, `contains a Row`, `invokes imageBuilder`, and `works as expected`.

## Keep setup proportional

Start with `pumpWidget`, a small subject builder, one action, and direct expectations. Add only what the behaviour requires.

Do not use:

- `Completer` to manufacture loading, success, failure, or timing states;
- handcrafted or embedded GIF, PNG, JPEG, or other encoded image bytes;
- `Uint8List.fromList` and `MemoryImage` solely to make image decoding succeed;
- manual invocation of `imageBuilder`, `placeholder`, `errorWidget`, or other internal builders and callbacks;
- arbitrary `Future.delayed` calls or repeated pumps with guessed durations;
- zones or `runZonedGuarded` to suppress errors;
- empty error handlers;
- deep finders that mirror the current widget hierarchy;
- mocks and stubs unrelated to the behaviour under test.

Never swallow an error to make a test pass. Fix the test harness or dependency instead.

Do not pre-resolve a theme, token set, or other dependency in `setUpAll` just to compare its values against the widget later. That resolution usually only exists to feed an exact-value assertion — remove the assertion (per "Treat visual styling deliberately" below) and the resolution step, and the harness it needed, both become unnecessary. Pass the real theme into the pumped widget and assert what the widget shows (an icon, a size, a supplied variant) instead of what a token equals. A test that never inspects raw token values has nothing to synchronise with and needs no warmup step at all.

For asynchronous behaviour, wait for meaningful framework state:

```dart
await tester.tap(find.text('Load more'));
await tester.pumpAndSettle();

expect(find.text('Next page'), findsOneWidget);
```

Use `pump(duration)` only when elapsed time is part of the public contract, such as a documented debounce or animation duration.

## Do not manufacture image states

Do not embed fake image bytes:

```dart
final fakeImageBytes = Uint8List.fromList([
  0x47,
  0x49,
  0x46,
]);
```

Do not retrieve an image widget and invoke its builder manually:

```dart
final image = tester.widget<DefaultCachedNetworkImage>(
  find.byType(DefaultCachedNetworkImage),
);
final context = tester.element(
  find.byType(DefaultCachedNetworkImage),
);
final artwork = image.imageBuilder!(
  context,
  MemoryImage(fakeImageBytes),
);
await tester.pumpWidget(artwork);
```

This tests a builder outside the original widget and couples the test to decoding, hierarchy, callback signatures, and a specific implementation.

Instead:

- control the state through an existing public dependency boundary;
- test the image-loading component at the layer that owns loading and decoding;
- test a visible fallback that the parent widget owns;
- test only the visible outcome owned by the widget;
- skip the branch if exercising it would only retest a dependency's implementation.

Do not add a production abstraction solely to enable a trivial test.

## Assert outcomes, not structure

Prefer assertions about:

- visible text, labels, controls, icons, and semantic information;
- presence or absence caused by a meaningful condition;
- enabled, disabled, selected, focused, loading, empty, or error states;
- callbacks caused by user interaction;
- navigation or another externally observable effect.

Avoid assertions about:

- incidental widget nesting;
- private state or private widget types;
- execution of internal callbacks;
- implementation-specific widget counts;
- exact `Positioned`, `Padding`, `DecoratedBox`, or `ClipRRect` properties;
- colours, borders, radii, and spacing that are not documented contracts.

Do not mirror a widget hierarchy:

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

Assert the behaviour directly:

```dart
expect(find.text('Games'), findsOneWidget);
```

## Treat visual styling deliberately

**Do not test dimensions.** Height, width, padding, gaps, radii, offsets and positions are not behaviour — asserting them copies the implementation into a second file and makes every visual tweak a two-file edit. A component's pixel appearance is a manual check, not a test. This holds even when a criterion states the number: the criterion is the contract, the test is not where it gets enforced.

Colour and other styling get the same default. Assert one only when it carries meaning a reader would otherwise miss — an active state distinguished from an inactive one, a destructive action distinguished from a safe one — and reference the design token, never a literal hex.

Do not assert a styling expression merely because it appears in the implementation. For example, asserting both branches of `isMini ? radius.mini : radius.lg` duplicates the source rather than protecting meaningful behaviour.

## Reference files

`test/widget/components/context_chip_test.dart` and
`test/widget/components/stat_pill_test.dart` are the shape to copy — both
human-written, both short (one and two tests), both asserting only what the
widget *does*: the label comes out uppercase, two entries produce two stats,
an unsupported list length trips the assert. Neither measures anything.

Read one of them before writing a new test file. If a new file is markedly
longer than these, or spends most of its lines on sizes and offsets, that is
the signal to cut it back rather than a sign the component is unusually rich.

## Inspect widget properties only when appropriate

Use `tester.widget<T>()` when a public property is the clearest representation of a meaningful contract that cannot be asserted more naturally.

Acceptable examples include:

- `onPressed` is null because an action is disabled;
- a field obscures sensitive text or uses a required keyboard type;
- an image exposes a required semantic label;
- a composed public component receives the correct domain value or documented variant.

```dart
testWidgets('shows the supplied status using the on-media variant', (
  tester,
) async {
  await tester.pumpWidget(
    buildSubject(
      status: LibraryStatus.playing,
    ),
  );

  final chip = tester.widget<StatusChip>(
    find.byType(StatusChip),
  );

  expect(chip.status, LibraryStatus.playing);
  expect(chip.variant, StatusChipVariant.onMedia);
});
```

Do not use `tester.widget<T>()` to retrieve a widget so its internal builder or callback can be invoked manually. Do not inspect properties merely to duplicate constructor arguments or freeze implementation-specific layout.

Prefer interaction when it expresses the contract more clearly.

## Good behaviour tests

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

```dart
testWidgets('hides the status when none is supplied', (tester) async {
  await tester.pumpWidget(
    buildSubject(status: null),
  );

  expect(find.byType(StatusChip), findsNothing);
});
```

```dart
testWidgets('shows a fallback glyph when the image url is empty', (
  tester,
) async {
  await tester.pumpWidget(
    buildSubject(imageUrl: ''),
  );

  expect(
    find.byIcon(Icons.videogame_asset_outlined),
    findsOneWidget,
  );
});
```

## Reject redundant setup and assertions

Do not construct one state only to compare it with another when the behaviour needs a single assertion.

Overcomplicated:

```dart
await tester.pumpWidget(
  buildSubject(status: LibraryStatus.playing),
);
final sizeWithStatus = tester.getSize(find.byType(CoverTile));

await tester.pumpWidget(
  buildSubject(status: null),
);
expect(find.byType(StatusChip), findsNothing);
expect(tester.getSize(find.byType(CoverTile)), sizeWithStatus);
```

Focused:

```dart
await tester.pumpWidget(
  buildSubject(status: null),
);

expect(find.byType(StatusChip), findsNothing);
```

Do not test invisible implementation details negatively. For example, asserting that an artwork overlay is absent when no image URL was supplied adds little value when the fallback branch is already observable.

## Review checklist

Before keeping a widget test, verify:

- The widget owns meaningful behaviour or a public contract.
- The test name states the condition and outcome in detail.
- The test is understandable without comments.
- The setup contains only what the behaviour needs.
- The action uses the public UI whenever possible.
- The assertions protect outcomes rather than source structure.
- No assertion measures a dimension, gap, radius or position.
- Any styling assertion carries meaning and names a design token.
- The file is no longer than `context_chip_test.dart` or `stat_pill_test.dart` without a reason.
- The test contains no completers or fake encoded image bytes.
- The test does not manually invoke internal builders or callbacks.
- The test contains no arbitrary delays, zones, or swallowed errors.
- Removing the behaviour would make the test fail.
- Refactoring the implementation without changing behaviour would leave the test passing.

If these conditions cannot be met, simplify the test, move it to the correct owning boundary, or do not create the test.
