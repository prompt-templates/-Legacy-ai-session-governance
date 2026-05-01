# vX.Y.Z Release Notes

Date: YYYY-MM-DD (UTC)

<!--
  RELEASE NOTES TEMPLATE — v3.0.4+
  ================================
  Audience: end users (people deciding whether to upgrade and what they'll feel after).
  NOT a developer changelog. NOT a commit log. NOT a §-code reference.

  RULES:
  - Lead with plain language. Describe behavior changes from the user's perspective.
  - Sentence subjects must be the actual fact ("AI replies become more decisive"),
    NOT internal IDs ("§11a" / "R-checks #170-175" / "MANDATORY REPLY DISCIPLINE marker").
  - Internal IDs (§ codes, R-check numbers, marker names) may appear as parenthetical
    citations at end of sentence or in the "What changed" section — never as the lead.
  - "Headline" must be readable in 30 seconds without governance domain knowledge.
  - "What you'll feel" is mandatory — this is the section users actually scan.
  - Skip sections that don't apply ("Industry alignment" is optional).
-->

## Headline

<1–3 sentences. Plain language. What did this release do, in user-feel terms?>

Example (good):
> Active SESSION_LOG stays compact on long-running projects (no more 100+ line release entries crowding the active file at startup). AI replies become more decisive and easier to read.

Example (bad — do NOT write this way):
> §4 entry-size cap (≤110) + §11a Reply Behavior 5 mandatory rules + 9 new R-checks (#167-175) + new marker MANDATORY REPLY DISCIPLINE.

## What you'll feel

<3–6 bullets, each leading with a user-observable change. Mandatory section.>

- <Concrete user-facing impact #1 — what's different in your day-to-day after upgrading?>
- <Concrete user-facing impact #2>
- <Concrete user-facing impact #3>

Example bullets:
- Closeout's handoff block now shows "OPENING MESSAGE — paste at next session" instead of generic "COPY/PASTE", so it's obvious where to use it.
- AI prints `Seed context: [...]` at startup — you can see whether it used your pasted handoff or auto-read SESSION_LOG fallback.
- Quick Start in README now covers the full lifecycle (start → work → close → resume), not just install.

## What changed

<Technical detail. Organized by area. Internal IDs OK here.>

### 1. <Area name — e.g. "Closeout output skeleton">

- <Specific change with file path + section reference>
- <Why this approach was chosen vs alternatives, if non-obvious>

### 2. <Next area>

- <…>

## Validation

- Command: `bash docs/qa/run_checks.sh`
- Result: `<N main + M legacy = TOTAL> checks PASS`
- <Other validation evidence: per-entry scans, sandbox QC, matrix audits — only if applicable>

## Upgrade path

<Concrete steps for existing users. Skip section only if there is genuinely nothing to do.>

Existing v<previous>.x users:

- <Re-run INIT.md instructions, what gets backed up, what gets merged>
- <Or manual merge instructions for users with local customizations>
- <Breaking changes? Migration steps? Deprecations? — call them out clearly>

## Tags / commits

- `vX.Y.Z` (GA / RC, latest / prerelease) — <one-line bundle description>
  - commit `<hash>` — <what this commit did>
  - commit `<hash>` — <what this commit did>

## Industry standards alignment (optional)

<Skip unless this release is grounded in published research, established patterns,
or community consensus that's worth citing. If you include this section, name the
sources and explain how the change reflects the principle.>
