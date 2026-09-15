---
name: concept-guardrails-cn
description: Run concept-spec guardrails (audit, concept, drift, pipeline, sync, map) only when the user explicitly invokes $concept-guardrails-cn. / 仅在用户显式调用 $concept-guardrails-cn 时运行概念规格护栏。
compatibility: 只需读写文件与 Grep/Glob；可选的边界注入运行时需要 Claude Code hooks 与 jq。
metadata:
  language: zh-CN
  translation_of: concept-guardrails
  author: ontology-of-everything
  version: "0.32.0"
  openclaw:
    homepage: https://github.com/ontology-of-everything/concept-skills/tree/main/skills/cn/concept-guardrails-cn
---

# 概念护栏

焦点问题：现有规格是否清楚表达模块契约，并与事实及派生地图对应？仅在显式调用 `$concept-guardrails-cn` 时运行。流程改编自 [wyx v0.26.0](https://github.com/jlifyio/wyx)（MIT，见 `LICENSE.upstream`）；规格用本仓 Jackson 方言，runtime 保留上游脚本。

## 概念与关系

**Concept** 是为单一目的设计的行为单元；规格声明契约，事实支撑判断，地图呈现派生关系。

| 对象 | 契约与权威关系 |
| --- | --- |
| CONCEPT.md | purpose/state/actions/operational principle 定义概念；OP 解释目的兑现，行为契约支持 OP；可选 notes 记录应用背景 |
| SYNCS.md | app/include/sync 记录跨概念协调，服务总体 PRD 的应用目的与场景；when/where/then 定义规则，`// flow:` 组织它们 |
| PIPELINE.md | 来源、阶段、输出、不变量、触发与 data boundary 记录数据质量；属本仓补充，不替代 sync |
| ARCHITECTURE.md | 从规格派生导航地图；产品依赖来自总体 PRD，不从同步边推导 |
| 回填 / 漂移 | 回填从实现重建可证实的契约；漂移对比契约与实现，二者都不能证明目的适切性 |

核心命题：规格覆盖不推出设计正确；地图准确不推出代码符合规格。推定目的须标为推断，不能用理想 OP 合理化当前缺陷。

## 模式与场景

`$concept-guardrails-cn <模式> [路径或描述]`；路径 → 回填，描述 → 新建，无参数 → 发现候选。未指定模式或项目无规格时先 audit。

| 模式 | 产出 / 必读参考 |
| --- | --- |
| `audit` | 只读覆盖与命令计划：[audit.md](references/audit.md) |
| `concept` | 概念候选或 CONCEPT：[concept.md](references/concept.md) |
| `drift` | 只读漂移报告：[drift-detection.md](references/drift-detection.md) |
| `pipeline` | 管道候选或 PIPELINE：[pipeline.md](references/pipeline.md) |
| `sync` | 协调候选或 SYNCS：[sync.md](references/sync.md) |
| `map` | 派生地图：[map.md](references/map.md) |

复杂建模 → concept-design-cn；确认模型批量转录 → concept-prd-cn；目的适切性、全面独立性与组合审计 → concept-audit-cn。伴生技能不可用时报告交接内容。

## 执行约束

- 先读规格、实现和项目约定。回填标出现状缺陷；已确认的新行为先改规格再改实现。
- 写入前呈现草案/diff；已有创建/修复授权直接完成，只有未决模型取舍或超出授权才确认。发现模式只列候选；只读审计不写历史或修复。
- 每概念一份权威规格；所属 PIPELINE 同目录，跨概念管道放组合层；每个 sync 包一份 SYNCS，按 flow 归组。规格变化时提示已有地图需重建，已授权则完成。
- 生成/读取 CONCEPT、SYNCS 或核对管道接口前，读 [规格契约](references/spec-format.md)：四节独立、具名输入/输出、case 匹配及查询绑定统一按此核对。新写用 operational principle，读取兼容 principle 与旧签名。
- wyx 旧 interactions/dependencies/known coupling/dispatching/coordination graph/sync: 段标待迁移，不混读；授权迁移时一起重写 CONCEPT/SYNCS/PIPELINE，保留触发、绑定、效果与失败语义。

## 完成条件

产出符合所选模式，定义、关系和引用有据可查；回填区分事实、推断与未决。报告扫描范围和修复方向；地图依内容重建，不以时间戳证明新鲜度。

启用自动注入时读 [hooks-runtime.md](references/hooks-runtime.md)：hooks 仅列规格、提示陈旧及注入 PIPELINE data boundary，不验证语义边界。
