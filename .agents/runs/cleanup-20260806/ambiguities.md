# Ambiguities Report
Source: `.agents/week-1-task-briefs.md` § "11 — Cleanup [PIPELINE]" (lines 385–429),
checklist items 1–3. Background: `.agents/handover.md` gotcha #2 (line-ending churn).
Date: 2026-08-06

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: The brief says "Create a `.gitattributes` at the repository root", but a
root `.gitattributes` already exists (7 lines, pinning Flutter's generated
plugin-registrant files to LF for the same reason). Assuming "create" means "ensure
the five generated-Dart patterns are present", i.e. append them to the existing file
and leave every existing entry byte-identical. Overwriting would delete a working fix
for the same class of problem and is read as unintended.

ASSUMPTION: Pattern text is taken verbatim from the brief's code block
(`*.g.dart`, `*.freezed.dart`, `*.gr.dart`, `*.config.dart`, `*.mocks.dart`, each
`text eol=lf`). Column alignment of the `text eol=lf` token is cosmetic and not
asserted. Bare `*.x` rather than `**/*.x` is correct — a leading-slash-free git
pattern already matches at any depth.

ASSUMPTION: `.gitattributes` itself is committed with the repository's normal line
endings; the brief specifies endings for the files it names, not for itself.

ASSUMPTION: "Untrack `coverage/lcov.info`" means remove it from the git index only,
leaving the working-tree file on disk (`git rm --cached`). Deleting local coverage
output is not requested and would break nothing but is unnecessary.

ASSUMPTION: The `.gitignore` entry is exactly `coverage/` as stated, appended under a
new comment heading in keeping with the file's existing sectioned style. `coverage/`
is the only coverage path in the tree today (`coverage/lcov.info`).

ASSUMPTION: "Remove the incorrect `envied` TODO" means deleting only the trailing
comment `# TODO: To deprecate this package and use flutter_secure_storage` from the
`envied: ^1.3.4` line in `pubspec.yaml`. The dependency, its version, its section
comment (`# Envied - Privatise file`) and the `envied_generator` dev dependency all
stay. The brief's own reasoning — the two packages solve different problems — is the
justification for deleting the note rather than acting on it.

ASSUMPTION: No replacement comment is written in place of the removed TODO. The brief
asks for removal, not for the rationale to be recorded in `pubspec.yaml`; the
reasoning lives in this run's artifacts.

ASSUMPTION: `git add --renormalize .` is run repo-wide as instructed, but is expected
to alter content only in files matching a `.gitattributes` pattern. Because the brief
forbids a blanket `* text=auto` / `*.dart eol=lf`, any hand-written source file
appearing in the resulting diff is treated as a symptom of an over-broad pattern, not
as an accepted cost. Criterion AC-1.4 makes this verifiable.

ASSUMPTION: Verification of the churn fix uses the brief's own procedure — `git
status` before and after `dart run build_runner build --delete-conflicting-outputs` —
on the run's own machine. The "roughly seventeen files" figure is descriptive; the
criterion is zero generated files reported modified, whatever the file count.

ASSUMPTION: The three fixes are independent and may land in any order within the one
commit. The brief calls them "three unrelated repository-hygiene fixes" and states no
sequencing between them.
