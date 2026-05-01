[English](README.md) | [繁體中文](README.zh-TW.md) | 简体中文 | [日本語](README.ja.md)

# :rocket: 支持跨 AI 工具交接的开发治理模板

当 Codex、Claude 或 Gemini 的配额用尽，把交接区块贴到下一个工具，它就能从同样的状态继续，不用重新说明。

- 跨命令行工具交接
- 统一工作流程：`PLAN -> READ -> CHANGE -> QC -> PERSIST`
- 防止治理规则漂移，而不是一直叠加新规则
- 一个专注于 session 连续性的 Harness Engineering 组件

**[30 秒快速开始](#quickstart)** · **[安装](#install)** · **[升级](#upgrade)** · **[快速操作](#quick-operations)**

![Overview](ref_doc/overview_infograph_cn.png)

> **初次接触？** 请看 **[互动式介绍页面](https://prompt-templates.github.io/ai-session-governance/?lang=cn)** — 以可视化方式了解本模板的功能与设计理念。


---

## :bookmark_tabs: 为什么要做这个

用多个 AI 工具开发时，最先出问题的通常是交接，不是生成质量。

常见失败模式：
- 每次切换工具都要重头说明
- 修复叠在修复上，规则越来越乱
- 说明文档、交接文档、日志慢慢对不上

本模板规定：
1. 每个工作阶段只有一条重入路径
2. 每项任务走同一套工作流程
3. 每次收尾前必须留下可追溯的记录

---

## :bookmark_tabs: 内置防护机制

也涵盖几个常见的 AI 失误：

| 防护机制 | 防止什么 |
|---|---|
| **PLAN 风险分级** | 高风险任务（≥3 文件、范围不明、破坏性操作、外部系统）在 AI 确认理解正确前不会自动开始 — 高风险计划暂停等用户确认 |
| **外部 API 代码安全** | 根据训练记忆臆测端点 / 参数 / Schema 并直接写入 API 调用代码 |
| **代码库上下文快照** | 每次工作阶段切换后 AI 重新从零摸索技术栈、外部服务与关键决策 |
| **测试计划治理** | 合并变更时未记录情景矩阵 — 预期结果与实际结果未被追踪 |
| **整合纪律** | 持续叠加规则，却未先确认既有规则是否已涵盖或应更新 |
| **文档同步注册表** | 变更后猜测要更新哪些文档 — `DOC_SYNC_CHECKLIST.md` 将变更类别映射到必要更新项，AI 查表而非自行判断 |
| **工作日志自动维护** | 工作日志随时间增长到数千行，占用 AI 每次启动的 context — 收尾时由 AI 按触发条件自动整理旧记录，保持启动上下文精简 |
| **QC 失败处理** | AI 静默重试或放弃失败的测试 — 测试或构建失败时，AI 必须报告失败内容、诊断原因，并等待用户指示，而非自动重试 |
| **收尾误触保护** | 「好了谢谢」之类的日常用语意外触发完整 session closeout — 当语意模糊时，AI 会先确认是否真的要结束工作阶段 |
| **回复行为治理** | AI 用假装开放题反问推回用户、选项夹差选项充数、过量澄清问题、未核对 facts 当已核对写、surface text 用 `§` codes 做句子主语 — §11a（v3.0.3）令 5 条 reply rules mandatory：judgement-first、≤3 options + 推荐、≤3 假设 + ≤3 问题、`UNVERIFIED` 与 `NA` 区分、surface text 用人话 |

### :small_blue_diamond: SESSION_LOG.md 怎么保持精简

`dev/SESSION_LOG.md` 在每次工作阶段启动时都会被读取。在活跃的项目中，这个文件可能增长到数千行——把几个月前已无关的历史记录全部载入 AI 的 context。

本模板通过“明确收尾检查”处理（不是只靠规则记忆）：

- 收尾时 AI 会检查：`SESSION_LOG.md` 是否超过 **400 行**，或是否存在超过 **30 天**的旧记录
- 命中触发条件时，AI 先归档旧记录，再写入本次收尾
- 未命中触发条件时，AI 跳过归档，直接写入收尾
- 旧记录移动到 `dev/archive/`（不删除），并按季度整理为 `SESSION_LOG_YYYY_QN.md`
- 主日志目标维持在 ≤ **200 行**，并保留最近 2 个工作阶段
- AI 启动时只读 `SESSION_LOG.md`，归档文件不会被载入

若你已有一个庞大的工作日志，在升级后第一次工作阶段收尾时会自动整理，不需要手动操作。

---

## :bookmark_tabs: 近期版本

| 版本 | 变更内容 | 对你的意义 |
|---|---|---|
| **v3.0.3** | (1) **§4 entry-size cap** — SESSION_LOG 每条 entry 上限 ≤110 行（含 verbatim handoff block），release-class detail 关到 `dev/SESSION_STATE_DETAIL.md`，从根源防止 log 膨胀。(2) **§11a Reply Behavior** — AI 每次 reply 必跟 5 条 mandatory rules：judgement-first（不伪装开放题反问）、choice format（≤3 options + 推荐带可验证依据）、ambiguity handling（≤3 假设 + ≤3 问题 per round）、fact verification（`UNVERIFIED` 与 `NA` 区分）、plain-language surface text（surface 不用 `§` codes 做主语）。9 条新 R-checks（#167-175）做 AGENTS / INIT mirror parity + 新 marker line MANDATORY REPLY DISCIPLINE。 | 长期项目 active SESSION_LOG 保持精简（release-class entry 100+ 行不再霸占 startup reads）。AI 回复更果断易读 — 减少「你觉得呢」循环、未核对 facts 标示清楚、surface text 不需要 reader 懂 § code 才看得明。两条 rules 经 INIT.md 推到所有用户 install。 |
| **v3.0**（含 v3.0.1 / v3.0.2 patches） | 治理文档大幅精简：AGENTS.md 从 734 行缩减至 504 行（−31.3%），所有规则完整保留；每 session 启动的系统 prompt token 成本下降约 15.6%。Legacy quarantine 机制把 89 条历史防漂移检查隔离到自动 chain 的第二层 harness — 主检查套件变轻，但 release 时禁止 bypass legacy，历史保险不会无声丢失。v3.0.1 加入 release 后文档同步治理（R29 系列检查），防止 README / index.html 漂走。v3.0.2 把 release / merge gate 扩充为 4 阶段生命周期（发前验证 / 发 release / 发后执手尾 / 观察期），加 R30 系列 enforcement。已创建 `dev/SESSION_STATE_DETAIL.md` 或 `dev/PROJECT_MASTER_SPEC.md` 的用户 re-install 时也会被自动备份，升级路径数据安全。 | 系统 prompt 中的治理文本变少 → 规则遵守率提升（业界数据：短规则约 89% vs 冗长约 35%）；release 后相关文件漂走会自动 catch（README、release notes、公开页 stat counter 同步）；本地文件在升级时被保留；跨 LLM 通用兼容（Claude Code、Claude Cowork、OpenAI Codex CLI、Gemini CLI 与 Web LLMs）— 零 hook 依赖。 |
| **v2.8** | 强化 INIT-only 封装边界：移除 `INIT.md` 与 README 对内部维护工具的引用，并新增回归检查，若 INIT 指向未附带文件即判定失败。 | 避免仅提供 `INIT.md` 的安装场景出错，并可自动拦截后续封装边界漂移。 |
| **v2.7** | 完成交接与日志膨胀治理升级，并用 30 组增长场景完成验证。交接输出更稳定精简，日志增大时旧内容会自动移出启动主路径。 | 启动更快、context 浪费更少，同时保留关键交接信息。压力场景下启动 payload 最高减少 **16,096 tokens**，且所有测试场景都保持必要交接字段完整。 |
| **v2.6** | AI 接手旧 session 时，会读 `SESSION_LOG.md` 找「留给下一个 AI 的交接备注」。以前的规则是「找文件里最后出现的那段」— 日志经手动整理或归档后，物理位置最靠后的反而可能是旧的。现在改为找「日期最新那条记录里的那段」，日志怎么调整都能找对。`INIT.md` 安装前的 10 步安全确认流程，原本在文件里写了两份，且已累积 8 处以上措辞差异；现在顶部改成指向下方唯一版本的 3 行说明，两份不再冲突。Session 开始和结束时显示的装饰小图案，原本规则说「避免和上一次重复」— 但 AI 跨 session 根本记不住上次用了哪个，这条规则等于一纸空文。现在改为：同一次 session 内，结束小图必须和开始小图不同（AI 确实能做到）。单纯编辑治理文档时，不会再错误触发「安装前必须先生成 `CODEBASE_CONTEXT.md`」的要求。自动质量检查从 169 条增至 210 条，新增覆盖 Session ID 格式、禁用命令列表完整性、文件名规范等。 | 交接备注不再找错；安装说明只有一份不会互相矛盾；Session 启动与结束的小图案会切实轮换；日常编辑不再被安全流程拦住；自动拦截的异常情况更多，发布前更有把握。 |
| **v2.5** | 核心工作流程规则重新定位以提升 AI 注意力权重（从注意力死区移至高优先区域）；冗余段落合并（净减 3 行）；填补三个工作流程缺口 — AI 测试失败时报告而非静默重试、deviation stop 后明确声明重入哪个阶段、模糊表达不再误触 session closeout | 核心规则获得更一致的 AI 遵守率；维护负担减轻；失败和交接时的 AI 行为更可预测 |
| **v2.4** | AI 在 PLAN 阶段进行风险分级 — 高风险任务（≥3 文件、范围不明、破坏性操作、外部系统）暂停等用户确认才继续；工作日志改用精简格式（每条记录缩小约 60%）；归档门槛从 800 行降至 400 行，减少 AI 启动时读取的无关历史 | 误解任务在改 code 之前被拦截；AI 启动更快；相同空间容纳更多历史 |
| **v2.3** | 七项系统性审计修正：AI 在动手前先展示对任务的理解（PLAN 显示）、用户指令与治理规则冲突时明确指出、执行中发现假设错误时停下回报、简单问题不再强制四段式输出 | 减少任务误解、覆盖操作可追溯、错误假设造成的白做大幅减少 |
| **v2.2** | Session log 不再无限增长 — 当 `SESSION_LOG.md` 超过 400 行或有超过 30 天的旧记录时，旧记录会自动移至 `dev/archive/`；活跃日志保留最近 7–10 个工作阶段 | 长期项目保持精简，无需手动清理；几个月前的历史记录不再占用 AI 的启动上下文 |
| **v2.1** | 两项可靠性修正：(1) 收到交接时，新的 AI 工具现在有更明确的指示，要求在开始工作前先读取治理规则；(2) 做完任何修改后，AI 必须在回复中显示它更新了哪些文档 — 看不到这个区块就代表该步骤被跳过 | 切换 AI 工具时交接更稳定；文档更新是否有做，在 AI 的回复中一目了然，不再静默略过 |
| **v2.0** | `DOC_SYNC_CHECKLIST.md` — 确定性文档同步注册表，将变更类别映射到必须更新的文档；`AGENTS.md` 加入章节标记（MANDATORY / CONDITIONAL / REFERENCE） | 消除文档同步猜测：AI 查表决定要更新什么，而非自行判断 |
| **v1.9.0** | 六项治理修正：新会话的三种触发条件、收尾时强制跨文件同步、优先事项清单每次重新生成而非累加、修改操作精确化 | 修正从实际应用中发现的 AI 行为缺口 — 过期清单、遗漏文件同步、范围歧义 |
| **v1.8.0** | 新增上下文压缩恢复规则 — AI 在对话被压缩后必须重新执行启动序列，不可信任压缩摘要中的待办清单 | 防止 Claude Code 自动压缩上下文后，AI 静默沿用过期的待办清单 |
| **v1.7.0** | 交接 Prompt 首段新增明确指示：先读 `AGENTS.md`，再依启动序列执行 | 接收工具就算不自动加载治理文件，交接也能正常衔接 |
| **v1.6.0** | 安装后自动输出 Quick Start 指令；`CODEBASE_CONTEXT.md` 生成前先备份，并扩大扫描来源 | 安装完直接有指令可用；首次上下文采集更完整 |

---

<a id="quickstart"></a>

## :bookmark_tabs: 30 秒快速开始

1. 打开 **[INIT.md](INIT.md)**，并粘贴到你的 AI 命令行工具中。
2. 按提示精确回复：
   - `INSTALL_ROOT_OK: <absolute_path>`
   - `INSTALL_WRITE_OK`
3. 之后每次新工作阶段开始时，输入：

```text
请按 AGENTS.md 开始本次工作阶段
```

---

<a id="install"></a>

## :bookmark_tabs: 安装

1. 打开 **[INIT.md](INIT.md)** -> 点击 **Raw** -> 全选 -> 复制
2. 粘贴到你的 AI 命令行工具（Claude Code、Codex、Gemini CLI 均可）
3. AI 会先执行根目录安全预检，并按顺序显示路径：`pwd`、`git root`
4. 若 `pwd` 与 `git root` 不一致，AI 必须先停止，并要求你选择根目录（1：使用 `pwd`，2：使用 `git root`）；AI 不可自行决定
5. AI 会针对你选择的根目录显示风险检查与演练规划（`create` / `merge` / `skip`），此时仍不会写入文件
6. 出现提示后，请回复以下确认句：
   - `INSTALL_ROOT_OK: <absolute_path>`
   - `INSTALL_WRITE_OK`
7. 在首次写入前，AI 会在 `<PROJECT_ROOT>/dev/init_backup/<UTC_TIMESTAMP>/` 自动创建轻量备份快照，保存已有治理目标文件
8. AI 会在你确认的项目根目录中创建或合并治理文件
9. AI 自动输出 **Quick Start** 区块，含可直接复制粘贴的操作指令 — 无须另行记忆

### :small_blue_diamond: 安装流程界面

<table>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_1.png" alt="安装流程步骤 1" width="92%" />
      <br />
      <sub>步骤 1：将 `INIT.md` 粘贴到 AI 命令行工具</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_2.png" alt="安装流程步骤 2" width="92%" />
      <br />
      <sub>步骤 2：确认检测到的根目录</sub>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_3.png" alt="安装流程步骤 3" width="92%" />
      <br />
      <sub>步骤 3：回复 `INSTALL_ROOT_OK`</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/install_step_4.png" alt="安装流程步骤 4" width="92%" />
      <br />
      <sub>步骤 4：回复 `INSTALL_WRITE_OK`</sub>
    </td>
  </tr>
</table>

完成步骤 4 确认后，AI 在写入任何文件前会先创建备份。

### :small_blue_diamond: 实际执行界面

<table>
  <tr>
    <td align="center" width="50%">
      <img src="ref_doc/launch.png" alt="启动界面" width="92%" />
      <br />
      <sub>启动：工作阶段开机与上下文加载</sub>
    </td>
    <td align="center" width="50%">
      <img src="ref_doc/closesession.png" alt="完工收尾界面" width="92%" />
      <br />
      <sub>收尾：工作阶段摘要与交接输出</sub>
    </td>
  </tr>
</table>

AI 自动处理并合并已有的 `AGENTS.md`、`CLAUDE.md`、`GEMINI.md`。
大多数情况下，直接使用 `INIT.md` 就够了。
不要手动复制整个仓库，用 `INIT.md` 安装才能安全合并。

**已安装并想升级？** 同样运行 `INIT.md` — 详见下方[从旧版升级](#upgrade)。

---

<a id="upgrade"></a>

## :bookmark_tabs: 从旧版升级

重新运行最新版 `INIT.md`，步骤与初次安装完全相同。

1. 打开 **[INIT.md](INIT.md)** → 点击 **Raw** → 全选 → 复制
2. 粘贴到你的 AI 命令行工具（Claude Code、Codex、Gemini CLI 均可）
3. 依次确认：`INSTALL_ROOT_OK: <absolute_path>`，再回复 `INSTALL_WRITE_OK`
4. AI 先备份现有文件，再将治理章节合并至最新版本

**安全升级通用 prompt（可直接复制）：**

```text
请用这份 INIT.md 执行治理升级，只做 merge 整合。
不得覆盖、删除或重置我现有的自定义 governance 规则/内容/文件。
请先显示 dry-run 计划（create/merge/skip），再等待我确认 INSTALL_ROOT_OK 与 INSTALL_WRITE_OK。
```

**升级时 AI 的动作：**
- 现有 `AGENTS.md`、`CLAUDE.md`、`GEMINI.md` → **merge**（治理章节更新至最新，你的自定内容保留）
- `dev/DOC_SYNC_CHECKLIST.md` → **merge**（项目自定义行保留，缺少的通用行自动补充）
- `dev/SESSION_HANDOFF.md`、`dev/SESSION_LOG.md` → **skip**（工作阶段记录绝对不动）
- 安装步骤 5 显示的 dry-run 计划会在写入前确认各文件为 `merge` / `skip`

适用任何已安装版本。

---

<a id="quick-operations"></a>

## :bookmark_tabs: 快速操作

以下句子可直接复制粘贴。

### :small_blue_diamond: 1) 开始新工作阶段

```text
请按 AGENTS.md 开始本次工作阶段
```

### :small_blue_diamond: 2) 收尾并完成完整交接

```text
请为本次工作阶段完成收尾与完整交接。
```

### :small_blue_diamond: 3) 快速开始下一个工作阶段

```text
<请粘贴上一轮输出的“NEXT SESSION HANDOFF PROMPT (COPY/PASTE)”区块（保持原文）。>
```

---

## :bookmark_tabs: 配额切换交接流程

1. 在命令行工具 A 的配额即将耗尽前，先完成本次收尾
2. 复制 `NEXT SESSION HANDOFF PROMPT (COPY/PASTE)` 区块
3. 在命令行工具 B 原文粘贴，不要改动内容
4. 工具 B 会依据 `SESSION_HANDOFF.md` 与 `SESSION_LOG.md` 接续执行

这是本仓库的核心设计目标。

---

## :bookmark_tabs: 平台设置

`AGENTS.md` 为治理规则的单一真实来源；`CLAUDE.md` 与 `GEMINI.md` 为薄型指针文件。

| 平台 | 原生文件 | 预设提供 | 若你已有该文件 |
|---|---|---|---|
| **Codex** | `AGENTS.md` | `AGENTS.md`（完整规则） | 将治理章节合并到已有文件 |
| **Claude Code** | `CLAUDE.md` | 指针文件：`@AGENTS.md` | 在已有 `CLAUDE.md` **最上方**加入 `@AGENTS.md` |
| **Gemini CLI** | `GEMINI.md` | 指针文件：`@./AGENTS.md` | 在已有 `GEMINI.md` **最上方**加入 `@./AGENTS.md` |

> **Codex 用户：** AGENTS.md 超过默认 32 KiB context 上限。请在 `~/.codex/config.toml` 中添加 `project_doc_max_bytes = 49152` 以加载完整文件。

---

## :bookmark_tabs: 3 种场景

### :small_blue_diamond: 场景 1 — 一个 AI 工具用尽配额，切换另一个工具续做
当你在某个命令行工具用尽配额时，可能需要立即切换到另一个工具。  
本模板可保留基线、待办、风险与验证状态，避免重述上下文。

### :small_blue_diamond: 场景 2 — 一个仓库，多个 AI 工具协作
例如由 Codex 编写代码、Claude 处理文档、Gemini 协助调试基础设施。  
通过共用交接文档与工作日志，可避免各工具对项目状态产生分歧。

### :small_blue_diamond: 场景 3 — 长期项目治理开始漂移
修复逐步累积、规则持续扩张、文档彼此矛盾。  
“先整合、后新增”可降低 SOP 膨胀与长期维护成本。

---

## :bookmark_tabs: 常见问题

可视化常见问题解答请见 **[互动式介绍页面](https://prompt-templates.github.io/ai-session-governance/?lang=cn)**。

### :small_blue_diamond: 1) 这只适合大型项目吗？
不是。小型项目马上就有效果；大型项目时间拉长效益更明显。

### :small_blue_diamond: 2) 第一天就需要 `PROJECT_MASTER_SPEC.md` 吗？
不用。先用 `AGENTS.md` + `SESSION_HANDOFF.md` + `SESSION_LOG.md` 就够了。

### :small_blue_diamond: 3) 这是编码标准吗？
不是。它规范 AI 怎么读、改、验证、交接——不管你怎么写代码。

### :small_blue_diamond: 4) 这会拖慢 AI 吗？
开始时有一点读取时间，通常比重复交代情况和修正错误省时。

### :small_blue_diamond: 5) 我已经有 README、既有文档与内部规则，仍然适用吗？
可以。它会跟你现有的合并，不会覆盖掉。

### :small_blue_diamond: 6) 什么时候不需要用这个？
如果你只是问一个问题、做一次性研究、或跑一个不会再回来的 session — 不用装这个。启动时要读文件、收尾时要写文件，这些 overhead 只有在你会跨多个 session 回到同一个项目时才值得。

这套模板是为持续进行的开发工作设计的：明天还会碰的 codebase、多个 AI 工具轮流上的 repo、「上周我们决定了什么」这句话真的很重要的项目。如果你的工作不涉及随时间变化的文件，PLAN→READ→CHANGE→QC→PERSIST 流程没有东西可以包住。

## :bookmark_tabs: 此仓库原始布局

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
   ├─ archive/                 # 自动归档的旧记录（按季度）
   ├─ DOC_SYNC_CHECKLIST.md    # 文档同步注册表
   ├─ CODEBASE_CONTEXT.md      # 首次工作阶段自动生成
   └─ PROJECT_MASTER_SPEC.md   # 可选
```

### :small_blue_diamond: 核心文件

- `INIT.md` - 创建/合并治理文件的启动提示（公开入口）
- `AGENTS.md` - 治理单一真实来源
- `CLAUDE.md` - Claude 指针文件
- `GEMINI.md` - Gemini 指针文件
- `dev/SESSION_HANDOFF.md` - 当前基线与下一步优先事项
- `dev/SESSION_LOG.md` - 逐工作阶段历史与验证结果（rolling window，自动整理）
- `dev/archive/` - 自动归档的旧工作日志，按季度整理；启动时不读取
- `dev/DOC_SYNC_CHECKLIST.md` - 文档同步注册表：将变更类别映射到必须更新的文档
- `dev/CODEBASE_CONTEXT.md` - 技术栈、外部服务、关键决策（首次工作阶段自动生成）
- `dev/PROJECT_MASTER_SPEC.md` - 可选的长期权威规格

---

## :bookmark_tabs: 本模板背后的治理原则

1. 修改前先阅读
2. 调试前先分类
3. 新增前先整合
4. 宣称完成前先验证
5. 离开前先持久化

---

## :bookmark_tabs: 验证记录

完整声明对照与平台验证请见：
- [docs/VERIFICATION.md](docs/VERIFICATION.md)
- 最新 QA 回归验收报告： [docs/qa/LATEST.md](docs/qa/LATEST.md)

截至 2026-05-01（v3.0.3）的摘要如下：
- AGENTS/INIT 规则同步：已验证（264 项自动化回归 — 175 主 + 89 legacy auto-chain）
- AGENTS.md L4 精简：734 → 521 行（−29.0%），所有规则与 227 个 grep-anchor 完整保留（212 baseline + R29×12 release-doc sync + R30×6 release-lifecycle 4-phase + entry-cap×3 + reply-behavior×6）
- Sandbox 安装实战验收：3 个 HIGH 风险场景 PASS（含 user 自建文件的 re-install / §5a `pwd ≠ git root` mismatch / §4 closeout 端到端）
- Matrix QC 10 维审计（sandbox install）：PASS（rc.1 的 LOW finding 已由 rc.2 hotfix 解除）
- 交接效率验证：仍有效（v2.7 的 30 组场景矩阵；在保留必要交接字段下，启动 payload 明显下降）
- 多平台指针文件行为：已验证

---

## :bookmark_tabs: 深度文档

若本仓库后续扩大，建议补充以下文档：

- `dev/PROJECT_MASTER_SPEC.md` — 完整架构、工作流程、发布、操作手册权威
- `docs/OPERATIONS.md` — 面向操作者的使用与维护程序
- `docs/POSITIONING.md` — 本模板的用途、非用途与定位

若上述文件尚不存在，当前最小需求仍为：

- `AGENTS.md`
- `dev/SESSION_HANDOFF.md`
- `dev/SESSION_LOG.md`

---

## :bookmark_tabs: 设计者

> 由 **[Adam Chan](https://www.facebook.com/chan.adam)** 设计 · [i.adamchan@gmail.com](mailto:i.adamchan@gmail.com)
>
> *Vibe Coding 的时代，人人都能打造属于自己的 AI 世界。*

---

## :bookmark_tabs: 许可

可自由使用、改编与扩展到你的工作流程中。
若你有改进，欢迎回馈可降低漂移且不增加复杂度的做法。
