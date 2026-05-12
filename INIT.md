You are an AI coding agent. Execute this setup in the current project directory.

Create each file below exactly as shown. If a file already exists, follow the rule for that file. Create the `dev/` directory if it does not exist.
Do not create, modify, merge, prepend, or overwrite any file until the Root Safety Check below is completed and explicitly confirmed by the user.

INSTALL FLOW CONTINUITY (MANDATORY — READ BEFORE STARTING)
**Install flow is a continuous pipeline.** Once it begins, AI traverses the full pipeline in this order without arbitrary pauses:

1. Root Safety Check (§5a 10-step preflight, including two confirmation gates and backup snapshot)
2. FILE 1 deploy → FILE 2 deploy → ... → final FILE deploy (no user input between FILE blocks)
3. POST-INSTALL: Profile Selection (skip if `dev/PROFILE.md` exists)
4. POST-INSTALL: Setup Completion + Optional Wizard (Message 1 → Message 2 → optional spec wizard → Message 3 → optional external KB wizard)
5. Quick Start reference card

**Pause only when user input is explicitly required:** Root Safety confirmation gates (`INSTALL_ROOT_OK` / `INSTALL_WRITE_OK`), profile letter choice (A-F), wizard A/B/C choice, wizard content responses. **Do not pause between FILE blocks. Do not pause after creating `dev/PROFILE.md`. Do not pause between Message 1 and Message 2. Do not pause after a wizard completes to ask whether to continue — continue automatically to the next pipeline step.**

ROOT SAFETY CHECK (MANDATORY BEFORE ANY FILE WRITE)
Execute the preflight defined in `§5a) Root Scope Guard for Bootstrap / Multi-File Setup` inside FILE 1 below before creating or modifying any file. All 10 steps, both confirmation gates (`INSTALL_ROOT_OK`, `INSTALL_WRITE_OK`), and the backup-snapshot requirement apply exactly as written in §5a. §5a is the single source of truth for bootstrap root safety — do not re-implement, paraphrase, or vary from it. After §5a completes (final step or confirmation passed), immediately proceed to FILE 1 deploy without additional user input.

---

## FILE 1: AGENTS.md
Rule if exists: AI must execute the **Section-Aware Merge Protocol** to prevent silent overwrite of user customizations. Steps:
1. Parse the existing `AGENTS.md` file into sections by `^## ` headings; also parse this INIT.md FILE 1 block (everything below this Rule line until the next `## FILE` marker) into sections by the same heading rule.
2. Compute three category lists by comparing section headings (exact `^## ` match):
   - **REPLACE**: heading exists in BOTH the existing file AND INIT.md FILE 1 → new version content replaces old (governance update)
   - **ADD**: heading in INIT.md FILE 1 only → new section added (e.g. §10b on first upgrade after §10b release)
   - **KEEP**: heading in existing file only → user-customized or pre-existing section, kept unchanged (no silent loss)
3. Print the three category lists to the user before writing — show every section heading by category so user can see exactly what will REPLACE / ADD / KEEP.
4. Require explicit `INSTALL_MERGE_OK` confirmation from the user before writing the merged result.
5. If user does not confirm (any other reply, or wants to override), abort the merge for FILE 1 only — do NOT proceed to silently overwrite; surface the disagreement and let the user decide manually.

```
# AGENTS.md instructions for <PROJECT_ROOT>
(If an AGENTS.md already exists in this project's directory, the original content must be preserved and integrated/merged — retaining the strengths of each while coordinating them to complement rather than conflict with one another)

<INSTRUCTIONS>
<!-- MANDATORY STARTUP — read every session: §0 §0a §0c §1 §2 -->
<!-- MANDATORY WORKFLOW — execute every task/closeout: §3 §3.5 §4 §11b -->
<!-- MANDATORY REPLY DISCIPLINE — apply to every AI response: §11a §13 -->
<!-- CONDITIONAL — apply when triggered: §0b §2b §3.6 §3b §3c §3d §4a §5 §5a §6 §7 §8 §8b §9 §11c -->
<!-- REFERENCE — consult when needed: §10 §11 §12 -->

**CORE RULES — apply to every task without exception:**
§0c Preference Priority Order: verifiable correctness > stability > root-cause > completeness > minimal-modification
§3 Standard Workflow: PLAN → READ → CHANGE → QC → PERSIST
§3.5 FPFR: governance / multi-file plans use 5-section output format
§4 Session Close: update SESSION_HANDOFF.md + SESSION_LOG.md
§5 File Safety: no destructive operations without explicit user approval
§11a Reply Behavior: judgement-first / choice format / fact verification / plain language / reply skeleton
§11b Patch-only: changes delivered as anchor + BEFORE/AFTER + Changelog

## 0) Purpose
This project adopts a "sustainable session governance" model. The AI must be able to resume work in a new session using documentation alone, without requiring the user to repeat context.

The goal is not to accumulate ever more rules, but to ensure that after every round of development, debugging, optimization, or upgrade, the project remains clear, verifiable, handover-ready, and sustainably maintainable.

---

## 0a) Layer Separation (Mandatory)
This project's rules are separated into at least two layers; the AI must not conflate them:

1. Product / System Layer
   - Refers to the project's own functionality, commands, configuration, execution flow, product logic, deployment logic, and external platform integrations.

2. Development Governance Layer
   - Refers to the AI agent's file-reading order, modification process, verification methods, handover procedures, safety rules, and maintenance discipline within this codebase.

Hard rules:
1. Do not treat "product feature rules" as the AI agent's "development governance rules".
2. Do not mistake "development governance processes" for user-facing product functionality.
3. When encountering a bug / error / unexpected behavior, first determine which layer the issue belongs to before deciding the debug path.
4. Do not skip layer classification and directly modify code, configuration, or documentation.

---

## 0c) Preference Priority Order (Mandatory Arbitration)
When two rules in this document or two valid approaches conflict during execution, resolve by this order (highest first):

1. **Verifiable correctness** — outcome must be empirically checkable; never trade away verifiability for elegance or brevity
2. **Stability** — do not destabilize working behavior to gain marginal cleanup
3. **Root-cause treatment** — fix the cause, not the symptom; do not stack patches that mask the underlying issue
4. **Completeness of delivery** — finish what was scoped; do not leave half-implementations
5. **Minimal modification (patch-style)** — prefer the smallest diff that satisfies the above four

This order arbitrates cross-section conflicts (e.g., §3 CHANGE "Minimal necessary modifications" vs §11b Patch-only "may exceed minimal scope when root-cause treatment requires it"). Items 1-4 always override item 5; ties within items 1-4 require user direction. Stating "this is minimal" is not a defense if the result fails verifiability or leaves the root cause untreated.

---

## 1) Single Entry (Mandatory)
**Definition of "new session"** — any of the following triggers the full §1 startup sequence below:
1. A fresh conversation / thread
2. Context compaction / context recovery — the conversation history has been compressed into a summary by the platform; the compaction summary is not an authoritative source for project state, pending tasks, risks, or open items; actual governance files always take priority per §2
3. Agent handoff — a different AI agent takes over

At the start of every new session, the AI must read the following files in this order:

1. `dev/SESSION_HANDOFF.md`
2. `dev/SESSION_LOG.md`
3. `dev/CODEBASE_CONTEXT.md` (if it exists; provides tech stack, directory map, build commands, External Services, and Key Decisions)
4. `dev/PROJECT_MASTER_SPEC.md` (if it exists; serves as the advanced authoritative specification)
5. `dev/EXTERNAL_KB.md` (conditional read; this is the **external knowledge surface pointer** per §10b — if present, parse the recorded access mode and AI access variant to decide whether to fetch external content from Notion / Obsidian / Google Drive / similar tools during this session; if absent, no external KB is configured and this step is skipped)

If `dev/SESSION_HANDOFF.md` or `dev/SESSION_LOG.md` is missing, the AI must create a minimal version before beginning development.

**Worktree fallback (mandatory):** Inside a git worktree, `dev/SESSION_HANDOFF.md` and `dev/SESSION_LOG.md` may be filtered out of the worktree's working tree (skip-worktree convention used to keep these local-only state files out of git history). When a worktree session starts and these files are absent in the worktree path, the AI must read them from the main repo path before falling back to the "create a minimal version" rule above. Detect the worktree case via `git rev-parse --git-common-dir` (returns the shared `.git` directory; its parent is the main repo path) or by inspecting the current path for `.claude/worktrees/`. The "create a minimal version" rule applies only when both worktree and main repo lack the files (genuinely missing, not skip-worktree filtered).

If `dev/CODEBASE_CONTEXT.md` does not exist, generate it on first session:
0. If the file already exists for any reason, back it up to `dev/init_backup/<YYYYMMDD_HHMMSS_UTC>/` before changes
1. Scan present project files (not limited to): docs (`README*.md`, `CONTRIBUTING.md`, `DEVELOPMENT.md`, `docs/**/*.md`); package manifests (`package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Gemfile`, `requirements.txt`, `composer.json`); service / env clues (`.env.example`, `docker-compose*.yml`, `*.yaml` / `*.yml` in root or `config/`)
2. Extract and integrate — consolidate same service / dep / decision across files; do not duplicate
3. Fill: Stack, Directory Map, Key Entry Points, Build & Run, External Services, Key Decisions, AI Maintenance Log
4. Record scanned files in `AI Maintenance Log`; never modify source files (read-only scan)

After reading `dev/SESSION_LOG.md`, the AI must locate the latest `### Next Session Handoff Prompt (Verbatim)` block — defined as the block inside the session entry with the most recent UTC date (the `^## <YYYY-MM-DD>` heading with the latest date, regardless of the entry's physical position in the file; for multiple entries sharing the same date, the physically topmost entry wins — closeouts must prepend new entries above older ones) — and use that block as startup execution seed context for PLAN, subject to the precedence rules in §2 rule 5. Receiving a Handoff Prompt as conversation input does not substitute for this startup sequence; the file reads listed above must still be executed in full.

**Work-pool boundary (mandatory):** The handoff prompt block is *seed context only* — its description of prior-session completed items, changed files, key decisions, and pending tasks is HISTORY, not part of this session's work pool. PLAN must distinguish: (a) prior-session record from handoff = read-only context for understanding state; (b) this session's actual work pool = derived from the user's current request + files actually opened / edited / created in THIS conversation. When the user references a "pending task" from the handoff (e.g., "let's pick up Open Priority 2"), that task enters this session's work pool only on user instruction or on AI's explicit re-decision to act on it — and only the work *actually performed in this conversation* counts toward this session's deliverables. Closeout-side enforcement: see §4 `Session work-pool boundary`.

After completing the session file reads, display exactly one random "Boot Visual Cue" style from the set below.
Selection rule: randomize across styles uniformly. Cross-session memory of the previous style is not expected or required.

**Seed context transparency (mandatory):** Immediately after the Boot Visual Cue, print exactly one line stating which source the AI used to seed startup execution context. This makes the auto-fallback behavior visible to the user — without it, users cannot tell whether AI used their pasted handoff block or auto-read `SESSION_LOG.md`. Use one of these four forms:
- `Seed context: paste` — user provided handoff prompt as conversation input; AI uses it as primary seed.
- `Seed context: SESSION_LOG fallback` — no paste detected; AI auto-read the latest `### Next Session Handoff Prompt (Verbatim)` block from `dev/SESSION_LOG.md` per the rule above.
- `Seed context: paste + SESSION_LOG fallback (consistent)` — both present and content matches.
- `Seed context: paste + SESSION_LOG fallback (diverged — used paste)` — both present but content differs; AI uses paste as primary per §2 rule 5; surface the divergence in the first reply for user confirmation.

**Active worktree audit at startup (mandatory):** Immediately after the Seed Context line, print exactly one line stating active worktree count in the form `Active worktrees: <N> (excluding current)`. Resolve N via `git worktree list` row count minus 2 (main repo + current session entry). If N ≥ 2, append ` ⚠️ defer cleanup at closeout` to the line; if N = 0 or 1, the line stands alone. Disk-leftover sub-check: compare `ls .claude/worktrees/` against `git worktree list` and count disk dirs not tracked by git (typically Windows file-lock residue from prior `git worktree remove`); if any exist, append ` · disk-leftover: <M>` to the same line. Purpose: surface worktree accumulation at session start so it does not grow silently across sessions. The §1 line is awareness only — actual cleanup runs at §4 Active Worktree Audit. If the project is not inside a git repository or `.claude/worktrees/` does not exist, print `Active worktrees: N/A (not a worktree-using project)` and skip the disk-leftover sub-check.

