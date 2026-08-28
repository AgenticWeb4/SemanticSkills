# Jackson 概念 PRD

`jackson-concept-prd` · **Jackson Concept PRD**

> 本文是给人看的中文说明，**不是** `npx skills add` 安装包内容。Agent 加载 [`skills/jackson-concept-prd/SKILL.md`](../../skills/jackson-concept-prd/SKILL.md)。

**Version:** 0.1.0 · Changelog:
[qa/jackson-concept-prd/CHANGELOG.md](../../qa/jackson-concept-prd/CHANGELOG.md)

## 一句话

把已确认的概念模型转录为 PRD 文档族：总体 PRD、每概念一份子 PRD、syncs 按 flow 分组。只转录，不发明。

## 适用场景

- 概念模型已确认，需要可导航、可验收的规格文档。
- 后续要按概念独立验证，或按 flow 看出欠同步与过同步。
- 发现模型缺口时应回到 `jackson-concept-design`，而不是在文档里填补。

## 方法

1. 总体 PRD 收录需求与 misfits、概念索引、syncs、依赖图与排除项。
2. 每概念一份子 PRD，零点名其他概念；验收场景由 OP 机械导出。
3. sync 按 flow 聚合，不按域拆分。
4. 不写代码；落地用 `jackson-concept-implementation`。

## 安装载荷

```text
skills/jackson-concept-prd/
├── SKILL.md
└── agents/openai.yaml
```

```bash
npx skills add ./skills/jackson-concept-prd \
  --skill jackson-concept-prd \
  --agent codex \
  --copy
```
