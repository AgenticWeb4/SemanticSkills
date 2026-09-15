# 实现依据

| 来源 | 采用的知识 |
| --- | --- |
| [Jackson：Concept Purposes / Concept Synchronization](https://essenceofsoftware.com/posts/distillation/) | 应用可有多个目的，每个概念仍有自身目的；同步使概念协作实现应用目标。这里只采用目的关系，规则语义采用下述新版 |
| [Jackson 2015，摘要、§8](https://groups.csail.mit.edu/sdg/pubs/2015/concept-essay.pdf) | OP 解释目的兑现；实现符合 OP 与模型适切性须分别判断 |
| [Beyond Objects v1](https://arxiv.org/abs/2606.27258) / [WYSIWID v2](https://arxiv.org/abs/2508.14511) | 概念、完成事件及因果组合；规格指导实现，旧事务同步不与当前因果规则混用 |
| [概念设计综述](https://essenceofsoftware.com/posts/distillation/) / [conceptbox](https://github.com/61040-fa25/conceptbox) | mediator 组合；规格驱动开发 |

模块单体、port/adapter、query API、目录与边界看护是本仓工程选择；各语言工具的能力限制及来源见对应参考。

本轮格式基线：[WYSIWID v1 §4–6](https://arxiv.org/html/2508.14511v1#S4)（核验 2026-09-14）；具名记录、输出 case、状态读取及同步语义见 [统一规格契约](spec-format.md)。旧资料的 queries/Requesting 作为标明的扩展，不能回写为 v1 原文要求。
