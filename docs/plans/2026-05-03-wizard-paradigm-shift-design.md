# Wizard Paradigm Shift — Design

**Date:** 2026-05-03
**Status:** Brainstorm validated; FPFR rework plan to follow in subsequent session
**Sessions referenced:**
- `Claude_20260503_1700` — paradigm shift root cause + 4-round dogfood findings
- `Claude_20260503_1627` — §11a rule 2 meta-patch + Q1–Q6 brainstorm (this design doc)

---

## 1. Context

### 1.1 Prior paradigm
The current onboarding wizard system (shipped Phase 1, session `Claude_20260503_1500`) uses a **5–7 step structured Q&A schema**. AI reads `dev/wizards/<name>_starter.md`, asks each step's question with declared options (3–6), records answers, then writes the output file at the end.

### 1.2 Critique that triggered the shift
4-round dogfood critique in session `Claude_20260503_1700` surfaced progressively deeper issues:
1. 3 options too few → expanded to 6 + dynamic frame
2. Abstract structure axis misaligned with user mental model → swapped to deliverable-domain enum
3. Question wording still ambiguous (user identity vs project type)
4. Step 3 deliverable form missing workflow/SOP type

**Root finding (accepted):** form-fill paradigm itself (5–7 cold questions answered upfront) mismatches:
- Modern Agentic AI collaboration pattern (user 1-sentence prompt → AI 推理 first-cut draft + assumptions → spot-check + correct → iterate → write file)
- The repo's actual user base beyond AI coding (marketing campaigns, branding, social media, publishing, script writing, business research)

User accepted reframe; chose deferred systematic rework over reactive fix-in-place.

### 1.3 Brainstorm session output
Session `Claude_20260503_1627` produced 7 explicit decisions (Q1–Q6 user-scope + Q2 AI-scope) defining the new paradigm. Mid-session meta-patch to AGENTS.md §11a rule 2 (Layer A Ask-gate + Layer B Outcome preview) was extracted because the brainstorm itself surfaced that AI's own choice format inherited the same form-fill flaw.

---

## 2. Validated Decisions

### Q1 — Scope (user-scope)
**Decision:** spec + runbook share the same new paradigm.

INIT.md POST-INSTALL Profile Selection (also form-fill) is **separate scope**, deferred for evaluation in a future session — it is a one-time install decision over a fixed 6-value enum, not a long-term project doc.

### Q2 — Architecture (AI-scope, decided by AI)
**Decision:** behavior / content separation.

| File | Role |
|---|---|
| `dev/wizards/playbook.md` | Single file. Behavior layer — how the draft+iterate paradigm works (when to engage, the loop, assumption surfacing rules, close-out signals, escape-hatch discipline). |
| `dev/templates/spec_template.md` | Content layer — field structure for `dev/PROJECT_MASTER_SPEC.md`, with example fills. Standalone reference value (a user can self-fill without invoking AI). |
| `dev/templates/runbook_template.md` | Content layer — field structure for `dev/RUNBOOK.md`, with example fills. Same standalone value. |

`dev/templates/` is a new namespace.

**Rationale:** the prior paradigm's form-fill mental model melted behavior (Q&A flow) and content (doc field shape) into one schema file. Splitting them releases each to evolve independently and makes templates useful even outside the wizard.

### Q2' — Body experience (user-scope)
**Decision:** **AI generates one-shot full draft + assumption list for user spot-check.**

Rejected:
- Per-section step-by-step confirmation (regresses to mini form-fill)
- Silent draft without assumption listing (transparency too low)

### Q3 — Trigger (user-scope)
**Decision:** preserve §3 PLAN auto-trigger + PROFILE.md `wizard_disabled_*` decline persistence.

The form-fill body was the friction source, not the trigger itself. With the body fixed, auto-trigger remains valuable for new-user discoverability.

### Q4 — Assumption block format (user-scope)
**Decision:** full short-bullet list, transparency優先.

AI surfaces all key assumptions made (typical 5–12 bullets), numbered, terse. User can target by index ("③⑤") or natural-language correction.

