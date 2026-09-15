# 依据与适用边界

核对术语/出处时读；以下为转述，流程和固定 Markdown 格式是本仓操作化。

| 一手来源 | 采用的知识 |
| --- | --- |
| [Jackson：Concept Purposes / Concept Synchronization](https://essenceofsoftware.com/posts/distillation/) | 应用可有多个目的，每个概念仍有自身目的；同步使概念协作实现应用目标。这里只采用目的关系，规则语义采用下述新版 |
| [Jackson 2015，摘要、§8–9](https://groups.csail.mit.edu/sdg/pubs/2015/concept-essay.pdf) | purpose + OP 构成可审查的设计论证；OP 是原型场景，misfit 可反驳目的兑现 |
| [Beyond Objects v1，§13](https://arxiv.org/abs/2606.27258) / [WYSIWID v2，§4](https://arxiv.org/abs/2508.14511) | 五要素/四节、queries 与因果 sync；采用当前因果语义，不混用旧书版事务同步 |
| [资格](https://essenceofsoftware.com/tutorials/concept-basics/criteria/) / [组合](https://essenceofsoftware.com/tutorials/concept-basics/sync/) / [依赖](https://essenceofsoftware.com/tutorials/concept-basics/dependency/) | 资格判据、欠/过同步、intrinsic/extrinsic 依赖和产品子集 |
| [Design moves](https://essenceofsoftware.com/posts/design-moves/) / [课程 rubric](https://61040-fa25.github.io/resources/concept-rubric) | 三对调整动作；notes 记录应用背景 |

两层论证检查、可选 query API 封装和规则节点图是本仓约定；论文也允许读公开抽象状态。OP 不是完整规格，良好论证也非全部行为的形式证明。

本轮格式基线：[WYSIWID v1 §4–6](https://arxiv.org/html/2508.14511v1#S4)（核验 2026-09-14）；具名记录、输出 case、状态读取及同步语义见 [统一规格契约](spec-format.md)。旧资料的 queries/Requesting 作为标明的扩展，不能回写为 v1 原文要求。
