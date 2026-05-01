# Harness Migration Notes — Legacy Quarantine

## Purpose

`docs/qa/legacy_checks.sh` quarantines 89 historical drift-defense checks (R11/R26/R27 series) that were originally part of `run_checks.sh`. They are not deleted because each one defends against a real regression that occurred during v1.x→v2.6 migrations.

## Why Quarantined

- The main `run_checks.sh` was carrying 224 grep checks, 89 of which were string-matching against historical wording. This made `AGENTS.md` text effectively un-editable: any rephrasing risked breaking grep parity.
- The 89 quarantined checks remain executable but are isolated so the main harness can shrink and `AGENTS.md` can be condensed during v3.0 work without losing historical drift defense.

## Execution Triggers (governance-driven, not memory-driven)

1. **Default auto-chain** — `bash docs/qa/run_checks.sh` automatically chains `legacy_checks.sh`. No flag needed.
2. **Explicit skip** — `LEGACY_SKIP=1 bash docs/qa/run_checks.sh` bypasses the chain. Forbidden by AGENTS.md §3c during Release/Merge verification.
3. **Staleness detection** — Main harness check `H01` fails if `AGENTS.md` mtime exceeds `.legacy_last_run` timestamp by more than 30 days. Forces a re-run before the gap grows.

## Series Inventory

### R11 — Harness Optimization Round 11 (v2.5)

| Check ID | Anchor String | Reason for Defense |
|---|---|---|
| R11-01 / R11-02 | `^\*\*CORE RULES` (heading-only; anchor tightened in v3.0.5 from raw `CORE RULES` to avoid DOC_SYNC row mentions triggering false match) | Attention anchor at top of AGENTS / INIT — without this, agents skim past §3 workflow |
| R11-03 / R11-04 | `defer to the §1 read order` | §2 SoT priority must reference §1 read order, not maintain a parallel file list |
| R11-05 | `current baseline, execution thresholds` (negative) | Old §2 file list deprecated; must not regrow |
| R11-06 / R11-07 | `^## 2c)` (negative) | §2c heading was merged into §3 in v2.5; reappearance = regression |
| R11-08 / R11-09 | `full context of the section to be modified` | §3 READ minimum coverage rule from former §2c |
| R11-10 / R11-11 | `§3 READ coverage` | §2b cross-reference correctly points at §3 |
| R11-12 / R11-13 | `QC reveals test failures` | §3 QC fail-path explicit handling |
| R11-14 / R11-15 | `receiving user direction following` | §3 deviation-resume behavior post user-direction |
| R11-16 / R11-17 | `confirm session-end intent` | §4 closeout protection against ambiguous "wrap up task" vs "wrap up session" |
| R11-18 to R11-21 | `project_doc_max_bytes` | README localized variants must keep Codex compatibility note |
| R11-22 / R11-23 | (awk position check) | §0b must remain after §4a (CONDITIONAL zone ordering) |
| R11-24 | (negative) | §2c removed from CONDITIONAL marker |
| R11-25 / R11-26 | `§5a` in CONDITIONAL marker | §5a presence in CONDITIONAL zone declaration |

### R26 — Re-Audit Fixes (v2.6)

