# Latest QA Regression

- Current report: [QA_REGRESSION_REPORT.md](QA_REGRESSION_REPORT.md)
- **Run automated checks:** `bash docs/qa/run_checks.sh` (from project root)
- Date (UTC): 2026-05-01
- Tag: **v3.0.6** (GA) — Closeout UX polish (Visual Cue redesign × 6 + multi-line hint → 1-line × 9 places + README × 4 Install/Upgrading 9-step → 5-step + "Behind the scenes" + Quick Op 3) "Why paste manually" + R27-10 pre-existing harness bug fix); v3.0.6 supplement (post-tag) — README Recent releases capped to most recent 5 + SVG-aligned commands across 4 README languages + LATEST_STABLE_TAG bump + DOC_SYNC strengthen
- Result: 315 total automated checks (226 main + 89 legacy auto-chain), 315 pass, 0 fail
- Focus of v3.0.6 release: 6 redesigned Visual Cues (Boot ✧/⚓/●; Closeout 🌅/🌙/🏁) with 1-cell Unicode box-drawing for monospace alignment; "paste hint" simplified to "(paste as your next session's first message)"; README Install + Upgrading restructured to 5-step flow with "Behind the scenes" callout for AI internals; Quick Op 3) explains why pasting OPENING MESSAGE manually beats `Follow AGENTS.md` short trigger (~70-85% short vs ~95%+ verbatim block); R27-10 bash exit-code capture bug fixed (legacy_checks.sh)
- v3.0.6 supplement focus: Recent releases version table capped to 5 entries (link to GitHub releases for older); 5-step lifecycle text + Quick Op 1)/2) commands aligned with SVG canonical (Follow AGENTS.md / wrap up / 收工); "Forgot to paste" callout corrected with model-specific reliability (~40-85% range, not blanket "auto-fallback works"); LATEST_STABLE_TAG="v3.0" → "v3.0.6" so R29 catches per-patch row drift; DOC_SYNC "Release published" row strengthened to mandate Recent releases bump
- Sandbox install QC: 3 HIGH-risk scenarios verified at v3.0.2 baseline; v3.0.5 + v3.0.6 changes are governance text + README polish only — sandbox re-validation deferred per §3c Phase 3 discretionary cleanup for non-mechanism releases
- Matrix QC audit reference: 10-dimension audit on prior commits resolved at v3.0.3 release
