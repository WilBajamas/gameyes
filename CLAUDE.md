# QuestLoggd — working notes for Claude

## Communication

Be token-saving. Do not reply in walls of text — say only what's necessary,
in short, plain English.

- Progress updates: one short sentence (what happened, what's next). Don't
  narrate routine tool calls, waits, or reasoning.
- Full detail is earned, not default: give it only for a genuine escalation
  the human must decide on, or when they explicitly ask for more.
- This applies double inside the feature pipeline (`/orchestrate` and its
  BA/Tech Lead/Dev/QA subagents, see `.claude/skills/`) — their reports get
  read by a human at every gate, so terse and skimmable beats thorough.

## Where things live

- Feature work goes through `/orchestrate` — see `.claude/skills/orchestrate/SKILL.md`.
- Product/design/architecture references: `.agents/references/`.
- `.claude/` and `.agents/` are both git-ignored — nothing there has version
  history. Edit with care; there's no `git diff` safety net.