Rejected:
- Low-confidence-only filtered list (AI's self-confidence judgment can be wrong; high-confidence assumptions may need challenge)
- Per-section grouping (no confidence signal; longer review)

### Q5 — Iteration termination (user-scope)
**Decision:** AI observes close-out signal and proposes write.

AI watches for:
- Two consecutive turns with no new modifications
- Closure language ("OK", "啱", "夠", "ready", "down", "good")

Then proposes: *"我寫入 `<output_path>`?"* User can confirm, or defer with *"等等仲要改 X"* to extend the loop.

Rejected:
- Pure user-explicit trigger (user may forget to write; draft trapped in conversation)
- Auto-write each iteration (file thrash; partial-state file confuses readers)

### Q6 — Vague input fallback (user-scope)
**Decision:** when 1-sentence input is too vague to draft, AI uses §11a rule 2 choice format to surface 3 plausible interpretations, **paired with a mandatory escape hatch** in the same prompt.

Format invariant: every choice prompt at this paradigm step must read as
> *"揀 A/B/C **或者俾多少少 context**"*

If user picks A/B/C → AI uses that interpretation as context, returns to main draft loop.
If user supplies free-form context (the "D" path) → AI uses that as context, returns to main draft loop.

**The escape hatch must never be stripped** — without it, the prompt regresses to a small forced-choice form-fill, contradicting paradigm intent.

Rejected:
- Always draft regardless of vagueness (extreme drafts waste a turn when input is truly empty)
- Compulsory 1–2 follow-up questions (regresses to mini form-fill)

---

## 3. Composite Sample Flow

```
[§3 PLAN entry; AI sees dev/PROJECT_MASTER_SPEC.md missing; PROFILE.md no decline flag]

AI:  我準備開始你個任務。留意到冇 dev/PROJECT_MASTER_SPEC.md，
     要唔要我即刻幫你 draft？俾我 1 句項目描述就得。
     (唔需要話「skip」即過，下次唔再提)

用戶: 我做緊個社區貓 platform

AI:  [一次過 draft 全文 ~60-150 行]

     我假設咗:
     ① 對象 = 香港養貓人 + 街坊
     ② 形式 = web app
     ③ 主要功能 = 照片打卡 + 領養
     ④ 資料來源 = 街頭觀察 + TNR 紀錄
     ⑤ 業務模式 = 非營利
     ⑥ 時程 = 3 個月 MVP
     ⑦ 成功指標 = 註冊數 + 活躍數
     邊條要改？

用戶: ③ 主要係街坊互助、② iOS app

AI:  [按 ②③ 改、全 doc 重 draft + 新假設清單]
     仲有冇要改？

用戶: 啱晒

AI:  好，我寫入 dev/PROJECT_MASTER_SPEC.md？

用戶: 寫

AI:  [寫入]
     已寫入。之後想改隨時直接編輯，或同我講。
```

### Vague-input branch sample

```
用戶: 整個 spec

AI:  「整個 spec」我見有 3 個方向:
     A. 個人 side-project（玩具／工具）
     B. 社區或開源 project
     C. 商業 SaaS / 內部工具
     揀邊個或者俾多少少 context

用戶: D — 我做緊個社區貓 platform 主打街坊互助

AI:  [收到 context、即按 D 描述 draft + 假設清單]
     [回到主 loop]
```

---

## 4. AI-scope Implementation Items (decided by AI)

These follow from the user-scope decisions above. No further user input needed; included here so the FPFR rework plan has a complete picture.

| Item | Action | Reason |
|---|---|---|
| `dev/wizards/_visual_frame.md` | DELETE | Visual frame (step label / progress dots) presupposes step-based form-fill; new paradigm is one-shot draft + iterate, no steps. |
| `dev/wizards/spec_starter.md` | DELETE (or git-history archive) | Content fully replaced by `dev/wizards/playbook.md` + `dev/templates/spec_template.md` separation. |
| `dev/wizards/runbook_starter.md` | DELETE (or archive) | Same as above for runbook. |
| `dev/wizards/README.md` | REWRITE | Becomes overview of playbook + templates pair, not schema-format docs. |
| `dev/wizards/playbook.md` | NEW | Behavior layer per Q2 architecture. |
| `dev/templates/spec_template.md` | NEW | Content layer for spec. |
| `dev/templates/runbook_template.md` | NEW | Content layer for runbook. |
| `AGENTS.md §3.6` | REWRITE | Reflect new paradigm — playbook + templates references, draft+iterate flow, escape-hatch discipline; PROFILE.md schema paragraph preserved. |
| `INIT.md FILE 1 §3.6` | MIRROR | Byte-aligned with AGENTS.md §3.6 rewrite. |
| `harness R33-04..14` | REWORK or RETIRE | Form-fill structure assumptions (declared options, step labels, progress dots, 4-lang option strings) invalidated by paradigm shift. New checks per playbook + templates structure. |
| `dev/DOC_SYNC_CHECKLIST.md` rows 34, 35 | UPDATE | "Wizard schema added or changed" semantics shift to "playbook or template added or changed"; "Profile selector logic" row out of scope this rework. |
| `INIT.md` install POST-INSTALL Wizard Auto-Trigger block | UPDATE | Trigger model preserved, but reference path changes (playbook + templates). |
| `README.md` × 4 Quick Op 4 | UPDATE | User-facing description shifts from "wizard 7-step Q&A" to "AI drafts spec + you spot-check". 4 pure-language registers preserved. |

---

## 5. Open Follow-ups (out of scope this rework)

1. **INIT.md POST-INSTALL Profile Selection** — also a form-fill paradigm (one-time 6-value enum at install). Separate evaluation: keep current form, apply paradigm shift, or replace with profile-inference from user's first task. Defer to future session.
2. **Runbook-specific semantics** (trigger conditions, rollback paths, acceptance gates) — implementation detail to be solved in `runbook_template.md` content design during rework.
3. **Production observation** — paradigm shift validation requires real user sessions outside dogfood. Carry over from prior backlog.

---

## 6. References

- AGENTS.md §3.6 — current onboarding wizard system (to be rewritten)
- AGENTS.md §11a rule 2 — Layer A Ask-gate + Layer B Outcome preview discipline (encoded mid-brainstorm; this paradigm leverages Layer B preview style)
- AGENTS.md §3 PLAN onboarding readiness check — auto-trigger flow (preserved)
- `dev/PROFILE.md` schema (`wizard_disabled_*` flags) — decline persistence (preserved)
- Session `Claude_20260503_1700` SESSION_LOG entry — root cause analysis + dogfood findings
- Session `Claude_20260503_1627` SESSION_LOG entry — meta-patch + brainstorm Q1–Q6 progression
- `docs/plans/2026-04-08-governance-audit-fixes.md` — prior naming-convention reference for design docs

---

## 7. Hand-off to Rework Session

Next session enters at FPFR plan stage:
- Use this document as the GOAL LINK (§3.5 Section 5)
- END-STATE SNAPSHOT covers the file table in §4 above
- DELIVERABLES enumerate the rewrites / creates / deletes
- METRICS measure pre→post line counts, harness check delta, AGENTS.md → ETH Zurich threshold trajectory
- ACCEPTANCE TEST: harness 332/332 (or whatever new count) PASS; sample flow §3 above produces a coherent first draft + assumption list against a real test prompt

No further user input is required to scope the rework. The next session's first action should be issuing the FPFR plan referencing this document.
