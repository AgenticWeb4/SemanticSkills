---
name: jackson-concept-prd
description: Transcribes a confirmed Jackson concept model into PRD documents (overall PRD, one sub-PRD per concept, syncs grouped by flow). Use this skill whenever the user asks for a concept PRD, 规格文档, or mentions jackson-concept-prd; do not invent model content.
---

# Jackson 概念 PRD（设计规格）

输入是已确认的概念模型（`jackson-concept-design` 的输出）。概念设计即设计规格：本技能只做转录与编排，不发明模型外的内容；发现模型缺口时回上游技能补模，不在文档里私自填补。文档交付后，代码落地用 `jackson-concept-implementation`。

## 文档族

默认路径（用户可覆盖）：

```text
docs/prd/
  README.md               # 总体 PRD：应用层视图
  concepts/<域>/<名>.md    # 每概念一份：独立可验证
  syncs/<flow>.md          # sync 多时按 flow 拆分；少则收进 README
```

- **域只是目录分组**（导航用），不承载语义：域内概念不共享状态、无特权引用。分域参考依赖图的聚类。
- 生成后这组文件就是模型的**持久形态（single source）**：模型变更后重新生成对应文件，不手改，避免规格与模型漂移。

## 总体 PRD（README.md）

- **需求与 Misfits**：用户 / 需要 / 问题 / 结果 / 约束。
- **概念索引**：按域分节，每概念一行 purpose + 子 PRD 链接。
- **Synchronizations**：按 flow 分组的 sync 块（多则拆到文档族里的 syncs 目录）。
- **依赖图与子集**：extrinsic 依赖、MVP 与版本裁剪。
- **排除与未决**：全量转录。

## 每概念子 PRD

铁律：**零点名其他概念**——上下文只以类型参数出现（`Comment<Target>`），组合信息只在总体 PRD。每份子 PRD 因此独立可读、可验证、可复用。

```markdown
# <Name<Type>>
- Purpose:
- Operational Principle:
- State:
- Actions:（含正常与错误两类结果）
- 判断: 专一 / 完整 / 独立 / 熟悉
- 验收场景: 由 OP 机械导出（OP 的每条历史 = 一条验收）
- 非功能约束: ［占位，由人补充］
```

## Sync PRD（按 flow）

Flow = 一个外部请求触发、多条细粒度 sync 接力的动作链。**不按域拆 sync**——sync 常跨域，按 flow 聚合才能看出欠同步与过同步。

```markdown
# Flow: <名>
触发: <外部请求/动作>

（sync 块，记法同 jackson-concept-design）

排除动作: 本 flow 有意不同步的概念动作及理由
```

## 完成条件

- 模型输出的每个部分（concepts、syncs、依赖图、排除与未决）都有唯一落点，无遗漏无重复。
- 每份概念子 PRD 零点名其他概念。
- 每条验收场景可追溯到 OP；文档无模型外的新信息（非功能占位除外）。
- 总体 PRD 可导航到全部子文档，链接有效。

## 依据

概念规范即规格：[WYSIWID 论文](https://arxiv.org/abs/2508.14511)（概念规范可直接生成代码与测试、行为增量 = sync 的增删）；记法与判据沿用 `jackson-concept-design`，不另立标准。
