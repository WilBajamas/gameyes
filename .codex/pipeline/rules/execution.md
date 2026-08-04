# Shared execution rules

Read this file when a pipeline role starts.

## Commands

- Use `fvm dart ...` and `fvm flutter ...`; never bare `dart` or `flutter`.
- On Windows, FVM writes SDK cache locks outside the workspace. If a command is
  silent, test `fvm dart --version` and rerun with scoped `fvm` escalation rather
  than extending repeated timeouts.
- Never run `fvm flutter gen-l10n`; Flutter Intl IDE regeneration owns `lib/generated/`.

## Scope

- Treat the task brief allowlist as the source-write boundary.
- Preserve unrelated and pre-existing changes.
- Generated outputs are implicit only for annotated allowlisted sources.
- Use unit and widget tests only; never add golden or integration tests.

## Flutter UI composition

- Put `BlocBuilder`, `BlocSelector`, and `BlocListener` at the lowest subtree that
  consumes their state. Keep static layout and route shells outside that boundary.
- Let screens directly own static `Scaffold`, `SafeArea`, scrolling, and sliver
  composition. Do not introduce passthrough view classes.
- Extract cohesive feature-owned sections into `presentation/widgets/` when that
  clarifies responsibility, even with one caller. Private `part` files are valid.
- Promote an explicitly app-wide primitive to `lib/widgets/` when its generic API
  is required now; do not add speculative options.
- Route directly to a reusable page that owns the route contract and lifecycle.
  Do not wrap it in a screen whose only job is to return that page.

## Acceptance criteria

- `tech-ac.md ## Technical acceptance criteria` is canonical.
- Other artifacts reference that section by path and criterion IDs; never copy it.
- Dev and QA must read the canonical section when verifying implementation.

## Communication

- Keep progress commentary to one short sentence: phase, result, or next gate.
- Do not narrate routine tool calls, waits, or diagnostics.
- Provide detail only for an urgent escalation or when the human asks.

## Self-correction

- Compare failures with the baselines in `orchestrator-state.md` first.
- For a new in-scope failure: identify the exact cause, apply the smallest source
  fix, and rerun the check. Maximum three attempts per failure point.
- Never weaken tests or edit generated files to pass a check.
- On the third failed attempt, follow `escalation.md`; do not attempt a fourth fix.