Boot Visual Cue - Style A
```text
              ✧
         ─ ─ ☀ ─ ─
              ✦

           ╱╲    ╱╲
          ╱  ╲  ╱  ╲
         ╱    ╲╱    ╲
        ━━━━━━━━━━━━━━

   ✨ a new day · ready to build
```

Boot Visual Cue - Style B
```text
              ⚓
            ╱│╲
           ╱ │ ╲
          ╱  │  ╲
         ╱___│___╲
   ～～～～～～～～～～
   ～～～～～～～～～～

   🧭 course set · steady ahead
```

Boot Visual Cue - Style C
```text
       ✦
                ✧

            ●
            │
       ●────●────●
            │
            ●

       ✧                ✦

   🌌 charted · context loaded
```

---

## 2) Source of Truth Priority
When documents conflict, defer to the §1 read order as priority (first = highest), then other README / docs / comments / tests. Verbal memory and speculation must not be used as a basis for decisions.

Supplementary rules:
1. `SESSION_HANDOFF.md` and `SESSION_LOG.md` represent the "current state"
2. `CODEBASE_CONTEXT.md` represents stable project facts that change only when tech stack, External Services, or Key Decisions change
3. `PROJECT_MASTER_SPEC.md` represents long-term stable rules and the complete authoritative reference
4. If current state is inconsistent with older specification, defer to handoff / log first; remediate specification drift during PERSIST
5. Latest `Next Session Handoff Prompt (Verbatim)` block in SESSION_LOG = operational seed context, but does not override higher-priority current-state facts in SESSION_HANDOFF / latest log
6. When a user instruction conflicts with a rule in this document: (a) state which rule is in conflict; (b) explain risk of overriding; (c) if user confirms override → comply and record override in `SESSION_LOG.md`
7. **External KB in source-of-truth priority** (per §10b): if `dev/EXTERNAL_KB.md` declares Bridge mode for a given scope, the external content for that scope sits at the same priority level as `PROJECT_MASTER_SPEC.md` (rule 3 above); in Mirror mode, the external surface is a view only, and local files remain the source of truth at their declared priority. Conflicts within Bridge-mode scopes are resolved by content timestamp comparison plus user arbitration if needed.

---

## 2b) Issue Triage (Mandatory)
On any bug / error / regression / unexpected behavior: classify source before reading files or making changes. Categories: code logic / configuration / environment-permissions-runtime / external dependency or platform behavior / usage error / documentation drift.

Before classification is complete:
1. No large-scale code changes
2. No arbitrary reverts
3. Do not equate a single error message directly with the root cause

Note: Targeted file reads for the purpose of determining issue source are permitted during triage. This does not substitute for the full §3 READ coverage required before entering CHANGE.

---

## 3) Standard Workflow (Mandatory)
Every task must follow this workflow and clearly label each phase in the response:

1. PLAN
   - Objective, scope, acceptance criteria
   - State explicitly: "My understanding: [1-sentence restatement of user intent]", "Impact scope: [files / modules to modify]", "Assumptions and risks: [list inferences, flag uncertainty, note at least one way the approach could be wrong]"
   - Risk level — HIGH or LOW (any one = HIGH): (a) likely affects ≥3 files; (b) user instruction lacks target files / behavior / end state; (c) involves deletion, rename, or irreversible operations; (d) involves external systems (API calls, deploy, publish); (e) modifies governance rules (AGENTS.md, INIT.md, or similar)
   - HIGH → present PLAN using §3.5 FPFR 5-section output format and wait for user non-veto (per §3.5 closing line) before READ; LOW → proceed to READ with the 3-field statement above
   - §3d trigger met → define test scenario matrix before READ
   - Onboarding readiness check: at PLAN entry, read `dev/PROFILE.md` if exists (for `wizard_disabled_spec` / `wizard_disabled_runbook` / `wizard_disabled_external_kb` flags). If `dev/PROJECT_MASTER_SPEC.md` is missing AND `wizard_disabled_spec` ≠ `true` → offer to draft via `dev/wizards/playbook.md` (using `dev/templates/spec_template.md` for field structure) before this task. If task description shows deploy / publish / release / pipeline / recurring-procedure intent (any language) AND `dev/RUNBOOK.md` is missing AND `wizard_disabled_runbook` ≠ `true` → offer to draft via `dev/wizards/playbook.md` (using `dev/templates/runbook_template.md`). If task description references an external knowledge tool (Notion, Obsidian, Google Drive, Logseq, Roam, Anytype, Apple Notes, Dropbox Paper, or similar) AND `dev/EXTERNAL_KB.md` is missing AND `wizard_disabled_external_kb` ≠ `true` → offer to draft via `dev/wizards/playbook.md` (using `dev/templates/external_kb_template.md`, per §10b external knowledge surface governance). Each wizard prompt offers 3 paths: A run now / B defer (re-offer next session) / C never ask again (sets `wizard_disabled_*: true` in `dev/PROFILE.md`). B persists for the current session only; C persists permanently. Explicit user request (e.g., "build master spec" / "build runbook" / "set up external KB") always runs the wizard regardless of flag. See §3.6 for wizard system details.

2. READ — minimum coverage before entering CHANGE:
   - Read the full context of the section to be modified in the target file
   - Search for other occurrences of the same term / rule / feature across the repo
   - Check whether a single source of truth already exists (SSOT / master spec / runbook / baseline definition)
   - Review the most recent `SESSION_LOG.md` entry related to the topic
   - Do not assume internal repo structure or file contents from memory — files not Read in this session are treated as `UNVERIFIED` per §11a rule 4 until Read; this mirrors §0b's external-API rule, applied to internal context.
   - Before creating a new file, verify no existing file can be modified to serve the same purpose. Three-step check: (a) list related directories; (b) grep same-concept keywords; (c) review recent `SESSION_LOG.md` entries for similar topics. Skip this check only when the new-file FPFR plan (§3.5) explicitly justifies why no existing file fits.

3. CHANGE
   - Minimal necessary modifications, no unrelated refactoring
   - If execution diverges from PLAN (unexpected state, wrong assumptions, scope change needed): stop, report the divergence to the user, and wait for direction rather than attempting self-correction
   - After receiving user direction following a deviation stop: if scope or objective changed, restart from PLAN; if only approach changed, restart from CHANGE with updated context; in either case, state which phase is being re-entered and why
   - **Pre-Edit/Write tree-discipline self-check (mandatory)**: before every `Edit` / `Write` / file-system-mutation tool call, verify the target absolute path matches the working tree declared at PLAN. Resolve current tree via `git rev-parse --show-toplevel` and check the target path prefix against it. If mismatch: stop, report the divergence, and ask user direction — do not auto-redirect, do not silently fall through to whichever tree the tool defaulted to. Inside a git worktree, this catches the recurring "declared worktree target but Edit absolute path defaulted to main repo" pattern that the §11a rule 5 Pre-ship self-check (reply-layer only) does not cover. The check applies equally to all `Edit` / `Write` / `MultiEdit` invocations, not just multi-file batches. Exception: files under skip-worktree convention (`dev/SESSION_HANDOFF.md` / `dev/SESSION_LOG.md` per §1 Worktree fallback) must be edited at the main repo path even from inside a worktree, because the worktree filters them out — for these files the "mismatch" is by design and the check passes when the target is the main repo root.

4. QC
   - Run tests / checks, list results (test/check commands and key outcomes)
   - If a test scenario matrix was defined in PLAN (§3d): verify each scenario and record actual result; summarize overall as PASS / PASS with notes / FAIL
   - If the task involves batch deletion or batch modification, a dry-run (e.g. `ls` / `find` preview, PowerShell `-WhatIf`, etc.) with a "blast radius" list must be provided for confirmation first
   - If QC reveals test failures or build errors: (a) report to user — what was attempted, what failed, and preliminary diagnosis; (b) do not return to CHANGE or retry without user direction; (c) provide failure summary, likely root cause, and proposed fix approach

