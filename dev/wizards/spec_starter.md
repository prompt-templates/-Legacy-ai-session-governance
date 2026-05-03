# Wizard: spec_starter

<!-- Generates `dev/PROJECT_MASTER_SPEC.md` via 7-step guided Q&A.
     AI reads this schema and conducts the wizard using the frame defined in `_visual_frame.md`.
     Triggered when: profile selector in INIT.md install completes; or AGENTS.md §3 PLAN onboarding readiness check fires. -->

<!-- HARD RULES (enforced by harness R33 series):
1. Each language string row uses ONE language only — do not mix English verbs/nouns into zh-TW/zh-CN/ja prose
2. Technical proper nouns (Agent / API / JSON / Markdown / SDK / placeholder tokens like [X]) are universal — may appear in any language
3. Examples use placeholders only — do NOT hardcode specific industry / tool / framework / company names (see harness R33-08 for enforced blacklist)
4. Each Question and each Option must have all 4 language entries (en / zh-TW / zh-CN / ja)
5. AI execution guidance is the only section that may stay in English-only config syntax
-->

## Wizard metadata

- **Output file:** `dev/PROJECT_MASTER_SPEC.md`
- **Step count:** 7
- **Skip path:** user reply `C` at Step 0 (bypass) → wizard exits without writing
- **Resume path:** user reply `跳過 / skip / B` at any step → wizard exits, partial draft saved with `[unfilled]` markers

## Step 0 — Bypass detection (zero-cost)

### Question (i18n)
- en:    Did you already type a topic or goal in your last message? If yes I will skip topic-class selection and use it.
- zh-TW: 你上一句已經有具體主題或目標?有嘅話我跳過主題分類,直接用你嗰句。
- zh-CN: 你上一句已经有具体主题或目标?有的话我跳过主题分类,直接用你那句。
- ja:    直前のメッセージで既に具体的なテーマや目標を入力しましたか?あればテーマ分類をスキップしてそのまま使います。

