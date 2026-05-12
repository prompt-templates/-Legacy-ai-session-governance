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
| Governance rule change (AGENTS.md) | INIT.md FILE 1 mirror; README if behavior is user-facing; landing page / user-facing artefact audit if such artefacts exist (per §3 PERSIST conditional sub-rule — feature lists, scenarios, FAQs, quick start sections, safeguards, pain-point sections, comparison sections — concrete list adapts per project) | grep parity check |
| Tech stack / build / dependency change | CODEBASE_CONTEXT.md Stack or Build section | manual review |
| External API / service change | CODEBASE_CONTEXT.md External Services block | block format check |
| New governance file added to install | §5a backup list in AGENTS.md; INIT.md ROOT SAFETY CHECK backup list; INIT.md FILE 1 §5a | grep check |
| Session-log maintenance policy changed | AGENTS.md §4a mechanism enforcement; INIT.md FILE 1 §4a + §5a backup list; README*.md safeguards section | grep + policy parity check |
| Session-log entry format / size policy changed | AGENTS.md §4 entry format + budget rule 5; INIT.md FILE 1 §4 mirror; docs/qa/run_checks.sh entry-cap awk check; docs/qa/QA_REGRESSION_REPORT.md row; existing over-cap entries refactored with detail relocated to dev/SESSION_STATE_DETAIL.md | bash docs/qa/run_checks.sh + grep parity |
| Reply behavior governance changed (§11a rules 1-10 incl. judgement / choice format / ambiguity / fact verification / plain language / reply skeleton / emoji vocabulary / output-only / SSOT alignment / register) | AGENTS.md §11a; INIT.md FILE 1 §11a mirror + FILE 6 DOC_SYNC template row; AGENTS/INIT marker line `MANDATORY REPLY DISCIPLINE`; docs/qa/run_checks.sh §11a rule-count + parity checks; docs/qa/QA_REGRESSION_REPORT.md rows; README*.md if behavior is described user-facing | bash docs/qa/run_checks.sh + grep parity |
| Closeout output skeleton or startup transparency wording changed | AGENTS.md §1 (seed-context line) + §4 rule 3 / rule 6 (Section 2 heading + skeleton); INIT.md FILE 1 mirror + install-time Quick Start `Resume in another AI tool` block + FILE 6 template row; README*.md Quick Operations `Resume next session` block (4 languages); docs/qa/run_checks.sh grep parity for new heading text + transparency rule | bash docs/qa/run_checks.sh + grep parity |
| Release notes template / format changed | docs/releases/_TEMPLATE.md (single-source template); existing release notes retroactively updated only if user-facing impact; INIT.md FILE 6 template row; harness check for `_TEMPLATE.md` presence + new releases include `What you'll feel` section | file existence + grep section presence |
| New project doc added | This file — add a row for the new doc's update triggers | row presence check |
| Workspace cleanup (delete untracked scratch / `_tmp_*` artifacts) | dev/SESSION_HANDOFF.md if Open Priorities, Current Baseline, or Known Risks referenced the deleted artifacts | manual review |
| Harness restructure (legacy quarantine / split / new harness layer) | docs/qa/MIGRATION_NOTES.md series table; AGENTS.md §3c Machine Verification clause; INIT.md FILE 1 mirror; run_checks.sh + legacy_checks.sh sync | bash docs/qa/run_checks.sh full chain |
| **Release published (tag + GitHub release + version bump)** | **Phase 2 publication** (§3c step 5): annotated tag + GitHub release with `isPrerelease` / `--latest` flags. **Doc sync** (mandatory, every patch release): README.md + 3 localized variants (zh-TW/zh-CN/ja): (a) **Recent releases version table** — add new `**vX.Y.Z**` row at top **using user-facing outcome register matching prior rows** (per `docs/releases/_TEMPLATE.md` RULES — read prior 1-2 rows' first sentence + "Why it matters" first sentence to anchor register before writing; forbidden as sentence subjects: § codes, R-check numbers, harness IDs (H01 / R27-10), internal variable names, governance term-of-art ("skip-worktree convention" / "canonical execution locus" / "work-pool boundary"); technical detail belongs in `docs/releases/<version>.md` "What changed" section, not in the README row), cap to most recent 5 entries (older entries link to GitHub releases page); (b) **Snapshot status** — bump version reference; docs/releases/<version>.md (release notes per `_TEMPLATE.md` 5-section); docs/qa/LATEST.md (date + check count + tag + focus); docs/qa/QA_REGRESSION_REPORT.md (current run summary + Feature Round entry); docs/VERIFICATION.md (claim baseline confirmation); docs/site/index.html stat-counter (`data-target` for total checks if check count changed); **docs/qa/run_checks.sh `LATEST_STABLE_TAG` bump** to new version (so R29-01..04 verify the new row exists in each README, R29-05 verifies the release notes file exists). **Phase 3 cleanup** (§3c step 6–7): if shipped via PR, delete merge-source branch (local + remote); for major releases, build sandbox install + run install QC. **Phase 4 observability** (§3c step 8): append Open Priority for production fail-mode observation. | grep regression (R29 + R30 series) + manual review of branch/sandbox state |
| Preference Priority Order changed (§0c) | AGENTS.md §0c; INIT.md FILE 1 §0c mirror; CORE RULES marker block in both files; harness grep parity for the 5-item priority list | bash docs/qa/run_checks.sh + grep parity |
| FPFR output format changed (§3.5 trigger / 5 sections / closing line) | AGENTS.md §3.5 + §3 PLAN HIGH-risk cross-ref; INIT.md FILE 1 mirror; harness grep parity for 5 section headings + closing line + trigger conditions; DOC_SYNC registry (this file) | bash docs/qa/run_checks.sh + grep parity |
| Patch-only delivery format changed (§11b) | AGENTS.md §11b + §11 cross-ref; INIT.md FILE 1 mirror; CORE RULES marker block; harness grep parity for anchor + BEFORE/AFTER + Changelog requirements | bash docs/qa/run_checks.sh + grep parity |
| Deep-Fix / Final-Landing trigger changed (§11c) | AGENTS.md §11c; INIT.md FILE 1 mirror; harness grep parity for trigger keywords + 4-step requirement | bash docs/qa/run_checks.sh + grep parity |
| Tooling format rules changed (§13 calc / JSON / Mermaid) | AGENTS.md §13.1 / §13.2 / §13.3; INIT.md FILE 1 mirror; harness grep parity for each subsection presence | bash docs/qa/run_checks.sh + grep parity |
| Wizard playbook or template added or changed (`dev/wizards/playbook.md`, `dev/templates/*.md`) | AGENTS.md §3.6 + INIT.md FILE 1 §3.6 mirror; affected file in `dev/wizards/` or `dev/templates/`; `dev/wizards/README.md` if list of templates / paradigm rules changed; AGENTS.md / INIT.md §3 PLAN onboarding readiness check if trigger conditions or path references changed; INIT.md install POST-INSTALL Wizard Auto-Trigger block if first-install flow path changed; harness R33 series — playbook + template existence checks; README.md × 4 Quick Op 4 if user-facing description changed | bash docs/qa/run_checks.sh + grep parity (R33 series) |
| Profile selector logic changed (INIT.md install flow / `dev/PROFILE.md` format / supported profile values) | INIT.md install Quick Start `POST-INSTALL: Profile Selection` step; AGENTS.md §3.6 supported profile enumeration; `dev/wizards/README.md` profile awareness section; AGENTS.md §5a backup list (`dev/PROFILE.md` entry); INIT.md FILE 1 §5a mirror; harness R33 series for backup list + profile section parity | bash docs/qa/run_checks.sh + grep parity |
| External KB setup added / changed / removed (`dev/EXTERNAL_KB.md` or `dev/templates/external_kb_template.md` or `docs/EXTERNAL_KB_COOKBOOK.md`) | `dev/EXTERNAL_KB.md` itself (the pointer file) if scope / mode / access variant changes; `dev/CODEBASE_CONTEXT.md` External Knowledge Surface section summary fields; AGENTS.md §10b if governance behavior changes; INIT.md FILE 1 §10b mirror; harness R33 series external KB parity checks; `dev/wizards/playbook.md` Variant — External KB wizard section if behavior changes; `docs/EXTERNAL_KB_COOKBOOK.md` if a new tool pattern is added | bash docs/qa/run_checks.sh + grep parity |
| _[Add project-specific rows below this line]_ | | |

## Anti-pattern: No Matching Row

If your change has no matching row above:
- Do NOT skip silently — add the missing row first, then proceed
- Record the registry addition in SESSION_LOG under `Doc Sync: registry updated`
- Reason: a stale registry is worse than no registry (false safety net)
