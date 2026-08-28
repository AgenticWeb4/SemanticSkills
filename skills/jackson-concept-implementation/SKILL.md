---
name: jackson-concept-implementation
description: Maps a confirmed Jackson concept model onto a modular monolith (one module per concept, syncs as mediators or a rule engine). Use this skill whenever the user asks to implement the concept model, 模块单体, or mentions jackson-concept-implementation.
---

# Jackson 概念实现（模块单体）

输入是已确认的概念模型（`jackson-concept-design` 的输出：concepts、syncs、依赖图）。本技能只做模型到代码结构的映射，不重开概念讨论；概念边界有疑问回上游技能，存量工程审计用 `jackson-concept-audit`。

## 映射总则

| 模型元素 | 代码落点 |
| --- | --- |
| 一个 concept | 一个独立编译单元（模块/crate/包），对外只暴露 actions 与状态查询 |
| 类型参数 `[U]` | 泛型参数或不透明 ID（值对象），不引入对方类型 |
| state | 模块私有，经 port 抽象持久化；不是全局数据模型 |
| actions | 模块的公开方法/服务，含正常与错误两类结果 |
| OP | 该模块的集成测试场景 |
| sync | 组合层代码：唯一允许同时引用多个概念的地方 |
| extrinsic 依赖图 | 构建/交付顺序与产品裁剪（feature/构建开关），不产生代码依赖 |

铁律（intrinsic 禁令的代码化）：**概念模块之间零相互引用**；数据与控制流全部经组合层流动。

概念模块内部按整洁架构分层（端口-适配器）：domain 放不变量与纯逻辑（零外部依赖）、actions 即应用服务（依赖 port 抽象）、adapter 实现 port；组合根是唯一命名具体 adapter 的地方。

## Sync 的两种落地（官方路线）

1. **过程式 mediator**（默认）：每个应用动作（flow 入口）一个编排函数，顺序调用各概念 actions、组装响应。最简单、最贴近常规 web 实践，Jackson 课程即此教法。
2. **声明式规则引擎**：sync 写成 `when / where / then` 规则（when 匹配动作完成，where 查询概念状态并绑定变量，then 派发后续动作），由引擎执行并留下动作溯源。表达力强、行为增量可按条增删，但需引入引擎运行时。

行为规则多、需要审计追踪或按规则粒度演进时才选 2。

## Syncs 层范式

syncs 层是应用级的用例层（整洁架构的 use-case 层），没有自己的 domain，不套完整分层。三原则：

- **薄**：只做编排与数据流；业务不变量必须在概念的 domain 里，出现在 syncs 里就下沉。
- **无自有持久状态**：某组 sync 开始积攒状态 = 升格为概念的信号，回上游技能。
- **按 flow 组织**：每个 flow 一个模块/文件，与 PRD 的 flow 文档一一对应。

## 接口层

- **对外 API 只暴露应用动作（即 sync），永不直通概念动作**——概念动作绕过组合层可达，所有 sync 约束（认证、级联、通知）即被穿透。
- 端点 = 组合层入口：路由与 DTO 映射写在接口适配器，概念对 HTTP/协议一无所知，签名中不出现传输格式（JSON、状态码）。
- REST/RPC 入站、webhook 出站等协议适配器全部放 app 边缘的接口模块；契约（OpenAPI/proto）是组合层资产，随应用版本演进，与概念版本无关——同一概念可复用于多个应用，各应用契约不同。
- 官方模式（论文）：外部请求本身是动作——Web 引导概念（`request`/`response`），端点触发 sync，响应也由 sync 产生；认证、鉴权因此都是普通 sync，不是中间件魔法。

## 事务边界

设计层的 sync 原子语义（全有或全无）在代码层由两条路线逼近：

- **过程式 mediator**：一条 sync = 一个事务边界。模块单体单库时可用共享 DB 事务包住 mediator 函数（单体红利）；各概念仍保持私有 schema/表，跨概念只经 actions 与组合层查询。
- **规则引擎路线**（论文明确放弃事务语义）：动作失败是可匹配的错误输出，由错误 sync 响应或补偿，不做跨概念回滚。
- 概念内部：单个 action 自身原子，由其存储适配器保证。

## 语言落地（按需读取，只读目标语言一份）

- Rust：[references/rust.md](references/rust.md) — cargo workspace、trait 即 port、组合根；cargo/cargo-deny 看护。
- Java：[references/java-spring.md](references/java-spring.md) — Spring Modulith 主线：`@ApplicationModule` 即概念模块、事件即声明式 sync、`verify()` 看护。
- TypeScript：[references/typescript.md](references/typescript.md) — workspace 包边界、LegibleSync 引擎路线；dependency-cruiser 看护。

## 违规信号

- 概念模块引用了另一概念模块 → intrinsic dependency，参数化或把耦合上移到 syncs。
- syncs 里出现业务不变量 → 下沉到所属概念的 domain。
- 一个概念模块服务两个 purpose、或一条 sync 长成流程脚本 → 回上游技能拆分。
- 概念间共享数据库表或全局模型 → 拆为各概念私有 state，跨概念查询放组合层。
- 概念签名出现 DTO/HTTP 类型 → 传输映射上移到接口层 adapter。
- 外部 API 直通概念动作 → 补一条 sync 作为应用动作，端点改挂 sync。

## 完成条件

- 模块依赖图核验：概念模块互不依赖；只有 syncs 与 app 引用多个概念。
- 边界规则已固化为架构看护测试并进 CI（工具见语言参考文件）。
- 每条 sync 的事务边界明确：共享事务或错误 sync 补偿，二选一并可指认。
- 每个概念的 OP 有对应集成测试；每条 sync 有对应测试。
- 概念模型中的排除动作在代码中未被组合层调用，也未经 API 暴露。
- 依赖图中的产品子集可通过 feature/构建开关裁剪。

## 依据

官方：

- [WYSIWID 论文](https://arxiv.org/abs/2508.14511)（概念规范格式、sync 语言与引擎、两条落地路线、Web 引导概念）
- [概念设计综述](https://essenceofsoftware.com/posts/distillation/)（mediator 与零引用原则）
- [Spring Modulith](https://spring.io/projects/spring-modulith)（Spring 官方模块单体工具）

社区：[LegibleSync](https://github.com/mastepanoski/legiblesync)（TypeScript 规则引擎实现）；各语言六边形架构与边界看护惯例见语言参考文件。
