# Verification Record

This document keeps the detailed claim mapping and platform compatibility checks referenced by README files.

Verification date baseline: 2026-03-26 (UTC); v3.0.3 baseline confirmed 2026-05-01

## Claim-to-mechanism mapping

| Claim | Backed by | Verified |
|---|---|---|
| Session continuity | AGENTS.md section 1 Single Entry, section 4 Session Close, SESSION_HANDOFF.md, SESSION_LOG.md | Yes |
| PLAN -> READ -> CHANGE -> QC -> PERSIST | AGENTS.md section 3 Standard Workflow | Yes |
| Anti-governance-bloat discipline | AGENTS.md section 3b Consolidation Discipline, section 8b Rule Promotion Threshold | Yes |
| Layer separation | AGENTS.md section 0a | Yes |
| Read before change | AGENTS.md section 3 READ phase (consolidated from former section 2c) | Yes |
| Issue triage before debug | AGENTS.md section 2b | Yes |
| Multi-agent session ID standard | AGENTS.md section 12 | Yes |
| File safety governance | AGENTS.md section 5, section 6 | Yes |
| Integration with existing project docs | AGENTS.md line 2 merge/preserve instruction | Yes |
| External API code safety | AGENTS.md section 0b External API Code Safety | Yes |
| Test plan governance | AGENTS.md section 3d Test Plan Design | Yes |
| Doc-sync registry | dev/DOC_SYNC_CHECKLIST.md; AGENTS.md §3 PERSIST trigger, §7, §8 | Yes |
| QC fail-path guidance | AGENTS.md section 3 QC phase — report failures, no auto-retry | Yes |
| Deviation resume path | AGENTS.md section 3 CHANGE phase — restart from PLAN or CHANGE after deviation stop | Yes |
| Closeout ambiguity guard | AGENTS.md section 4 Session Close — confirm intent on ambiguous expressions | Yes |
| Core rules attention anchor | AGENTS.md top-level CORE RULES block — critical rules in highest attention position | Yes |
| Legacy quarantine + auto-chain harness | docs/qa/legacy_checks.sh; main run_checks.sh auto-chain; AGENTS.md §3c forbids `LEGACY_SKIP=1` during release | Yes (v3.0) |
| H01 staleness governance trigger | AGENTS.md mtime vs `.legacy_last_run`; >30d gap fails main harness automatically | Yes (v3.0) |
| Re-install backup list completeness | AGENTS.md §5a step 9 covers `dev/SESSION_STATE_DETAIL.md` + `dev/PROJECT_MASTER_SPEC.md` (v3.0-rc.2 hotfix) | Yes (v3.0-rc.2) |
| Release-doc sync governance | dev/DOC_SYNC_CHECKLIST.md `Release published` row; AGENTS.md §3c Machine Verification doc-sync clause; R29 regression series | Yes (v3.0.1) |
| Release-lifecycle 4-phase gate | AGENTS.md §3c Phase 1–4 (pre-release / execution / post-cleanup / observability); R30 regression series enforces governance text presence | Yes (v3.0.2) |
| SESSION_LOG entry-size cap | AGENTS.md §4 entry format (≤110 hard cap incl. verbatim handoff block); R-checks #167 (per-entry awk scan) + #168/#169 (rule grep parity); dev/SESSION_STATE_DETAIL.md as overflow escape valve | Yes (v3.0.3) |
| Reply Behavior governance | AGENTS.md §11a (5 mandatory rules: judgement-first / choice format ≤3 + recommendation / ambiguity ≤3 hypotheses + ≤3 questions / fact verification UNVERIFIED ≠ NA / plain-language surface text); marker line MANDATORY REPLY DISCIPLINE; R-checks #170-175 enforce AGENTS / INIT mirror parity | Yes (v3.0.3) |

## Platform compatibility verified

| Platform | Reads governance file | Session persistence | Structured workflows | Reference |
|---|---|---|---|---|
| Codex | `AGENTS.md` native | Client-side sessions + resume | AGENTS.md directives + Agents SDK | OpenAI Codex docs |
| Claude Code | `CLAUDE.md` native; `AGENTS.md` via `@` import | Auto memory + session resume | Plan mode + skills | Claude Code docs |
| Gemini CLI | `GEMINI.md` native; `AGENTS.md` via config/import | `/memory` + session save/resume | Skills + GEMINI.md directives | Gemini CLI docs |

## Regression evidence

- Latest QA pointer: [docs/qa/LATEST.md](qa/LATEST.md)
- Current detailed report: [docs/qa/QA_REGRESSION_REPORT.md](qa/QA_REGRESSION_REPORT.md)
- Latest run snapshot (UTC): 2026-05-01, 264 automated checks (175 main + 89 legacy auto-chain), 264 pass, 0 fail; includes Phase 1 legacy quarantine + Phase 2 L4 reduction + v3.0-rc.2 §5a backup hotfix + v3.0.1 release-doc sync R29 series (12 checks) + v3.0.2 release-lifecycle 4-phase governance R30 series (6 checks) + v3.0.3 §4 entry-size cap (3 checks: #167-169) + §11a Reply Behavior (6 checks: #170-175)
- **Run automated checks:** `bash docs/qa/run_checks.sh` (from project root)

## Not yet verified

- Longitudinal effectiveness across 50+ sessions
- Compliance rate across different model generations
- Performance impact of mandatory handoff/log reads at session start
