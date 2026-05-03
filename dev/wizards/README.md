# Wizards (behavior + content)

This directory + the sibling `dev/templates/` directory implement the onboarding wizard system for non-trivial governance docs.

| File | Role |
|---|---|
| `dev/wizards/playbook.md` | **Behavior layer** — how AI conducts the draft+iterate loop (when to engage / one-shot draft / assumption list / close-out / vague-input fallback). |
| `dev/templates/spec_template.md` | **Content layer** — field structure for `dev/PROJECT_MASTER_SPEC.md`, with example fills. |
| `dev/templates/runbook_template.md` | **Content layer** — field structure for `dev/RUNBOOK.md`, with example fills. |

## Paradigm

User supplies a 1-sentence project description → AI generates a one-shot full draft + numbered assumption list → user spot-checks and corrects → AI iterates → AI proposes write. The behavior loop is in `playbook.md`; the field structure is in templates.

Templates have **standalone value** — a user can self-fill `dev/PROJECT_MASTER_SPEC.md` or `dev/RUNBOOK.md` from the template without invoking AI.

## Triggers

1. AGENTS.md §3 PLAN onboarding readiness check (auto, respects `dev/PROFILE.md` `wizard_disabled_*` flags).
2. INIT.md install POST-INSTALL Wizard Auto-Trigger (first install only, spec only).
3. Explicit user request ("build master spec" / "建 master spec" / "build runbook" / "建 runbook" — runs regardless of disabled flag).

## `dev/PROFILE.md` schema

Created by INIT.md install POST-INSTALL: Profile Selection step. Fields:

```
profile: <one of: general / research / coding / writing / agent-design / data-analysis>
language: <auto-detected user language; wizard render fallback when chat language unclear; defaults to en>
created: <YYYY-MM-DD UTC>
wizard_disabled_spec: <true|false>     # default false; set true by wizard prompt C-path ("never ask again")
wizard_disabled_runbook: <true|false>  # default false; same mechanism for runbook
```

**Decline persistence:** wizard offers 3 paths — A (run now) / B (defer, allow re-prompt next session) / C (never ask again, sets the corresponding `wizard_disabled_*` flag to `true`). AGENTS.md §3 PLAN reads these flags before surfacing a wizard prompt; `true` suppresses auto-prompt permanently.

**Explicit override:** even when a flag is `true`, an explicit user request runs the wizard. Flags only block auto-prompts.

**Render language precedence:** (1) latest user chat language, (2) `PROFILE.md` `language` field, (3) `en` default.

## Adding a new wizard

1. Add a content template to `dev/templates/<name>_template.md` (field structure + example fills, standalone-fillable).
2. Add the trigger condition to AGENTS.md §3 PLAN onboarding readiness check + mirror to INIT.md FILE 1.
3. Update `playbook.md` if the new wizard introduces behavior beyond the standard draft+iterate loop.
4. Update harness `docs/qa/run_checks.sh` R33 series — playbook + new template existence checks.
5. Update `dev/DOC_SYNC_CHECKLIST.md` row covering wizard / template change category.

## References

- Behavior: `dev/wizards/playbook.md`
- Templates: `dev/templates/`
- Design rationale: `docs/plans/2026-05-03-wizard-paradigm-shift-design.md`
- Profile awareness (suggestion-only, user override always wins): see `dev/wizards/playbook.md` Step 2 + AGENTS.md §3.6