### AI execution guidance (config)
- if user's prior message contains ≥1 sentence with a topic / goal noun → skip Step 0 + Step 1, jump to Step 2 with that text as `topic_anchor`
- if user replies "B / defer / 稍後 / skip this time" → exit wizard without writing or setting flag (re-prompt allowed in next session)
- if user replies "C / never ask again / 唔需要 / 不需要 / 不要 / 永遠唔再問" → exit wizard, set `wizard_disabled_spec: true` in `dev/PROFILE.md` (creating PROFILE.md if it doesn't exist with default fields)
- otherwise → run Step 1

## Step 1 — Topic class

### phase_title (i18n)
- en:    Topic Class
- zh-TW: 主題類型
- zh-CN: 主题类型
- ja:    テーマ分類

### Question (i18n)
- en:    Which common type does your project most resemble?
- zh-TW: 你嘅項目最似邊種常見類型?
- zh-CN: 你的项目最像哪种常见类型?
- ja:    あなたのプロジェクトはどの一般的な種類に最も近いですか?

### Option A
- en:    Domain mapping — survey a [domain]'s landscape, players, or literature
- zh-TW: 領域整理 — 梳理一個 [domain] 嘅整體面貌、主要對手或文獻
- zh-CN: 领域整理 — 梳理一个 [domain] 的整体面貌、主要对手或文献
- ja:    領域マッピング — ある [domain] の全体像、主要なプレイヤー、文献を整理

### Option B
- en:    Comparative analysis — compare [N] alternatives or main parties in [domain]
- zh-TW: 比較分析 — 喺 [domain] 入面比較 [N] 個方案或主要對手
- zh-CN: 比较分析 — 在 [domain] 中比较 [N] 个方案或主要对手
- ja:    比較分析 — [domain] における [N] 個の選択肢または主要なプレイヤーを比較

### Option C
- en:    Build / implement — create [thing] that solves [problem]
- zh-TW: 建造 / 實作 — 整一個解決 [problem] 嘅 [thing]
- zh-CN: 构建 / 实现 — 做一个解决 [problem] 的 [thing]
- ja:    構築 / 実装 — [problem] を解決する [thing] を作る

### AI execution guidance (config)
- profile=research      → recommend A
- profile=writing       → recommend A
- profile=data-analysis → recommend A or B (ask user without recommendation if ambiguous)
- profile=coding        → recommend C
- profile=agent-design  → recommend C, attach note `agent_flow_note`
- profile=general       → infer from user prior message; if no signal → present options without recommendation

## Step 2 — Topic specifics

### phase_title (i18n)
- en:    Topic Specifics
- zh-TW: 主題具體化
- zh-CN: 主题具体化
- ja:    テーマの具体化

### Question (i18n)
- en:    State your topic in one sentence. I will pre-fill from your prior input if available.
- zh-TW: 用一句講你嘅主題。如果之前已經提過,我會幫你 pre-fill。
- zh-CN: 用一句话讲你的主题。如果之前已经提过,我会帮你 pre-fill。
- ja:    テーマを一文で。直前の入力があれば pre-fill します。

### Pre-fill rule (config)
extract from: `topic_anchor` (Step 0 detection) OR user's last message
fallback: prompt user to provide one sentence
patterns by language:
  - en:    `[topic] for [angle]`
  - zh-TW: `[主題] 嘅 [角度]`
  - zh-CN: `[主题] 的 [角度]`
  - ja:    `[テーマ]の[角度]`

### AI execution guidance (config)
- always show pre-fill as default option
- if pre-fill empty → require user input (no recommendation, just example pattern)

## Step 3 — Deliverable form

### phase_title (i18n)
- en:    Deliverable Form
- zh-TW: 交付物形態
- zh-CN: 交付物形态
- ja:    成果物の形態

### Question (i18n)
- en:    What's the primary output format?
- zh-TW: 主要輸出格式係?
- zh-CN: 主要输出格式是?
- ja:    主な出力形式は?

### Option A
- en:    Markdown report ([X] words) with embedded tables / charts
- zh-TW: Markdown 報告([X] 字)+ 內嵌表格 / 圖表
- zh-CN: Markdown 报告([X] 字)+ 内嵌表格 / 图表
- ja:    Markdown レポート([X] 文字)+ 表 / 図を埋め込み

### Option B
- en:    Slide deck ([N] slides) presentation-ready
- zh-TW: 投影片([N] 頁)即用
- zh-CN: 幻灯片([N] 页)即用
- ja:    スライド資料([N] 枚)発表向け

### Option C
- en:    Code / artifact — running [thing] (repository, package, or runnable script)
- zh-TW: 程式碼 / 成品 — 可運行嘅 [thing](代碼庫 / 套件 / 可執行腳本)
- zh-CN: 代码 / 成品 — 可运行的 [thing](代码库 / 软件包 / 可执行脚本)
- ja:    コード / 成果物 — 動作する [thing](リポジトリ / パッケージ / 実行可能スクリプト)

### AI execution guidance (config)
- profile=research / writing / data-analysis → recommend A (Markdown is the most governance-friendly source format)
- profile=coding / agent-design → recommend C
- profile=general → infer from Step 1 selection

## Step 4 — Timeline / first milestone

### phase_title (i18n)
- en:    First Milestone
- zh-TW: 第一個 milestone
- zh-CN: 第一个 milestone
- ja:    最初のマイルストーン

### Question (i18n)
- en:    What's the scope of your first milestone?
- zh-TW: 你嘅第一個里程碑範圍係?
- zh-CN: 你的第一个里程碑范围是?
- ja:    最初のマイルストーンの範囲は?

### Option A
- en:    v0.1 outline — skeleton + thesis per chapter ([T] days)
- zh-TW: v0.1 大綱 — 章節骨架 + 每章一段論點([T] 日)
- zh-CN: v0.1 大纲 — 章节骨架 + 每章一段论点([T] 日)
- ja:    v0.1 outline — 章構成 + 各章のテーゼ([T] 日)

### Option B
- en:    v1 full first draft — complete content pass ([T] weeks)
- zh-TW: v1 完整初稿 — 內容全寫一遍([T] 週)
- zh-CN: v1 完整初稿 — 内容全写一遍([T] 周)
- ja:    v1 完全初稿 — 内容を一通り書く([T] 週間)

### Option C
- en:    Pre-scoping note — confirm whether the project itself is worth doing ([T] days)
- zh-TW: 先期範圍筆記 — 確認個項目本身值唔值得做([T] 日)
- zh-CN: 先期范围笔记 — 确认项目本身值不值得做([T] 日)
- ja:    プレスコーピングノート — プロジェクト自体の価値を確認([T] 日)

### AI execution guidance (config)
- always recommend A (smallest reality-check increment)
- attach note: option B has higher rework risk; option C only if project value is unclear

## Step 5 — Sources / data scope

### phase_title (i18n)
- en:    Sources / Data Scope
- zh-TW: 資料來源 / 範圍
- zh-CN: 资料来源 / 范围
- ja:    ソース / データ範囲

### Question (i18n)
- en:    Where will source material come from?
- zh-TW: 資料會由邊度來?
- zh-CN: 资料从哪里来?
- ja:    ソース資料の入手元は?

### Option A
- en:    Public sources — published works / official sites / open data in [domain]
- zh-TW: 公開來源 — [domain] 入面已發表嘅作品 / 官方網站 / 公開數據
- zh-CN: 公开来源 — [domain] 中已发表的作品 / 官方网站 / 公开数据
- ja:    公開ソース — [domain] における発表済み作品 / 公式サイト / 公開データ

### Option B
- en:    Mixed — public sources plus first-party interviews or internal data
- zh-TW: 混合 — 公開來源加埋第一手訪談或內部數據
- zh-CN: 混合 — 公开来源加上第一手访谈或内部数据
- ja:    混合 — 公開ソースに加えて一次インタビューまたは内部データ

### Option C
- en:    First-party only — interviews / surveys / instrumented telemetry
- zh-TW: 純第一手 — 訪談 / 問卷 / 自家收集嘅遙測數據
- zh-CN: 纯第一手 — 访谈 / 问卷 / 自家收集的遥测数据
- ja:    一次データのみ — インタビュー / アンケート / 自前のテレメトリ

### AI execution guidance (config)
- always offer all 3 options without strong recommendation
- attach note: each option has different ethical / privacy / verification implications

## Step 6 — Audience

### phase_title (i18n)
- en:    Audience
- zh-TW: 讀者 / 受眾
- zh-CN: 读者 / 受众
- ja:    読者 / 受け手

### Question (i18n)
- en:    Who is this primarily written for?
- zh-TW: 主要寫畀邊類人睇?
- zh-CN: 主要写给哪类人看?
- ja:    主に誰に向けて書いていますか?

### Option A
- en:    Domain practitioners — assume baseline knowledge, medium jargon density
- zh-TW: 從業者 — 假設讀者識基本概念,中等專業術語密度
- zh-CN: 从业者 — 假设读者懂基本概念,中等专业术语密度
- ja:    業界従事者 — 基礎知識を前提、中程度の専門用語密度

### Option B
- en:    General public — explain core concepts, low jargon, more analogies
- zh-TW: 一般大眾 — 要解釋核心概念,少術語,多比喻
- zh-CN: 一般大众 — 要解释核心概念,少术语,多比喻
- ja:    一般読者 — 核心概念を解説、専門用語控えめ、比喩多め

### Option C
- en:    Decision-maker — investor / policy maker / executive; lead with conclusion + impact
- zh-TW: 決策者 — 投資人 / 政策制訂者 / 高層;結論 + 影響擺前面
- zh-CN: 决策者 — 投资人 / 政策制订者 / 高层;结论 + 影响放前面
- ja:    意思決定者 — 投資家 / 政策担当者 / 経営層;結論と影響を冒頭に

### AI execution guidance (config)
- infer from Step 2 topic phrasing: technical vocabulary → recommend A; everyday vocabulary → recommend B; market / impact framing → recommend C
- if no signal → present all 3 without recommendation

## Step 7 — Success criteria / Done definition

### phase_title (i18n)
- en:    Success Criteria
- zh-TW: 完成標準
- zh-CN: 完成标准
- ja:    完了の定義

### Question (i18n)
- en:    What signals "done" for this project?
- zh-TW: 點先算完成?
- zh-CN: 怎样才算完成?
- ja:    何をもって完了とみなしますか?

### Option A
- en:    Internal sign-off — at least 1 reviewer approves the [N]-pillar coverage
- zh-TW: 內部核准 — 至少 1 個審閱者通過 [N] 大支柱嘅覆蓋
- zh-CN: 内部核准 — 至少 1 个审阅者通过 [N] 大支柱的覆盖
- ja:    内部承認 — [N] 個の主要分野を満たし、レビュアー1名以上の承認

### Option B
- en:    Quantitative — ≥[N] actionable insights / ≥[N] tested cases / KPI threshold
- zh-TW: 數量化 — ≥[N] 個可行洞察 / ≥[N] 個測試案例 / KPI 達標
- zh-CN: 数量化 — ≥[N] 个可行洞察 / ≥[N] 个测试用例 / KPI 达标
- ja:    定量的 — 実行可能な知見 ≥[N] 件 / テストケース ≥[N] 件 / KPI 達成

### Option C
- en:    Public release — published / shipped / shared with the intended audience
- zh-TW: 公開發佈 — 出版 / 出貨 / 同預期受眾分享咗
- zh-CN: 公开发布 — 出版 / 出货 / 已与预期受众分享
- ja:    公開リリース — 発表 / リリース / 想定読者への共有完了

### AI execution guidance (config)
- profile=research / writing → recommend A
- profile=coding / agent-design → recommend B (testable criteria)
- profile=data-analysis → recommend B
- profile=general → ask user without recommendation

## Note strings (i18n, referenced by AI execution guidance)

### agent_flow_note
- en:    Your [thing] is the agent flow itself
- zh-TW: 你嘅 [thing] 就係 Agent 工作流本身
- zh-CN: 你的 [thing] 就是 Agent 工作流本身
- ja:    あなたの [thing] が Agent ワークフローそのものです

## Output template — `dev/PROJECT_MASTER_SPEC.md`

After all 7 steps, AI writes the spec using this skeleton with answers substituted:

```markdown
# Project Master Spec

**Project:** {step2_topic}
**Profile:** {dev/PROFILE.md profile field}
**Created:** {today's UTC date} (via guided wizard, AI-assisted)

## 1. Topic / Scope
{step1_class summary} — {step2_topic}

## 2. Deliverable
{step3_form description}

## 3. First Milestone
{step4_milestone description}

## 4. Sources / Data Scope
{step5_sources description}

## 5. Audience
{step6_audience description}

## 6. Success Criteria
{step7_done description}

## 7. Risks
[unfilled — recommended to populate after first milestone reality check]

## 8. Open Decisions
[unfilled — capture as work progresses]
```
