# Dev artifact template

Read only when writing `diff-summary.md`.

```markdown
# Diff Summary
Source: [task brief source]
Date: [ISO date]
Dev Agent version: 1.0
Branch: feature/[slug]
Commit: PENDING — awaiting Phase 4B human review

## Files created
[path — purpose]

## Files modified
[path — change]

## Test files
[path — coverage]

## Self-corrections
[file, error, fix, attempts] or NONE

## Deviations from implementation plan
[deviation and reason] or NONE

## Verification against baseline
[commands and attributable results]

## Acceptance criteria status
[ID]: satisfied | not satisfied — [note]
```

After approved commit, replace `Commit:` with the SHA.
