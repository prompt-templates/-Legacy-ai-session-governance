# Wizard: runbook_starter

<!-- Generates `dev/RUNBOOK.md` via 5-step guided Q&A.
     AI reads this schema and conducts the wizard using the frame defined in `_visual_frame.md`.
     Triggered when: user explicitly asks to build a runbook; or AGENTS.md §3 PLAN detects user mentioning deploy / publish / release / pipeline / recurring-procedure keywords AND `dev/RUNBOOK.md` does not exist. -->

<!-- HARD RULES (enforced by harness R33 series):
1. Each language string row uses ONE language only — no mixing English verbs/nouns into zh-TW/zh-CN/ja prose
2. Technical proper nouns (Agent / API / JSON / Markdown / SDK / placeholder tokens like [X]) are universal — may appear in any language
3. Examples use placeholders only — do NOT hardcode specific tools / domains / company names
4. Each Question and each Option must have all 4 language entries (en / zh-TW / zh-CN / ja)
-->

## Wizard metadata

- **Output file:** `dev/RUNBOOK.md`
- **Step count:** 5
- **Skip path:** user reply `C / 唔需要 / 不需要 / skip` at Step 0 → wizard exits without writing
- **Multi-runbook support:** if `dev/RUNBOOK.md` exists, AI offers to create a named variant (`dev/runbooks/<name>.md`) instead

## Step 0 — Confirm runbook intent

### Question (i18n)
- en:    Are we building a runbook for a recurring procedure (deploy / publish / pipeline / review gate)?
- zh-TW: 我哋係咪要建一份重複執行流程嘅 runbook(部署 / 發佈 / 流水線 / 審查門檻)?
- zh-CN: 我们是不是要建一份重复执行流程的 runbook(部署 / 发布 / 流水线 / 审查门槛)?
- ja:    繰り返し実行する手順(デプロイ / 公開 / パイプライン / レビューゲート)の runbook を作成しますか?

