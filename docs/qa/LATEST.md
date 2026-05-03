# Latest QA Regression

- Current report: [QA_REGRESSION_REPORT.md](QA_REGRESSION_REPORT.md)
- **Run automated checks:** `bash docs/qa/run_checks.sh` (from project root)
- Date (UTC): 2026-05-03
- Tag: **v3.0.7** (GA, latest) — onboarding wizard paradigm shift + matrix-qc audit logic root-fix + playbook dogfood patches + landing-page feature card + README locale heading drift fix
- Result: 329 total automated checks (240 main + 89 legacy auto-chain), 329 pass, 0 fail
- Focus of v3.0.7 release: (1) Wizard paradigm shift — form-fill schemas (`_visual_frame.md` / `spec_starter.md` / `runbook_starter.md`) retired; new `dev/wizards/playbook.md` behavior layer + `dev/templates/` content namespace (spec + runbook templates); user supplies 1-sentence project description, AI drafts full file + assumption list, iterates, proposes write. (2) Matrix-QC audit-logic root-fix — `.claude/agents/matrix-qc.md` Boundary-Aware Divergence section + Hard rule #2 prescriptive-verb ban; audits stay description-only. (3) Playbook dogfood patches — Step 4 closure classification (soft vs explicit write), Step 2 hallucination guardrail with `(待補)`, Step 2 explicit per-field assumption discipline. (4) README × 4 locale heading drift fix (line 248 in zh-TW / zh-CN / ja). (5) Landing page f12 feature card surfacing wizard system in 4 languages. (6) Harness R33 series rework 17 → 14 checks, EXPECTED_INDEX_COUNTER 332 → 329
- Prior v3.0.6 supplement focus: Recent releases version table capped to 5 entries; 5-step lifecycle text + Quick Op 1)/2) commands aligned with SVG canonical; "Forgot to paste" callout corrected with model-specific reliability (~40-85% range); LATEST_STABLE_TAG="v3.0" → "v3.0.6" so R29 catches per-patch row drift; DOC_SYNC "Release published" row strengthened
- Original v3.0.6 GA focus: 6 redesigned Visual Cues (Boot ✧/⚓/●; Closeout 🌅/🌙/🏁); "paste hint" simplified; README Install + Upgrading restructured to 5-step flow; Quick Op 3) explains why pasting beats short trigger; R27-10 bash exit-code capture bug fixed
- Sandbox install QC: 3 HIGH-risk scenarios verified at v3.0.2 baseline; v3.0.5 + v3.0.6 changes are governance text + README polish only — sandbox re-validation deferred per §3c Phase 3 discretionary cleanup for non-mechanism releases
- Matrix QC audit reference: 10-dimension audit on prior commits resolved at v3.0.3 release
