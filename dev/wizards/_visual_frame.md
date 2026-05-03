# Wizard Visual Frame — Style B (✦ star-themed)

<!-- This file defines the shared visual frame + i18n label table used by every wizard schema in `dev/wizards/`.
     AI executes a wizard by reading the schema (e.g. `spec_starter.md`), then renders each step using this frame.
     Single source of truth — schemas reference labels by key, do not duplicate frame ASCII or label strings. -->

## Frame template — applies to every wizard step

```text
   ✦   ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─   ✦

        ◇  {step_label}   ·   {phase_title}

        ⋆ ⋆ {progress_dots} ──── {percent}% {progress_label}

   ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─

   {question_text}

      ▸  A.  {option_a}
      ▸  B.  {option_b}
      ▸  C.  {option_c}

   💡  ────  {pick_label}: {recommended_letter}  ────  {recommendation_reason}
```

Substitution variables:

| Variable | Source |
|---|---|
| `{step_label}` | `step_label` i18n entry below + `{N}` / `{Total}` numerics |
| `{phase_title}` | per-step `phase_title` i18n entry from the schema |
| `{progress_dots}` | rendered as `●` for completed + `○` for remaining (e.g. step 3/7 → `●●●○○○○`) |
| `{percent}` | computed from N/Total × 100, rounded to nearest integer |
| `{progress_label}` | `progress_label` i18n entry below |
| `{question_text}` | per-step `Question` i18n entry from the schema |
| `{option_a}` / `{option_b}` / `{option_c}` / `{option_d}` / `{option_e}` / `{option_f}` | per-step `Option A/B/C/D/E/F` i18n entry from the schema (schema declares 3–6 options; render one line per declared option) |
| `{pick_label}` | `pick_label` i18n entry below |
| `{recommended_letter}` | `A`–`F` selected by AI per step's `AI execution guidance` |
| `{recommendation_reason}` | one-sentence reason in user's language, written by AI based on step context |

## Completion frame — rendered once at wizard end

```text
        ╭━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╮
        ┃   ✦   {completion_title}      ┃
        ┃                                ┃
        ┃   {N} / {N} ━━━━━━━━━━ 100%    ┃
        ┃                                ┃
        ┃   📦  {output_path}            ┃
        ┃       {output_size_note}       ┃
        ╰━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━╯
```

`{output_path}` = the file the wizard wrote (e.g. `dev/PROJECT_MASTER_SPEC.md`).
`{output_size_note}` = i18n size note like `34 lines written` (en) / `已寫入(34 lines)`(zh-TW) / `已写入(34 lines)`(zh-CN) / `34 行を出力済み`(ja).

## i18n label table (shared by all wizard schemas)

### step_label
- en:    Step {N} / {Total}
- zh-TW: 第 {N} / {Total} 步
- zh-CN: 第 {N} / {Total} 步
- ja:    ステップ {N} / {Total}

### progress_label
- en:    progress
- zh-TW: 進度
- zh-CN: 进度
- ja:    進捗

### pick_label
- en:    My pick
- zh-TW: 我推
- zh-CN: 我推
- ja:    私の推奨

### completion_title
- en:    WIZARD COMPLETE
- zh-TW: WIZARD 完成
- zh-CN: WIZARD 完成
- ja:    WIZARD 完了

### output_size_note
- en:    {N} lines written
- zh-TW: 已寫入({N} 行)
- zh-CN: 已写入({N} 行)
- ja:    {N} 行を出力済み

## Hard rules (apply to every wizard schema using this frame)

1. Do not change the frame ASCII characters — `✦` / `◇` / `─` / `⋆` / `▸` / `💡` are part of the visual identity
2. Do not invent new label keys — if a wizard step needs a new label, add it to this file's i18n table first
3. Each label must have all 4 language entries (en / zh-TW / zh-CN / ja); harness check enforces this
4. Numeric variables (`{N}` / `{Total}` / `{percent}`) substitute as plain digits, no localization
5. Path variables (`{output_path}`) substitute as plain text, no localization
6. Schema may declare 3–6 options per question (Option A through Option F); frame renders one `▸ X. {option_x}` line per declared option. Each declared option requires all 4 language entries (`en` / `zh-TW` / `zh-CN` / `ja`)
