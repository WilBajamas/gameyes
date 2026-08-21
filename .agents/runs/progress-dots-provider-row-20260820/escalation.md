# Escalation
Agent: QA Agent
Run: progress-dots-provider-row-20260820
Opened: 2026-08-21
Phase: QA
Reason: `test/widget/components/action_row_test.dart:34` asserts a dimension —
`expect(tester.getSize(find.byType(ActionRow)).height, 52);` inside the test
`shows the busy indicator only while loading`. The `flutter-widget-test` skill,
revised 2026-08-21 (commit `f833f65`), now forbids this outright: "Do not test
dimensions … Height, width, padding, gaps, radii, offsets and positions are not
behaviour", and its review checklist reads "No assertion measures a dimension,
gap, radius or position." Phase 4B removed the seven standalone dimension tests
but missed this line because it sits inside a behaviour test rather than being
one of its own. It is the only remaining dimension assertion in the run.
Route to: Dev Agent
Attempts made: N/A
Action required: Delete line 34 of `test/widget/components/action_row_test.dart`.
Nothing else. The test's behaviour coverage — indicator absent when not loading,
present when loading, label still visible — is unaffected, so no replacement
assertion is needed and none should be added. Do not touch either widget file,
the other three tests in that file, or `progress_dots_test.dart`. Everything else
in the run passes: analyzer at baseline (0/2/31), suite at `+267 -10` with no new
failure, all 32 criteria PASS or MANUAL, `tdd.md` and `flutter-widgets`
compliance clean, scope clean.
