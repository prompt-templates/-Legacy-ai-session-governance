# Wizard Playbook (behavior layer)

This file defines **how** the AI conducts an onboarding wizard for non-trivial governance docs (`dev/PROJECT_MASTER_SPEC.md` / `dev/RUNBOOK.md` / `dev/EXTERNAL_KB.md`). The **content** for each doc lives in:

- `dev/templates/spec_template.md` — field structure for `PROJECT_MASTER_SPEC.md`
- `dev/templates/runbook_template.md` — field structure for `RUNBOOK.md`
- `dev/templates/external_kb_template.md` — field structure for `dev/EXTERNAL_KB.md` external knowledge surface pointer (per AGENTS.md §10b); pairs with `docs/EXTERNAL_KB_COOKBOOK.md` tool-specific reference

The behavior here is paradigm-aligned with modern Agentic AI collaboration: **user describes the project briefly (and optionally points to reference signals — local files / URLs / known decisions) → AI actively reads any provided sources before drafting → AI generates a one-shot full draft + numbered assumption list (each item labeled by source) → user spot-checks and corrects → AI iterates → AI proposes write**. This replaces a prior 5–7 step structured Q&A schema (retired 2026-05-03).

---

## When to engage

The wizard triggers from one of these paths:

1. **AGENTS.md §3 PLAN onboarding readiness check** — at PLAN entry, if the relevant doc is missing AND the matching `wizard_disabled_*` flag in `dev/PROFILE.md` is not `true`, AI offers to draft. Flags suppress auto-prompts only; they never block explicit user requests.
2. **INIT.md install POST-INSTALL Optional Wizard** — fires once at first install for `PROJECT_MASTER_SPEC.md` and offers `RUNBOOK.md` / `EXTERNAL_KB.md` setup as additional opt-in prompts.
3. **Explicit user request** — phrases like "build master spec", "建 master spec", "build runbook", "建 runbook", "set up external KB", "設 external KB" run the wizard regardless of any disabled flag.

In all cases the offer must include a clear decline path (A run now / B defer / C never ask again) and must respect user choice. C-path persists by setting `wizard_disabled_spec: true` / `wizard_disabled_runbook: true` / `wizard_disabled_external_kb: true` in `dev/PROFILE.md`.

### Variant — External KB wizard (per AGENTS.md §10b)

The external KB wizard differs from spec / runbook wizards in **content** (the seed is tool + URL + mode, not project description) but reuses the same draft + iterate behavior loop below. Specifics:

- **Main question** at Step 1: tool type + entry URL + access mode (Mirror / Bridge / Mixed). Supplements: AI access variant (Direct via MCP / API / sync-folder, or Paste-only), in-scope items (collections / vault paths / folder URLs), sync expectation (every PERSIST / per session / weekly batch / manual), notes.
- **Source grounding** at Step 2a: if user provides the entry URL and AI has Direct access (MCP / API), AI reads the external schema to verify the structure exists and is accessible before drafting. If Paste-only, AI flags assumptions about external schema as `[my inference]` per Step 2c.
- **Draft target**: `dev/EXTERNAL_KB.md` based on `dev/templates/external_kb_template.md`. Reference `docs/EXTERNAL_KB_COOKBOOK.md` for tool-specific patterns the AI may suggest (but not impose).
- **Tool neutrality**: the AI must not push the user toward a specific tool. If the user names a tool, suggest patterns from the cookbook entry for that tool; if no specific tool is named, ask which tool before suggesting patterns.

---

## The draft + iterate loop

### Step 1 — Take the seed (main question + optional supplements)

Ask the user for a brief project description as the **main question**, plus three optional supplements presented as low-friction prompts. Frame: low cognitive barrier on the main question, supplements explicitly optional with an escape phrase ("answering only the main question is fine").

The prompt MUST contain three structural parts in this order:

