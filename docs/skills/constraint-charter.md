# 约束宪章 · Uncle Bob 门禁持久化

`constraint-charter` · **Constraint Charter**

> 本文是给人看的中文说明，**不是** `npx skills add` 安装包内容。Agent 加载 [`skills/constraint-charter/SKILL.md`](../../skills/constraint-charter/SKILL.md)。

**Version:** 0.1.0

## 一句话

把审计目标、数值门禁与已知不测清单固化为仓库内的 `GATES.md`（受版本控制），经 grilling 逐题确立并接线到 pre-commit/CI，使「不看代码也能正确」成为软件本身的一部分。

## 在分层中的位置

| 层 | 技能 | 职责 |
| --- | --- | --- |
| 立场 | don't-read-the-code / 不读代码协议 | 读什么 / 不读什么 |
| 引擎 | verification-gauntlet | 单次任务跑门禁流水线 |
| 持久化 | **constraint-charter（本技能）** | 宪章入库、跨会话存续、修宪协议 |

## 宪章五节

1. 审计目标  
2. 约束表（约束 \| 阈值 \| 强制工具 \| 强制位置）  
3. 验收入口（Gherkin）  
4. 已知不测清单  
5. 修宪记录  

## 安装载荷

```text
skills/constraint-charter/
└── SKILL.md
```

```bash
npx skills add ./skills/constraint-charter \
  --skill constraint-charter \
  --agent cursor \
  --copy
```