| Check ID | Anchor String | Reason for Defense |
|---|---|---|
| R26-01 / R26-02 | `last occurring such heading` (negative) | §1 verbatim wording was rewritten; old phrasing must not regrow |
| R26-03 / R26-04 | `regardless of the entry` | §1 most-recent-dated tiebreak: physical order doesn't override date |
| R26-05 / R26-06 | `subject to the precedence rules in §2 rule 5` | §1 cross-reference to §2 rule 5 |
| R26-05b / R26-06b | `physically topmost entry wins` | §1 same-date tiebreaker rule |
| R26-07 | `single source of truth for bootstrap root safety` | INIT.md top-block delegates fully to §5a (no parallel rules) |
| R26-08 / R26-09 | `INSTALL_ROOT_OK` / `INSTALL_WRITE_OK` | Two-stage install confirmation gates |
| R26-10 / R26-11 | `randomize across styles uniformly` | Boot Visual Cue selection rule |
| R26-12 / R26-13 | `within a single session, the Closeout Visual Cue must differ` | Closeout cue distinct from Boot cue in same session |
| R26-14 / R26-15 | `if the previous style is known` (negative) | Old wording removed; must not return |
| R26-16 / R26-17 | `Editing documentation, governance rules, or templates` | §0b scope clarification (when External API rules apply) |
| R26-18 / R26-19 | `not retroactively rewritten` | §12 grandfather clause for pre-format session IDs |
| R26-20 / R26-21 | `YYYYMMDD.*HHMM` | §12 Session ID format presence |
| R26-22 to R26-27 | `Filename enforcement`, `alternative names such as`, `ARCHITECTURE.md` | §10 PROJECT_MASTER_SPEC.md filename uniqueness |
| R26-28 to R26-33 | `Remove-Item -Recurse -Force`, `git reset --hard`, `git clean -fdx` | §5 forbidden ops list |
| R26-34 / R26-35 | `If high-risk markers are detected` | §5a step 10 abort rule |
| R26-36 to R26-39 | `Major separator:` / `Minor separator:` | §4 closeout layout separator rules |

### R27 — P3 Root-Fix (v2.7)

| Check ID | Anchor String | Reason for Defense |
|---|---|---|
| R27-01 / R27-02 | `Session handoff compactness budget` | §4 budget caps existence |
| R27-03 / R27-04 | `evaluate triggers directly from \`dev/SESSION_LOG.md\`` | §4a executable maintenance trigger |
| R27-05 / R27-06 | `python docs/qa/session_log_maintenance.py` (negative) | AGENTS / INIT must not require Python runtime in user-path |
| R27-07 | `FILE 7: docs/qa/session_log_maintenance.py` (negative) | INIT install boundary excludes maintenance script |
| R27-08 | `session_log_maintenance.py` exists | maintainer-side script is present |
| R27-08b / R27-08c | `Session-log maintenance policy changed` | DOC_SYNC row presence in INIT template + dev checklist |
| R27-09 / R27-10 | python self-test + check execution | maintenance script integrity (skipped if Python unavailable) |
| R27-11 to R27-18 | `session_log_maintenance.py` / `python docs/qa/session_log_maintenance.py` (negative) | All 4 README variants must hide internal maintenance script |
| R27-19 / R27-20 | `docs/qa/run_checks.sh` / `docs/qa/session_log_maintenance.py` (negative) in INIT | INIT.md package self-containment |

## Self-Deprecation Path

A check may be retired from `legacy_checks.sh` when **all** the following are true:
1. The original drift situation has been replaced by an equivalent or stronger check in the main harness (e.g. behavior marker, structural anchor)
2. The check has passed continuously for ≥3 releases without any related drift incident
3. Removing the check is recorded in this file with a "retired" note and the replacement check ID

Retired checks are deleted from `legacy_checks.sh` (not commented out) and noted here for audit history.

## Adding to Legacy

If a future release patches a regression that depended on specific wording:
1. Add a check to `legacy_checks.sh` (do not add to main `run_checks.sh`)
2. Append a row to the appropriate series table in this file with the anchor string and defense reason
3. The check participates in auto-chain from day one

## Audit History

| Date (UTC) | Session ID | Action |
|---|---|---|
| 2026-04-25 | Claude_20260425 | Initial quarantine: 89 checks (R11×26, R26×41, R27×22) moved from run_checks.sh |
| 2026-05-01 | Claude_20260501_2000 | R11-01 / R11-02 anchor tightened from `CORE RULES` to `^\*\*CORE RULES` (heading-only). Reason: v3.0.5 DOC_SYNC rows now mention "CORE RULES marker block" as a doc-sync target, which triggered false positive on the loose pattern. Tightened anchor matches only the actual bold heading. No checks added or removed; legacy total remains 89. |
