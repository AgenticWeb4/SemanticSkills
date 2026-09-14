# concept 技能的知识结构依据

核验：2026-09-13。焦点问题：如何组织五个 `concept-*` 技能，使代理理解概念间的关系，并据需求和代码审查概念及应用设计？作者主张与本仓操作化分列；按用户要求，Novak 的编写依据只留本研究记载，技能正文不出现 Novak 说明。

## 一手定义

**Novak & Cañas（2008）**把概念定义为：对事件、对象或其记录中规律的感知，并以标签指称。命题由两个或更多概念经连接词形成有意义的陈述。概念与命题是知识结构的主要构件；原文也承认图像、声音等其他记忆，不能概括成“所有知识仅由概念与命题构成”。[《The Theory Underlying Concept Maps》，Introduction、Psychological/Epistemological Foundations，IHMC 2006-01 Rev 2008-01](https://cmap.ihmc.us/docs/theory-of-concept-maps)

**Cañas & Novak（2009）**进一步要求：概念标签简短，关系通常含动词，组合后能读成有意义短句；仅把词装入节点不构成概念图。焦点问题限定所回答的问题；层次由语境中的一般到具体组织，不要求图形始终为单根树。交叉连接揭示不同知识分支间的关系。[《What is a Concept Map?》，Propositional/Hierarchical Structure、Focus Question、Cross-Links](https://cmap.ihmc.us/docs/conceptmap.php)

**Daniel Jackson（2015）**讨论的软件 concept 是为目的引入的功能构造，其范围包含相关状态与行为。purpose 说明需要；operational principle（OP）以典型场景说明如何兑现需要。审查这个论证能够发现概念设计缺陷；OP 并非完整行为规格，operational misfit 则展示目的如何落空。既有系统需先重建论证，论证欠缺本身不证明系统在实践中失败。[《Towards a Theory of Conceptual Design for Software》，摘要、§7–9、PDF 第 13 页讨论](https://groups.csail.mit.edu/sdg/pubs/2015/concept-essay.pdf)

## 本仓采用的结构

下列为结合上述资料的编写约定，**不是原作者共同提出的方法，也不是 Jackson 规格新增字段**。

1. **焦点与定义**：先说明任务问题、核心概念及边界；区分软件 concept、知识概念、实体、动作与场景。
2. **关系与论证**：以有意义的关系解释知识。原则约束行动，核对命题表达待验证判断；不能只把清单改名为“命题”。OP 保留时间顺序和目的结果，不强压成单个三元组。
3. **事实与运用**：需求、代码、测试支持或反驳判断，例子只说明含义；区分事实、推断和未决，再执行可核验步骤。
4. **层次与连接**：核心定义与关系留在入口，细节按需展开。知识交叉连接不等于 sync、产品依赖或允许概念互调。

## 概念目的与应用目的

Jackson 明确承认应用整体可有一个或多个目的，但每个概念还须自有目的；概念目的在通用情境解释其价值，在特定应用解释为何纳入。概念常需同步才能实现应用目标。[《The Essence of the Essence》，Concept Purposes、Concept Synchronization](https://essenceofsoftware.com/posts/distillation/)

组合可以产生超出各部分收益相加的 synergy：短码与过期机制结合，允许较小词库服务同等规模用户，使短码可采用常用词。[组合教程，Concept synergy](https://essenceofsoftware.com/tutorials/concept-basics/sync/)

应用特定协调外置于同步；单概念定义保持独立。[《Beyond Objects》§12–13](https://arxiv.org/html/2606.27258v1#S12) 概念在特定应用中为何共同纳入由 extrinsic 依赖表达，不是概念本身互相依赖。[依赖教程，Intrinsic dependencies](https://essenceofsoftware.com/tutorials/concept-basics/dependency/)

据此，本仓采用两条审查规则：

- **分别论证两层目的**：概念检查 state/actions → OP → concept purpose；应用检查实例化概念与 sync → 应用场景 → 应用目的。应用目的可跨概念兑现，不应压进某一概念的 purpose，也不能用若干 OP 通过替代组合核验。
- **用事实寻找 misfit**：分别检查概念与组合如何使目的落空，定位目的/模型、组合规则、实现或证据缺口；陈述必要环境假设，不能把规格满足视为现实目的必达。

“应用场景”“应用论证”及这两条检查链是本仓编写约定；本次所核原文没有把它们规定为 OP 之外的新规格字段或正式术语。组合场景不必改名为“应用 OP”。

## 技能改写示例

| 现有写法 | 定义与有意义关系的写法（本仓示例） |
| --- | --- |
| `OP 有代表性测试` | **OP** 是展示目的兑现的典型场景；**代表性测试** 用具体输入与结果检查该场景。测试通过支持实现符合这条场景，动作边界和其他情境仍须另查。 |
| `检查组合正确性` | **应用目的** 说明产品在特定情境提供的价值；**sync** 协调概念动作。审查应用场景能否经声明的 sync 兑现目的，并检查组合是否保持各概念契约。 |

本次调整知识表达与审查关系，不要求新增概念图；定义、命题和事实需相互校正，而非脱离需求与代码整理术语。


## 本次落地与验证

已重构五个技能，未提交或发布。知识组织方法只用于编写，技能安装包不出现 Novak/Cañas 名字或理论宣讲；研究记录不属于运行时必读内容。

| 技能 | 核心改动及落点 | 版本 |
| --- | --- | --- |
| [concept-design](../../../skills/concept-design/SKILL.md) | 定义概念与应用目的；两条原则审查目的兑现及事实反例；输出含应用场景及概念/sync 依据 | 0.7.0 |
| [concept-audit](../../../skills/concept-audit/SKILL.md) | 无代码可审设计；分开概念论证、应用组合适切性和实现符合性 | 0.6.0 |
| [concept-prd](../../../skills/concept-prd/SKILL.md) | 总体 PRD 保存应用目的与场景，CONCEPT 保留局部目的/OP，验收追溯前提与出处 | 0.6.0 |
| [concept-implementation](../../../skills/concept-implementation/SKILL.md) | 概念 OP 与应用端到端验证分层；区分业务协调、组合根装配和根因修复 | 0.7.0 |
| [concept-guardrails](../../../skills/concept-guardrails/SKILL.md) | 从事实重建契约，标推定目的；精简模式重复，统一独立性、入口及失败策略 | 0.31.0 |

同时修正：检查清单冒充命题、字面零点名与语义独立性冲突、组合根引用例外、模型错误误路由 PRD、Requesting 被误作唯一入口、错误 sync 被一律强制、行为增量被等同于 sync 增删、订位示例未定义到场条件却判完整。压缩复核发现的 DTO/协议边界检查遗漏已补回。

### 内容压缩

口径为五技能 28 份 SKILL.md 与指导性 references 的 Unicode 字符总数，含 Markdown 标记、空白、模板和示例；不计代码运行时、UI 元数据、QA 或研究记录。不把移入 references 当作删除，不要求每个文件同比缩短。此次新增的测量 Python 文件已按用户要求删除。

基线及逐文件哈希保存在 [knowledge-baseline.json](../../../qa/concept-design/knowledge-baseline.json)，对应开始时提交 `f0e798f43b770796a8c05572157336176309f4ff`。

| 技能 | 修改前 | 修改后 | 减少 |
| --- | ---: | ---: | ---: |
| concept-design | 10,575 | 9,474 | 10.41% |
| concept-audit | 6,206 | 6,492 | -4.61% |
| concept-prd | 6,691 | 5,897 | 11.87% |
| concept-implementation | 9,437 | 7,992 | 15.31% |
| concept-guardrails | 19,340 | 12,729 | 34.18% |
| **合计** | **52,249** | **42,584** | **18.50%** |

audit 因纯设计与应用目的审查增加少量内容；总量接近约 20% 目标，优先保留定义、条件、行为和证据。

### 已执行检查

- 五套 `qa/concept-*/validate.sh` 通过：安装布局、skills-ref、Markdownlint、skillcheck；guardrails 另验证 runtime 语法和 JSON。
- 技能内部链接、评估 JSON/ID、目录及文档版本、UI 显式调用策略检查通过；runtime 文件集合及哈希与基线相同。
- 通用 quick_validate 四套通过；guardrails 的既有 compatibility 字段仍被该工具旧白名单拒绝，但仓库支持的 skills-ref/skillcheck 已通过，保留合法元数据。
- 独立一致性复核检查定义、两层目的、压缩损失及安装包自包含性；发现的 DTO 核验遗漏已修正。
- 独立前向执行五次：Trash 两方案设计审计、OP 成立但允许重复预约的审计、局部概念成立但付款组合错误的审计、TemporaryTrash PRD 转录、付费预约概念与组合设计。均保留证据边界及未决，不以缺代码虚构实现缺陷。
- 新增七个行为评估案例并检查格式；未声称七个案例全部由自动评估器运行，也未把代理模型推演称为形式证明或运行时测试。PRD 试运行产物仅在 gitignored workspace 内。