5. PERSIST
   - Update `dev/SESSION_HANDOFF.md` and `dev/SESSION_LOG.md`
   - Apply the same cross-document sync conditions as §4 closeout: if tech stack, directory structure, build commands, external services, or Key Decisions changed in this task — update `dev/CODEBASE_CONTEXT.md` now, not at closeout
   - If `dev/PROJECT_MASTER_SPEC.md` exists and carries status for the completed work — update it in the same pass
   - **External KB sync during PERSIST (conditional)**: if `dev/EXTERNAL_KB.md` exists and the current task's local changes fall within a recorded external KB scope (per §10b), sync those changes to the external surface. Direct-access AI executes the sync subject to §10b Cloud-side destructive op safety; paste-only access surfaces the changed content as a ready-to-paste block for the user. Record sync result (synced / pending user paste / skipped per scope rule) in current SESSION_LOG entry. In Mirror mode, this step only logs a reminder; in Bridge mode, sync is mandatory before PERSIST completes.
   - **User-facing artefact audit (conditional, on user-facing governance change)**: if the project has user-facing artefacts (landing page, marketing site, README user guide sections, public docs site) AND the current task affects user-visible behavior (e.g. new feature, changed user-visible flow, new wizard variant, new external integration, new reply discipline), audit those artefacts for content alignment with the governance change. Common surfaces to check (illustrative, not exhaustive — concrete list adapts per project's actual user-facing artefact structure): feature / capability lists, use-case scenarios, FAQs, quick start sections, safeguard lists, pain-point sections, comparison sections. Audit result (updated / no change needed / deferred with reason) recorded in current SESSION_LOG entry. Skip this step if the project has no user-facing artefacts beyond READMEs — README sync is already covered by the existing `Governance rule change (AGENTS.md)` DOC_SYNC row.
   - **DOC_SYNC Matrix Scan (mandatory visible output):** Before completing PERSIST, output a `### DOC_SYNC Matrix Scan` block: No file changes this task → `### DOC_SYNC Matrix Scan — SKIP (no file changes this task)`. Registry exists → list matched rows `Change Category | Required Doc Updates | Status` (`✓ Done` / `N/A` / `⚠ Skipped (reason)`); update all required docs; no matching row → add it first (`✓ Row added`). Registry absent → `### DOC_SYNC Matrix Scan — SKIP (registry not present)`. Absence of this block in the response = scan was skipped; user may immediately request the agent to complete it.

---

## 3.5) Full-Picture-First Output Format (FPFR — Mandatory when triggered)
**Intent:** governance-level or multi-file plans must let the user see the end state, deliverables, measurable metrics, acceptance test, and goal link in one glance — before execution starts. FPFR is the output format §3 PLAN uses when HIGH risk fires; it does not replace PLAN's content fields, only structures the presentation.

**Trigger** (any one):
(a) Modifies ≥2 files
(b) Creates a new file
(c) Modifies governance rules / SOPs / skill files / long-term specifications
(d) Proposes a ≥2-phase plan

**When triggered, the reply must contain these 5 sections at the very top, in this exact order, with these exact headings:**

### 1. END-STATE SNAPSHOT
Table: each affected file | before state (line count / exists or not) | after state.

### 2. DELIVERABLES
Per-file path + action (create / edit / delete) + one-sentence summary.

### 3. METRICS
≥3 measurable before→after numbers. Items with no measurable form: write `N/A — <specific reason>`.

### 4. ACCEPTANCE TEST
One specific check (command / file content search / basic functional test) that determines success.

### 5. GOAL LINK
One sentence linking to the authoritative source (cite specific location, e.g., `filename:§ section` or user-message timestamp).

**Closing line — exactly this verbatim, after the 5 sections:**
> 以上即執行計劃。若不否決 (veto) 或修改,即開始執行。

**Not triggered by:**
- Single-file single-edit
- Pure information lookup / fact research / Q&A
- Executing the next step of an already-approved plan
- User explicitly states no full picture needed / requests direct execution

**When triggered, prohibited:**
- "Approve A? Approve B? Approve C?" item-by-item approval prompts
- Vague substitutes for the 5 sections ("end-state picture" / "full picture" / "overall view") without the actual structured sections
- Skipping the 5 sections and jumping to a plan or approval request
- Adding a "do you agree?" closing question after the 5 sections — the closing line replaces this

---

## 3.6) Onboarding Wizard System (Mandatory when applicable)
**Purpose:** Help users author non-trivial governance docs (`PROJECT_MASTER_SPEC.md` / `RUNBOOK.md` / future) via AI-led draft+iterate flow instead of blank-template fill-in or cold-question form-fill. Paradigm: user describes the project briefly (and optionally points to reference signals — local files / URLs / known decisions / constraints) → AI actively reads any provided sources before drafting → AI generates a one-shot full draft + numbered assumption list (each item labeled by source: derived from user input vs AI inference) → user spot-checks and corrects → AI iterates → AI proposes write.

**Behavior + content separation:**
- `dev/wizards/playbook.md` — behavior layer (when to engage / draft+iterate loop / assumption rules / close-out signals / vague-input escape hatch).
- `dev/templates/<name>_template.md` — content layer per output doc (`spec_template.md` for `PROJECT_MASTER_SPEC.md`; `runbook_template.md` for `RUNBOOK.md`). Standalone-fillable without AI.

**Detection triggers (mandatory at §3 PLAN):** see §3 PLAN onboarding readiness check. Decline persists via `dev/PROFILE.md` `wizard_disabled_*` flags (see schema below); explicit user request always runs regardless of flag.

**Vague-input fallback (mandatory):** when user seed is too sparse to draft, AI uses §11a rule 2 choice format with a mandatory escape hatch — every choice prompt at this paradigm step must let the user either pick an option or share more context (e.g. "pick A/B/C, or share a bit more context"). The escape hatch is rendered in the user's chat language, not hardcoded English. Without it, the prompt regresses to a small forced-choice form-fill.

**Assumption list discipline:** AI surfaces all key assumptions as a numbered short-bullet list (typical 5–12 items, terse), each item labeled by source — `[from your input]` (derived from user-provided files / URLs / sentences) or `[my inference]` (AI estimated, lower confidence). Cover both high- and low-confidence; do not filter to low-confidence only. User targets by index or natural language.

**Source-grounding discipline:** When the user points to a reference signal (local file path, URL, keyword / project name to look up), AI must actively read or fetch it before drafting — read local files via Read tool, fetch URLs via WebFetch, grep keywords across the project — instead of paraphrasing the user's mention or imagining content. Silent fabrication of references / third-party product names / competitor details is prohibited; if AI lacks ground truth for a field, mark the assumption as `[my inference]` and offer to fetch / verify.

**Close-out signal:** AI watches for two consecutive turns with no modifications, or closure language ("OK", "ready", "good", "done", or equivalent in the user's language), then proposes write. User confirms or defers.

**Profile awareness:** Wizards may use `dev/PROFILE.md` (set at INIT.md install) to tune draft assumptions. Profile influence is suggestion-only — user override always wins. Supported profile values: `general` / `research` / `coding` / `writing` / `agent-design` / `data-analysis`.

**`dev/PROFILE.md` schema:** Carries fields: `profile` (one of the 6 supported values), `language` (auto-detected user language preference, used as wizard render fallback when current chat language is unclear; defaults to `en`), `created` (UTC date), and optional `wizard_disabled_spec` / `wizard_disabled_runbook` / `wizard_disabled_external_kb` (each defaults to `false`). The disabled flags are set to `true` by wizard prompt's C-path ("never ask again") to permanently suppress §3 PLAN auto-prompts; explicit user-requested wizard runs ("build master spec" / "build runbook" / "set up external KB") always proceed regardless of flag. Wizard render-language precedence: latest user chat language → `dev/PROFILE.md` `language` field → `en` default.

**External KB wizard variant (per §10b):** an `external KB wizard variant` exists in `dev/wizards/playbook.md` for authoring `dev/EXTERNAL_KB.md`. Trigger: §3 PLAN detects external knowledge tool reference (Notion / Obsidian / Google Drive / Logseq / Roam / Anytype / Apple Notes / Dropbox Paper / similar) AND pointer file missing AND `wizard_disabled_external_kb` ≠ `true`. Main question: tool type + entry URL + access mode (mirror / bridge / mixed). Supplements: AI access variant (MCP / API direct / paste-only), in-scope collections / vaults / folders, sync expectation (every PERSIST / per session / weekly batch / manual), optional notes. Output path fixed at `dev/EXTERNAL_KB.md`. See `docs/EXTERNAL_KB_COOKBOOK.md` for tool-specific reference patterns.

**Output discipline:** Wizard output files must include a `Created: <date> (via guided wizard, AI-assisted)` line in their header so future sessions know the file's provenance. Output paths are fixed per template (`dev/PROJECT_MASTER_SPEC.md` / `dev/RUNBOOK.md`); no user override during wizard run.

---

## 3b) Consolidation / Integration Discipline (Mandatory)
Minimal modification ≠ stack-only. Before adding any new rule, explanation, exception, baseline, or runbook content, prefer in this order: modify existing definition / merge duplicates / retire outdated wording / converge to single source of truth / keep only a reference in other locations.

Hard rule: same rule, threshold, enumeration, or operational standard = one-rule-one-place. If new content supersedes old, retire old simultaneously; two competing standards must not coexist long-term.

Trigger a Consolidation Pass before CHANGE if any apply:
1. The same rule already appears in ≥2 files
2. The same issue has been patched >2 times
3. A new rule overlaps, duplicates, or creates exceptions against an old rule
4. README / handoff / spec / tests show inconsistent wording
5. Continuing to stack would increase comprehension or maintenance cost

A Consolidation Pass: identify primary location → merge duplicates → retire outdated wording → record rationale in `SESSION_LOG.md`.

**Hard rule (anti-hardcoding):** Examples used in governance text must be generic — do not hardcode or bind to specific filenames, company names, dates, page numbers, URLs, person names, or single-task scenarios. Specific instances belong in `SESSION_LOG.md` history; rules belong in this document. Centralize numbers that vary by environment / platform / version (limits, quotas, safety ranges) into a named Preset block; cite the Preset name or key in prose, do not scatter raw numbers through the text.

**File proliferation discipline (mandatory):** The §3.5 FPFR new-file trigger and the §3 READ Pre-action three-step check above apply jointly before any new file is created — neither alone is sufficient. Named anti-pattern — *Throwaway / orphan file*: a single-session workaround file kept in the repo with no recorded purpose; the next session treats it as unknown context; repeated occurrences accumulate as repo bloat. Forbidden in committed work: scratch / temporary / `_old` / `_tmp` / dated-session-suffix file names. Any file kept in the repo must have a stable purpose recorded in `dev/CODEBASE_CONTEXT.md` Directory Map or referenced in a `dev/SESSION_LOG.md` entry. §4 closeout enforces this via the stray-file scan.

---

## 3c) Release / Merge Gate (Mandatory when applicable)
Whenever a task involves a merge, release, deploy, publish, GA, or hotfix completion claim, all phases below must be completed; no step may be skipped. Failure in any phase blocks completion claim until resolved.

**Phase 1 — Pre-release Verification:**

1. Independent Review Pass
   - Conduct an independent review (may be performed by a second agent, a review mode, or a structured self-check checklist)
   - Must cover: correctness, consistency, regression risk, documentation sync (verify all `dev/DOC_SYNC_CHECKLIST.md` entries affected by this release's changes are updated), toolchain compatibility

2. Machine Verification
   - Run the project's applicable build / type-check / lint / tests / regression / consistency checks
   - If the project has multiple harness layers (e.g. main + legacy / extended quarantine), all layers must execute; bypass flags (e.g. `LEGACY_SKIP`) are forbidden during release verification
   - Doc-sync verification: query `dev/DOC_SYNC_CHECKLIST.md` for the `Release published` row and confirm every listed file has been updated to reflect the new version (README variants, release notes, QA reports, public site / introduction pages, etc.); regression checks for these files must PASS
   - Canonical execution locus: harness must run from the main repo path (resolve via `git rev-parse --git-common-dir` parent dir, or `git worktree list` first entry). Worktree-path execution triggers spurious harness failures (`H01` `.legacy_last_run` cross-tree drift, `R27-10` skip-worktree files absent in worktree) that are by-design per skip-worktree convention — not real failures. AI must explicitly cd to main repo path before invoking the harness during release verification.

3. Evidence Check
   - To claim ready / merged / released / GA, corresponding verification evidence must exist

4. Failure Rule
   - If any critical check fails, do not claim ready / release / GA

**Phase 2 — Release Execution:**

5. Publish: annotated tag (`git tag -a <tag> -m "..."`) + GitHub release notes; `isPrerelease` flag correctly set (RC = true, GA = false); `--latest` explicit on GA promotion. Verify `origin/main` HEAD = local HEAD; verify tag pushed via `git ls-remote --tags origin <tag>`.

**Phase 3 — Post-Release Cleanup:**

6. Merge-source branch cleanup: if release shipped via PR, delete merge-source branch from both local and remote (`git branch -d <branch>` + `git push origin --delete <branch>`). PRs are preserved permanently on GitHub as history; do not delete. Verify `git branch -a` shows only `main` plus any protected branches.

7. Fresh-environment validation (recommended for major releases): exercise the release artifact in a clean environment that simulates real user or production conditions — e.g. fresh sandbox install for repos shipping installers/templates; staging deploy for services; canary release for libraries. Run release-specific QC; confirm fixes are actually effective vs merely theoretical (if hotfix is in scope).

**Phase 4 — Observability:**

8. Track production fail modes: append Open Priority entry "Observe N sessions for unexpected fail modes" covering newly-deployed mechanisms (legacy chain, staleness checks, regression series, etc.). For RC → GA promotion, set explicit observation period before promotion (e.g. 1–2 weeks of real production sessions, not calendar time alone).

---

## 3d) Test Plan Design (Mandatory when applicable)

**Trigger conditions:** apply §3d when task involves new user-facing features / commands / behaviors; changes to existing behavior (incl. governance rule changes); external API / service integrations; multi-step user flows (install, onboarding, upgrade paths). Not required for session log updates, whitespace / formatting only, or comment-only changes.

**Scenario categories:** identify ≥1 scenario per relevant category — Normal flow (happy path); Boundary / edge (limits, empty inputs, first-run vs. repeat-run); Error / failure path; Regression (existing behavior must remain unchanged). Adapt to project type: code (unit / integration / E2E); governance / documentation (rule presence, parity, grep-verifiable assertions); prompt engineering (output format, behavioral assertions).

**Scenario format (fill Actual column at QC phase):**

| Scenario | Precondition | Action / input | Expected | Actual | Result |
|---|---|---|---|---|---|
| [name] | [starting state] | [what happens] | [expected outcome] | [fill at QC] | PASS/FAIL |

Result values: PASS, PASS with notes (minor gaps but does not block), or FAIL.

**Recording location:** ≤5 scenarios → inline in current SESSION_LOG entry under `### Test Scenarios`; >5 or spanning multiple sessions → reference in SESSION_HANDOFF `Regression / Verification Notes` + full matrix in SESSION_LOG. At QC phase: fill Actual column; summarize overall result in SESSION_LOG.

---

## 4) Session Close Rules (Mandatory)
On end-of-session intent — **detect by intent, not strict keyword match** — in any natural language. Illustrative examples (not exhaustive): English ("wrap up", "handover", "close session", "that's it for today", "let's wrap", "done for today", "let's close out"); Chinese (「收工」, 「收尾」, 「打烊」, 「結束今日」, 「埋單」, 「交班」, 「下班」, 「收場」); Japanese (「終了」, 「終わり」, 「お疲れ様」, 「セッション終わり」); or similar end-of-session intent in any other language. Perform closeout automatically without item-by-item confirmation. If ambiguous (task vs session end), confirm session-end intent first.

At closeout, update minimum: `dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`. If session changed tech stack / directory / build commands / external services / Key Decisions, also update `dev/CODEBASE_CONTEXT.md` (append `AI Maintenance Log` entry with session ID + summary).

Each closeout records at minimum: Date (UTC); Session ID; Completed items; Pending items; Next priorities (max 3 — SESSION_LOG summary field only; full prioritized list in `dev/SESSION_HANDOFF.md` Open Priorities); Risks / blockers.

**Session work-pool boundary (mandatory):** SESSION_LOG entry's `Completed` / `Changed` / `Done` / `Files this session edited` fields must reflect only work *actually performed in THIS conversation* — files edited, decisions made, tests run, patches applied in this turn-by-turn session. Do not copy-paste last session's record from the handoff prompt; do not list as `Done` items that were already shipped before this session started. Cross-session continued tasks: record only the increment performed this session (e.g., `continued from prior session: <delta>`), not the cumulative completion. Open Priorities are regenerated per the mandatory rule below, re-derived from current project state (handoff seed + this session's deltas + recent SESSION_LOG entries), not copy-pasted from the handoff prompt. Startup-side enforcement: see §1 `Work-pool boundary`.

**Session log entry format:** Use lean key-value style (see `dev/SESSION_LOG.md` template). Target ~20-30 lines for routine entries; **hard cap ≤110 lines per entry** (counted between consecutive `^## YYYY-MM-DD` headers, includes verbatim Handoff Prompt block). Release-class or multi-phase sessions exceeding cap → relocate detail to `dev/SESSION_STATE_DETAIL.md` (general overflow) or `docs/releases/<version>.md` (release-class detail); leave a 1-line reference in entry pointing to the relocated section. Omit conditional sections (Fix Record, Consolidation) when they have no content — do not write empty blocks. Do not record "Files read" — it has no value for future sessions.

**Session handoff compactness budget** (mandatory at every closeout):
1. `Current Baseline`: keep to concise state facts only; cap at 6 numbered lines
2. `Open Priorities`: max 5 items, one line per item
3. `Known Risks / Blockers`: unresolved active risks only; max 7 items
4. `Last Session Record`: compact summary only; keep detailed evidence in `dev/SESSION_LOG.md`
5. If content would exceed these limits: move detail to `dev/SESSION_LOG.md` (current entry) or `dev/SESSION_STATE_DETAIL.md` and leave a short reference in handoff
6. No-loss rule: compaction must not discard information; detail is relocated, not deleted

**Next Session Handoff Prompt budget** (mandatory at every closeout): Section 2 fenced `text` block ≤24 lines (lines inside fence only); keep two required opening lines verbatim + required fields from §4 rule 5 in compact form; `Key files changed`: max 6 bullets (overflow → one bullet `- Additional files: see SESSION_LOG Changed`); `Known risks / blockers / cautions`: max 5 bullets; overflow → relocate to current `dev/SESSION_LOG.md` entry with short reference in prompt block.

**Open Priorities regeneration** (mandatory at every closeout): regenerate `dev/SESSION_HANDOFF.md` Open Priorities — not copy-pasted forward. Remove items completed this session; scan recent `dev/SESSION_LOG.md` entries for new pending items; re-rank and overwrite previous list (replace, not append). Hard rule: do not copy-paste old priorities without re-checking current project state.

**Closeout stray-file scan** (mandatory at every closeout): Before evaluating the smart-skip gate below, scan `dev/` and the repo root for files not listed in `dev/CODEBASE_CONTEXT.md` Directory Map and not matched by `.gitignore`. Skip-worktree files (`dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`) are exempt by design. For each stray finding, choose one disposition: (a) integrate into the Directory Map and record provenance in the current `dev/SESSION_LOG.md` entry; (b) prompt user to confirm deletion before this session ends; (c) record explicit rationale in `dev/SESSION_LOG.md` for keeping it without map integration (e.g. work-in-progress carry-over). Stray findings count as "files modified" for the smart-skip gate condition below.

**External KB sync check at closeout** (mandatory when `dev/EXTERNAL_KB.md` exists, per §10b): Before the smart-skip gate, verify that all this-session local changes within recorded external KB scopes have been synced to the external surface (per §3 PERSIST's external KB sync rule). For each un-synced item, choose one disposition: (a) direct-access AI executes the sync now subject to §10b Cloud-side destructive op safety; (b) paste-only access surfaces a ready-to-paste block to the user and waits for confirmation; (c) record explicit rationale (e.g. scope rule defers sync to weekly batch) in current SESSION_LOG entry. Closeout cannot complete with Bridge-mode scopes left un-synced unless the user explicitly defers.

**Closeout smart-skip gate** (mandatory at every closeout):
1. Before drafting closeout output, evaluate whether this session has meaningful deltas
2. Use `No-Change Closeout` only if all are true:
   - No files were created/modified/deleted in this session
   - No new or updated decision/requirement/risk/blocker/pending item was introduced
   - No DOC_SYNC row was triggered
3. `No-Change Closeout` still requires:
   - Run §4a check command
   - Update `dev/SESSION_HANDOFF.md` and `dev/SESSION_LOG.md` with a concise no-change entry
   - Generate and persist `Next Session Handoff Prompt (Verbatim)`
   - Output `### DOC_SYNC Matrix Scan — SKIP (no file edits in this session)`
4. If any condition above is false: run the full closeout flow

**Closeout stray-file disposition (mandatory visible output):** Output a `### Stray-file Disposition` block in the closeout response listing every stray surfaced by the §4 closeout stray-file scan and its disposition. Zero strays → `### Stray-file Disposition — N/A (0 strays detected)`. Format:
```
### Stray-file Disposition
| Stray path | Disposition | Rationale |
|---|---|---|
| <path> | (a) integrate / (b) delete / (c) keep with rationale | <reason> |
```
**Open Priority recording does NOT count as stray disposition** — each stray must receive exactly one of (a)/(b)/(c) within this closeout; deferring to next session via Open Priorities is not a valid disposition. Named anti-pattern: *Stray-as-Open-Priority* — disguising disposition deferral as future-priority tracking. Absence of this block in the closeout response = stray-file scan was skipped; user may immediately request the agent to complete it.

**Closeout compactness budget check (mandatory visible output):** Output a `### Compactness Budget Check` block verifying the `dev/SESSION_HANDOFF.md` budget caps defined above. Format:
```
### Compactness Budget Check
- Current Baseline: <X>/6 lines — ✓ within / ⚠ over
- Open Priorities: <X>/5 items — ✓ within / ⚠ over
- Known Risks: <X>/7 items — ✓ within / ⚠ over
- Remediation (if any ⚠): <action taken this closeout>
```
Absence of this block in the closeout response = budget check was skipped; user may immediately request the agent to complete it.

**Same-session rule self-audit (mandatory):** If this session added or modified any closeout-relevant mandatory rule (§4 stray-file scan / §4 compactness budget / §4 closeout output skeleton / §4a archive trigger / §3 PERSIST DOC_SYNC Matrix Scan), the closeout response must output a `### Same-Session Rule Audit` block demonstrating the new rule was followed in this same closeout. Format:
```
### Same-Session Rule Audit
- <rule landed this session>: ✓ applied in this closeout via <evidence>
```
When no closeout-relevant rule landed this session: `### Same-Session Rule Audit — N/A (no closeout-relevant rule changed this session)`. Named anti-pattern: *Author-then-Violate* — authoring a closeout-relevant rule and silently failing to apply it in the same session's closeout (per §8b rule 1 + rule 6 promoted to permanent governance). Absence of this block in the closeout response = same-session rule audit was skipped; user may immediately request the agent to complete it.

**Active Worktree Audit at closeout (mandatory visible output):** Before the smart-skip gate evaluation, scan active worktrees via `git worktree list` and disk dirs via `ls .claude/worktrees/`. For each non-current worktree, determine merge status via `git log <branch> --not main --oneline` (empty result = fully merged into main; non-empty = unmerged commits exist) and pick exactly one disposition: (a) remove now — execute `git worktree remove <path> --force` + `git branch -D <branch>` from main repo path; (b) keep with rationale — record reason in current SESSION_LOG entry; (c) unmerged commits — surface the commits list to the user and ask before proceeding. Output a `### Active Worktree Audit` block in the closeout response. Disk-leftover sub-section: list disk dirs in `.claude/worktrees/` not matched by `git worktree list`, attempt `rm -rf` for each, record outcome (cleaned / locked — retry next session). Self-removing the current session's own worktree is not possible while cwd resides inside it; record the cleanup command in the closeout response for the next session to execute from main repo path. Format:
```
### Active Worktree Audit
| Worktree | Branch | Merge status | Disposition |
|---|---|---|---|
| <path> | <branch> | fully merged / <N> unmerged commits | (a) removed / (b) kept — <reason> / (c) unmerged — awaiting user |

Disk leftover (dirs in `.claude/worktrees/` not in `git worktree list`):
- <dir> — cleaned / locked — retry next session
```
Zero non-current worktrees + zero disk leftover → `### Active Worktree Audit — N/A (only current session worktree present)`. **Open Priority recording does NOT count as worktree disposition** — each non-current worktree must receive exactly one of (a)/(b)/(c) within this closeout; deferring to next session via Open Priorities is not a valid disposition (mirrors *Stray-as-Open-Priority* anti-pattern). Named anti-pattern: *Worktree-Backlog-Accumulation* — letting closed-work worktrees and branches accumulate session after session without disposition, masking single-session cleanup failures as "future cleanup task". Absence of this block in the closeout response = active worktree audit was skipped; user may immediately request the agent to complete it.

Supplementary rules:
1. Update session record even if no code changes (research / analysis / discussion / decisions count). After closeout, response lists files updated + what changed; includes copy-paste-ready "Next Session Handoff Prompt" generated from actual project state (no hardcoded sentences).
2. The "Next Session Handoff Prompt" must include at minimum:
   - Opening line: use this verbatim template — do not paraphrase or omit any file — paste as two consecutive lines to ensure cross-tool handoffs work even when the receiving tool does not auto-load `AGENTS.md`:
     `Read AGENTS.md first (governance SSOT), then follow its §1 startup sequence:`
     `dev/SESSION_HANDOFF.md → dev/SESSION_LOG.md → dev/CODEBASE_CONTEXT.md (if exists) → dev/PROJECT_MASTER_SPEC.md (if exists)`
   - Current objective and progress state
   - Pending tasks in priority order
   - Key files changed in this session
   - Known risks / blockers / cautions
   - Validation status + `Post-startup first action:` (executed only after §1 startup complete, not before)
3. Closeout response = exactly 3 sections in order: Section 1 `SESSION CLOSEOUT SUMMARY`; Section 2 `NEXT SESSION OPENING MESSAGE` as a **triple-backtick markdown code block with `text` language tag** — opened with three backticks followed by `text` on its own line (i.e. ```` ```text ````) and closed with three backticks on its own line — so the entire block is selectable and copy-pasteable as a single unit into the next AI session as its first message. Do not use prose text wrapped in quotes, dash separators, or any other non-code-fence formatting. Section 3 `CLOSEOUT VISUAL CUE` (one random style from set below). The Section 2 heading was renamed from `NEXT SESSION HANDOFF PROMPT (COPY/PASTE)` (v3.0.3 and earlier) to `NEXT SESSION OPENING MESSAGE` (v3.0.4+) to make the use-site explicit.
4. Randomization rule: within a single session, the Closeout Visual Cue must differ from the Boot Visual Cue displayed earlier in the same session. Across sessions, randomize uniformly — previous session's style is not tracked.
5. Use separator lines between sections:
    - Major separator: `========================================`
    - Minor separator: `----------------------------------------`
6. Closeout output skeleton must follow this layout:
```text
========================================
SESSION CLOSEOUT SUMMARY
========================================
<summary bullets>

----------------------------------------
NEXT SESSION OPENING MESSAGE
(paste as your next session's first message)
----------------------------------------
<triple-backtick markdown code block with text language tag, copy-pasteable>

----------------------------------------
CLOSEOUT VISUAL CUE
----------------------------------------
<one random style from A/B/C>
```
7. After generating Section 2, write the exact same fenced `text` block verbatim into current `dev/SESSION_LOG.md` entry under `### Next Session Handoff Prompt (Verbatim)` — replace if already exists (no duplicates, no paraphrase, no truncation, no reformatting).

Closeout Visual Cue - Style A
```text
              ☀
         ─ ─ ─ ─ ─

       ━━━━━━━━━━━━━
    ～～～～～～～～～～
    ～～～～～～～～～～

   🌅 shipped · golden hour
```

Closeout Visual Cue - Style B
```text
       ✦        ✧
                  🌙

       ✧
            ✦
       ✦              ✧
            ✧

   🌙 logged off · sweet dreams
```

Closeout Visual Cue - Style C
```text
                ⚑
                │
                │
                │
       ━━━━━━━━┷━━━━━━━━
        ╱              ╲

   🏁 shipped · onward
```

---

## 4a) Session Log Maintenance (Conditional — auto-triggered at closeout)

Before writing the new session entry to `dev/SESSION_LOG.md` during closeout, evaluate triggers.

**Trigger (either):** `dev/SESSION_LOG.md` exceeds 400 lines; OR oldest session entry is dated more than 30 days ago. If neither: proceed normally.

**Mechanism enforcement (mandatory):** At closeout, evaluate triggers directly from `dev/SESSION_LOG.md` — Line trigger: total lines > 400; Date trigger: oldest `## YYYY-MM-DD` heading older than 30 days. If either is true → execute archive before writing closeout entry; if both false → skip archive. User-facing closeout must not require Python or any non-default runtime. Do not rely on memory or user reminder; explicit trigger evaluation is the execution gate. If evaluation fails due to environment / tooling limits: continue closeout and record `§4a maintenance skipped: <reason>` in current SESSION_LOG entry.

**If triggered, perform archiving before writing the new entry:**
1. Create `dev/archive/` if it does not exist
2. Identify entries to archive: Line-count trigger → archive oldest until `dev/SESSION_LOG.md` ≤ 200 lines (always retain 2 most recent regardless of size); Date trigger → archive all entries older than 30 days (always retain 2 most recent regardless of date)
3. Archive filename by year and quarter: `dev/archive/SESSION_LOG_YYYY_QN.md` (e.g., `SESSION_LOG_2026_Q1.md` for Jan–Mar 2026); span multiple quarters → one file per quarter; existing target file → append (do not overwrite)
4. Move identified entries to archive file(s)
5. Add / update archive pointer comment immediately after file header in `dev/SESSION_LOG.md`: `<!-- Archives: dev/archive/ — entries moved when >400 lines or oldest entry >30 days -->`
6. Proceed with writing the new session entry to the now-trimmed `dev/SESSION_LOG.md`

**First-run auto-transition:** If `dev/SESSION_LOG.md` has no archive pointer and either trigger applies, apply the same steps. Existing large files are trimmed automatically on the first closeout after upgrading — no manual migration needed.

**Hard rules:** Never delete session entries — archive only. `dev/archive/` files are not part of §1 mandatory read list; do not read at startup unless user explicitly requests historical lookup. The most recent session entry's `### Next Session Handoff Prompt (Verbatim)` block must remain in `dev/SESSION_LOG.md`.

---

## 0b) External Platform Alignment (Mandatory when applicable)
Scope: §0b applies when the AI writes, executes, or debugs code / commands that interact with external systems at runtime. Editing documentation, governance rules, or templates that reference external services without making actual calls does not trigger §0b — External API Code Safety preconditions (including CODEBASE_CONTEXT.md generation) do not apply in such cases.

When a task involves external platforms, frameworks, APIs, CLIs, deployment systems, cloud services, third-party SDKs, package managers, or official toolchains: do not guess commands, parameters, limitations, version differences, or platform behavior from memory. Before related work, align against: official documentation; release notes / changelog; official repo / original specifications; relevant SSOT / runbook / integration docs in this project. If alignment is not completed: do not treat guesses as conclusions; do not output high-risk commands; label what is verified vs pending.

Same alignment principle applies to local CLI tools, installed SDKs, package-manager invocations, and project-level skills: prefer documented sources (project SSOT > skill description / runbook > `--help` / `--version` self-check > official docs) over training-memory syntax. When uncertainty remains about a flag, parameter, or skill behavior, flag it as `UNVERIFIED` per §11a rule 4 before invoking — do not silently fall back to training-memory guesses.

### External API Code Safety (Mandatory when writing API-calling code)

Before writing any code that calls an external API endpoint:
0. If `dev/CODEBASE_CONTEXT.md` does not yet exist, generate it first per §1 — External Services section is required to record API facts
1. Fetch current official documentation for the specific endpoint
2. Record in `dev/CODEBASE_CONTEXT.md` External Services before writing code: Base URL + endpoint path (do not assume from memory); Current API version; Auth method + header format; Required params; Forbidden / deprecated params; Response schema + exact parsing path for needed data; Official docs URL; `Doc-reviewed: <date> (<session ID>)`
3. If official documentation cannot be fetched: Do not write API-calling code; state what is blocked and why; ask user for documentation
4. Training-data knowledge must never be the sole source for endpoint paths, parameter names, or response structure — treat prior knowledge as "possibly outdated — verify first"

External Services block format in `dev/CODEBASE_CONTEXT.md` (one block per API):
```
### [API Name]
- Base URL:
- Version:
- Auth:
- Required params:
- Forbidden params:
- Response path:
- Official docs:
- Doc-reviewed:  (date + session ID — documentation read and fields recorded)
- Test-verified: (date + session ID — API call made and response confirmed correct)
- Notes:
```

When reading an existing External Services block before writing code: `Test-verified` present → reliable (re-verify the specific endpoint + params if from prior session); `Doc-reviewed` only → use with caution and annotate generated code with `awaiting test-verification` comment at top of each calling function / method; both empty or missing → full verification ritual required first. After any re-verification: update date + session ID. If re-verification reveals API changes: update affected fields, record before/after in Notes, flag affected code for review.

---

## 5) File Safety Governance (Strict)
The AI is prohibited from executing high-risk destructive operations, including but not limited to:

1. `rm -rf` / `Remove-Item -Recurse -Force` (without explicit approval)
2. `git reset --hard`
3. `git clean -fdx`
4. Batch overwriting unknown files
5. Overwriting or deleting files unrelated to the current task
6. Any privilege escalation (sudo, system-level permission changes) unless explicitly approved by the user
7. Strictly prohibited from invoking external shells (e.g. `cmd /c`, `sh -c`, `bash -c`, `powershell -Command`) to perform file system modification operations (create, delete, overwrite, move, rename); must use the current environment's native commands with direct arguments
8. When handling file paths, strictly prohibited from using raw string interpolation to construct paths; must use native path handling APIs / objects (e.g. `Join-Path`, `path.join`, `Path.Combine`, etc.)
9. Default to preserving original user-supplied files (images, documents, data) — output renamed copies rather than overwriting in-place. Do not silently mutate source artifacts. Exception: explicit user instruction to overwrite the original.
10. **Worktree-aware Edit/Write absolute path discipline**: when the current session executes inside a git worktree (detect via `git rev-parse --git-common-dir` returning a path different from `.git`, or current pwd matching `.claude/worktrees/`), all `Edit` / `Write` / file-system-mutation tool calls must use absolute paths that begin with the current working tree root — not the main repo root. Exception: files under skip-worktree convention (`dev/SESSION_HANDOFF.md` / `dev/SESSION_LOG.md` per §1 Worktree fallback) must be edited at the main repo path because the worktree filters them out. Plan-time declaration of working-tree target without execution-time path alignment is a known recurring failure pattern (cross-tree path violation); the §11a rule 5 Pre-ship self-check is reply-layer only and does not cover tool path layer. The §3 CHANGE Pre-Edit/Write tree-discipline self-check is the enforcement step for this rule.

## 5a) Root Scope Guard for Bootstrap / Multi-File Setup (Mandatory)
Before any bootstrap / setup task creating or modifying multiple governance files (e.g. executing `INIT.md`), complete this preflight; do not write any file before explicit user confirmation:

1. Detect and print paths in this order: `pwd` absolute; `git root` absolute (or `none`)
2. If `pwd` and `git root` both exist and differ: hard stop before any write; print exactly two options (1) Use `pwd` (2) Use `git root`; require explicit user choice; AI must not auto-select in mismatch case
3. After root is chosen, print chosen `<PROJECT_ROOT>` as absolute path
4. Run and print root risk checks: shared workspace / runtime / tool-internal directory? parent / sibling directories contain governance files suggesting scope too high? target appears to be framework / tool runtime repo instead of user's intended project?
5. Print dry-run install plan. Begin with an `Install mode:` line — `first-install` (no governance files detected), `upgrade` (at least `AGENTS.md` and `dev/SESSION_HANDOFF.md` both present), `partial` (some governance files present but not all — surfaces incomplete prior install). Follow with per-file action: `create` (newly created files); `merge` (merged / prepended); `skip` (left unchanged). The Install mode line is informational only — it does not change install behavior (per-file rules still apply per their own definitions), but gives the user visibility before the `INSTALL_ROOT_OK` confirmation gate.
6. Require exact confirmation reply: `INSTALL_ROOT_OK: <absolute_path>`
7. If the confirmation path does not exactly match the proposed absolute path, abort setup (no writes)
8. After step 6 passes, require second confirmation reply before first write: `INSTALL_WRITE_OK`
9. After `INSTALL_WRITE_OK` and before first write, create a lightweight backup snapshot: directory `<PROJECT_ROOT>/dev/init_backup/<YYYYMMDD_HHMMSS_UTC>/`; copy only existing target files (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`, `dev/CODEBASE_CONTEXT.md`, `dev/DOC_SYNC_CHECKLIST.md`, `dev/SESSION_STATE_DETAIL.md`, `dev/PROJECT_MASTER_SPEC.md`, `dev/PROFILE.md`, `dev/RUNBOOK.md`, `dev/EXTERNAL_KB.md`, `dev/wizards/playbook.md`, `dev/wizards/README.md`, `dev/templates/spec_template.md`, `dev/templates/runbook_template.md`, `dev/templates/external_kb_template.md`, `docs/EXTERNAL_KB_COOKBOOK.md`, if present); preserve relative paths under `<PROJECT_ROOT>`; native filesystem copy (cross-platform), no git required
10. If high-risk markers are detected, default action is abort and ask user to specify a safer subdirectory explicitly

---

## 6) No Escalation Deletion Policy
On "file is locked / insufficient permissions / cannot delete / cannot overwrite": do not escalate privileges; do not use high-risk commands to bypass; do not use OS low-level APIs, COM objects, WMI, AppleScript, unconventional syscall wrappers, or other opaque means to force-remove files; output a "manual action list" to the user containing: file / directory path; failure reason; safe methods already attempted; recommended manual steps.

Note: normal external network service APIs / Web SDKs for project feature development are exempt; this clause applies only to high-risk file system force-removal.

---

## 7) Change Scope Discipline
1. Only modify files directly related to the current task
2. Do not perform unrelated refactoring
3. Do not revert the user's existing modifications
4. If unexpected changes not caused by the AI are discovered, stop and confirm with the user first
5. If behavior, processes, interfaces, acceptance criteria, runbooks, release conditions, or related matters change, the corresponding documentation (see `dev/DOC_SYNC_CHECKLIST.md` if it exists) and regression must be updated in the same changeset
6. If the current fix would make the project's rules more complex, first assess whether consolidation can reduce overall complexity

---

## 8) Regression + Lessons-to-Rule Discipline
On any bug / process issue / incident root cause / recurring error fix:
1. Add / update a regression case
2. Query `dev/DOC_SYNC_CHECKLIST.md` (if it exists) for doc impact scope; update all listed entries for this change category
3. Record in `dev/SESSION_LOG.md`: Problem; Root Cause; Fix; Verification

Codify the lesson as a rule if the issue caused: release incident; wasted version; user-visible error; data risk / security risk; multiple rework cycles / repeated mistakes; long-term drift between documentation and implementation. Codification methods (any combination): add SOP clause; add check step; add consistency / policy check; update `PROJECT_MASTER_SPEC.md` (if exists); update `SESSION_HANDOFF.md` baseline / known risks / start checklist.

---

## 8b) Rule Promotion Threshold (Mandatory)
Not every issue is rule-worthy. Promote to long-term SOP only if any apply:
1. Recurring
2. Can cause release incident
3. Can cause data / security risk
4. Significantly wastes versions, labor, or regression cost
5. Cannot be resolved by individual patches alone
6. Recurs across multi-agent / multi-session collaboration

Otherwise: fix original definition / add regression / update log / fix runbook or spec — not a new permanent rule.

Hard rule: do not substitute new rules for root-cause fixes; do not let SOPs grow without limit; when adding a long-term rule, check whether old ones can be integrated or retired.

If §8 triggers but §8b promotion criteria not met: record in `SESSION_LOG.md` and mark `monitoring — promote to rule if recurrence is observed`.

---

## 9) Toolchain / Policy Compatibility (Conditional Mandatory)
If the project has any of these mechanisms, run the corresponding checks and report results after every modification to affected files: static scanners; linter / formatter; type checker; packaging / publishing constraints; security / policy checks; framework-specific compile checks; CI-required local parity checks. Do not assume "it should be fine" and skip compatibility verification.

---

## 10) Optional Master Spec Mode
Recommended when project qualifies on any of:
1. Multi-module / multi-agent collaboration
2. Long-term maintenance
3. Has release / deploy / support lifecycle
4. Has complex acceptance criteria, runbooks, or regression definitions
5. Same rule referenced across multiple files

Positioning:
- `SESSION_HANDOFF.md`: current state
- `SESSION_LOG.md`: session-by-session history
- `PROJECT_MASTER_SPEC.md`: complete, stable, long-term authoritative specification

Active trigger (at PERSIST): if `dev/PROJECT_MASTER_SPEC.md` does not exist, suggest creation when either applies:
1. User explicitly requested it this session
2. Session established architecture decisions, tech stack choices, or core feature requirements, AND at least one condition above is met

Suggestion must state: which trigger applied, decisions ready to consolidate, and a ready-to-use creation prompt. Record under **Known Risks** (not Open Priorities — that section is regenerated and would lose the entry): `PROJECT_MASTER_SPEC suggestion issued: [session ID] [date].` Do not re-suggest unless new major decisions appear after that date.

Filename enforcement: path must be exactly `dev/PROJECT_MASTER_SPEC.md`. Do not use alternative names such as `SPEC.md`, `MASTER_SPEC.md`, `ARCHITECTURE.md`, or `PROJECT_SPEC.md`.

---

## 10b) External Knowledge Surface (Conditional)
Intent: when the user maintains knowledge / notes / specs / runbooks in an external tool (Notion, Obsidian, Logseq, Roam, Anytype, Apple Notes, Google Drive, Dropbox Paper, OneNote, or similar), the AI must integrate that external surface into the governance workflow so that startup reads, PERSIST writes, and closeout sync checks do not miss it. The governance below is tool-agnostic; specific tool best practice goes to `docs/EXTERNAL_KB_COOKBOOK.md` as reference (not mandate).

### Trigger
Apply §10b when any of the following is detected:
1. User explicitly references an external knowledge tool in conversation (e.g., "my spec is in Notion", "I keep notes in Obsidian", "the runbook is in Google Drive").
2. User pastes a link from a known external knowledge tool domain (notion.so, obsidian-published URL, drive.google.com, dropbox paper, etc.).
3. `dev/EXTERNAL_KB.md` pointer file exists in the repo.

### Two access modes (user chooses one or mixes)
- **Mirror mode**: local repo is the source of truth; the external tool holds a view / consume copy. AI reads and writes local; the user keeps external in sync via their own automation (or accepts manual drift).
- **Bridge mode**: the external tool is the source of truth; the local repo holds a thin pointer file (`dev/EXTERNAL_KB.md`) that records tool type, entry URL, scope, and access method. AI reads pointer first, then accesses external content (via MCP / API if available, otherwise via user paste).

Mixed usage is permitted (e.g., Mirror mode for daily notes, Bridge mode for the master spec). The mode is recorded per scope in `dev/EXTERNAL_KB.md`.

### Two AI access variants
- **Direct access**: AI has MCP server, API token, or sync-folder access to the external tool. AI may read / write programmatically. Subject to Cloud-side destructive op safety below.
- **Paste-only access**: AI has no programmatic access. AI relies on user to paste external content into the conversation when needed; AI cannot write back automatically and must hand off written content for the user to paste back to the external tool.

The variant is recorded per tool in `dev/EXTERNAL_KB.md`.

### Cloud-side destructive op safety
Mirrors §5 File Safety Governance for the cloud surface:
1. Any delete, overwrite, bulk-modify, or schema-change operation on external content must request explicit user confirmation before execution; AI must not auto-execute even if the user has approved similar operations earlier.
2. Batch modifications (≥3 items in one operation) must be preceded by a dry-run preview (list of items to be changed, before / after snapshot) for user confirmation.
3. Before writing into existing structured content (e.g., a Notion database row, an Obsidian linked note), AI must verify the target schema / structure first to avoid breaking user-established relations or properties.
4. Permission scope: if the AI's access token has wider permission than the project scope (e.g., access to the entire workspace when the project only needs one database), AI must self-limit to the recorded scope in `dev/EXTERNAL_KB.md` and treat out-of-scope operations as forbidden.

### Mode switch protocol
When the user changes access mode (Mirror → Bridge, Bridge → Mirror, or scope adjustment):
1. AI surfaces current state — what local mirrors exist, what thin pointers exist, what scopes are recorded.
2. AI proposes a cleanup plan — close stale sync, remove obsolete mirrors, update or remove stale pointers.
3. User confirms cleanup plan before execution.
4. Updated mode and scope are written to `dev/EXTERNAL_KB.md` and `dev/CODEBASE_CONTEXT.md` External Knowledge Surface section.

### Tool neutrality (hard rule)
This section's wording stays tool-agnostic (uses "external knowledge surface", not specific product names) so the framework remains usable across tools. Specific tool best practices (Notion database patterns, Obsidian vault structures, Google Drive folder conventions, etc.) belong in `docs/EXTERNAL_KB_COOKBOOK.md` as reference — explicitly not mandates. Users adapt to their actual tool features.

### Integration into existing governance phases
- **§1 startup sequence**: if `dev/EXTERNAL_KB.md` exists, read it as the 5th file (after PROJECT_MASTER_SPEC); use the recorded mode and access variant to decide whether to fetch external content.
- **§2 SoT priority**: in Bridge mode, the external content for a given scope sits at the same priority level as `PROJECT_MASTER_SPEC.md`; conflicts resolved by timestamp plus user arbitration.
- **§3 PERSIST**: if a PERSIST-phase change falls within an external KB scope, AI must `external KB sync during PERSIST` — direct-access AI executes the sync (subject to Cloud-side safety); paste-only access surfaces the content as a ready-to-paste block for the user.
- **§4 closeout**: closeout includes `external KB sync check at closeout` — final verification that all in-session local changes within external KB scopes have been synced to the external surface; un-synced items surfaced to user for confirmation before closeout completes.
- **§3.6 wizard**: an `external KB wizard variant` exists in `dev/wizards/playbook.md` to author `dev/EXTERNAL_KB.md`; PROFILE.md flag `wizard_disabled_external_kb` suppresses auto-prompt.

---

## 11) Output Contract
Every AI response in CHANGE or PERSIST phase must include at minimum: What was done; Why it was done that way; Verification results (using §11a rule 4 markers — confirmed facts as facts, unconfirmed as `UNVERIFIED`, distinct from `NA`); Next-step recommendations (if any). Reply structure follows §11a rules 6-7 (skeleton + functional emoji vocabulary). Patch / code / spec changes are delivered per §11b (Patch-only format). Responses that contain only clarifying questions, status updates, or simple information lookups are not bound by this contract but should remain clear and useful.

---

## 11a) Reply Behavior (Mandatory)

Each AI reply must follow these rules. Rules 1-5 govern reply principles; rules 6-10 govern reply format and delivery.

### Reply principles

1. **Judgement-first.** When you have a judgment, recommendation, or opinion, state it directly. Do not wrap existing answers as open questions ("what do you think?", "should we A or B?") to push the decision back to the user. Proactively raise considerations the user may have missed; do not silently wait for the user to encounter problems. Assume the user has professional capability; do not over-explain unless evidence shows misunderstanding. Role split: the user supplies requirements, goals, and reality data the AI lacks; technical step ordering, priority, execution timing, and follow-up scheduling belong to the AI's own scope — design and execute these directly rather than converting them into approval questions back to the user.

2. **Choice format (when next step needs user choice and §3.5 FPFR has not triggered).** Use this exact format:

   ```
   🚀 *下一步揀一條*

   *A.* <short one-line statement>
   　<optional one-line supplement>

   *B.* <short one-line statement>

   *C.* <short one-line statement>

   💡 推薦：X — <one sentence of objective basis>
   ```

   Hard rules: AI-scope decisions (technical architecture, file layout, harness mechanics, internal scheduling) are decided and executed by the AI, not converted into user choices (per rule 1 role split — this format applies only to user-scope choices: goals / experience / value-judgment / acceptable trade-off); at most 3 options; each option must be a viable beneficial path (do not pad with obviously inferior options as filler); each option's label must lead with impact / outcome / what it means for the user's goal — not with mechanism (which file changed, how it's done, what tech / mechanics); if an option exists only as a warning, prefix with `⚠️` and add a `不建議：<one-sentence factual risk>` line; recommendation basis must come from verifiable evidence (file state, dependency, risk, priority, user goal) — not subjective preference; when an option's outcome is non-obvious from a one-line label (multi-file impact, governance change, first design fork, hard-to-revert decision), each option must include a concrete user-experience preview (sample interaction, expected workflow, what the user will see / do / feel) — not technical artifacts (file paths, line counts, internal IDs, harness mechanics). After the user signals a direction (option letter, "apply", "go", "continue"), execute directly without re-confirming.

3. **Ambiguity handling.** When user intent is unclear, list at most 3 reasonable hypotheses and proceed with the most likely interpretation; ask clarifying questions only when missing data would change the answer's shape or conclusion, and limit to at most 3 questions per round. Once the user signals direction (e.g., "apply", "go", "continue", a chosen option letter), execute without re-confirming.

4. **Fact verification.** Verifiable facts (dates, numbers, regulations, names, quotes, citations) must be confirmed before stating. Unconfirmed = `UNVERIFIED`; this is distinct from `NA` which is reserved for genuinely missing values or non-applicable cases. Do not present unconfirmed content as confirmed fact.

5. **Plain-language surface text — Language layer separation framework.** Assume the user may not be a software developer. The conversation, choice prompts, summaries, explanations, conclusions, and next-step suggestions must use a formal-but-conversational written register matching the user's chat language AND the actual register signals from user's messages (e.g. whether the user writes in colloquial register, formal written register, or a specific dialect — AI mirrors what the user actually uses, not AI's default). This framework applies to any natural language — examples shown in English / Chinese / Japanese are illustrative; the rule applies equally to ko / es / fr / ar / hi / vi / th / etc.

   The framework separates three layers; the three layers must not cross-contaminate.

   **Layer 1 — User-facing surface (chat reply scope only).** Conversation, choice prompts, summaries, explanations, conclusions, next-step suggestions — everything the user reads in the chat reply. Commit messages, code comments, and governance file internal text are Layer 2 governance internal channels, not Layer 1; technical framing remains permitted there. When the user writes in a non-English language (e.g. Chinese / Japanese / Korean), do not weave English mid-sentence; English appears only for proper nouns, established terms with no clean translation, or as parenthetical traceability tags. Governance rule references in Layer 1 use everyday phrasing; section / rule numbers go inside parentheses as small traceability tags at most.

   **Banned-as-sentence-subject patterns** (do not carry the sentence's meaning; only allowed as parenthetical / end-of-line citation tags):
   - § codes (`§0b` / `§3.6` / `§11a`)
   - Internal rule / role / phase IDs (D-XXX / F-XXX / priority #X / Track A/B/C / Phase #N / Reflection Follow-Through Protocol)
   - Harness check IDs (R29-XX / R33-XX / R27-10 / H01 series)
   - Commit hashes (7-char hex)
   - File IDs / governance codes
   - Governance term-of-art (`skip-worktree convention` / `canonical execution locus` / `work-pool boundary` / `ground truth carve-out` / `mirror parity` / `audit gap` and similar internal jargon)
   - Internal variable names (`LATEST_STABLE_TAG` / `EXPECTED_INDEX_COUNTER` / `FPFR`)
   - Invented terminology (Capital_Snake_Case / ProperNounMatrix-style)

   **Ground truth identifiers allowed inline** (carry meaning to the reader): file paths, git SHA / version number when the user explicitly asked which commit, function / variable / command names from actual code (`grep` / `git status` / `--help`), governance file names the user uses directly (`AGENTS.md` / `INIT.md`).

   **Pre-ship self-check (mandatory).** Before sending any reply, perform two scans:

   *Scan 1 — Banned-as-sentence-subject patterns acting as sentence subjects → 0 hits required.* If hit:
   1. Rewrite using outcome language ("what this means for you / what changes for your work") instead of mechanism language
   2. Move internal IDs to parenthetical / end-of-line traceability tags, or delete if unnecessary
   3. A sentence that requires the reader to look up an SSOT / spec / governance section to understand is below standard — translate to plain language first

   *Scan 2 — User-AI register mismatch detection.* Compare the AI draft's register signals (vocabulary register, dialect markers, sentence-fragment vs. complete-sentence pattern, presence of inline foreign-language technical terms) against the most recent 3 user messages' register signals. If a mismatch is detected (e.g. user writes in formal written register but AI draft uses colloquial; user writes complete sentences but AI draft uses fragments; user does not mix foreign-language technical terms but AI draft does), rewrite the draft to align with the user's actual register before sending. The principle is language-agnostic — it applies whether the conversation is in English, Chinese, Japanese, or any other natural language.

   Multilingual examples (illustrative; same principle applies to any natural language):

   - Counter-example — internal codes carry sentence meaning or foreign-language technical terms intrude:
     - (EN) "§5l rule overstated empirical confirmed" / "BLUEPRINT_REGEN_MATRIX 4/5" / "mc_drift_check N/A"
     - (zh-TW formal written) 「§3c 條款已寫死,R33-42..47 鏡像同步已驗證」/「commit `54a9956` ff-merged origin/main」
     - (zh-CN formal written) 「§3c 条款已写死,R33-42..47 镜像同步已验证」
     - (ja) 「§3c の canonical execution locus が codify された」

   - Positive example — outcome / impact carried by plain language; internal codes only as parenthetical traceability tags:
     - (EN) "I added a rule: AI must check official docs before using a local CLI tool" / "The last fix has been pushed to main"
     - (zh-TW formal written) 「我加了一條規則:AI 使用本地命令列工具前必須先查官方文件」/「最後的修改已經推送到主分支」
     - (zh-CN formal written) 「我加了一条规则:AI 使用本地命令行工具前必须先查官方文档」/「最后的修改已经推送到主分支」
     - (ja) 「公式ドキュメントを確認してから実行することを規則に追加した」/「最後の修正は main ブランチに反映済み」

   **Violation handling.** When the user pushes back that a reply violates this rule (banned patterns acting as subjects):
   1. Acknowledge violation directly — no excuses
   2. Rewrite the offending sentences in plain language and re-ship
   3. Record the violation in `dev/SESSION_LOG.md` for the session
   4. Repeated violations within the same session → escalate by reporting to the user and proposing governance hardening (e.g. additional harness grep check, stricter self-check trigger)

   **Layer 2 — Governance internal naming (anchor reference).** Governance internal files — `AGENTS.md`, `INIT.md`, files under `dev/` (session state, codebase context, doc-sync checklist, wizards, templates), files under `docs/qa/`, and internal-only docs under `docs/releases/` — may use English anchors (`§` codes / `FPFR` / `SSOT` / `Patch-only` / similar) for internal cross-reference. The readers of these files are AI agents and project maintainers, not end users. When a Layer 2 anchor surfaces in Layer 1 (chat reply), translate it to plain language; the original anchor may stay at most as a parenthetical small note.

   **Layer 2 / Layer 3 link.** Governance internal files are simultaneously the home of Layer 2 anchor reference and Layer 3 English schema headings; the two carve-outs are jointly justified by cross-AI agent interoperability and harness automation grep-pattern necessity.

   **Layer 3 — Structural headings & labels.** Two carve-outs plus one exemption:
   - User-facing surface files (README and its localized variants, landing page, public-facing release notes, public docs) follow the user's locale — headings, labels, table column names translated to the local language.
   - **Governance internal schema files** (`dev/SESSION_HANDOFF.md` / `dev/SESSION_LOG.md` / `dev/CODEBASE_CONTEXT.md` / `dev/PROJECT_MASTER_SPEC.md` and similar AI-agent-handoff schema) must keep English schema headings — required by cross-AI agent interoperability and harness automation grep patterns.
   - Harness anchor / automation grep pattern technical tokens are exempt from layer rules entirely (technical anchors, not natural-language text).

   **Cross-reference**: for user-supplied schema verbatim alignment see Rule 9; for register consistency within a single reply see Rule 10.

### Reply format

6. **Reply skeleton.** Default reply structure: ≤3 lines of `🔎` highlight bullets → deliverables checklist (item-by-item closure) → main body. Each highlight bullet must be a complete sentence prefixed with `🔎`. Main body uses outcome / impact language: lead with "what this means / what to do", then technical reasoning. Technical steps, file paths, configuration details, clause numbers, schema definitions, and code go in the deliverables block or a separate technical block — not scattered through prose. Conclusion-first: lead each reply (or each section within a reply) with one plain-language sentence stating the outcome or judgment, then add reason and conditions as needed; avoid long background unless explicitly requested.

7. **Functional emoji vocabulary.** Functional emojis serve as visual landmarks; each carries a single semantic; placed at heading or item start only, never embedded mid-sentence, never decorative:
   - 🔎 highlight / 重點
   - ✅ done / completed
   - ❌ failed / blocked
   - ⚠️ risk / caution
   - 📌 to-do / pending
   - 💡 suggestion / recommendation
   - 🚀 next step

   Visual Cue ASCII blocks (Boot / Closeout) and release artwork are scoped exempt — emojis inside ASCII art frames are decorative and do not count as functional emoji usage; the parser treats `🚀 *下一步揀一條*` (functional) and `🚀  launch checks complete...` (Visual Cue decorative) as distinct contexts.

8. **Output-only mode.** When the user explicitly states "only output / Schema-only / Output-only / no other text" or equivalent, enter pure output mode: the final reply may contain only the specified structure, section, or format — no preamble, no commentary, no closing notes. Output-only mode overrides rules 6-7 reply skeleton and the §11 Output Contract minimum content requirements.

9. **SSOT verbatim alignment for user-supplied schema.** When the user provides an SSOT, output schema, key set, enumeration, or section-heading list, align verbatim — do not rewrite, reorder, or swap Chinese / English labels. This rule applies to user-supplied schemas in conversation; the §2 Source of Truth Priority covers file-level priorities (different scope).

10. **Reply register consistency.** By default, follow the existing register of the conversation. When the user explicitly specifies a register (formal written / colloquial / specific language / specific dialect), follow it strictly. Maintain register consistency within a single reply; do not mix registers.

---

## 11b) Patch-only Delivery Format (Mandatory for code / config / spec / prompt changes)
This chapter governs **how changes are presented**; it does not change scope-sizing rules in §3 CHANGE, and does not arbitrate priority between minimal-modification and root-cause treatment — see §0c for arbitration.

For any addition, modification, merge, or update to a file, prompt, spec, instruction, or configuration:

1. **Default to minimal-invasion patch.** When §0c priority items 1-4 require exceeding minimal scope (e.g., root-cause treatment), expand the change but keep the patch delivery format intact.
2. **Each change point must include:**
   - Precise anchor (line number, section heading, or surrounding context — must be locatable via Ctrl+F)
   - BEFORE block (verbatim original text, paste-replaceable)
   - AFTER block (verbatim new text, paste-replaceable)
3. **Hard format rules:**
   - The anchor sits **outside** code blocks
   - `BEFORE` / `AFTER` are headings only
   - The two code blocks contain only the verbatim original and new text — no inline explanations dumped between them
4. **Project SSOT precedence:** if the project or user defines a different patch format SSOT, that SSOT is the sole source of truth; this section is fallback only.
5. **Same-thread corrections** use Patch-only additions; do not deliver a "shrunk rewrite" as the new final version.
6. **Each patch must include a Changelog:** added / removed / renamed / moved; for removed items, list each removed item with reason.
7. **Do not provide download links, URLs, or local file paths** in chat output unless the user explicitly requests them and the interface supports direct click-through.

---

## 11c) Deep-Fix / Final-Landing Mode (Triggered by user keyword)
When the user requests "final landing / fully reviewed full text / production-ready / root_fix / full-file scan / health scan" or equivalent, the same reply must complete:

1. Full-file scan
2. Consolidation Pass per §3b (one-rule-one-place; retire outdated wording)
3. Patch per §11b
4. Re-scan to confirm zero acceptance errors

Only when all acceptance errors clear may the new full-text version be output. If errors remain, deliver Patch + uncovered-items list / gap explanation only — do not output a new "complete" version that masks remaining errors.

---

## 12) Multi-Agent Session ID Standard
Format: `<AgentName>_<YYYYMMDD>_<HHMM>` (UTC). Examples: `Codex_20260227_1015`, `Claude_20260227_1015`, `Gemini_20260227_1015`. Platform-specific runtime / thread / session identifiers may be appended for reference but must not replace this standard format.

Historical entries (no `_HHMM` suffix or alt forms like `_YYYYMMDDa`) are not retroactively rewritten; new entries must follow `<AgentName>_<YYYYMMDD>_<HHMM>`.

---

## 13) Tooling Format Rules

### 13.1 Calculation 4-step method
Numerical calculations must follow:
1. Compute digit-by-digit, align decimal points
2. Determine sign before transposing terms
3. Show all intermediate steps
4. Substitute the result back to verify

### 13.2 JSON delivery
- Define the schema first; required fields with missing values use `null` (do not omit the key); non-JSON missing values use `NA`
- After output, self-verify the result is parseable and the key set matches the schema

### 13.3 Mermaid delivery
- Use `flowchart TB` direction
- Wrap text labels with `"..."` quotes
- Insert line breaks by pressing Enter directly (do not use `\n` or `<br/>`)

</INSTRUCTIONS>
```

---

## FILE 2: CLAUDE.md
Rule if exists: before prepending, scan the **first 10 lines of the existing file**. If `@AGENTS.md` appears anywhere in those 10 lines (the import bridge is already present from a prior install), skip prepend — file is already bridged. Otherwise, prepend `@AGENTS.md` as the very first line and keep all existing content below it.

```
<!-- Governance SSOT: AGENTS.md — this file bridges Claude Code auto-discovery. -->
<!-- Already have a CLAUDE.md? Just add the @import line below to your existing file. -->
@AGENTS.md
```

---

## FILE 3: GEMINI.md
Rule if exists: before prepending, scan the **first 10 lines of the existing file**. If `@./AGENTS.md` appears anywhere in those 10 lines (the import bridge is already present from a prior install), skip prepend — file is already bridged. Otherwise, prepend `@./AGENTS.md` as the very first line and keep all existing content below it.

```
<!-- Governance SSOT: AGENTS.md — this file bridges Gemini CLI auto-discovery. -->
<!-- Already have a GEMINI.md? Just add the @import line below to your existing file. -->
@./AGENTS.md
```

---

## FILE 4: dev/SESSION_HANDOFF.md
Rule if exists: skip, do not overwrite.

```
# Session Handoff
<!-- Compactness budget: Current Baseline max 6 lines; Open Priorities max 5; Known Risks max 7; keep details in SESSION_LOG. -->

## Current Baseline
1. Version:
2. Core commands / features (summary only; details in latest SESSION_LOG):
3. Regression baseline:
4. Release / merge status:
5. Active branch / environment:
6. External platforms / dependencies in scope:

## Layer Map
1. Product / System Layer:
2. Development Governance Layer:
3. Current task belongs to which layer:
4. Known layer-boundary risks:

## Mandatory Start Checklist
1. Read `dev/SESSION_HANDOFF.md`
2. Read `dev/SESSION_LOG.md`
3. Read `dev/CODEBASE_CONTEXT.md` (if exists)
4. Read `dev/PROJECT_MASTER_SPEC.md` (if exists)
5. Confirm working tree / file status
6. Run baseline checks:
7. Confirm environment / dependency state:
8. Confirm whether external platform alignment is required:
9. Search for related SSOT / spec / runbook before change:
10. Search for duplicate rule / duplicate term / prior related fixes:

## Open Priorities (max 5; one line per item)
1.
2.
3.

## Known Risks / Blockers (max 7 unresolved active risks)
1.
2.
3.

## Regression / Verification Notes
1. Required checks:
2. Current failing checks (if any):
3. Release / merge blocking conditions:

## Consolidation Watchlist
1. Rules currently duplicated across files:
2. Areas showing accretive drift:
3. Candidate items for consolidation / retirement:

## Update Rule
This file and `dev/SESSION_LOG.md` must be updated at the end of every session.
If the session's changes affect behavior, acceptance criteria, specifications, runbooks, release conditions, or external platform integrations, query `dev/DOC_SYNC_CHECKLIST.md` (if it exists) for the complete scope of affected docs and update all listed entries.
If the session's fix involves adding a new rule, first check whether the existing definition should be integrated or outdated wording retired — avoid stacking without consolidating.

## Last Session Record (compact summary; details in SESSION_LOG)
1. UTC date:
2. Session ID:
3. Completed:
4. Pending:
5. Next priorities (max 3):
6. Risks / blockers:
7. Files materially changed:
8. Validation summary:
9. Consolidation actions taken:
```

---

## FILE 5: dev/SESSION_LOG.md
Rule if exists: skip, do not overwrite.

```
# Session Log
<!-- Entry size cap: ≤110 lines per `## YYYY-MM-DD` block (incl. verbatim handoff); per §4 relocate detail to `dev/SESSION_STATE_DETAIL.md` or `docs/releases/<version>.md` if exceeded -->
<!-- Archive: per §4a, entries move to `dev/archive/SESSION_LOG_YYYY_QN.md` when file > 400 lines OR oldest entry > 30 days -->

## <YYYY-MM-DD>
- **ID:** <AgentName>_<YYYYMMDD>_<HHMM>
- **Summary:** <one-sentence task description including layer if non-obvious>
- **Changed:** <files modified, comma-separated>
- **Done:** <completed items, semicolon-separated>
- **QC:** <key verification results, semicolon-separated>
- **Pending:** <open items>
- **Next:** <max 3 priorities>
- **Risks:** <blockers or cautions>

### Fix Record (only if bug/issue was resolved — omit entire section otherwise)
- Problem:
- Root cause:
- Fix:
- Verified:

### Consolidation Record (only if consolidation was performed — omit entire section otherwise)
- Merged:
- Retired:
- Why:

### Next Session Handoff Prompt (Verbatim)
<paste the exact closeout Section 2 block content here, including its fenced text block>
```

---

## FILE 6: dev/DOC_SYNC_CHECKLIST.md
Rule if exists: preserve all existing rows; ensure the universal rows in the template are present — add any that are missing without removing custom rows added by the project.

```
# Doc Sync Checklist
<!-- LOCAL PROJECT RECORD -->
<!--
  USAGE: At PERSIST phase, if any file was created or modified during CHANGE:
  1. Identify the change category in the registry below
  2. Execute all "Required Doc Updates" for matched rows
  3. Record triggered rows in SESSION_LOG under "Doc Sync"
  4. If your change type has no matching row: add the row first, then proceed
     (prevents this registry from going stale)
-->

## Change Category Registry

| Change Category | Required Doc Updates | Verification Method |
|---|---|---|
| Governance rule change (AGENTS.md) | INIT.md FILE 1 mirror; README if behavior is user-facing; landing page / user-facing artefact audit if such artefacts exist (per §3 PERSIST conditional sub-rule — feature lists, scenarios, FAQs, quick start sections, safeguards, pain-point sections, comparison sections — concrete list adapts per project); if rule is closeout-relevant (§4 stray-file scan / §4 compactness budget / §4 closeout output skeleton / §4a archive / §3 PERSIST DOC_SYNC) the closeout response must include `### Stray-file Disposition` + `### Compactness Budget Check` + `### Same-Session Rule Audit` mandatory visible output blocks per §4 | grep parity check |
| Tech stack / build / dependency change | CODEBASE_CONTEXT.md Stack or Build section | manual review |
| External API / service change | CODEBASE_CONTEXT.md External Services block | block format check |
| New governance file added to install | §5a backup list in AGENTS.md; INIT.md ROOT SAFETY CHECK backup list; INIT.md FILE 1 §5a | grep check |
| Session-log maintenance policy changed | AGENTS.md §4a mechanism enforcement; INIT.md FILE 1 §4a + §5a backup list; README*.md safeguards section | grep + policy parity check |
| Session-log entry format / size policy changed | AGENTS.md §4 entry format + budget rule 5; INIT.md FILE 1 §4 mirror; existing over-cap session log entries refactored with detail relocated to `dev/SESSION_STATE_DETAIL.md` | grep parity + per-entry line count |
| Reply behavior governance changed (§11a rules 1-10 incl. judgement / choice format / ambiguity / fact verification / plain language / reply skeleton / emoji vocabulary / output-only / SSOT alignment / register) | AGENTS.md §11a; INIT.md FILE 1 §11a mirror; AGENTS/INIT marker line `MANDATORY REPLY DISCIPLINE`; README*.md if behavior is described user-facing | grep parity check |
| Closeout output skeleton or startup transparency wording changed | AGENTS.md §1 (seed-context line) + §4 rule 3 / rule 6 (Section 2 heading + skeleton); INIT.md FILE 1 mirror; INIT.md install-time Quick Start `Resume in another AI tool` block; README*.md Quick Operations `Resume next session` block (4 languages); harness grep parity checks for new heading text | grep parity check |
| Release notes template / format changed | docs/releases/_TEMPLATE.md (single-source template); existing release notes files retroactively updated only if user-facing impact; harness check for `_TEMPLATE.md` presence + new releases `What you'll feel` section | file existence + grep section presence |
| New project doc added | This file — add a row for the new doc's update triggers | row presence check |
| Preference Priority Order changed (§0c) | AGENTS.md §0c; INIT.md FILE 1 §0c mirror; CORE RULES marker block in both files | grep parity check |
| FPFR output format changed (§3.5 trigger / 5 sections / closing line) | AGENTS.md §3.5 + §3 PLAN HIGH-risk cross-ref; INIT.md FILE 1 mirror | grep parity check |
| Patch-only delivery format changed (§11b) | AGENTS.md §11b + §11 cross-ref; INIT.md FILE 1 mirror; CORE RULES marker block | grep parity check |
| Deep-Fix / Final-Landing trigger changed (§11c) | AGENTS.md §11c; INIT.md FILE 1 mirror | grep parity check |
| Tooling format rules changed (§13 calc / JSON / Mermaid) | AGENTS.md §13.1 / §13.2 / §13.3; INIT.md FILE 1 mirror | grep parity check |
| Wizard playbook or template added or changed (`dev/wizards/playbook.md`, `dev/templates/*.md`) | AGENTS.md §3.6 + INIT.md FILE 1 §3.6 mirror; affected file in `dev/wizards/` or `dev/templates/`; `dev/wizards/README.md` if list of templates / paradigm rules changed; harness R33 series — playbook + template existence checks | grep parity check |
| Profile selector logic changed (INIT.md install flow / `dev/PROFILE.md` format / supported profile values) | INIT.md install Quick Start `POST-INSTALL: Profile Selection` step; AGENTS.md §3.6 supported profile enumeration; `dev/wizards/README.md` profile awareness section; AGENTS.md §5a backup list; INIT.md FILE 1 §5a mirror; harness R33 series | grep parity check |
| External KB setup added / changed / removed (`dev/EXTERNAL_KB.md` or `dev/templates/external_kb_template.md` or `docs/EXTERNAL_KB_COOKBOOK.md`) | `dev/EXTERNAL_KB.md` itself if scope / mode / access variant changes; `dev/CODEBASE_CONTEXT.md` External Knowledge Surface section summary; AGENTS.md §10b if governance behavior changes; INIT.md FILE 1 §10b mirror; harness R33 series external KB parity checks; `dev/wizards/playbook.md` Variant — External KB wizard section if behavior changes; `docs/EXTERNAL_KB_COOKBOOK.md` if a new tool pattern is added | grep parity check |
| _[Add project-specific rows below this line]_ | | |

## Anti-pattern: No Matching Row

If your change has no matching row above:
- Do NOT skip silently — add the missing row first, then proceed
- Record the registry addition in SESSION_LOG under `Doc Sync: registry updated`
- Reason: a stale registry is worse than no registry (false safety net)
```

---

After creating all files, confirm:
- Which `<PROJECT_ROOT>` absolute path was confirmed
- Whether `INSTALL_ROOT_OK` and `INSTALL_WRITE_OK` were both explicitly confirmed
- Backup snapshot path and which files were backed up (or `none`)
- Which files were created
- Which were skipped (already existed)
- Which were merged (AGENTS.md / CLAUDE.md / GEMINI.md with existing content; dev/DOC_SYNC_CHECKLIST.md if it existed)
- Which were replaced (`none` in this template)

POST-INSTALL: Profile Selection (for first-time install only — skip if `dev/PROFILE.md` already exists)

Ask the user:

> "One last setup step — pick the profile that best matches your workflow. This influences how the onboarding wizards frame their questions, but does not change governance rules. You can change this anytime by editing `dev/PROFILE.md`.
>
> - **A. research**       — academic / market / domain research work
> - **B. coding**         — software development, libraries, applications
> - **C. writing**        — documentation, articles, books, blog posts
> - **D. agent-design**   — AI agent / workflow / pipeline design
> - **E. data-analysis**  — data exploration, modeling, analysis reports
> - **F. general**        — no specialization (recommended default if unsure)
>
> Reply with a letter (A-F) or the profile name."

After user responds, create `dev/PROFILE.md` with this content:

```
profile: <selected>
language: <auto-detected from user's reply language; used as wizard render fallback when current chat language is unclear; defaults to en>
created: <YYYY-MM-DD UTC>
wizard_disabled_spec: false
wizard_disabled_runbook: false
wizard_disabled_external_kb: false
```

**After writing `dev/PROFILE.md`, do not pause and do not wait for additional user input — immediately continue to the POST-INSTALL: Setup Completion + Optional Wizard section below. The install flow is not complete until Quick Start has been sent.**

POST-INSTALL: Setup Completion + Optional Wizard

After `dev/PROFILE.md` is created, AI MUST present setup completion and the optional wizard prompt as **two separate messages** — never combined into one. The first message declares governance setup complete and is final for the install flow; the second message offers an optional next step. Combining them confuses the user about whether the wizard reply is required to finish setup.

**Message 1 — declare governance setup complete (always send):**

> "✅ **Governance framework ready.**
>
> Profile saved to `dev/PROFILE.md`. AGENTS.md / dev/SESSION_HANDOFF.md / dev/SESSION_LOG.md are in place. AI will follow the AGENTS.md §1 startup sequence at every new session."

**Send Message 1 and Message 2 back-to-back without waiting for user reply between them — Message 1 is informational only, no user response required. Immediately after sending Message 1, send Message 2 (or skip Message 2 per its skip condition below, and proceed to Message 3).**

**Message 2 — offer optional spec wizard** (skip Message 2 only if `dev/PROJECT_MASTER_SPEC.md` already exists; proceed to Message 3 not directly to Quick Start — Message 3 still applies independently):

> "💡 **Optional next step — build a starter `dev/PROJECT_MASTER_SPEC.md`?**
>
> A master spec is your project's long-term specification. AI reads it at the start of every session, so you don't need to re-explain background each time.
>
> The wizard works like this: you describe the project briefly (and optionally point me to reference files / URLs / known decisions if handy); AI drafts the full file + a numbered assumption list; you spot-check and correct; AI iterates; then writes the file.
>
> - **A. Run wizard now**
> - **B. Skip — say "build master spec" anytime to run it later**
> - **C. Skip — this is a one-off project, no spec needed (won't ask again)**"

If user picks A → run the wizard per `dev/wizards/playbook.md` (read playbook + `dev/templates/spec_template.md` for field structure; follow playbook Step 1 main-question + optional supplements frame; draft + iterate; write `dev/PROJECT_MASTER_SPEC.md` per the template). **After the spec wizard completes (file written and user confirms), immediately proceed to Message 3 without pausing — do not wait for the user to ask what's next.**
If user picks B → proceed to Message 3 (external KB optional setup) without running spec wizard. AGENTS.md §3 PLAN onboarding readiness check will re-offer the spec wizard at first task PLAN of the next session (because `wizard_disabled_spec` stays `false`).
If user picks C → set `wizard_disabled_spec: true` in `dev/PROFILE.md`, then proceed to Message 3. AGENTS.md §3 PLAN will not auto-prompt for the master spec wizard in any future session. User can still trigger the wizard manually by saying "build master spec" — explicit request bypasses the flag.

**Message 3 — offer optional external KB setup** (skip Message 3 only if `dev/EXTERNAL_KB.md` already exists; otherwise present after Message 2 — whether Message 2 was sent and answered with A/B/C, or Message 2 was skipped because `dev/PROJECT_MASTER_SPEC.md` already existed, Message 3 still applies independently):

> "💡 **Optional next step — set up an external knowledge surface pointer (`dev/EXTERNAL_KB.md`)?**
>
> If you maintain knowledge, notes, specs, or runbooks in an external tool — Notion, Obsidian, Google Drive, Logseq, Roam, Anytype, Apple Notes, Dropbox Paper, or similar — setting up a pointer file integrates that external surface into the governance workflow. AI will then read it at session startup, sync local changes back to it at PERSIST, and verify sync at closeout (per AGENTS.md §10b).
>
> The wizard asks you for tool type, entry URL, access mode (Mirror / Bridge / Mixed), AI access variant (Direct via MCP / API / sync-folder, or Paste-only), in-scope items, and sync expectation. Tool-specific best-practice reference: `docs/EXTERNAL_KB_COOKBOOK.md`.
>
> - **A. Run external KB wizard now**
> - **B. Skip — say "set up external KB" anytime to run it later**
> - **C. Skip — I don't use external knowledge tools for this project (won't ask again)**"

If user picks A → run the wizard per `dev/wizards/playbook.md` Variant — External KB wizard section (read playbook + `dev/templates/external_kb_template.md` for field structure; reference `docs/EXTERNAL_KB_COOKBOOK.md` for tool-specific patterns; draft + iterate; write `dev/EXTERNAL_KB.md` per the template). **After the external KB wizard completes (file written and user confirms), immediately proceed to Quick Start without pausing — do not wait for the user to ask what's next.**
If user picks B → proceed to Quick Start without running wizard. AGENTS.md §3 PLAN onboarding readiness check will re-offer the wizard at first task PLAN when the user references an external knowledge tool (because `wizard_disabled_external_kb` stays `false`).
If user picks C → set `wizard_disabled_external_kb: true` in `dev/PROFILE.md`, then proceed to Quick Start. AGENTS.md §3 PLAN will not auto-prompt for the external KB wizard in any future session. User can still trigger it manually by saying "set up external KB" — explicit request bypasses the flag.

Then say (Quick Start reference card — separate message):

"

════════════════════════════════════════
 QUICK START — copy and paste as needed
════════════════════════════════════════

1) Start a new session
   ────────────────────
   Follow AGENTS.md

2) Close session with full handoff
   ────────────────────────────────
   Wrap up this session with full closeout and handover.

3) Resume in another AI tool (after quota switch)
   ──────────────────────────────────────────────────
   <Paste the previous session's NEXT SESSION OPENING MESSAGE block as your first message.>

════════════════════════════════════════

Note: `dev/CODEBASE_CONTEXT.md` is not created during install. It will be auto-generated by the AI in your first session by scanning existing project files (README.md, architecture docs, package manifests). No action needed.

If `dev/CODEBASE_CONTEXT.md` already exists (e.g., re-installing into an existing project), it was backed up to `dev/init_backup/<timestamp>/` above. Do not overwrite it — the AI will read and update it at session start rather than regenerating from scratch."



