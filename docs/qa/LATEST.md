# Latest QA Regression

- Current report: [QA_REGRESSION_REPORT.md](QA_REGRESSION_REPORT.md)
- **Run automated checks:** `bash docs/qa/run_checks.sh` (from project root)
- Date (UTC): 2026-05-01
- Tag: **v3.0.5** (GA) — Tier 2 meta-instruction integration: §0c Preference Priority Order + §3.5 FPFR + §11a expanded (5→10 rules) + §11b Patch-only + §11c Deep-Fix + §13 Tooling Format Rules
- Result: 315 total automated checks (226 main + 89 legacy auto-chain), 315 pass, 0 fail
- Focus of latest run: §0c priority order + 5-item list parity (R32-01..04), §3.5 FPFR section + 5-section headings + closing line + trigger conditions + §3 PLAN cross-ref (R32-05..12), §3b anti-hardcoding (R32-13..14), §5 rule 9 preserve original (R32-15..16), §11a rules 6-10 — reply skeleton / emoji vocab / output-only / SSOT verbatim / register (R32-17..26), §11b Patch-only (R32-27..28), §11c Deep-Fix (R32-29..30), §13 Tooling Format Rules with 3 subsections (R32-31..34)
- Sandbox install QC: 3 HIGH-risk scenarios verified at v3.0.2 baseline; v3.0.5 governance text additions are universal mirror parity changes — sandbox re-validation deferred per §3c Phase 3 discretionary cleanup for governance text-only releases
- Matrix QC audit reference: 10-dimension audit on prior commits resolved at v3.0.3 release
