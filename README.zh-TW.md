[English](README.md) | 繁體中文 | [简体中文](README.zh-CN.md) | [日本語](README.ja.md)

# :rocket: 支援跨 AI 工具交接的開發治理範本

當 Codex、Claude 或 Gemini 的配額用盡，把交接區塊貼到下一個工具，它就能從同樣的狀態繼續，不用重新說明。

- 跨命令列工具交接
- 統一工作流程：`PLAN -> READ -> CHANGE -> QC -> PERSIST`
- 防止治理規則漂移，而不是一直疊加新規則
- 一個專注於 session 連續性的 Harness Engineering 組件

**[工作階段如何運作](#quickstart)** · **[安裝](#install)** · **[升級](#upgrade)** · **[快速操作](#quick-operations)**

![Overview](ref_doc/overview_infograph_tw.png)

> **🆕 初次接觸？** 建議先花 5 分鐘看 **[互動式介紹頁面](https://prompt-templates.github.io/ai-session-governance/?lang=tw)** — 以視覺化方式了解本範本的功能與設計理念，再閱讀本 README 其餘章節。


---

## :bookmark_tabs: 為什麼要做這個

用多個 AI 工具開發時，最先壞掉的通常是交接，不是生成品質。

常見失敗模式：
- 每次切換工具都要重頭說明
- 修復疊在修復上，規則越來越亂
- 說明文件、交接文件、工作日誌慢慢對不上

本範本規定：
1. 每個工作階段只有一條重入路徑
2. 每項任務走同一套工作流程
3. 每次收尾前必須留下可追溯的記錄

---

## :bookmark_tabs: 內建防護機制

也涵蓋幾個常見的 AI 失誤：

| 防護機制 | 防止什麼 |
|---|---|
| **PLAN 風險分級** | 高風險任務（≥3 檔案、範圍不明、破壞性操作、外部系統）在 AI 確認理解正確前不會自動開始 — 高風險計劃暫停等用戶確認 |
| **外部 API 代碼安全** | 根據訓練記憶臆測端點 / 參數 / Schema 並直接寫入 API 呼叫代碼 |
| **代碼庫上下文快照** | 每次工作階段切換後 AI 重新從零摸索技術棧、外部服務與關鍵決策 |
| **測試計劃治理** | 合併變更時未記錄情景矩陣 — 預期結果與實際結果未被追蹤 |
| **整合紀律** | 持續疊加規則，卻未先確認既有規則是否已涵蓋或應更新 |
| **文件同步登錄表** | 變更後猜測要更新哪些文件 — `DOC_SYNC_CHECKLIST.md` 將變更類別對應到必要更新項，AI 查表而非自行判斷 |
| **工作日誌自動維護** | 工作日誌隨時間增長到數千行，佔用 AI 每次啟動的 context — 收尾時由 AI 依觸發條件自動整理舊記錄，保持啟動上下文精簡 |
| **QC 失敗處理** | AI 靜默重試或放棄失敗的測試 — 測試或建置失敗時，AI 必須報告失敗內容、診斷原因，並等待用戶指示，而非自動重試 |
| **收尾誤觸保護** | 「好了謝謝」之類的日常用語意外觸發完整 session closeout — 當語意模糊時，AI 會先確認是否真的要結束工作階段 |
| **回覆行為治理** | AI 用假裝開放題反問推回用戶、選項夾差選項充數、過量澄清問題、未核對 facts 當已核對寫、surface text 用 `§` codes 做句子主語 — §11a（v3.0.3 baseline + v3.0.5 擴展）令 10 條 reply rules mandatory：judgement-first 加角色分工、規定選擇題格式（`🚀 *下一步揀一條*` + A/B/C + `💡 推薦`）、≤3 假設 + ≤3 問題、`UNVERIFIED` 同 `NA` 區分、surface text 用人話加反例正例、回覆骨架（`🔎` 重點 → 交付清單 → 正文）、功能 emoji 詞彙（🔎/✅/❌/⚠️/📌/💡/🚀）、Output-only mode override、SSOT 逐字對齊、回覆語體一致 |
| **全圖優先計劃** | AI 將多檔或治理改動當散文堆，無 end-state、無交付、無指標、無驗收、無目標連結 — §3.5 FPFR（v3.0.5）規定：當涉及 ≥2 檔 / 新建檔 / 治理改動 / ≥2 階段計劃時，必須以 5 個固定區段 + 收尾句呈交；明禁「同意 A？同意 B？」逐項批准 |
| **補丁式交付格式** | AI 將代碼 / spec / 設定改動當整段重生文字交，無 anchor、無 before/after，難審難 rollback — §11b（v3.0.5）規定：精準 anchor 喺 code block 外、BEFORE / AFTER 兩個 code block 內只放 verbatim 文字、Changelog 列出 added / removed / renamed / moved |
| **跨規則仲裁** | AI 對住規則衝突（例如「最小改動」vs「根因治理」）隨機揀，無一致優先序 — §0c（v3.0.5）明文優先序：事實可驗收 > 穩定性 > 根因治理 > 完整性交付 > 最小改動；前 4 項永遠 override 第 5 項 |
| **工具格式硬規則** | AI 計算唔展示步驟、JSON 無 schema、Mermaid 方向亂 — §13（v3.0.5）規定：計算四步法（逐位 + 判正負 + 顯示步驟 + 代回驗算）、JSON schema-first 必填欄位用 `null`、Mermaid `flowchart TB` 方向加 `"..."` 包覆 text label |

### :small_blue_diamond: SESSION_LOG.md 怎麼保持精簡

`dev/SESSION_LOG.md` 在每次工作階段啟動時都會被讀取。在活躍的專案中，這個檔案可能增長到數千行——把幾個月前已無關的歷史記錄全部載入 AI 的 context。

本範本用「明確收尾檢查」處理（不是只靠規則記憶）：

- 收尾時 AI 會檢查：`SESSION_LOG.md` 是否超過 **400 行**，或是否含有超過 **30 天**的舊記錄
- 若命中條件，AI 會先歸檔舊記錄，再寫入本次收尾
- 若未命中條件，AI 會略過歸檔，直接寫入收尾
- 舊記錄會搬移到 `dev/archive/`（不刪除），並按季度整理成 `SESSION_LOG_YYYY_QN.md`
- 主動日誌目標維持 ≤ **200 行**，且保留最近 2 個工作階段
- AI 啟動時只讀 `SESSION_LOG.md`，歸檔文件不會被載入

若你已有一個龐大的工作日誌，在升級後第一次工作階段收尾時會自動整理，不需要手動操作。

---

## :bookmark_tabs: 近期版本

僅顯示最近 5 個版本 — 較舊版本詳見 [GitHub 完整 release 歷史](https://github.com/prompt-templates/ai-session-governance/releases)。

| 版本 | 變更內容 | 對你的意義 |
|---|---|---|
| **v3.0.6** | 收尾介面優化：6 款重新設計的工作階段啟動/收尾視覺、「貼上此區塊」說明從 3 行縮為 1 行、README 安裝/升級流程從 9 步縮為 5 步並加上「AI 背後執行」說明區塊。README 接續區段首次解釋為何手動貼上 OPENING MESSAGE 比 `Follow AGENTS.md` 更可靠（約 95% vs 約 70-85%）。修補既有 harness exit code 漏洞（R27-10）。 | 新用戶安裝流程大幅精簡。工作階段啟動/收尾畫面更美觀。「為何手動貼上」的解釋消除常見困惑。 |
| **v3.0.5** | 完整回覆協議現入治理，不再只是「universal subset」。回覆會先用 `🔎` 重點 bullet（≤3 行）、再交付清單、再正文。選擇題用一致格式 `🚀 *下一步揀一條*` + A/B/C + `💡 推薦`。多檔或治理改動觸發全圖優先計劃，5 個固定區段（END-STATE / DELIVERABLES / METRICS / ACCEPTANCE / GOAL LINK）+ 收尾句 — 不再有「同意 A？同意 B？」逐項批准。代碼 / spec / 設定改動以補丁交付：精準 anchor 在 code block 外、BEFORE / AFTER 兩個 code block 內只放 verbatim 文字、加 Changelog。數值答案展示四步。JSON 先定 schema。Mermaid 用 `flowchart TB` 加 `"..."` 包覆 text label。當兩條規則衝突時 AI 依明文優先序（事實可驗收 > 穩定性 > 根因 > 完整性 > 最小改動），不再隨機選擇。 | 回覆體驗一致、可掃讀：頂置重點 → 清單 → 正文，surface text 不再夾雜 `§` codes。非 trivial 工作的計劃永遠是全圖優先，所以你可以一眼 veto / 修改整個 plan，無需逐項批准。Patch 易審可貼。仲裁規則令 AI 不再為「diff 較小」犧牲事實可驗收 — 事實可驗收永遠勝出。 |
| **v3.0.4** | 每次工作階段結束時 AI 給你的那段字條，現在標題改為「NEXT SESSION OPENING MESSAGE」，並在底下加一行提示「貼成你下次 AI 工作階段的第一條訊息」— 看到就知道要貼去哪。工作階段開始時 AI 會印一行 `Seed context: ...` 顯示用了哪個來源（你貼的、或者自動讀取上次留下的字條），讓你看清楚有沒有接續到。README 不再只教安裝 + 開始，現在覆蓋完整每日流程（開始 → 工作 → 結束 → 下次接續），並附 4 個語言版本的視覺流程圖。release notes 改用新模板，每篇都先講「對你的意義」，不再像內部 changelog。 | 工作階段結尾不再困惑「這段字條要貼去哪」。AI 啟動時不用再猜「它有沒有接續上次」。新用戶讀 README 就看到整個日常流程，不只是安裝。 |
| **v3.0.3** | AI 回覆變得更果斷直接：當 AI 有判斷時會直接給出，不再用「你覺得呢」反問把決定推回給你。選項最多 3 個並附上明確推薦。AI 未核對過的數字、日期、引用會明確標示 `UNVERIFIED`，讓你一眼分辨已核實 vs 未核實。內部規則代碼不再用作回覆裡的句子主語。每筆 SESSION_LOG 收尾紀錄上限 ≤110 行，發布版本相關的詳細內容會移到另一個檔案，避免每次啟動讀取時被舊紀錄拖慢。 | 簡單任務減少來回確認。已核實 vs 未核實的狀態看得清楚。閱讀回覆不再需要先懂治理術語。長期專案啟動速度不會被歷史紀錄拖慢。 |
| **v3.0**（含 v3.0.1 / v3.0.2 patches） | 治理檔案大幅精簡：AGENTS.md 從 734 行縮減至 504 行（−31.3%），所有規則完整保留；每 session 啟動的系統 prompt token 成本下降約 15.6%。Legacy quarantine 機制把 89 條歷史防漂移檢查隔離到自動 chain 的第二層 harness — 主檢查套件變輕，但 release 時禁止 bypass legacy，歷史保險不會無聲丟失。v3.0.1 加入 release 後文檔同步治理（R29 系列檢查），防止 README / index.html 漂走。v3.0.2 把 release / merge gate 擴充為 4 階段生命週期（發前驗證 / 發 release / 發後執手尾 / 觀察期），加 R30 系列 enforcement。已建立 `dev/SESSION_STATE_DETAIL.md` 或 `dev/PROJECT_MASTER_SPEC.md` 的用戶 re-install 時也會被自動備份，升級路徑資料安全。 | 系統 prompt 中的治理文字變少 → 規則遵守率提升（業界數據：短規則約 89% vs 冗長約 35%）；release 後相關文件漂走會自動 catch（README、release notes、公開頁 stat counter 同步）；本機檔案在升級時被保留；跨 LLM 通用相容（Claude Code、Claude Cowork、OpenAI Codex CLI、Gemini CLI）— 零 hook 依賴。 |

---

<a id="quickstart"></a>

## :bookmark_tabs: 工作階段如何運作

安裝一次之後，每次工作階段都重複同一個循環：

![工作階段流程](ref_doc/lifecycle_flow_tw.svg)

### :small_blue_diamond: 5 步走完一次完整流程

1. **安裝**（一次性）：將 **[INIT.md](INIT.md)** 貼到你的 AI 工具，依提示回覆 `INSTALL_ROOT_OK: <absolute_path>` 與 `INSTALL_WRITE_OK`。
2. **開始工作階段**：輸入 `Follow AGENTS.md`，AI 會接續你上次的進度。
3. **工作**：請 AI 開發功能、修 bug、寫文件 — 任何事都可以。
4. **結束**：輸入 `收工`。AI 會給你一張 **NEXT SESSION OPENING MESSAGE** 字條。
5. **下次工作階段**：把那張字條貼成你的第一條訊息 — 就回到步驟 2 了。

> **忘了在步驟 5 貼上字條？** 貼上仍是最可靠做法 — AI 自動讀取 `SESSION_LOG.md` 的可靠度視 AI 工具與 model 而定，由約 40% 至 85% 不等。詳見下方[快速操作](#quick-operations) §3「為何要手動貼上」的解說。

---

<a id="install"></a>

## :bookmark_tabs: 安裝

1. 在你想安裝治理規則的專案資料夾，開啟你選擇的 AI 工具（Codex / Claude Code / Claude CoWork / Gemini CLI）。
2. 開啟 **[INIT.md](INIT.md)** → 點擊 **Raw** → 全選複製。
3. 貼到 AI 對話框並提交。
4. AI 會請你回覆兩項確認，每項分行回覆：
   - `INSTALL_ROOT_OK: <absolute_path>`
   - `INSTALL_WRITE_OK`
5. 完成 — AI 會輸出 **Quick Start** 區塊作為操作參考。

> **AI 在背後執行的步驟（無須手動操作）：** AI 執行根目錄安全預檢（顯示 `pwd` + `git root`，若不一致則停止讓你選擇），在寫入前顯示演練計劃（`create` / `merge` / `skip`），並將既有治理檔案備份至 `dev/init_backup/<UTC_TIMESTAMP>/`。

### :small_blue_diamond: 安裝流程畫面

<table>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_1.png" alt="安裝流程步驟 1" width="92%" />
      <br />
      <sub>步驟 1：將 `INIT.md` 貼到 AI 命令列工具</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_2.png" alt="安裝流程步驟 2" width="92%" />
      <br />
      <sub>步驟 2：確認偵測到的根目錄</sub>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_3.png" alt="安裝流程步驟 3" width="92%" />
      <br />
      <sub>步驟 3：回覆 `INSTALL_ROOT_OK`</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_4.png" alt="安裝流程步驟 4" width="92%" />
      <br />
      <sub>步驟 4：回覆 `INSTALL_WRITE_OK`</sub>
    </td>
  </tr>
</table>

完成步驟 4 確認後，AI 在寫入任何檔案前會先建立備份。

### :small_blue_diamond: 實際執行畫面

<table>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/launch.png" alt="啟動畫面" width="92%" />
      <br />
      <sub>啟動：工作階段開機與上下文載入</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/closesession.png" alt="完工收尾畫面" width="92%" />
      <br />
      <sub>收尾：工作階段摘要與交接輸出</sub>
    </td>
  </tr>
</table>

AI 自動處理並合併既有的 `AGENTS.md`、`CLAUDE.md`、`GEMINI.md`。
大多數情況下，直接使用 `INIT.md` 就夠了。
不要手動複製整個儲存庫，用 `INIT.md` 安裝才能安全合併。

**已安裝並想升級？** 同樣執行 `INIT.md` — 詳見下方[從舊版升級](#upgrade)。

---

<a id="upgrade"></a>

## :bookmark_tabs: 從舊版升級

與安裝流程相同 — 對同一個專案根目錄重新執行 `INIT.md`。

1. 在已安裝的專案資料夾開啟同一個 AI 工具。
2. 開啟 **[INIT.md](INIT.md)** → 點擊 **Raw** → 全選複製。
3. 貼到 AI 對話框並提交。
4. AI 會請你回覆兩項確認，每項分行回覆：
   - `INSTALL_ROOT_OK: <absolute_path>`
   - `INSTALL_WRITE_OK`
5. 完成 — AI 備份既有檔案、合併新治理內容、保留你的自訂規則。

**安全升級提示語**（如需額外保護，於步驟 3 之前貼上）：

```text
請用這份 INIT.md 執行治理升級，僅做 merge 整合。
不得覆寫、刪除或重置我現有的自訂 governance 規則/內容/檔案。
請先顯示 dry-run 計劃（create/merge/skip），再等待我確認 INSTALL_ROOT_OK 與 INSTALL_WRITE_OK。
```

> **AI 在背後執行的步驟（無須手動操作）：** AI 將既有 `AGENTS.md` / `CLAUDE.md` / `GEMINI.md` / `dev/*` 檔案備份至 `dev/init_backup/<UTC_TIMESTAMP>/`，然後合併治理章節 — 你的自訂內容、`dev/DOC_SYNC_CHECKLIST.md` 自訂列、`dev/SESSION_HANDOFF.md` / `dev/SESSION_LOG.md` 全部保留。可從任何已安裝版本升級。

---

<a id="quick-operations"></a>

## :bookmark_tabs: 快速操作

以下句子可直接複製貼上。

### :small_blue_diamond: 1) 開始新工作階段

```text
Follow AGENTS.md
```

### :small_blue_diamond: 2) 收尾並完成完整交接

```text
收工
```

### :small_blue_diamond: 3) 快速開始下一個工作階段

```text
<貼上上一輪輸出的「NEXT SESSION OPENING MESSAGE」區塊作為下次工作階段的第一條訊息。>
```

> **為何要手動貼上，而非依賴 `Follow AGENTS.md` 短指令？** 治理設計本身是 self-contained — AI 應自動讀取上次留下的 handoff。然而實際測試顯示 `Follow AGENTS.md` 短指令的可靠度因 AI 工具與 model 而異：Claude Code Opus 約 85%、Claude Code Sonnet 約 60%、CoWork Opus 約 75%、CoWork Sonnet 約 40%。OPENING MESSAGE 區塊是明文指令 — 開頭兩行明確指示 AI 依序讀取 4 個治理檔，同一矩陣下可靠度提升至約 75–98%。多貼一次即可消除不確定性。如有疑慮，請貼上。

![為何要手動貼上](ref_doc/why_paste_handoff_tw.svg)

### :small_blue_diamond: 4) 建立 starter 專案 spec 或 runbook(guided wizard)

```text
build master spec
```

(或輸入 `build runbook` 建立一份重複執行流程的 runbook)

> **作用：** 給 AI 一句項目描述(或重複執行流程描述)。AI 一次過生成完整草稿，欄位全部填好，再附一份有編號的「我假設咗 ...」清單。你逐項挑錯(用編號或者口語都得)，AI 重 draft。draft 啱晒，AI 主動問「我寫入 `dev/PROJECT_MASTER_SPEC.md` 啦？」(或者 `dev/RUNBOOK.md`)。專為長期項目願景模糊、唔想答冷冰冰問題清單嘅用戶設計。行為定義在 `dev/wizards/playbook.md`；欄位結構在 `dev/templates/spec_template.md` 同 `dev/templates/runbook_template.md`(兩個都可以唔用 AI 自己 fill)。第一次安裝時(`INIT.md` 的 POST-INSTALL: Profile Selection 步驟)會自動觸發一次，新用戶無需知道 wizard 存在也能受益。

---

## :bookmark_tabs: 配額切換交接流程

1. 在命令列工具 A 的配額即將耗盡前，先完成本次收尾
2. 複製 `NEXT SESSION HANDOFF PROMPT (COPY/PASTE)` 區塊
3. 在命令列工具 B 原文貼上，不要改動內容
4. 工具 B 會依 `SESSION_HANDOFF.md` 與 `SESSION_LOG.md` 接續執行

這是本儲存庫的核心設計目標。

---

## :bookmark_tabs: 平台設定

`AGENTS.md` 為治理規則的單一真實來源；`CLAUDE.md` 與 `GEMINI.md` 為薄型指標檔。

| 平台 | 原生檔案 | 預設提供 | 若你已有該檔案 |
|---|---|---|---|
| **Codex** | `AGENTS.md` | `AGENTS.md`（完整規則） | 將治理章節合併到既有檔案 |
| **Claude Code** | `CLAUDE.md` | 指標檔：`@AGENTS.md` | 在既有 `CLAUDE.md` **最上方**加入 `@AGENTS.md` |
| **Gemini CLI** | `GEMINI.md` | 指標檔：`@./AGENTS.md` | 在既有 `GEMINI.md` **最上方**加入 `@./AGENTS.md` |

> **Codex 用戶：** AGENTS.md 超過預設 32 KiB context 上限。請在 `~/.codex/config.toml` 中加入 `project_doc_max_bytes = 49152` 以載入完整檔案。

---

## :bookmark_tabs: 3 種情境

### :small_blue_diamond: 情境 1 — 一個 AI 工具用盡配額，切換另一個工具續做
當你在某個命令列工具用盡配額時，可能需要立即切換到另一個工具。  
本範本可保留基線、待辦、風險與驗證狀態，避免重述上下文。

### :small_blue_diamond: 情境 2 — 一個儲存庫，多個 AI 工具協作
例如由 Codex 撰寫程式碼、Claude 處理文件、Gemini 協助除錯基礎設施。  
透過共用交接文件與工作日誌，可避免各工具對專案狀態產生分歧。

### :small_blue_diamond: 情境 3 — 長期專案治理開始漂移
修復逐步累積、規則持續擴張、文件彼此矛盾。  
「先整合、後新增」可降低 SOP 膨脹與長期維護成本。

---

## :bookmark_tabs: 常見問題

視覺化常見問題解答請見 **[互動式介紹頁面](https://prompt-templates.github.io/ai-session-governance/?lang=tw)**。

### :small_blue_diamond: 1) 這只適合大型專案嗎？
不是。小型專案馬上就有效果；大型專案時間拉長效益更明顯。

### :small_blue_diamond: 2) 第一天就需要 `PROJECT_MASTER_SPEC.md` 嗎？
不用。先用 `AGENTS.md` + `SESSION_HANDOFF.md` + `SESSION_LOG.md` 就夠了。

### :small_blue_diamond: 3) 這是編碼標準嗎？
不是。它規範 AI 怎麼讀、改、驗證、交接——不管你怎麼寫程式。

### :small_blue_diamond: 4) 這會拖慢 AI 嗎？
開始時有一點讀取時間，通常比重複交代情況和修正錯誤省時。

### :small_blue_diamond: 5) 我已經有 README、既有文件與內部規則，仍然適用嗎？
可以。它會跟你現有的合併，不會覆蓋掉。

### :small_blue_diamond: 6) 什麼時候不需要用這個？
如果你只是問一個問題、做一次性研究、或跑一個不會再回來的 session — 不用裝這個。啟動時要讀檔、收尾時要寫檔，這些 overhead 只有在你會跨多個 session 回到同一個專案時才值得。

這套範本是為持續進行的開發工作設計的：明天還會碰的 codebase、多個 AI 工具輪流上的 repo、「上週我們決定了什麼」這句話真的很重要的專案。如果你的工作不涉及隨時間變化的檔案，PLAN→READ→CHANGE→QC→PERSIST 流程沒有東西可以包住。

## :bookmark_tabs: 此儲存庫原始佈局

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
   ├─ archive/                 # 自動歸檔的舊記錄（按季度）
   ├─ DOC_SYNC_CHECKLIST.md    # 文件同步登錄表
   ├─ CODEBASE_CONTEXT.md      # 首次工作階段自動生成
   └─ PROJECT_MASTER_SPEC.md   # 可選
```

### :small_blue_diamond: 核心檔案

- `INIT.md` - 建立/合併治理檔案的啟動提示（公開入口）
- `AGENTS.md` - 治理單一真實來源
- `CLAUDE.md` - Claude 指標檔
- `GEMINI.md` - Gemini 指標檔
- `dev/SESSION_HANDOFF.md` - 當前基線與下一步優先事項
- `dev/SESSION_LOG.md` - 逐工作階段歷史與驗證結果（rolling window，自動整理）
- `dev/archive/` - 自動歸檔的舊工作日誌，按季度整理；啟動時不讀取
- `dev/DOC_SYNC_CHECKLIST.md` - 文件同步登錄表：將變更類別對應到必須更新的文件
- `dev/CODEBASE_CONTEXT.md` - 技術棧、外部服務、關鍵決策（首次工作階段自動生成）
- `dev/PROJECT_MASTER_SPEC.md` - 可選的長期權威規格

---

## :bookmark_tabs: 本範本背後的治理原則

1. 修改前先閱讀
2. 除錯前先分類
3. 新增前先整合
4. 宣稱完成前先驗證
5. 離開前先持久化

---

## :bookmark_tabs: 驗證紀錄

完整聲明對照與平台驗證請見：
- [docs/VERIFICATION.md](docs/VERIFICATION.md)
- 最新 QA 回歸驗收報告： [docs/qa/LATEST.md](docs/qa/LATEST.md)

截至 2026-05-01（v3.0.6）的摘要如下：
- AGENTS/INIT 規則同步：已驗證（315 項自動化回歸 — 226 主 + 89 legacy auto-chain）
- AGENTS.md governance 範圍：530 → 687 行（+29.6%）為 v3.0.5 Tier 2 整合；v3.0.6 視覺更新與用語簡化對行數中性；累計 −6.4% 對比 v2.x baseline (734)；所有規則與 290 個 grep-anchor 完整保留（212 baseline + R29×12 + R30×6 + entry-cap×3 + reply-behavior×6 + R31×17 + R32×34）
- Sandbox 安裝實戰驗收：3 個 HIGH 風險情景 PASS（含 user 自建檔的 re-install / §5a `pwd ≠ git root` mismatch / §4 closeout 端到端）
- Matrix QC 10 維審計（sandbox install）：PASS（rc.1 的 LOW finding 已由 rc.2 hotfix 解除）
- 交接效率驗證：仍有效（v2.7 的 30 組情景矩陣；在保留必要交接欄位下，啟動 payload 顯著下降）
- 多平台指標檔行為：已驗證

---

## :bookmark_tabs: 深度文件

若本儲存庫後續擴大，建議補充以下文件：

- `dev/PROJECT_MASTER_SPEC.md` — 完整架構、工作流程、發佈、操作手冊權威
- `docs/OPERATIONS.md` — 面向操作者的使用與維護程序
- `docs/POSITIONING.md` — 本範本的用途、非用途與定位

若上述檔案尚不存在，當前最小需求仍為：

- `AGENTS.md`
- `dev/SESSION_HANDOFF.md`
- `dev/SESSION_LOG.md`

---

## :bookmark_tabs: 設計者

> 由 **[Adam Chan](https://www.facebook.com/chan.adam)** 設計 · [i.adamchan@gmail.com](mailto:i.adamchan@gmail.com)
>
> *Vibe Coding 的時代，人人都能打造屬於自己的 AI 世界。*

---

## :bookmark_tabs: 授權

可自由使用、改編與擴展至你的工作流程中。
若你有改進，歡迎回饋可降低漂移且不增加複雜度的做法。
