# Escalation
Agent: QA Agent
Run: error-states-20260824
Opened: 2026-08-24T18:05:00Z
Phase: 5 — QA
Reason: `flutter-widget-test` violation. `test/widget/components/error_notice_test.dart:120–129`
('shows the strip again when rebuilt with the same inputs after a dismissal') asserts
`expect(find.byType(ErrorNotice), findsOneWidget)` after pumping a harness that places an
`ErrorNotice` unconditionally — a tautology. Its `onDismiss` is `buildSubject`'s default
`() {}`, so no dismissal actually occurs, and if `ErrorNotice` gained a `_dismissed` flag that
permanently suppressed the strip (the exact failure case [2.7-AC14] names) the element would
still be in the tree and the test would still pass. Fails the skill's checklist item "Removing
the behaviour would make the test fail", and asserts structure rather than the observable
outcome.
Route to: Dev Agent
Action required: Rewrite that single test so its assertion names what the strip shows rather
than that the component type exists — e.g. assert the `errorTint` surface or the message text
is present after the rebuild, driving the dismissal through a harness that actually removes the
notice (the one at `error_notice_test.dart:156` already does this) so "after a dismissal" is
real. Do not add a test for any of the ten inspection-only criteria, do not weaken the existing
dismiss test at `:103`, and change no source file — the implementation is correct
(`error_notice.dart:6` is stateless) and every other criterion passes. Nothing else in the run
needs action: analyzer 33 (0/2/31) and tests +343 -10 both match baseline, the dead-code fence
held, the token trap is cleared, and no inspection-only criterion received a test.
