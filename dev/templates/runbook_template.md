# Runbook — Template

**Output target:** `dev/RUNBOOK.md`
**Role:** repeatable procedure reference for deploys / publishes / releases / pipelines / any recurring procedure.

This template defines the **field structure** for a runbook. Each field includes a one-line description and an example fill using placeholders (`[X]` / `[N]` / `[step]`). Users may self-fill this template without invoking AI; AI uses this template as the structural reference when running `dev/wizards/playbook.md` draft+iterate flow.

---

## Required fields per procedure

### 1. Procedure name and trigger
What this procedure is, when to run it.

> Example: `[procedure name]` — runs when `[trigger condition]` (e.g., before each release; after `[event]`; on cron `[schedule]`).

### 2. Frequency / Cadence
How often the procedure runs. One-time vs recurring.

> Example: every release; weekly; on-demand.

### 3. Pre-conditions
What must be true before starting.

> Example: `[branch]` is clean; `[service]` is reachable; `[N]` artifacts present.

### 4. Steps (numbered)
Each step is a single discrete action. State the command, expected result, and how to verify.

> Example:
> 1. Run `[command]`. Expected: `[outcome]`. Verify: `[check]`.
> 2. ...

### 5. Verification
Final acceptance check that the whole procedure succeeded.

> Example: `[final state condition]` — verified by `[command / check]`.

### 6. Rollback / Failure path
What to do if any step fails. Each rollback step should be reversible.

> Example: if step `[N]` fails → run `[rollback command]`; if `[failure mode]` → escalate to `[owner]`.

### 7. Acceptance gate (optional)
For release-class procedures: who or what approves before completion.

> Example: requires `[approver]` sign-off; requires `[N]/[N]` checks PASS.

### 8. Owner / Approval (optional)
Who owns this procedure, who can authorize exceptions.

### 9. Notes / Edge cases (optional)
Known gotchas, observed failure modes, environmental dependencies.

---

## Header line (mandatory)

The output `dev/RUNBOOK.md` must include this line in its header:

```
Created: <YYYY-MM-DD> (via guided wizard, AI-assisted)
```

If user self-fills this template without AI, replace `via guided wizard, AI-assisted` with `manual`.

---

## How to use this template

1. **Self-fill path** — copy the field structure into `dev/RUNBOOK.md`, fill each field per procedure, drop the example placeholder lines. Write the header `Created:` line. Multi-procedure runbooks repeat fields 1–9 per procedure under second-level headings.
2. **AI-assisted path** — invoke the wizard. Triggers, draft+iterate loop, assumption rules, close-out signals all live in `dev/wizards/playbook.md` (single source of truth). The wizard reads this template + your 1-sentence procedure description and runs the playbook flow.

---

## References

- AGENTS.md §3 PLAN onboarding readiness check — when AI offers this wizard
- dev/wizards/playbook.md — AI behavior for the draft+iterate loop
- Design rationale: `docs/plans/2026-05-03-wizard-paradigm-shift-design.md`
