---
name: constraint-charter
description: >-
  Persists Uncle Bob's "don't read the code" audit goals, gates, and numeric
  constraints as a versioned Constraint Charter (GATES.md), settled via grilling
  and wired into pre-commit/CI so correctness without reading code is part of
  the software itself. Use when the user says 约束宪章, constraint charter,
  把约束固化下来, 立宪, 门禁写进仓库, wants Uncle Bob-style gates as a committed
  project artifact, or is onboarding a project for agent development under
  constraints.
license: Apache-2.0
compatibility: Requires grilling-style Q&A; optional setup-pre-commit / CI tooling to enforce charter thresholds.
metadata:
  author: ontology-of-everything
  version: "0.1.0"
---

# 约束宪章 (Constraint Charter)

> "What I do instead is to surround the agents with extreme constraints." — Robert C. Martin, Jul 2026

`dont-read-the-code`（或不读代码协议）是立场，`verification-gauntlet` 是单次执行的引擎；本技能是**持久化层**：把审计目标与约束写成仓库里一份受版本控制的宪章文件，让门禁跨任务、跨会话、跨 agent 存续。约束不是聊天记录里的口头协议，而是软件本身的一部分。

**宪章文件**：`GATES.md`，置于仓库根（或用户指定处），提交入库。它是 agent 开工前必读、人类合并时唯一需要读的裁决依据。

## Agent discipline

歧义仅问改查证路径者；已述/已决不重问；可自证则推进；须裁断则一次一问。立宪阶段的决策题必须一次一问、附推荐答案。

## 工作流

### 1. 立宪 — grilling 式拷问（阻塞，先于任何代码）

用 `grilling` 的方式**一次只问一个问题**、每题附推荐答案，逐条确立下列决策。事实自己查（语言、工具链、现有 CI），**决策必须交用户拍板**：

- **审计目标**：这个软件"正确"由什么裁决？哪些路径是钱/安全/合规敏感路径（QA 详审级）？
- **验收语言**：Gherkin 场景用什么领域词汇（词汇未定先跑 `domain-modeling`）。
- **数值约束**，逐项确认阈值——每条约束必须是**工具强制执行的数字**，"写干净点"不是约束：
  - 圈复杂度上限（每函数）
  - 模块大小上限（行数 / 公共接口宽度，深模块词汇见 `codebase-design`）
  - 依赖方向（violations = build failure）
  - 覆盖率下限、变异分数下限（mutation score，这是"测试的测试"，是敢不读单测的依据）
- **读/不读矩阵**的项目级例外（默认：实现与单元测试不读；Gherkin / QA / 指标报告读）。
- **已知不测清单**：明确说出哪些东西有意不测、为什么。

### 2. 落章 — 写 GATES.md

宪章固定五节，全部可裁决、无形容词：

1. **审计目标** — 正确性的裁决者；敏感路径清单及其审查级别。
2. **约束表** — `约束 | 阈值 | 强制工具 | 强制位置(pre-commit/CI)` 四列，一行一门禁。
3. **验收入口** — Gherkin 场景存放路径 + 人类必须评审/共同撰写的声明。
4. **已知不测清单** — 有意留白之处，逐条注明理由。
5. **修宪记录** — 每次阈值变更：日期、旧值→新值、决策人、理由。

可选：同时落盘 `GATES.template.md` 仅当用户要求模板可复用。

### 3. 接线 — 宪章即执行

宪章里的每一行约束表都必须接到工具（`setup-pre-commit` + CI）。**写在宪章里但没有工具强制的约束，视为宪章缺陷**，与门禁红灯同级处理。靠人记得去跑的门禁不是门禁，是侥幸。

### 4. 运行 — 日常开发

- 每个任务开工前，agent 读 `GATES.md`；任务级门禁执行走 `verification-gauntlet`。
- 门禁红灯：把失败输出和数字**原样**递给 agent（"把 X 的复杂度降到 8 以下"），绝不代为手改。
- 同一门禁三次失败 = 设计问题而非努力问题：停下，重新 grilling，多半要重切 seam。

### 5. 修宪 — 变更协议

- 阈值只能通过"修宪"变更：交用户决策 → 记入修宪记录 → 改工具配置。**绝不为了变绿而放宽阈值、删场景、排除文件**。
- 新发现的失败模式（如 `code-review`、`dead-code` 抽查所得）转化为新约束条目入宪，而不是就地打补丁。

## 退出声明

Done = 宪章五节齐备且每条约束已接线 + 全部门禁对照宪章数字变绿 + 已知不测清单复述一遍。合并的论据是这份对照报告，不是"我看过了，没问题"。
