# Latest QA Regression

- Current report: [QA_REGRESSION_REPORT.md](QA_REGRESSION_REPORT.md)
- **Run automated checks:** `bash docs/qa/run_checks.sh` (from project root)
- Date (UTC): 2026-05-01
- Tag: **v3.0.3** (GA) — §4 entry-size cap (≤110) + §11a Reply Behavior governance
- Result: 264 total automated checks (175 main + 89 legacy auto-chain), 264 pass, 0 fail
- Focus of latest run: §4 entry-size cap (R-checks #167-169 + STATE_DETAIL escape valve), §11a Reply Behavior 5 mandatory rules (R-checks #170-175 + new marker line MANDATORY REPLY DISCIPLINE), HANDOFF baseline drift fix (carry-over numbers from prior closeout)
- Sandbox install QC: 3 HIGH-risk scenarios verified at v3.0.2 baseline (re-install with user overflow files / §5a pwd≠git-root mismatch / §4 closeout end-to-end); v3.0.3 governance text additions are universal mirror parity changes — sandbox re-validation deferred per §3c Phase 3 discretionary cleanup for patch-level releases
- Matrix QC audit reference: 10-dimension audit on current main HEAD — verdict PARTIAL pre-release with 5 findings (HIGH×2 README Snapshot drift + MEDIUM×1 README safeguards row + LOW×2 minor); HIGH and MEDIUM resolved by this release's doc-sync; re-audit at this commit pending
