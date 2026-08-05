# QA artifact templates

Read only when writing QA output.

## `qa-report.md`

```markdown
# QA Report
Run: [run id]
Commit: [SHA]
Overall result: PASS | PASS — pending manual checks | FAIL

## Manual verification required
[exact checks, or NONE]

## Static analysis
[command, baseline comparison, attributable diagnostics]

## Test results
[command, pass/fail/timeout]

## Coverage gaps
[coverage-mode gaps or NONE]

## Acceptance criteria
[ID]: PASS | FAIL | MANUAL — [file:line or test evidence]

## Architectural compliance
[findings]

## Escalation required
Route to: Dev | Tech Lead | Human | NONE
[reason/action]
```

On FAIL, write `escalation.md` using the shared escalation rules.