1. **Main question** — one short open-ended ask: what the project is, who it's for. One sentence to a short paragraph is enough.
2. **Optional supplements** — three bullets, each prefaced with "if you have any":
   - 📁 Reference files (PRD, prior spec, meeting notes, design docs) — provide paths
   - 🔗 Relevant URLs (product page, docs, competitors) — paste links
   - 📌 Known decisions / constraints (tech choice, deadlines, must-haves / must-not-haves) — one line each
3. **Escape phrase** — explicitly tell the user that answering only the main question is sufficient. This protects against the supplements being read as a four-field form. Example phrasing: "If you don't have time, just answer the main question; I'll fill the rest from inference and surface assumptions for you to spot-check."

The supplements are **never converted into mandatory questions**. They are hints at what would help, not a checklist.

The prompt is rendered in the user's chat language — example phrasing above is illustrative only, not a verbatim mandate.

If the description is still too vague even after main + supplements → see "Vague-input fallback" below.

### Step 2 — Read sources, then generate one-shot draft + labeled assumption list

**Step 2a — Source grounding (mandatory before drafting):**

Before generating the draft, AI MUST process every reference signal the user provided in Step 1:

- **Local file path** → read it via the Read tool.
- **URL** → fetch it via WebFetch (or equivalent).
- **Keyword / project name to look up** → grep across the project / search where applicable.

Silent fabrication of references / third-party product names / competitor details is **prohibited**. If a reference signal cannot be processed (file missing, URL unreachable, fetch blocked), surface the failure to the user before drafting; do not invent content to fill the gap. If the user mentions an external product / competitor without providing a source link, treat it as inference territory and label accordingly in Step 2c.

**Step 2b — Draft:**

Read the relevant template (`dev/templates/spec_template.md` or `dev/templates/runbook_template.md`) for field structure, then fill every field with a plausible value inferred from the seed + processed sources. **Hallucination guardrail:** for optional fields without any ground truth in the seed, processed sources, or surrounding context (e.g., References / prior art / specific external products / specific dates without a stated timeline), write `(待補)` or `TBD` — do NOT fabricate plausible-sounding entries. Generic defaults that hold for almost any project of the type (e.g., "Phase 1 = MVP" / "Audience = primary user group") are acceptable but must surface in the assumption list as low-confidence inferences.

**Step 2c — Labeled assumption list:**

List every key assumption as a numbered short-bullet (typical 5–12 items, terse). Cover both high- and low-confidence assumptions — do NOT filter to low-confidence only; high-confidence assumptions may still be wrong and need challenge.

Each item MUST be tagged by source at the start:

- `[from your input]` — derived from user-provided seed / files / URLs / decisions. The user spot-checks whether AI read the source correctly.
- `[my inference]` — AI-estimated where ground truth was absent. The user knows this is the "AI fills the gap" zone and reviews more carefully.

Format invariants:
- One numbered list. No per-section grouping.
- Each item ≤ 1 line, terse, with the source tag at the start.
- **Each filled template field gets at least one explicit assumption** stating the primary inference, naming the chosen direction over plausible alternatives (e.g., `④ [my inference] <dimension> 推 <chosen-option-A> 而非 <alternative-option-B>`; do NOT bury the inference in a vague entry like `④ <dimension>`). Implicit inferences erode the transparency contract.
- Cover target audience, deliverable form, scope, success criteria, constraints (whichever apply per template).

**Step 2d — Surface draft + labeled assumption list in one reply.**

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

Format invariant — every choice prompt at this paradigm step must offer A/B/C interpretations PLUS a free-form context path. Example pattern (rendered in the user's chat language; phrasing below is illustrative only):

> A. `<interpretation 1, with concrete user-experience preview>`
> B. `<interpretation 2>`
> C. `<interpretation 3>`
> **Pick A/B/C, or share a bit more context**

If user picks A/B/C → use that interpretation as seed, return to draft+iterate loop.
If user gives free-form context (the "share more context" path) → use that as seed, return to draft+iterate loop.

**Hard rule:** the escape hatch (the free-form "share more context" path) must NEVER be stripped. Without it, the prompt regresses to a small forced-choice form-fill, contradicting paradigm intent.

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
