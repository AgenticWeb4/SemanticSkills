---
name: jackson-concept-design
description: Model or review requirements as Jackson concepts defined by Purpose, OP, State, and Actions, then compose them with Syncs. Use this skill whenever the user asks to discuss requirements or review a concept model; stop at model confirmation without producing engineering documents or code.
---

# Jackson 概念设计

把需求转成可理解、可评价、可组合的概念模型。停在模型确认；除非用户明确要求，不生成 PRD、架构或代码。本文是按 Jackson 的结构、判据与设计动作整理的操作循环，不冒充作者原文流程。

## 核心模型

Concept 同时是用户为有效使用软件而掌握的**心理构造**，和与之对应的**连贯功能单元**。应用由独立 concepts 组成，由 synchronizations（syncs）联结成应用行为；界面和术语表达概念，代码实现概念，但都不是概念本身。

```text
Concept = Name + Purpose + Operational Principle + State + Actions
```

- **Name**：简短易记，唤起正确、熟悉的心理模型。
- **Purpose**：为何存在、给谁什么价值；need-focused、specific、evaluable，且恰好一个。
- **Operational Principle（OP）**：少量端到端典型故事，展示如何使用并兑现 purpose。写法：
  - 历史要足够长，结尾兑现 purpose——注册本身无价值，随后认证才展示 Password 的目的；
  - 一次只解释一个 concept，写 actions 与结果，不写界面、协议或表结构；
  - 先用当前场景的具体对象写以检验价值，成立后再改写为多态通用版本；
  - OP 解释本质，不替代规范：行为由 state machine（state + actions）完整规定。
- **State**：运行中为支持行为必须记住的事实，不是领域知识或数据库设计。User、Item 等实体通常只是这里的身份类型或多态参数，不是顶层模块。
- **Actions**：用户或系统执行的抽象行为，读取或改变 state；定义条件、输入、输出与效果，不拆成界面步骤。

## 设计循环

重复 1–5 直到 misfits 消失。先确认 purpose 与边界，再确认名称和细节；全程区分已确认、推断与待决定。

1. **找需要**：明确受益者、misfit、现有做法、期望结果与约束；把"要什么"追问成"为什么"。暂不讨论页面、数据库和服务。
2. **识别候选**：从具体场景自下而上找细粒度目的，优先熟悉、可复用的概念；不从名词表、实体、页面或团队边界映射。边界不明先保留备选。
3. **逐个刻画**：写 Name、Purpose、具体 OP，由 OP 推导 actions 和最小 state；删除行为不需要的 state，补齐必要 action，成立后参数化上下文对象。
4. **批评边界**：对每个候选过一遍资格判据与四词（见下节），结论只用：`保留`、`拆分`、`合并`、`参数化`、`降级为 type/action/implementation`、`移至 sync`、`待确认`。
5. **组合再设计**：用 syncs 表达跨概念行为与应用入口，检查一致与可选子集。调整用三对 design moves：**split/merge**（控制力 vs 简单）、**unify/specialize**（通用 vs 贴合）、**tighten/loosen**（自动化 vs 灵活）。

## 判据

**资格**——候选是否够格成为 concept：

- **用户可感（User-facing）**：用户能体验其功能；API 中程序员也是用户。
- **语义性（Semantic）**：表达抽象意义，不是控件、样式或技术机制。
- **行为性（Behavioral）**：有动态行为，不只是分类与属性。
- **目的性（Purposive）**：独立带来真实、可评价的价值。
- **端到端（End-to-end）**：从动作延伸到兑现目的的结果。

第六条资格——独立性——与四词中的**独立**是同一判据，见下。

**四词**——批评边界与输出判断统一用这四个词：

- **专一（Specificity）**：只承担一个不可分的目的；多目的即 conflation，拆分。
- **完整（Completeness）**：含兑现目的所需的全部功能；只有片段即 fragmentation，合并或补齐。
- **独立（Independence）**：无需引用其他 concept 即可理解；共享对象用类型参数抽象，如 `Comment<Target>` 而非 `Comment<Post>`。
- **熟悉（Familiarity）**：优先沿用已知概念并保持惯例；新概念须提供熟悉概念或其组合给不了的价值。

**组合后再查**：

- **复用（Reusability）**：通常是四词达标的结果，不是充分条件。
- **一致（Integrity）**：同一 concept 各处保持名称、目的与行为，组合不改变其含义。

## 常见误判速查

名称只是线索：Trash、Password、Reservation 因 purpose 与 behavior 成为 concepts。

| 候选 | 通常归属 | 另立 concept 的条件 |
| --- | --- | --- |
| User、Order 等实体 | state 中的类型/身份 | 自身有独立目的和完整动态行为 |
| 表、类、微服务、页面、控件 | 实现或表达层 | 实现结构恰好承载一个完整 concept 时才可能对应；界面元素不成为 concept |
| register、save 等 | 单个 action | 自身兑现独立目的时重新判断 |
| 故事、用例、feature、workflow | 场景/流程切片 | 独立、端到端服务恰好一个目的且有自己的状态机 |
| 跨概念触发规则 | sync | 自有目的、状态和完整行为 |

## Sync 与依赖

Sync 约束多个 concept 的 actions 共同发生，用于触发、连接或限制应用行为。Concept 规范不点名其他 concepts；组合只写在 app/sync 层。

- **Intrinsic dependency**：concept 定义引用另一 concept——消除（参数化或移至 sync）。
- **Extrinsic dependency**：应用选了 A 才有理由选 B——可以存在，但不写进 A 的定义。

## 输出格式

```markdown
## 需求与 Misfits
- 用户 / 需要 / 问题 / 结果 / 约束

## Concepts
### <Name<Type>>
- Purpose:
- Operational Principle:
- State:
- Actions:
- 判断: 专一 / 完整 / 独立 / 熟悉

## Synchronizations
| 应用动作 | When | 同步动作 | 组合理由/风险 |

## 排除与未决
| 候选/问题 | 结论 | 理由/取舍 |
```

## 完成条件

- 每个 concept 恰好一个 purpose，OP 以兑现该 purpose 的结局收尾。
- 每个 concept 的四词判断均有结论，结论词出自设计循环第 4 步词表。
- State 与 actions 完整规定行为，无界面、协议或表结构细节。
- 无 intrinsic dependency；跨概念行为全部落在 Synchronizations 表。
- 被否决的候选与待决取舍全部进入排除与未决表，无空悬项。

## 一手依据

核验 Jackson 观点只用作者的[官方教程](https://essenceofsoftware.com/tutorials/)、[概念设计综述](https://essenceofsoftware.com/posts/distillation/)与 [Design moves](https://essenceofsoftware.com/posts/design-moves/)；引用时区分原句、忠实转述与本技能的操作性综合。
