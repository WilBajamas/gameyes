# BA artifact templates

Read only when writing BA artifacts.

## `tech-ac.md`

Written only when `ambiguities.md ## CRITICAL` is `NONE`. Keep under 600 lines —
if the feature needs more, flag it in `ambiguities.md` instead: it likely needs
splitting into multiple tickets.

```markdown
# Technical Acceptance Criteria
Source: [FRS version + sections | ticket ID]
Date: [today]
BA Agent version: 1.0

## Feature summary
One paragraph, engineering-facing, not stakeholder language.

## Technical acceptance criteria
[SOURCE-ID] LAYER: specific, verifiable behaviour statement
  Failure case: what happens when this fails or the condition is not met
... one block per criterion — this section is the pipeline's canonical criteria
source; every downstream artifact references it by ID, never copies it.

## Out of scope
[Anything explicitly excluded, or reasonably assumed in scope but isn't]

## Assumptions
ASSUMPTION: [text]
(or NONE)
```

## `ambiguities.md`

Written on every run, without exception, even when both sections are empty.

```markdown
# Ambiguities Report
Source: [FRS version + sections | ticket ID]
Date: [today]

## CRITICAL (pipeline blocked — requires human decision before proceeding)
CRITICAL-1: [requirement ID] — [description of ambiguity]
  Options: [option A] | [option B]
  Recommended: [if a reasonable default exists, otherwise NONE]
  Decision needed from: BA / Product Owner
(or NONE)

## ASSUMPTIONS (minor — pipeline may proceed)
ASSUMPTION: [text]
(or NONE)
```
