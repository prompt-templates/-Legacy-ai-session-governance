# Verification Record

This document keeps the detailed claim mapping and platform compatibility checks referenced by README files.

Verification date baseline: 2026-03-26 (UTC); v3.0.5 baseline confirmed 2026-05-01

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
| Reply Behavior governance baseline | AGENTS.md §11a (5 mandatory rules at v3.0.3 baseline — expanded to 10 rules in v3.0.5; see "Reply Behavior expanded" row below: judgement-first / choice format ≤3 + recommendation / ambiguity ≤3 hypotheses + ≤3 questions / fact verification UNVERIFIED ≠ NA / plain-language surface text); marker line MANDATORY REPLY DISCIPLINE; R-checks #170-175 enforce AGENTS / INIT mirror parity | Yes (v3.0.3 baseline; see v3.0.5 expansion row) |
| Closeout output clarity (Section 2 heading rename) | AGENTS.md §4 rule 3 + rule 6 skeleton: `NEXT SESSION HANDOFF PROMPT (COPY/PASTE)` → `NEXT SESSION OPENING MESSAGE` with paste-location hint; INIT.md mirror + install-time Quick Start update; README × 4 Quick Operations Resume reference update; R31-05 / R31-06 grep parity | Yes (v3.0.4) |
| Startup seed-context transparency | AGENTS.md §1: post-Boot-Visual-Cue mandatory `Seed context: ...` line with 4 enumerated forms (paste / fallback / consistent / diverged); INIT.md mirror; R31-01 to R31-04 grep parity | Yes (v3.0.4) |
| Release notes user-readability template | docs/releases/_TEMPLATE.md 5-section format (Headline / What you'll feel / What changed / Validation / Upgrade); v3.0.3 retroactively rewritten to template; R31-07 to R31-09 grep + file-existence | Yes (v3.0.4) |
| Lifecycle SVG embedded in README × 4 languages | ref_doc/lifecycle_flow_{en,tw,cn,ja}.svg (4-step day-to-day flow + forgot-to-paste fallback panel); embedded in respective README via `![Lifecycle flow](...)` markdown; R31-10 to R31-17 file-existence + embedding grep | Yes (v3.0.4) |
| Preference Priority Order arbitration | AGENTS.md §0c (5-item: verifiable correctness > stability > root-cause > completeness > minimal-modification); resolves cross-section conflicts; INIT.md mirror; R32-01 to R32-04 grep parity | Yes (v3.0.5) |
| FPFR full-picture-first output format | AGENTS.md §3.5 (5 sections: END-STATE / DELIVERABLES / METRICS / ACCEPTANCE / GOAL LINK + verbatim closing line + 4 trigger conditions + 4 not-triggered + 4 prohibited patterns); §3 PLAN HIGH-risk cross-refs §3.5; INIT.md mirror; R32-05 to R32-12 grep parity | Yes (v3.0.5) |
| Anti-hardcoding hard rule | AGENTS.md §3b (examples must be generic; numbers in named Preset blocks; specific instances belong in SESSION_LOG history not the doc); INIT.md mirror; R32-13 / R32-14 grep parity | Yes (v3.0.5) |
| Preserve original user-supplied files | AGENTS.md §5 rule 9 (default to renamed copies; do not overwrite in-place; explicit user instruction is the only exception); INIT.md mirror; R32-15 / R32-16 grep parity | Yes (v3.0.5) |
| Reply Behavior expanded (§11a 5→10 rules) | AGENTS.md §11a rules 6-10: reply skeleton (≤3 行 🔎 → 交付 → 正文), functional emoji vocabulary (🔎/✅/❌/⚠️/📌/💡/🚀), Output-only mode override, SSOT verbatim alignment for user-supplied schema, reply register consistency; rules 1, 2, 5 also extended (role-split / prescribed 🚀 A/B/C + 💡 推薦 format / counter-example + positive example); INIT.md mirror; R32-17 to R32-26 grep parity | Yes (v3.0.5) |
| Patch-only delivery format | AGENTS.md §11b (precise anchor outside code blocks + BEFORE/AFTER paste-replaceable code blocks + Changelog mandatory; project SSOT precedence; same-thread corrections via Patch additions only); INIT.md mirror; R32-27 / R32-28 grep parity | Yes (v3.0.5) |
| Deep-Fix / Final-Landing trigger mode | AGENTS.md §11c (user-keyword triggered: "root_fix" / "final landing" / "全檔掃描" / "production-ready" / etc; 4-step requirement: full scan → §3b consolidation → §11b patch → re-scan; zero-error gate before new full-text version); INIT.md mirror; R32-29 / R32-30 grep parity | Yes (v3.0.5) |
| Tooling format hard rules | AGENTS.md §13.1 calculation 4-step method + §13.2 JSON schema-first / null vs NA + §13.3 Mermaid flowchart TB direction + Enter linebreaks; INIT.md mirror; R32-31 to R32-34 grep parity | Yes (v3.0.5) |

## Platform compatibility verified

| Platform | Reads governance file | Session persistence | Structured workflows | Reference |
|---|---|---|---|---|
| Codex | `AGENTS.md` native | Client-side sessions + resume | AGENTS.md directives + Agents SDK | OpenAI Codex docs |
| Claude Code | `CLAUDE.md` native; `AGENTS.md` via `@` import | Auto memory + session resume | Plan mode + skills | Claude Code docs |
| Gemini CLI | `GEMINI.md` native; `AGENTS.md` via config/import | `/memory` + session save/resume | Skills + GEMINI.md directives | Gemini CLI docs |

## Regression evidence

- Latest QA pointer: [docs/qa/LATEST.md](qa/LATEST.md)
- Current detailed report: [docs/qa/QA_REGRESSION_REPORT.md](qa/QA_REGRESSION_REPORT.md)
- Latest run snapshot (UTC): 2026-05-01, 315 automated checks (226 main + 89 legacy auto-chain), 315 pass, 0 fail; includes Phase 1 legacy quarantine + Phase 2 L4 reduction + v3.0-rc.2 §5a backup hotfix + v3.0.1 release-doc sync R29 series (12 checks) + v3.0.2 release-lifecycle 4-phase governance R30 series (6 checks) + v3.0.3 §4 entry-size cap (3 checks: #167-169) + §11a Reply Behavior baseline (6 checks: #170-175) + v3.0.4 closeout-clarity / startup-transparency / lifecycle-svg R31 series (17 checks) + v3.0.5 Tier 2 meta-instruction integration R32 series (34 checks: §0c / §3.5 FPFR / §3b anti-hardcoding / §5 preserve-original / §11a rules 6-10 / §11b Patch-only / §11c Deep-Fix / §13 Tooling Format Rules)
- **Run automated checks:** `bash docs/qa/run_checks.sh` (from project root)

## Not yet verified

- Longitudinal effectiveness across 50+ sessions
- Compliance rate across different model generations
- Performance impact of mandatory handoff/log reads at session start
