# Codebase Context

## Stack
- Language: Markdown, Bash, Python
- Framework: N/A (governance template repository)
- Key libs/tools: `bash`, `python`, `ripgrep`, `git`
- Package manager: N/A (no project package manifest detected)
- Runtime/version notes: CLI-oriented governance for Codex / Claude Code / Gemini CLI

## Directory Map
- Root governance/install files: `AGENTS.md`, `INIT.md`, `CLAUDE.md`, `GEMINI.md`
- Runtime session state: `dev/SESSION_HANDOFF.md`, `dev/SESSION_LOG.md`, `dev/archive/`
- Doc sync registry: `dev/DOC_SYNC_CHECKLIST.md`
- QA tooling: `docs/qa/run_checks.sh` (main+legacy regression harness), `docs/qa/legacy_checks.sh` (auto-chained legacy harness), `docs/qa/session_log_maintenance.py` (optional dev utility — self-test + manual archive simulation only; NOT the runtime archive gate), `docs/qa/*.md` (baselines + reports)
- Design/implementation plans: `docs/plans/*.md`
- Reference assets: `ref_doc/*.png` and related media

## Key Entry Points
- Primary SSOT for governance behavior: `AGENTS.md`
- Bootstrap/install orchestration: `INIT.md`
- Regression harness: `docs/qa/run_checks.sh` (auto-chains `legacy_checks.sh`)
- Session-log archive gate: AGENTS.md §4a — triggers evaluated directly from `dev/SESSION_LOG.md` at closeout (line count > 400 OR oldest entry > 30 days); shell-evaluated, no Python or non-default runtime required
- Operator-facing overview: `README.md` + localized README variants

## Build & Run
- Session startup command (operator): `Follow AGENTS.md`
- Full QA regression: `bash docs/qa/run_checks.sh` (auto-chains legacy harness)
- Session log archive: handled by AGENTS.md §4a at closeout — AI evaluates triggers from `dev/SESSION_LOG.md` directly (no command to run); on trigger fire, AI moves entries to `dev/archive/SESSION_LOG_YYYY_QN.md` before writing the new closeout entry
- Optional dev utility — `python docs/qa/session_log_maintenance.py --self-test` simulates the trigger logic for local verification; not part of the runtime closeout flow

## External Services
### GitHub Repository / Release Hosting
- Base URL: `https://github.com/prompt-templates/ai-session-governance`
- Versioning/release channel: Git tags + GitHub Releases
- Auth: Repository-dependent (public read assumed for current URLs)
- Required params: N/A (documentation/release hosting usage only in this repo)
- Forbidden params: N/A
- Response path: N/A
- Official docs: `https://docs.github.com/`
- Doc-reviewed: 2026-04-19 (Codex_20260419_1533)
- Test-verified: 2026-04-18 release URL recorded in SESSION_LOG
- Notes: README and SESSION_LOG reference GitHub release links.

### GitHub Pages (Interactive Introduction)
- Base URL: `https://prompt-templates.github.io/ai-session-governance/`
- Version: N/A
- Auth: Public
- Required params: optional `lang` query in localized links
- Forbidden params: N/A
- Response path: N/A
- Official docs: `https://docs.github.com/en/pages`
- Doc-reviewed: 2026-04-19 (Codex_20260419_1533)
- Test-verified: not executed in this session (network restricted)
- Notes: Linked from all README variants as onboarding page.

## Key Decisions
- `AGENTS.md` is governance SSOT; `CLAUDE.md` / `GEMINI.md` are pointers.
- Startup sequence is mandatory and includes `SESSION_HANDOFF -> SESSION_LOG -> CODEBASE_CONTEXT -> PROJECT_MASTER_SPEC`.
- `SESSION_LOG` long-term growth is controlled by AGENTS.md §4a — AI evaluates triggers directly from the file (line count > 400 OR oldest entry > 30 days) at closeout and archives without requiring Python or any non-default runtime. The `session_log_maintenance.py` script is preserved as an optional dev utility (self-test only), not the runtime gate.
- Handoff compactness is governed by explicit budget caps in `AGENTS.md` §4.
- Worktree edge cases (v3.0.10): `dev/SESSION_HANDOFF.md` and `dev/SESSION_LOG.md` are kept on `git update-index --skip-worktree` so they stay as local-only state in the main repo. AGENTS.md §1 Worktree fallback rule directs AI to resolve these files from the main repo path (`git rev-parse --git-common-dir` parent dir) when running inside a worktree, before falling back to the "create a minimal version" rule. Release verification harness has canonical execution locus = main repo path (AGENTS.md §3c Phase 1 step 2) — worktree-path harness execution triggers spurious `H01` / `R27-10` failures that are by-design per skip-worktree convention, not real failures.

## AI Maintenance Log
- Created: 2026-04-19 (Codex_20260419_1533)
- Last updated: 2026-05-08 (Claude_20260508_v3.0.10)
- Change summary:
  - 2026-04-19 (Codex_20260419_1533): First-time generation because `dev/CODEBASE_CONTEXT.md` was missing at startup.
  - 2026-05-05 (Claude_20260505): Synced session-log archive description to AGENTS.md §4a (shell-evaluated triggers, no Python at runtime). Prior wording described `session_log_maintenance.py` as the active gate; the §4a rewrite (v3.0.5) moved enforcement into closeout-time AI trigger evaluation. Script preserved as dev self-test utility.
  - 2026-05-08 (Claude_20260508_v3.0.10): Added Key Decisions worktree convention note synced to AGENTS.md §1 Worktree fallback (mandatory) + §3c Canonical execution locus addition. v3.0.10 release — codifies skip-worktree convention for `dev/SESSION_HANDOFF.md` / `dev/SESSION_LOG.md` (worktree-path session reads from main repo) and harness canonical execution locus (main repo path; worktree-path execution triggers spurious `H01` / `R27-10` by-design).
- Source files scanned (present):
  - `README.md`
  - `README.zh-TW.md`
  - `README.zh-CN.md`
  - `README.ja.md`
  - `docs/VERIFICATION.md`
  - `docs/qa/LATEST.md`
  - `docs/qa/QA_REGRESSION_REPORT.md`
  - `docs/plans/2026-04-14-harness-optimization.md`
  - `docs/plans/2026-04-08-governance-audit-fixes.md`
  - `docs/plans/2026-03-26-doc-sync-checklist.md`
  - `docs/plans/2026-03-24-governance-gap-fixes.md`
  - `docs/plans/2026-03-16-test-plan-governance-impl.md`
  - `docs/plans/2026-03-16-external-api-safety-impl.md`
  - `docs/plans/2026-03-16-external-api-safety-design.md`
  - `docs/plans/2026-03-16-codebase-context-impl.md`
  - `docs/plans/2026-03-16-codebase-context-design.md`
- Scan patterns with no matching files:
  - `CONTRIBUTING.md`, `DEVELOPMENT.md`
  - `package.json`, `pyproject.toml`, `go.mod`, `Cargo.toml`, `Gemfile`, `requirements.txt`, `composer.json`
  - `.env.example`, `docker-compose*.yml`, `docker-compose*.yaml`, root/config `*.yml`/`*.yaml`
