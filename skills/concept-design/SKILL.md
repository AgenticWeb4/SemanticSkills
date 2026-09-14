---
name: concept-design
description: Generates Daniel Jackson concept models (purpose, OP, state, actions, syncs) only when the user explicitly invokes $concept-design. / 仅在用户显式调用 $concept-design 时做概念建模。
metadata:
  openclaw:
    homepage: https://github.com/ontology-of-everything/concept-skills/tree/main/skills/concept-design
---

# 概念设计

焦点问题：应用要满足什么需要，哪些独立概念及同步组合能兑现它？仅在显式调用 `$concept-design` 时运行；交付模型，按已有授权继续 PRD/实现。伴生技能缺失时交付模型与缺口。

## 概念与关系

**Concept** 是为一个目的设计的连贯行为单元；页面、实体、代码模块只是候选线索。

| 概念 | 定义及关系 |
| --- | --- |
| 概念目的（purpose） | 一个可评价的需要，说明单个 concept 为什么存在 |
| 应用目的 | 特定产品希望为使用者达成的结果，由概念选择及同步组合实现；不等于各概念目的的简单相加 |
| OP（principle / operational principle） | 演示 concept 如何兑现 purpose 的典型且有区分力的场景；可用 after/then 表达 |
| state / actions | 行为契约：状态、不变量、动作前置条件、效果及输出 case；共同界定允许行为 |
| 场景 / 命题 | 场景描述条件下的具体行为；命题用明确关系连接概念，表达可检验的判断；OP 是场景，技能执行原则是取舍依据 |
| sync | 将概念动作的完成关联为后续调用的应用规则，承载跨概念行为 |
| misfit | 设计行为与实际需要不匹配；负面场景可揭示目的落空 |

关键命题：**概念契约支持 OP，OP 兑现概念目的；概念选择与 sync 支持应用场景，场景结果兑现应用目的**。组合必须保持各概念允许行为，局部论证成立不推出整体目的达成。OP 不覆盖全部行为；事实须有需求/模型/实现来源，推断与待决项另标。

## 两条原则

1. **论证目的兑现**：分别检查概念与应用两层的条件、行为、结果和目的关系；应用论证还核对概念选择与 sync，单一目的判据用于概念，不机械套用整个应用。
2. **用事实与反例检验**：从真实约束寻找目的落空的场景，区分模型缺陷、实现偏离和证据不足；反例推动修订，未找到反例不等于证明正确。

## 设计循环

1. **理解事实**：明确应用受益者、目的、现状、期望结果与约束。既有系统沿实际入口读调用、状态归属、失败路径及测试；分别记录现状与期望。
2. **定义候选**：先读 [规格契约与模板](references/spec-format.md)，澄清关键术语，写 purpose、OP、最小 state 和完整 actions；用具体场景检验含义，再将外部身份抽象为类型参数。
3. **审查论证与边界**：读 [criteria.md](references/criteria.md)，核对概念论证、反例及专一/完整/独立/熟悉；逐候选给边界结论与理由。
4. **组合检验**：读 [sync-notation.md](references/sync-notation.md)，以应用目的和端到端场景选择/实例化 concepts，定义 sync 的入口、绑定、响应、并发与失败；检查欠/过同步及是否扭曲概念目的，再派生两种图，验证 MVP。
5. **修订并交付**：按判据中的调整动作修正已证实的 misfits；保留未决前提、证据与影响，仅阻塞依赖部分。

## 规格与输出

类型参数可零个或多个，是不假定字段的身份；四节不依赖其他概念定义，同名局部参数合法。应用背景进 notes，协调归 sync，协议/表布局留在实现层。

````markdown
## 应用目的与场景
<用户、应用目的、现状、结果、约束；来源/推断/未决>
<成功/拒绝等端到端场景：条件 → 概念动作与 sync → 可观察结果 → 应用目的；misfits>

## Concepts
<按 spec-format.md 填写每个概念的 purpose、state、actions、operational principle；可选 queries/notes>

论证：<契约支持 OP、结果满足目的的依据；反例或未决>
边界：<专一/完整/独立/熟悉的结论及理由>

## Synchronizations
<app / include / sync；按入口或规则职责归组，关联应用场景及目的>

## 同步图与产品子集
<when → 规则节点 → then；where 另标读取>
<独立的产品依赖图：A → B 表示纳入 A 需要 B；MVP>

## 排除与未决
<候选/动作/前提、结论、来源及影响>
````

签名、结果分支与状态关系是同步接口；OP 是代表性场景。按共享契约区分论文格式、本地 query 扩展及旧方言，不能仅换标题或符号。

## 完成条件

- 概念定义/OP/边界及应用场景/组合分别有目的兑现依据；未知前提可见，示例不掩盖缺口。
- include、动作/query、参数、输出和绑定可解析；迁移保留触发、效果及失败语义。
- 各入口可达结果、排除动作和循环有明确策略；需响应时覆盖成功与拒绝，后台事件可无响应。
- 同步图保留多源合取、多目标与查询边；MVP 除依赖闭包外还满足入口、剩余规则与外部资源需要。

首次应用四节/组合读 [订位例](references/example-reserving.md)；核对 Jackson 定义及本仓约定读 [sources.md](references/sources.md)。
