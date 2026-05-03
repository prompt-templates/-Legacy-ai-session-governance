# Wizard Playbook (behavior layer)

This file defines **how** the AI conducts an onboarding wizard for non-trivial governance docs (`dev/PROJECT_MASTER_SPEC.md` / `dev/RUNBOOK.md`). The **content** for each doc lives in:

- `dev/templates/spec_template.md` — field structure for `PROJECT_MASTER_SPEC.md`
- `dev/templates/runbook_template.md` — field structure for `RUNBOOK.md`

The behavior here is paradigm-aligned with modern Agentic AI collaboration: **user supplies a 1-sentence project description → AI generates a one-shot full draft + numbered assumption list → user spot-checks and corrects → AI iterates → AI proposes write**. This replaces a prior 5–7 step structured Q&A schema (retired 2026-05-03).

---

## When to engage

The wizard triggers from one of these paths:

1. **AGENTS.md §3 PLAN onboarding readiness check** — at PLAN entry, if the relevant doc is missing AND the matching `wizard_disabled_*` flag in `dev/PROFILE.md` is not `true`, AI offers to draft. Flags suppress auto-prompts only; they never block explicit user requests.
2. **INIT.md install POST-INSTALL Wizard Auto-Trigger** — fires once at first install for `PROJECT_MASTER_SPEC.md`.
3. **Explicit user request** — phrases like "build master spec", "建 master spec", "build runbook", "建 runbook" run the wizard regardless of any disabled flag.

In all cases the offer must include a clear decline path (A run now / B defer / C never ask again) and must respect user choice. C-path persists by setting `wizard_disabled_spec: true` or `wizard_disabled_runbook: true` in `dev/PROFILE.md`.

---

## The draft + iterate loop

### Step 1 — Take the seed
Ask the user for a short project description. One sentence is enough. Keep the prompt short — no multi-question form.

> "俾我 1 句項目描述就得 — 我會即刻 draft 全份。"

If the description is too vague to draft a useful first cut → see "Vague-input fallback" below.

### Step 2 — Generate one-shot draft + assumption list
Read the relevant template (`dev/templates/spec_template.md` or `dev/templates/runbook_template.md`) for field structure, then:

1. Fill every field with a plausible value inferred from the seed + context. **Hallucination guardrail:** for optional fields without any ground truth in the seed or surrounding context (e.g., References / prior art / specific external products / specific dates without a stated timeline), write `(待補)` or `TBD` — do NOT fabricate plausible-sounding entries. Generic defaults that hold for almost any project of the type (e.g., "Phase 1 = MVP" / "Audience = primary user group") are acceptable but must surface in the assumption list as low-confidence inferences.
2. List every key assumption made as a numbered short-bullet (typical 5–12 items, terse). Cover both high- and low-confidence assumptions — do NOT filter to low-confidence only; high-confidence assumptions may still be wrong and need challenge.
3. Surface the draft + assumption list in one reply.

Format invariants for the assumption list:
- One numbered list. No per-section grouping.
- Each item ≤ 1 line, terse.
- **Each filled template field gets at least one explicit assumption** stating the primary inference (e.g., for Tech stack write `④ 技術 stack 推 React + Node + PostgreSQL 而非 native iOS / Java`; do NOT bury the inference in a vague entry like `④ 技術 stack`). Implicit inferences erode the transparency contract.
- Cover target audience, deliverable form, scope, success criteria, constraints (whichever apply per template).

### Step 3 — Spot-check and iterate
User responds. Common patterns:
- Index reference (e.g., "③⑤ 改成 ...") → AI updates those items + re-draft entire doc + new assumption list.
- Free-form correction → AI parses, applies, re-draft + list.
- Add new constraint not in current assumption list → AI absorbs, re-draft + list.

Each iteration produces a new full draft + refreshed assumption list. Do NOT show only the diff — the user spot-checks the whole, and a stale assumption list erodes the transparency contract.

### Step 4 — Close-out signal detection
Two classes of signals — treat them differently:

**(a) Soft closure** — user signals satisfaction but hasn't explicitly requested write. Examples: "ready", "down", "啱晒", "得", "好", "OK" (without write verb), or two consecutive turns with no new modifications.

→ AI proposes write, waits for explicit confirmation:

> "我寫入 `<output_path>`?"

User confirms ("寫" / "yes" / "go") → write file (Step 5). User defers ("等等仲要改 X") → loop continues.

**(b) Explicit write request** — user directly requests file write. Examples: "寫", "寫入", "OK 寫", "write it", "go write", "write 落去", or any phrase with an imperative write verb.

→ AI skips the propose step and writes directly per Step 5. No extra confirmation turn — re-asking after an explicit write request adds a redundant round-trip and feels hesitant.

If unsure which class a signal falls into (e.g., short ambiguous reply "OK 啦"), default to (a) soft closure — the extra confirmation turn is cheaper than a wrong write.

### Step 5 — Write
On confirmation:
1. Write the draft to its target output path (`dev/PROJECT_MASTER_SPEC.md` for spec; `dev/RUNBOOK.md` for runbook).
2. Header line: `Created: <YYYY-MM-DD> (via guided wizard, AI-assisted)`.
3. After write, brief acknowledgement: "已寫入 `<path>`。之後想改隨時直接編輯，或同我講。"

---

## Vague-input fallback

If the user's seed is too sparse to draft a useful first cut (e.g., a request to build the doc with zero project context), use AGENTS.md §11a rule 2 choice format with **mandatory escape hatch**.

Format invariant — every choice prompt at this paradigm step reads as:

> A. `<interpretation 1, with concrete user-experience preview>`
> B. `<interpretation 2>`
> C. `<interpretation 3>`
> **揀 A/B/C 或者俾多少少 context**

If user picks A/B/C → use that interpretation as seed, return to draft+iterate loop.
If user gives free-form context (the "D" / context path) → use that as seed, return to draft+iterate loop.

**Hard rule:** the escape hatch (`或者俾多少少 context`) must NEVER be stripped. Without it, the prompt regresses to a small forced-choice form-fill, contradicting paradigm intent.

---

## What this paradigm replaces

Prior paradigm (retired 2026-05-03): structured 5–7 step Q&A schema (`dev/wizards/*_starter.md`) with declared options per step, visual frame ASCII, step labels. The form-fill model assumed users could answer cold questions upfront — a poor match for vague long-term project visions and a poor match for modern Agentic AI collaboration.

This paradigm leverages AI's ability to produce a coherent first draft from minimal input + state assumptions transparently for correction. Iteration is cheap; cold question answering is expensive.

---

## References

- Design rationale: `docs/plans/2026-05-03-wizard-paradigm-shift-design.md`
- Behavior trigger: `AGENTS.md §3.6` + `AGENTS.md §3 PLAN onboarding readiness check`
- Decline persistence schema: `dev/wizards/README.md` `dev/PROFILE.md` schema section
- Choice format with escape hatch: `AGENTS.md §11a` rule 2 (Layer A Ask-gate + Layer B Outcome preview)
