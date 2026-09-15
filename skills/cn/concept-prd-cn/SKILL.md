---
name: concept-prd-cn
description: Generates PRD files from a confirmed concept model only when the user explicitly invokes $concept-prd-cn. / 仅在用户显式调用 $concept-prd-cn 时转录概念 PRD。
metadata:
  language: zh-CN
  translation_of: concept-prd
  openclaw:
    homepage: https://github.com/ontology-of-everything/concept-skills/tree/main/skills/cn/concept-prd-cn
---

# 概念 PRD

焦点问题：如何把已确认模型持久化，使目的、行为与验收仍可追溯？仅在显式调用 `$concept-prd-cn` 时运行。输入模型含 concepts、syncs、依赖、排除与未决；模型缺口回 concept-design-cn，代码落地交 concept-implementation-cn。

## 概念与命题

**Concept** 是为一个目的设计的行为单元；转录须保存其含义及与其他模型元素的关系。

| 概念 | 定义及关系 |
| --- | --- |
| 确认模型 | 已授权的目的、行为及取舍；约束转录内容 |
| 权威规格 | 模型的唯一持久落点；CONCEPT 记录概念，SYNCS 记录协调，总体 PRD 索引全局关系 |
| 设计论证 | 概念契约 → OP → 概念目的；概念选择/sync → 应用场景 → 应用目的；转录保留两层关系及前提 |
| 验收场景 | 从 OP 或 state/actions 契约导出的具体检查，带来源；不生成新需求 |

核心命题：忠实转录保存定义、关系、前提与未决状态；文件齐全不能补足模型论证。模块已存在时规格与代码共存，未就绪时集中暂存，迁移后仍只保留一份权威文件。

## 转录与核对

1. **核对输入**：读确认模型、需求出处与现有文档；仅核实模块路径及索引所需代码事实。实际代码差异不能未经确认改写模型。
2. **确定落点**：以下为输出路径；模块未就绪时暂存。

   ```text
   docs/prd/README.md        # 总体 PRD
   <模块>/CONCEPT.md          # 或 docs/prd/concepts/<名>.md
   <syncs>/SYNCS.md           # 或 docs/prd/SYNCS.md
   ```

3. **写总体 PRD**：保存应用目的、端到端场景及其概念/sync 依据、Misfits、概念索引（purpose + 链接）、同步图、产品依赖与子集、排除和未决；跨概念前提及论证放这里。
4. **转录规格与验收**：读 [规格契约](references/spec-format.md) 与 [文件编排](references/templates.md)，CONCEPT 保留四节、概念内前提与目的兑现说明；应用背景进 notes。SYNCS 转录 app/include/sync，按入口或规则职责以 `// flow:` 分组，转录期单文件。概念 OP、应用场景和行为契约分别导出验收，均附出处；应用目标缺失时标未决，不从概念目的拼造。
5. **更新核对**：对已有文档做最小编辑，同步索引/派生图，保留人工维护内容；实现期迁移或 sync 拆包由 concept-implementation-cn 承接。

## 完成条件

- 每个模型元素有唯一落点，定义、关系、论证前提、排除与未决无遗漏；未确认信息保持原状态。
- CONCEPT 四节不依赖其他概念定义；同名局部参数合法；无 interactions/dependencies 段，应用实例化归 SYNCS。
- 验收可追溯到概念 OP、应用场景或行为契约；缺口不被占位内容包装成已确认行为。
- sync 参数、绑定与输出对应真实声明，可达失败策略保留，查询空集不变成错误；全局索引链接有效。

首次转录读 [订位例](references/example-reserving.md)；核验规格依据读 [sources.md](references/sources.md)。
