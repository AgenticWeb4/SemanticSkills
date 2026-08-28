---
name: jackson-concept-audit
description: Audits an existing codebase against its Jackson concept model (spec drift, boundaries, criteria, composition, dependencies). Use this skill whenever the user asks to audit a concept model, 概念审计, or mentions jackson-concept-audit; read-only.
---

# Jackson 概念审计

输入：PRD 文档族（默认仓库 `docs` 下的 `prd` 目录）或概念模型 + 代码库。**只读**：不修改任何文件，产出发现清单；修复由路由到的技能执行。无规格文档时降级为纯边界与判据审计，并在报告中声明。

## 五个维度

| 维度 | 检查 | 发现路由 |
| --- | --- | --- |
| **规格漂移** | PRD/模型 ↔ 代码对账：概念集合与模块一一对应、actions/state 签名一致、每个 OP 有对应测试、排除动作未被组合层调用或暴露 | 文档过期 → `jackson-concept-prd`；模型过期 → `jackson-concept-design` |
| **边界违规** | 概念模块互引、共享表或全局数据模型、DTO/传输类型进概念签名、业务不变量出现在 syncs 层 | `jackson-concept-implementation` |
| **判据重审** | 用资格判据与四词审存量模块：一模块多目的（conflation）、目的碎片化（fragmentation）、无理由背离熟悉概念 | `jackson-concept-design` |
| **组合质量** | 欠同步（漏自动化）、过同步（抢用户控制）、flow 缺错误 sync、概念动作直通外部 API、sync 积攒自有状态（升格信号） | 模型层 → `jackson-concept-design`；代码层 → `jackson-concept-implementation` |
| **依赖与子集** | 文档依赖图与代码实际依赖不符、违反 Parnas 规则（合理的产品子集被不当依赖阻断）、MVP 子集不可裁剪构建 | `jackson-concept-design` |

## 执行步骤

1. **定位规格**：读 PRD 文档族与总体 PRD 的依赖图；同时利用工程自带素材（如 Spring Modulith `Documenter` 生成的模块文档、cargo/dependency-cruiser 的依赖图输出）。
2. **逐维度检查**：每条发现记录维度、位置（文件/模块）、证据（可复核的代码或文档片段）、严重度、路由。
3. **合并根因**：同一问题跨维度出现时合并指向根因——概念互引的根因常是模型里未参数化的 intrinsic 依赖，而不是五条独立发现。
4. **输出报告**：给出修复顺序，上游优先——先模型（design）、再文档（prd）、后代码（implementation）。

## 报告格式

```markdown
# 审计报告 <日期>
范围: <规格版本 / 代码版本>；跳过的维度及原因

## <维度名>
| 发现 | 位置 | 证据 | 严重度 | 路由 |

## 修复顺序
1. <根因级发现，上游优先>
```

## 完成条件

- 五维度全部执行，或明确声明跳过原因。
- 每条发现有位置与证据，可独立复核；无「疑似」空泛项。
- 每条发现有唯一路由；修复顺序按上游优先排列。
- 未修改任何文件。

## 依据

Jackson：

- 批评循环与判据（`jackson-concept-design`）
- 欠/过同步与 mediator 原则（[概念设计综述](https://essenceofsoftware.com/posts/distillation/)）
- Parnas 规则（[依赖与子集教程](https://essenceofsoftware.com/tutorials/concept-basics/dependency/)）
- 规范可从代码提取（[WYSIWID 论文](https://arxiv.org/abs/2508.14511)）

业界：架构 fitness functions 管持续（CI 工具见 `jackson-concept-implementation` 语言参考），审计管周期，两层互补。
