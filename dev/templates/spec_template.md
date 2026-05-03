# Project Master Spec — Template

**Output target:** `dev/PROJECT_MASTER_SPEC.md`
**Role:** complete, stable, long-term authoritative specification (per `AGENTS.md §10`).

This template defines the **field structure** for a project master spec. Each field includes a one-line description and an example fill using placeholders (`[X]` / `[topic]` / `[domain]` / `[N]`). Users may self-fill this template without invoking AI; AI uses this template as the structural reference when running `dev/wizards/playbook.md` draft+iterate flow.

---

## Required fields

### 1. Project name and one-line vision
What this project is, in one sentence. A first-time reader should grasp the scope without further context.

> Example: `[X]` — `[one-line description of what it does and for whom]`.

### 2. Audience / Users
Who this is for. Be specific — different user groups will require different decisions.

> Example: `[primary user group]`; `[secondary user group, if any]`.

### 3. Scope
What is in scope. What is explicitly out of scope. Out-of-scope is as important as in-scope.

> Example (in scope): `[capability 1]`, `[capability 2]`.
> Example (out of scope): `[non-goal 1]`, `[non-goal 2]`.

### 4. Architecture / Tech stack
Languages, frameworks, key libraries, runtime targets, deployment model.

> Example: `[language]` + `[framework]`; runs on `[platform]`; deploys via `[mechanism]`.

### 5. Key decisions
Architectural / design decisions worth preserving for future readers, with one-line rationale each.

> Example: chose `[option A]` over `[option B]` because `[reason]`.

### 6. Success criteria
How "this works" is measured. Verifiable conditions, not aspirations.

> Example: `[metric 1]` reaches `[threshold]`; `[behavior]` works for `[N]` users without `[failure mode]`.

### 7. Constraints and risks
Known limits, dependencies, risks. What could go wrong.

> Example: depends on `[external service]`; risk: `[failure mode]` if `[condition]`.

### 8. Roadmap / Milestones (optional)
If staged, list phases with one-line goals.

> Example: Phase 1 = `[goal]`; Phase 2 = `[goal]`.

### 9. References (optional)
Links to design docs, prior art, related issues, external specs.

---

## Header line (mandatory)

The output `dev/PROJECT_MASTER_SPEC.md` must include this line in its header:

```
Created: <YYYY-MM-DD> (via guided wizard, AI-assisted)
```

If user self-fills this template without AI, replace `via guided wizard, AI-assisted` with `manual`.

---

## How to use this template

1. **Self-fill path** — copy the field structure into `dev/PROJECT_MASTER_SPEC.md`, fill each field, drop the example placeholder lines. Write the header `Created:` line.
2. **AI-assisted path** — invoke the wizard (say "build master spec" or accept the §3 PLAN onboarding offer). AI reads this template + your 1-sentence project description, generates a one-shot draft with all fields filled + a numbered assumption list. Spot-check, correct, iterate, write. See `dev/wizards/playbook.md` for the loop.

---

## References

- AGENTS.md §10 — Optional Master Spec Mode (when this doc is recommended)
- dev/wizards/playbook.md — AI behavior for the draft+iterate loop
- Design rationale: `docs/plans/2026-05-03-wizard-paradigm-shift-design.md`