### AI execution guidance (config)
- if user already named the procedure → use as `procedure_anchor`, skip to Step 1
- if user replies "B / defer / 稍後 / skip this time" → exit wizard without writing or setting flag (re-prompt allowed when keyword detected in next session)
- if user replies "C / never ask again / 唔需要 / 不需要 / 不要 / 永遠唔再問" → exit wizard, set `wizard_disabled_runbook: true` in `dev/PROFILE.md` (creating PROFILE.md if it doesn't exist with default fields)
- otherwise → run Step 1 to elicit procedure name

## Step 1 — Procedure name + trigger condition

### phase_title (i18n)
- en:    Procedure & Trigger
- zh-TW: 流程名稱 + 觸發條件
- zh-CN: 流程名称 + 触发条件
- ja:    手順名 + 発動条件

### Question (i18n)
- en:    Name the procedure and state when it fires.
- zh-TW: 講個流程名稱,同埋幾時會觸發。
- zh-CN: 讲流程名称,以及什么时候触发。
- ja:    手順名と発動タイミングを教えてください。

### Pre-fill rule (config)
extract from: `procedure_anchor` (Step 0) OR user's last message keywords
patterns by language:
  - en:    `[procedure_name] — fires when [trigger]`
  - zh-TW: `[流程名] — [觸發條件] 時觸發`
  - zh-CN: `[流程名] — [触发条件] 时触发`
  - ja:    `[手順名] — [発動条件] のときに実行`

### AI execution guidance (config)
- always require user input here (no pre-defined options)
- if pre-fill empty → ask without recommendation

## Step 2 — Pre-conditions

### phase_title (i18n)
- en:    Pre-conditions
- zh-TW: 前置條件
- zh-CN: 前置条件
- ja:    前提条件

### Question (i18n)
- en:    What must be true before this procedure can run?
- zh-TW: 流程開始前必須滿足咩條件?
- zh-CN: 流程开始前必须满足什么条件?
- ja:    手順開始前に満たすべき条件は?

### Option A
- en:    Environment ready — required tools / credentials / network access available
- zh-TW: 環境就緒 — 必要工具 / 憑證 / 網絡連線可用
- zh-CN: 环境就绪 — 必要工具 / 凭证 / 网络连接可用
- ja:    環境準備完了 — 必要ツール / 認証情報 / ネットワーク接続が利用可能

### Option B
- en:    Upstream completed — preceding step / dependency / approval signed off
- zh-TW: 上游已完成 — 前置步驟 / 依賴 / 審批已簽
- zh-CN: 上游已完成 — 前置步骤 / 依赖 / 审批已签
- ja:    上流完了 — 前段ステップ / 依存関係 / 承認が完了

### Option C
- en:    State verified — system in expected baseline (no in-progress conflicting work)
- zh-TW: 狀態已核實 — 系統喺預期基線(冇進行中嘅衝突工作)
- zh-CN: 状态已核实 — 系统处于预期基线(没有进行中的冲突工作)
- ja:    状態確認済み — システムが想定ベースライン(進行中の競合作業なし)

### AI execution guidance (config)
- always offer all 3, allow multi-select (user can pick A+B / A+B+C / etc.)
- attach note: most production runbooks need at least A; B and C reduce mid-procedure surprises

## Step 3 — Execution steps

### phase_title (i18n)
- en:    Execution Steps
- zh-TW: 執行步驟
- zh-CN: 执行步骤
- ja:    実行ステップ

### Question (i18n)
- en:    How many sequential steps does the procedure have, and where do they live?
- zh-TW: 流程有幾多個連續步驟?喺邊度執行?
- zh-CN: 流程有多少个连续步骤?在哪里执行?
- ja:    手順は何ステップ連続しますか?どこで実行しますか?

### Option A
- en:    Few steps ([N] ≤ 3), runs in single environment / tool
- zh-TW: 步驟少([N] ≤ 3),單一環境 / 工具內完成
- zh-CN: 步骤少([N] ≤ 3),单一环境 / 工具内完成
- ja:    ステップ少([N] ≤ 3)、単一の環境 / ツール内で完結

### Option B
- en:    Medium ([N] = 4-8), spans multiple tools or environments
- zh-TW: 中等([N] = 4-8),跨多個工具或環境
- zh-CN: 中等([N] = 4-8),跨多个工具或环境
- ja:    中規模([N] = 4-8)、複数ツールまたは環境にまたがる

### Option C
- en:    Many ([N] > 8), with branch / fallback paths
- zh-TW: 多([N] > 8),含分支 / 後備路徑
- zh-CN: 多([N] > 8),含分支 / 后备路径
- ja:    多数([N] > 8)、分岐 / フォールバックを含む

### AI execution guidance (config)
- present all 3, no strong recommendation
- after user picks → AI prompts for the actual step list (free-form), records in output
- attach note: Option C suggests splitting into sub-runbooks if > 12 steps

## Step 4 — Acceptance check

### phase_title (i18n)
- en:    Acceptance Check
- zh-TW: 驗收檢查
- zh-CN: 验收检查
- ja:    受け入れチェック

### Question (i18n)
- en:    What concrete check confirms the procedure ran successfully?
- zh-TW: 邊個具體檢查可以確認流程成功?
- zh-CN: 哪个具体检查可以确认流程成功?
- ja:    どの具体的なチェックで手順成功を確認しますか?

### Option A
- en:    Automated — command output / health endpoint / test suite returns expected value
- zh-TW: 自動化 — 指令輸出 / 健康檢查端點 / 測試套件返回預期值
- zh-CN: 自动化 — 指令输出 / 健康检查端点 / 测试套件返回预期值
- ja:    自動化 — コマンド出力 / ヘルスチェックエンドポイント / テストスイートが期待値を返す

### Option B
- en:    Manual visual — open dashboard / UI / log viewer and confirm specific signal
- zh-TW: 人手視覺檢查 — 開儀表板 / UI / 日誌檢視器確認特定訊號
- zh-CN: 人工视觉检查 — 打开仪表盘 / UI / 日志查看器确认特定信号
- ja:    目視確認 — ダッシュボード / UI / ログビューアで特定シグナルを確認

### Option C
- en:    External confirmation — downstream consumer / stakeholder / monitoring alert reports OK
- zh-TW: 外部確認 — 下游消費者 / 持份者 / 監控告警報 OK
- zh-CN: 外部确认 — 下游消费者 / 持份者 / 监控告警报 OK
- ja:    外部確認 — 下流の利用者 / ステークホルダー / 監視アラートが OK を返す

### AI execution guidance (config)
- always recommend A first if possible (fastest + least manual error)
- if procedure inherently visual / human-judgment → B is acceptable
- attach note: a runbook without an acceptance check is incomplete

## Step 5 — Failure / rollback

### phase_title (i18n)
- en:    Failure / Rollback
- zh-TW: 失敗處理 / 回滾
- zh-CN: 失败处理 / 回滚
- ja:    失敗時 / ロールバック

### Question (i18n)
- en:    What happens if the procedure fails midway?
- zh-TW: 流程中途失敗會點?
- zh-CN: 流程中途失败怎么办?
- ja:    手順が途中で失敗した場合は?

### Option A
- en:    Auto-rollback — system restores prior baseline automatically
- zh-TW: 自動回滾 — 系統自動回復先前基線
- zh-CN: 自动回滚 — 系统自动恢复先前基线
- ja:    自動ロールバック — システムが自動的に直前のベースラインに復元

### Option B
- en:    Manual rollback — operator runs documented rollback steps
- zh-TW: 人手回滾 — 操作員跑文檔記錄嘅回滾步驟
- zh-CN: 人工回滚 — 操作员跑文档记录的回滚步骤
- ja:    手動ロールバック — 担当者が文書化されたロールバック手順を実行

### Option C
- en:    Forward-fix — diagnose and patch in place; no rollback path
- zh-TW: 向前修復 — 即場診斷加 patch;唔走回頭路
- zh-CN: 向前修复 — 现场诊断加 patch;不走回头路
- ja:    前方修正 — その場で診断して修正、ロールバックしない

### AI execution guidance (config)
- recommend A if available, B as fallback
- attach note: option C is high-risk for production; only recommend if rollback is infeasible

## Output template — `dev/RUNBOOK.md`

```markdown
# Runbook: {step1_procedure_name}

**Created:** {today's UTC date} (via guided wizard, AI-assisted)

## Trigger
{step1_trigger}

## Pre-conditions
{step2_preconditions list}

## Execution Steps
{step3_size category} — [{N}] steps:

1. [step 1 description]
2. [step 2 description]
...

## Acceptance Check
{step4_check description}

## Failure / Rollback
{step5_rollback description}

## Notes
[unfilled — populate with edge cases / known issues as encountered]
```
