# concept-skills
[![skills.sh](https://skills.sh/b/ontology-of-everything/concept-skills)](https://skills.sh/ontology-of-everything/concept-skills)

> 先说清含义，再写代码、跑命令、起草规格。

[concept-skills](https://github.com/ontology-of-everything/concept-skills) 收录 8 个 [Agent Skills](https://agentskills.io/)，覆盖本体与语义层、概念设计和演示文稿制作。每个技能把协议留在轻薄的 `SKILL.md`，体量大的领域材料放在 `references/`，只在任务需要时加载。

华为云操作类技能现已迁移到 [`concept-git/cloud-concept-skills`](https://github.com/concept-git/cloud-concept-skills)，本仓库不再分发。

概念设计几个技能改编自 Daniel Jackson 的 concepts 与 synchronizations 模型 —— [The Essence of Software](https://essenceofsoftware.com/)（2021），sync 采用 *Beyond Objects*（[arXiv:2606.27258](https://arxiv.org/abs/2606.27258)）里现行的 when/where/then 记法 —— 面向 Agent 改编，未获作者背书。

English: [README.md](README.md)。

当前基线版本为 **1.0.0**。`concept-*` 全家仅显式调用；`concept-guardrails` 只消费 Jackson 记法。

## 目录

- [技能](#技能)
- [安装](#安装)
- [用法](#用法)
- [贡献](#贡献)
- [更新日志](CHANGELOG.zh.md)
- [许可](#许可)

## 技能

### 概念设计

从需求到模块，以概念模型为契约。每个技能停在自己的边界上交棒：`design` → `prd` / `implementation` → `audit`。

| 技能 | 版本 | 做什么 |
| --- | --- | --- |
| [`concept-design`](docs/skills/concept-design.md) | 0.7.0 | 仅显式调用 · 设计独立概念与同步组合；用 OP 检验概念目的，用端到端场景检验应用目的，以事实和反例审查论证 |
| [`concept-prd`](docs/skills/concept-prd.md) | 0.6.0 | 仅显式调用 · 将确认模型转录为总体 PRD、概念规格与同步规则，保留概念/应用目的、论证前提、未决取舍及验收追溯 |
| [`concept-implementation`](docs/skills/concept-implementation.md) | 0.7.0 | 仅显式调用 · 将确认模型实现为模块单体，保持概念独立与因果同步，规格共存，测试分别关联概念目的与应用目的 |
| [`concept-audit`](docs/skills/concept-audit.md) | 0.6.0 | 仅显式调用 · 只读审查概念与应用目的兑现论证；有代码时再核对实现符合性，覆盖适切性、独立性、组合、漂移和产品子集，按证据与根因路由修复 |
| [`concept-guardrails`](docs/skills/concept-guardrails.md) | 0.31.0 | 仅显式调用 · 六种模式处理规格覆盖、概念回填、漂移、管道、同步与地图；区分事实、推定目的及设计缺口，使用本仓 Jackson 记法，可选 wyx hooks |

### 本体与语义

企业知识来自 API / 数据库（`semantic-km-creator`）；个人知识来自原文（`semantic-pkm-creator`）。

| 技能 | 版本 | 做什么 |
| --- | --- | --- |
| [`semantic-km-creator`](docs/skills/semantic-km-creator.md) | 0.6.0 | 企业知识：把一套接口、CLI 或表/库做成粒度先行的 Kimball 语义层，经 HTML 决策工作台推进，输出 OKF 或 YAML，每个字段可追溯到观察到的证据 |
| [`semantic-pkm-creator`](docs/skills/semantic-pkm-creator.md) | 0.3.0 | 个人知识：两轮从原文萃取场景、概念、实体：先扫骨架给人确认，再回填 IPO、分解、组装与八种关系 |

### 胶片

| 技能 | 版本 | 做什么 |
| --- | --- | --- |
| [`html-slides`](docs/skills/html-slides.md) | 0.1.0 | 仅显式调用：大纲 → 逐页表 → 明文单文件 HTML 胶片；风格可插拔（generic、华为官方浅/深色、Apple）；可选导出 PPTX |

各技能细节与安全边界见 [docs/skills/](docs/skills/)，机器可读索引见 [docs/catalog.yml](docs/catalog.yml)，仓库更新日志见 [CHANGELOG.zh.md](CHANGELOG.zh.md)，各技能变更记录在 `qa/<name>/CHANGELOG.md`。

## 安装

需要 Node.js（用于 `npx`）。

```bash
npx skills add ontology-of-everything/concept-skills \
  --skill <skill-name> \
  --agent cursor \
  --copy -y
```

`--agent` 可填 `cursor`、`claude-code` 或 `codex`。一次装多个；加 `--global` 装到 `~/.agents/skills/`（Cursor 与 Codex 都会扫描），而不是项目的 `.agents/skills/`：

```bash
npx skills add ontology-of-everything/concept-skills \
  --skill concept-design concept-prd concept-guardrails \
  --agent cursor codex \
  --global --copy -y
```

列出可装技能，或开发时从本地目录安装：

```bash
npx skills add ontology-of-everything/concept-skills --list
npx skills add ./skills/<skill-name> --skill <skill-name> --agent cursor --copy -y
```

收录：[skills.sh](https://skills.sh/ontology-of-everything/concept-skills)（分组见 [`skills.sh.json`](skills.sh.json)）· [SkillsMP](https://skillsmp.com/)（仓库 topics：`claude-skills`、`claude-code-skill`）· [ClawHub](https://clawhub.ai/)。

各 Agent 说明：[Cursor](docs/agents/cursor.md) · [Claude Code](docs/agents/claude-code.md) · [Codex](docs/agents/codex.md)。

使用前先读一遍技能内容——技能以你的 Agent 权限运行。

## 用法

技能通常按 description 自动触发，正常说话就够。`concept-*` 全家默认不启动，必须显式指名（Cursor `/concept-design`，Codex `$concept-design`）：

```text
$concept-design 把这个需求建成概念模型
$concept-prd 模型定了，出一份 PRD 规格
$concept-guardrails 给 src/orders 写概念规格，然后查漂移
把这套接口做成语义层                        → semantic-km-creator
做一份 15 分钟产品介绍网页胶片               → $html-slides
```

要指名某个技能：Cursor 里用 `/skill-name`，Codex 里用 `$skill-name`。

## 贡献

[docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) · [docs/authoring.md](docs/authoring.md)

```bash
./tools/skill-scaffold.sh <skill-name>   # 新建技能
./tools/install-git-hooks.sh             # pre-commit → validate-all.sh
./tools/validate-all.sh                  # 全部技能，与 CI 一致
./qa/<skill-name>/validate.sh            # 单个技能
```

`skills/<name>/` 是安装载荷；门禁与 eval 放在 `qa/<name>/`，不随安装分发。每次改技能须同步：`skills/`、`qa/`（`VERSION`、`CHANGELOG.md`）、`docs/catalog.yml`、`docs/skills/<name>.md`。

## 许可

[Apache-2.0](LICENSE) © concept-skills contributors。发布到 [ClawHub](https://clawhub.ai/) 的技能包在该平台为 MIT-0；仓库源码仍为 Apache-2.0。
