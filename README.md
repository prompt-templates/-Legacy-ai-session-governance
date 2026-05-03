English | [繁體中文](README.zh-TW.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md)

# :rocket: Governance Template for Cross-AI Handoff Workflows

When your Codex / Claude / Gemini quota runs out, paste the handoff block into the next AI and it picks up where you left off.

- Handoff works across different AI CLIs
- Standard workflow: `PLAN -> READ -> CHANGE -> QC -> PERSIST`
- Keeps governance from drifting, instead of just adding more rules
- A harness engineering component focused on session continuity

**[How a session works](#quickstart)** · **[Install](#install)** · **[Upgrade](#upgrade)** · **[Quick Operations](#quick-operations)**

![Overview](ref_doc/overview_infograph_en.png)

> **🆕 First time here?** The **[Interactive Introduction](https://prompt-templates.github.io/ai-session-governance/)** walks you through what this template does in about 5 minutes — recommended before reading the rest of this README.


---

## :bookmark_tabs: Why this exists

With multiple AI tools, handoff is usually what breaks first — not output quality.

Common failure pattern:
- Context resets every time you switch tools
- Fixes pile on top of fixes, rules get messier
- README, handoff docs, and logs stop matching

This template requires:
1. One re-entry path every session
2. One workflow for every task
3. One persistent record before closing

---

## :bookmark_tabs: Built-in safeguards

It also catches a few common AI mistakes:

| Safeguard | What it prevents |
|---|---|
| **PLAN risk grading** | Proceeding with high-risk tasks (≥3 files, ambiguous scope, destructive ops, external systems) before confirming the AI understood correctly — high-risk plans pause for user confirmation |
| **External API Code Safety** | Writing API-calling code from hallucinated endpoint / schema memory; requires doc-verified baseline before coding |
| **Codebase context snapshot** | Relearning tech stack, external services, and key decisions from scratch every session |
| **Test plan governance** | Merging changes without a scenario matrix — expected vs. actual outcomes untracked |
| **Consolidation discipline** | Rule accumulation without checking whether existing rules should be updated first |
| **Doc-sync registry** | Guessing which docs to update after a change — `DOC_SYNC_CHECKLIST.md` maps change category to required updates so AI looks up instead of self-assessing |
| **Session log maintenance** | Session history growing to thousands of lines and consuming AI context window — during closeout, AI applies built-in trigger rules to archive old entries and keep startup context lean |
| **QC fail-path** | AI silently retrying or abandoning failed tests — when tests or builds fail, AI must report what failed, diagnose the cause, and wait for user direction instead of auto-retrying |
| **Closeout ambiguity guard** | Accidentally triggering full session closeout with casual remarks like "thanks, that's all I needed" — AI confirms session-end intent when the expression is ambiguous |
| **Reply behavior governance** | AI replying with disguised open questions, padding choice lists with bad options, asking too many clarifying questions, presenting unverified facts as confirmed, or using internal `§` codes as sentence subjects — §11a (v3.0.3 baseline + v3.0.5 expanded) makes 10 rules mandatory: judgement-first with role-split, prescribed choice format (`🚀 *下一步揀一條*` + A/B/C + `💡 推薦`), ≤3 hypotheses + ≤3 questions per round, `UNVERIFIED` distinct from `NA`, plain-language surface text with counter-examples, reply skeleton (`🔎` highlights → deliverables → body), functional emoji vocabulary (🔎/✅/❌/⚠️/📌/💡/🚀), Output-only mode override, SSOT verbatim alignment, reply register consistency |
| **Full-picture-first plans** | AI dumping multi-file or governance changes as ad-hoc text without showing the end state, deliverables, metrics, acceptance test, and goal link first — §3.5 FPFR (v3.0.5) makes 5 fixed sections + verbatim closing line mandatory whenever ≥2 files / new file / governance change / ≥2-phase plan is on the table; "approve A? approve B?" item-by-item prompts are explicitly prohibited |
| **Patch-only delivery format** | AI delivering code / spec / config changes as walls of regenerated text with no anchor or before/after, making review and rollback hard — §11b (v3.0.5) requires precise anchor outside code blocks, BEFORE / AFTER blocks containing only verbatim text, and a Changelog listing added / removed / renamed / moved items |
| **Cross-rule arbitration** | AI arbitrarily picking between conflicting rules (e.g. "minimal modification" vs "fix the root cause") with no consistent priority — §0c (v3.0.5) sets explicit priority order: verifiable correctness > stability > root-cause > completeness > minimal-modification; items 1-4 always override item 5 |
| **Tooling format hard rules** | AI shipping calculations without showing work, JSON without schema, Mermaid with random direction — §13 (v3.0.5) requires calculation 4-step method (digit-by-digit + sign-before-transpose + steps + verify-by-substitution), JSON schema-first with `null` for missing required fields, Mermaid `flowchart TB` with quoted text labels |

### :small_blue_diamond: How SESSION_LOG.md stays manageable

`dev/SESSION_LOG.md` is read at every session start. In an active project this file can grow to thousands of lines — loading months of history that has no relevance to today's work.

The template handles this with explicit closeout checks (not memory-only rules):

- At closeout, AI checks whether `SESSION_LOG.md` exceeds **400 lines** or contains entries older than **30 days**
- If a trigger is hit, AI archives old entries before writing the new closeout entry
- If no trigger is hit, AI skips archive and writes closeout normally
- Archived entries are moved to `dev/archive/` (never deleted), organized by quarter: `SESSION_LOG_YYYY_QN.md`
- The active log target is ≤ **200 lines** while retaining the 2 most recent sessions
- AI reads only `SESSION_LOG.md` at startup — archive files are not loaded

If you already have a large session log, it is trimmed automatically on the first session close after upgrading. No manual step needed.

---

## :bookmark_tabs: Recent releases

Most recent 5 versions only — see [full release history on GitHub](https://github.com/prompt-templates/ai-session-governance/releases) for older entries.

| Version | What changed | Why it matters |
|---|---|---|
| **v3.0.6** | Closeout UX polish: 6 redesigned session boot/closeout visuals, the "paste this block" caption shortened from 3 lines to 1 line, and README's install/upgrade flow shortened from 9 steps to 5 with a "behind the scenes" callout for AI internals. README's Resume section now explains why pasting the OPENING MESSAGE manually beats relying on `Follow AGENTS.md` (~95% vs ~70-85% reliability). Pre-existing harness exit-code bug (R27-10) patched. | New users get a much shorter, cleaner install flow. Sessions look better at boot/close. The "why paste manually" answer removes a common source of confusion when switching AI tools. |
| **v3.0.5** | The full reply protocol now lives in governance, not just a "universal" subset. Replies arrive with `🔎` highlight bullets first, then a deliverables checklist, then explanation. Choice prompts use a consistent `🚀 *下一步揀一條*` + A/B/C + `💡 推薦` menu. Multi-file and governance changes trigger a full-picture-first plan with 5 fixed sections (END-STATE / DELIVERABLES / METRICS / ACCEPTANCE / GOAL LINK) and a verbatim closing line — no more "approve A? approve B?" rounds. Code / spec / config changes arrive as patches: precise anchor outside code blocks, BEFORE / AFTER blocks containing only verbatim text, plus a Changelog. Numerical answers show all four steps. JSON output defines schema first. Mermaid uses `flowchart TB` with quoted labels. When two rules conflict, AI follows an explicit priority order (verifiable correctness > stability > root-cause > completeness > minimal-modification) instead of arbitrarily picking. | The reply experience is now consistent and scannable: top-down highlights → checklist → body, with no internal `§` codes leaking into surface text. Plans for non-trivial work are always full-picture-first, so you can veto or modify the whole thing in one read — instead of approving piece by piece. Patches are review-friendly and paste-replaceable. The arbitration rule means AI no longer trades verifiability for "smaller diff" — verifiable correctness always wins. |
| **v3.0.4** | The closeout block at the end of each session is now labelled "NEXT SESSION OPENING MESSAGE" with a one-line hint underneath ("paste this as the first message of your next AI session") so it's clear where it goes. At session start, AI prints which source it used to seed the session — paste, auto-fallback from your saved note, or both — so you can tell whether your paste was needed. The README now teaches the full daily flow (start → work → close → resume) with a visual flow chart in 4 languages, instead of stopping at install. A new release-notes template makes every release lead with "What you'll feel". | No more "where do I paste this?" confusion at the end of a session. No more guessing whether AI started blank or picked up automatically. New users see the full lifecycle right in the README, not just the install step. |
| **v3.0.3** | AI replies became more direct: when AI has a recommendation, it now states it instead of pushing the decision back as an open question. Choices come capped at 3 options with one explicit recommendation. Numbers and facts the AI hasn't verified are marked `UNVERIFIED` so you can tell them apart from confirmed information. Internal rule codes no longer appear as sentence subjects in user-facing replies. Each closeout entry in the session log is hard-capped at ≤110 lines, with release-class detail moved to a separate file so startup stays fast even on release-heavy weeks. | Less back-and-forth on simple tasks. Clearer state on what AI has and hasn't verified. Replies readable without needing to know any governance terminology. Long-running projects don't slow down at session startup. |
| **v3.0** (incl. v3.0.1 / v3.0.2 patches) | Major governance-file slim-down: AGENTS.md cut from 734 to 504 lines (−31.3%) while preserving every rule; system-prompt token cost per session boot down ~15.6%. A legacy quarantine moves 89 historical drift-defense checks into an auto-chained second harness — the main check suite stays lean but bypassing legacy is forbidden during release verification. v3.0.1 added release-doc sync governance (R29-series checks) preventing README/index.html drift. v3.0.2 expanded the release/merge gate into a 4-phase lifecycle (pre-release verification / release execution / post-release cleanup / observability) with R30-series enforcement. Users who created `dev/SESSION_STATE_DETAIL.md` or `dev/PROJECT_MASTER_SPEC.md` are properly backed up on re-install (data-safe upgrade path). | Less governance text in every system prompt → higher rule-adherence rate (industry data: short rules ~89% vs verbose ~35%). Release-related drift is automatically caught (READMEs, release notes, public site stat counters all stay in sync). Existing local notes are preserved on upgrade. Cross-LLM compatibility maintained across Claude Code, Claude Cowork, OpenAI Codex CLI, and Gemini CLI — zero hook dependency. |

---

<a id="quickstart"></a>

## :bookmark_tabs: How a session works

After installing once, every session follows the same loop:

![Lifecycle flow](ref_doc/lifecycle_flow_en.svg)

### :small_blue_diamond: 5 steps, end-to-end

1. **Install** (one-time): paste **[INIT.md](INIT.md)** into your AI tool, then confirm `INSTALL_ROOT_OK: <absolute_path>` and `INSTALL_WRITE_OK`.
2. **Start a session**: type `Follow AGENTS.md`. AI catches up on what you were doing.
3. **Work**: ask AI to build features, fix bugs, write docs — anything.
4. **Close**: type `wrap up`. AI hands you a **NEXT SESSION OPENING MESSAGE** block.
5. **Next session**: paste that block as your first message — and you're back at step 2 instantly.

> **Forgot to paste in step 5?** Pasting is still the most reliable path — AI's `SESSION_LOG.md` auto-fallback varies from ~40% to ~85% depending on AI tool and model. See [Quick Operations](#quick-operations) §3 "Why paste manually" below for the full breakdown.

---

<a id="install"></a>

## :bookmark_tabs: Install

1. Open the AI tool of your choice (Codex / Claude Code / Claude CoWork / Gemini CLI) at the project folder where you want governance installed.
2. Open **[INIT.md](INIT.md)** → click **Raw** → copy all.
3. Paste into the AI dialog and submit.
4. AI replies asking for two confirmations — reply each on its own line:
   - `INSTALL_ROOT_OK: <absolute_path>`
   - `INSTALL_WRITE_OK`
5. Done — AI prints a **Quick Start** block when finished.

> **Behind the scenes (no action needed):** AI runs a root safety preflight (prints `pwd` + `git root`, stops if they differ so you can choose), shows a dry-run plan (`create` / `merge` / `skip`) before any write, and creates a backup snapshot of any existing governance files at `dev/init_backup/<UTC_TIMESTAMP>/`.

### :small_blue_diamond: Install UI walkthrough

<table>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_1.png" alt="Install step 1" width="92%" />
      <br />
      <sub>Step 1: Paste `INIT.md` into your AI CLI</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_2.png" alt="Install step 2" width="92%" />
      <br />
      <sub>Step 2: Review detected roots</sub>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_3.png" alt="Install step 3" width="92%" />
      <br />
      <sub>Step 3: Confirm `INSTALL_ROOT_OK`</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_4.png" alt="Install step 4" width="92%" />
      <br />
      <sub>Step 4: Confirm `INSTALL_WRITE_OK`</sub>
    </td>
  </tr>
</table>

After step 4, AI creates a backup before writing anything.

### :small_blue_diamond: Real run snapshots

<table>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/launch.png" alt="Launch screen" width="92%" />
      <br />
      <sub>Launch: session boot and context loading</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/closesession.png" alt="Close session screen" width="92%" />
      <br />
      <sub>Closeout: session summary and handoff output</sub>
    </td>
  </tr>
</table>

Don't copy the repo manually. Use `INIT.md` — it handles merging safely into your existing files.

**Already installed and want to upgrade?** Same `INIT.md` flow — see [Upgrading](#upgrade) below.

---

<a id="upgrade"></a>

## :bookmark_tabs: Upgrading from a previous version

Same flow as Install — re-run `INIT.md` against the same project root.

1. Open the same AI tool at your installed project folder.
2. Open **[INIT.md](INIT.md)** → click **Raw** → copy all.
3. Paste into the AI dialog and submit.
4. AI replies asking for two confirmations — reply each on its own line:
   - `INSTALL_ROOT_OK: <absolute_path>`
   - `INSTALL_WRITE_OK`
5. Done — AI backs up existing files, merges new governance content, preserves your custom rules.

**Optional safe-upgrade prompt** (paste this before step 3 for extra protection):

```text
Upgrade governance with this INIT.md in merge-only mode.
Do not overwrite, delete, or reset any of my existing custom governance rules/content/files.
Show the dry-run plan first (create/merge/skip), then wait for my confirmations: INSTALL_ROOT_OK and INSTALL_WRITE_OK.
```

> **Behind the scenes (no action needed):** AI backs up existing `AGENTS.md` / `CLAUDE.md` / `GEMINI.md` / `dev/*` files into `dev/init_backup/<UTC_TIMESTAMP>/`, then merges governance sections — your custom content, `dev/DOC_SYNC_CHECKLIST.md` custom rows, and `dev/SESSION_HANDOFF.md` / `dev/SESSION_LOG.md` are all preserved. Works from any previously installed version.

---

<a id="quick-operations"></a>

## :bookmark_tabs: Quick Operations

### :small_blue_diamond: 1) Start a session

```text
Follow AGENTS.md
```

### :small_blue_diamond: 2) Close with full handoff

```text
wrap up
```

### :small_blue_diamond: 3) Resume in another AI CLI

```text
<Paste the previous session's "NEXT SESSION OPENING MESSAGE" block as your first message.>
```

> **Why paste manually instead of just `Follow AGENTS.md`?** Governance is designed so AI auto-reads your saved handoff from `SESSION_LOG.md` — that's the self-contained intent. In practice, the short `Follow AGENTS.md` trigger reliability varies widely by AI tool and model: Claude Code Opus ~85%, Claude Code Sonnet ~60%, CoWork Opus ~75%, CoWork Sonnet ~40%. The OPENING MESSAGE block is a longer explicit prompt — its first two lines anchor the receiving AI to read all 4 governance files in order, pushing reliability to ~75-98% across the same matrix. One extra paste removes the guesswork. When in doubt, paste.

![Why paste manually](ref_doc/why_paste_handoff_en.svg)

### :small_blue_diamond: 4) Build a starter project spec or runbook (guided wizard)

```text
build master spec
```

(or `build runbook` for a recurring procedure runbook)

> **What it does:** AI runs a 5-7 step Q&A wizard. Each step shows a pre-filled answer, 2-3 alternative options, and AI's recommendation with reasoning — you just pick (or say "skip"). Designed for new users who don't know what `PROJECT_MASTER_SPEC.md` or `RUNBOOK.md` should contain. Schemas live in `dev/wizards/` and render with a star-themed (✦) frame in 4 languages (en / zh-TW / zh-CN / ja). The wizard also auto-fires once at first install (POST-INSTALL: Profile Selection step in `INIT.md`) so first-time users don't need to know the wizard exists.

---

## :bookmark_tabs: Quota-switch handoff flow

1. Work in CLI-A until quota is near limit
2. Ask for closeout and copy the generated handoff block
3. Open CLI-B and paste the block unchanged
4. CLI-B continues from the same baseline using `SESSION_HANDOFF.md` + `SESSION_LOG.md`

This is the primary design target of this repo.

---

## :bookmark_tabs: Platform setup

`AGENTS.md` is the single governance source of truth. `CLAUDE.md` and `GEMINI.md` are thin pointers.

| Platform | Native file | What ships | Existing file action |
|---|---|---|---|
| **Codex** | `AGENTS.md` | full governance rules | merge governance sections |
| **Claude Code** | `CLAUDE.md` | pointer: `@AGENTS.md` | prepend `@AGENTS.md` |
| **Gemini CLI** | `GEMINI.md` | pointer: `@./AGENTS.md` | prepend `@./AGENTS.md` |

> **Codex users:** AGENTS.md exceeds the default 32 KiB context limit. Add `project_doc_max_bytes = 49152` to `~/.codex/config.toml` to load the full file.

---

## :bookmark_tabs: 3 scenarios

### :small_blue_diamond: Scenario 1 — Quota exhausted, switch AI and continue
You hit quota in one CLI and must switch immediately.  
This template preserves baseline, pending tasks, risks, and validation state so work continues without re-explaining context.

### :small_blue_diamond: Scenario 2 — One repo, multiple AI agents
Different agents handle code, docs, and infra.  
Shared handoff/log discipline prevents parallel reality drift.

### :small_blue_diamond: Scenario 3 — Long-lived repo with governance drift
Fixes keep accumulating and docs diverge.  
Consolidation-before-adding rules reduce SOP sprawl and maintenance cost.

---

## :bookmark_tabs: FAQ

For a visual walkthrough of common questions, see the **[Interactive Introduction](https://prompt-templates.github.io/ai-session-governance/)**.

### :small_blue_diamond: 1) Is this only for large projects?
No. Small repos benefit right away; larger ones see more gain over time.

### :small_blue_diamond: 2) Do I need `PROJECT_MASTER_SPEC.md` on day one?
No. Start with `AGENTS.md` + `SESSION_HANDOFF.md` + `SESSION_LOG.md`.

### :small_blue_diamond: 3) Is this a coding style guide?
No. It governs how AI reads, changes, verifies, and hands over work — not how you write code.

### :small_blue_diamond: 4) Will this slow sessions down?
There's a short read at startup. Usually less overhead than re-explaining context and redoing mistakes.

### :small_blue_diamond: 5) Can I keep my existing docs and internal rules?
Yes. It merges with what you already have — it doesn't overwrite things.

### :small_blue_diamond: 6) When is this overkill?
If you're asking a quick question, doing one-off research, or running a single session you won't come back to — skip this. The startup reads and closeout writes add overhead that only pays off when you'll return to the same project across multiple sessions.

This template was built for ongoing development work: codebases you'll touch again tomorrow, repos where multiple AI tools take turns, projects where "what did we decide last week" actually matters. If your workflow doesn't involve files that change over time, the PLAN→READ→CHANGE→QC→PERSIST cycle has nothing to wrap around.

## :bookmark_tabs: Repository source layout

```text
<PROJECT_ROOT>/
├─ INIT.md
├─ AGENTS.md
├─ CLAUDE.md
├─ GEMINI.md
├─ docs/
│  └─ ...
└─ dev/
   ├─ SESSION_HANDOFF.md
   ├─ SESSION_LOG.md
   ├─ archive/                 # auto-archived log entries (quarterly)
   ├─ DOC_SYNC_CHECKLIST.md    # doc-sync registry
   ├─ CODEBASE_CONTEXT.md      # auto-generated first session
   └─ PROJECT_MASTER_SPEC.md   # optional
```

### :small_blue_diamond: Core files

- `INIT.md` - bootstrap prompt (public entry point)
- `AGENTS.md` - governance source of truth
- `CLAUDE.md` - Claude pointer to SSOT
- `GEMINI.md` - Gemini pointer to SSOT
- `dev/SESSION_HANDOFF.md` - current baseline and next priorities
- `dev/SESSION_LOG.md` - session-by-session history and validation (rolling window, auto-trimmed)
- `dev/archive/` - auto-archived session log entries, organized by quarter; not read at startup
- `dev/DOC_SYNC_CHECKLIST.md` - doc-sync registry: maps change category to required doc updates
- `dev/CODEBASE_CONTEXT.md` - tech stack, external services, key decisions (auto-generated first session)
- `dev/PROJECT_MASTER_SPEC.md` - optional long-term authority

---

## :bookmark_tabs: Governance principles

1. Read before change
2. Triage before debug
3. Consolidate before adding
4. Verify before claiming done
5. Persist before leaving

---

## :bookmark_tabs: Verification

Full verification details:
- [docs/VERIFICATION.md](docs/VERIFICATION.md)
- Latest QA regression report: [docs/qa/LATEST.md](docs/qa/LATEST.md)

Snapshot status (as of 2026-05-01 — v3.0.6):
- AGENTS/INIT rule parity: verified (315-check automated regression — 226 main + 89 legacy auto-chain)
- AGENTS.md governance scope: 530 → 687 lines (+29.6%) at v3.0.5 Tier 2 integration; v3.0.6 visual cue refresh + hint simplification line-count-neutral; cumulative −6.4% vs v2.x baseline (734); all rules + 290 grep-anchors preserved (212 baseline + R29×12 + R30×6 + entry-cap×3 + reply-behavior×6 + R31×17 + R32×34)
- Sandbox install QC: 3 HIGH-risk scenarios PASS (re-install with user overflow files / §5a `pwd ≠ git root` mismatch / §4 closeout end-to-end)
- Matrix QC audit (10-dimension) on sandbox install: PASS (LOW finding from rc.1 resolved by rc.2 hotfix)
- Handoff efficiency validation: still valid (30-scenario matrix from v2.7; required handoff fields preserved while startup payload decreased)
- Multi-platform pointer behavior: verified

---

## :bookmark_tabs: Deep docs

If this repo grows, recommended companion docs:
- `dev/PROJECT_MASTER_SPEC.md`
- `docs/OPERATIONS.md`
- `docs/POSITIONING.md`

Current minimum:
- `AGENTS.md`
- `dev/SESSION_HANDOFF.md`
- `dev/SESSION_LOG.md`

---

## :bookmark_tabs: Designer

> Designed by **[Adam Chan](https://www.facebook.com/chan.adam)** · [i.adamchan@gmail.com](mailto:i.adamchan@gmail.com)
>
> *Built for the Vibe Coding era — everyone deserves to shape their own AI-powered world.*

---

## :bookmark_tabs: License

Use, adapt, and extend for your workflows.
