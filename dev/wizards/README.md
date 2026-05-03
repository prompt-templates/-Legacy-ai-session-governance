# Wizard Schemas

This directory holds onboarding wizard schemas read by AI to conduct guided Q&A with users. AI executes a wizard by reading the schema markdown, rendering each step using the shared visual frame, and writing the resulting document to its target location.

## Files

| File | Purpose | Output target |
|---|---|---|
| `_visual_frame.md` | Shared visual frame template + i18n label table (used by all wizards) | n/a (template) |
| `spec_starter.md` | 7-step wizard generating a project master spec | `dev/PROJECT_MASTER_SPEC.md` |
| `runbook_starter.md` | 5-step wizard generating a recurring-procedure runbook | `dev/RUNBOOK.md` |

## How wizards trigger

Wizards fire from one of three paths:

1. **Install profile selector** — `INIT.md` install Quick Start asks the user for a profile, then auto-fires `spec_starter` if the user opts in
2. **AGENTS.md §3 PLAN onboarding readiness check** — at PLAN entry, AI scans for missing `dev/PROJECT_MASTER_SPEC.md` (or `dev/RUNBOOK.md` when user mentions deploy / publish / pipeline keywords) and offers to run the wizard
3. **User explicit request** — phrases like "build a master spec", "建 master spec", "build runbook", "建 runbook"

In all cases AI must offer a clear decline path and respect user choice.

## Hard rules (enforced by harness R33 series)

1. **Each language string row uses ONE language only.** Do not mix English verbs/nouns into zh-TW / zh-CN / ja prose. Technical proper nouns (`Agent` / `API` / `JSON` / `Markdown` / `SDK` / placeholder tokens like `[X]` / `[domain]`) are universal — may appear in any language string.
2. **Each Question and each Option must have all 4 language entries** (`en` / `zh-TW` / `zh-CN` / `ja`). Missing a language → harness fail.
3. **Examples use placeholders only.** Do NOT hardcode specific industry / tool / framework / company names. Use `[X]` / `[topic]` / `[domain]` / `[thing]` / `[problem]` / `[N]` / `[T]`. Harness R33-08 / R33-09 enforces the exact blacklist.
4. **AI execution guidance is the only section that may stay in English-only config syntax.** It's executor instructions, not user-facing text.
5. **Do not duplicate the visual frame ASCII or the i18n label table.** Schemas reference `_visual_frame.md`; if a new label is needed, add it to `_visual_frame.md` first.

## Adding a new wizard

1. Create `dev/wizards/<name>_starter.md`
2. Define metadata block (output file, step count, skip path)
3. Add a Step 0 bypass detection
4. Add steps 1..N each with: `phase_title (i18n)` / `Question (i18n)` / `Option A/B/C (i18n)` / `AI execution guidance (config)`
5. Add an output template at the end (skeleton with placeholders)
6. Update `INIT.md` Quick Start if the wizard should auto-trigger at install
7. Update `AGENTS.md` §3.6 if the wizard has a new detection trigger
8. Update harness `docs/qa/run_checks.sh` R33 series — add file existence + i18n completeness checks
9. Update `dev/DOC_SYNC_CHECKLIST.md` if change category isn't covered

## Profile awareness

Wizards may use the `profile` field from `dev/PROFILE.md` (created by INIT.md install) to tune recommendations. Supported profile values:

- `general` — no specialization
- `research` — academic / market / domain research work
- `coding` — software development, libraries, applications
- `writing` — documentation, articles, books, blog posts
- `agent-design` — AI agent / workflow / pipeline design
- `data-analysis` — data exploration, modeling, analysis reports

Profile awareness is **suggestion-only** — wizards must still allow user override. Schemas using profile-aware logic place it in the `AI execution guidance` config block.

## `dev/PROFILE.md` schema

Created by INIT.md install POST-INSTALL: Profile Selection step. Fields:

```
profile: <one of the 6 supported values above>
language: <auto-detected user language preference; defaults to en>
created: <YYYY-MM-DD UTC>
wizard_disabled_spec: <true|false>     # default false; set true by spec_starter Step 0 C-path
wizard_disabled_runbook: <true|false>  # default false; set true by runbook_starter Step 0 C-path
```

**Decline persistence:** Each wizard's Step 0 offers 3 paths — A (run now) / B (defer, allow re-prompt next session) / C (never ask again, set the corresponding `wizard_disabled_*` flag to `true`). AGENTS.md §3 PLAN reads these flags before deciding to surface a wizard prompt; `true` suppresses auto-prompt permanently.

**Explicit override:** Even when a flag is `true`, an explicit user request like "build master spec" or "build runbook" runs the wizard. Flags only block auto-prompts, not user-initiated runs.

**Render language precedence:** Wizards pick render language by precedence: (1) latest user chat language, (2) `PROFILE.md` `language` field, (3) `en` default.
