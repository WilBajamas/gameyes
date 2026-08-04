# QA artifact template

Read only when writing `qa-report.md`.

```markdown
# QA Report
Source: [task-brief.md source identifier]
Date: [today]

Overall result: PASS | PASS — pending manual checks | FAIL

## Manual verification required
(Omit entirely if none)
[SOURCE-ID] — Open [screen], with [state/condition] — expect [what should be seen]

## Static analysis
Status: PASS | FAIL
Errors: N | NONE
path/to/file.dart:line — error description

## Test results
Status: PASS | FAIL | SKIPPED (testing-mode: none)
Tests run: N  |  Passed: N  |  Failed: N
Failing tests: test/path/to/file_test.dart — test name — failure reason

## Coverage gaps (coverage mode only)
[SOURCE-ID]: no test found for failure case — [description]
(or NONE)

## Acceptance criteria
[SOURCE-ID]: PASS — [file:line or test name proving it]
[SOURCE-ID]: MANUAL — [what a human must check]
[SOURCE-ID]: FAIL | PARTIAL — [exactly what is wrong or missing]

## Architectural compliance
Status: PASS | FAIL
FAILs: [deviation from tdd.md] (or NONE)
WARNINGs: [harmless additive deviation] (or NONE)

## Escalation required
NONE | [issue → route to: Dev Agent | Tech Lead Agent | Human]
```

On FAIL, write `escalation.md` per the shared escalation rules after this report.
