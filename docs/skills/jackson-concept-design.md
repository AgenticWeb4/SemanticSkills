# Jackson 概念设计

`jackson-concept-design` · **Jackson Concept Design**

> 本文是给人看的中文说明，**不是** `npx skills add` 安装包内容。Agent 加载 [`skills/jackson-concept-design/SKILL.md`](../../skills/jackson-concept-design/SKILL.md)。

**Version:** 0.1.0 · Changelog:
[qa/jackson-concept-design/CHANGELOG.md](../../qa/jackson-concept-design/CHANGELOG.md)

## 一句话

把需求转成由独立 concepts 和 synchronizations 组成的概念模型：每个 concept 都用单一 Purpose、端到端 Operational Principle、最小 State 与完整 Actions 定义。

## 适用场景

- 需求还停留在功能、页面或实体清单，需要找到用户真正要掌握的功能单元。
- 已有概念模型出现边界糊模、功能碎片、交叉依赖或命名陌生。
- 需要在进入 PRD、架构或代码前，先确认用户面向的心理模型和行为边界。

## 方法

1. 从受益者、misfit、现有做法和期望结果开始，追问功能背后的需要。
2. 识别有独立目的的候选 concepts，而不把表、页面、实体名或团队边界直接映射成 concepts。
3. 用 Purpose、Operational Principle、State 和 Actions 刻画每个 concept。
4. 用专一、完整、独立、熟悉审查边界，并用 split/merge、unify/specialize、tighten/loosen 调整。
5. 把跨 concept 的触发与约束放入 synchronizations，在模型确认处停止。

## 安装载荷

```text
skills/jackson-concept-design/
├── SKILL.md
└── agents/openai.yaml
```

```bash
npx skills add ./skills/jackson-concept-design \
  --skill jackson-concept-design \
  --agent codex \
  --copy
```
