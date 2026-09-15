# 概念与同步规格契约

编写、转录、实现或核对 CONCEPT/SYNCS 时读。格式以 [WYSIWID v1 §4](https://arxiv.org/html/2508.14511v1#S4) 的概念规范、[§5](https://arxiv.org/html/2508.14511v1#S5) 的同步语言为基线；flow、绑定与重放依据 [§6](https://arxiv.org/html/2508.14511v1#S6)。下列模板是本仓改写，非原文或可直接执行的引擎语法。

## CONCEPT：独立的行为接口

新写按 purpose → state → actions → operational principle 排列；概念名及可选类型参数在标题。Markdown 标题、requires/ensures、notes、queries 节是本仓表达约定。占位只示意字段，未确认内容须标未决。

```markdown
# concept Name [T]

## purpose
<一个可评价的需要>

## state
items: set Item
owner: Item -> T
<声明 Item 为本概念的身份类型；说明关系的基数、初态及必要不变量>

## actions
act [item: Item; owner: T] => [item: Item]
  requires <该成功 case 的适用条件>
  ensures <状态变化、输出值与未改变部分>
act [item: Item; owner: T] => [error: E]
  requires <该错误 case 的适用条件；声明 E 的含义>
  ensures <错误值及状态后果>

## operational principle
after <条件及已声明动作的输入 => 输出>
then <后续动作/观察及可观察结果；如何兑现 purpose>
```

| 要素 | 核对标准 |
| --- | --- |
| 名称/类型 | 外部身份用无字段假设的类型参数，可零个或多个；局部类型、枚举及输出类型有定义。应用实例化只在 SYNCS |
| purpose | 一个需要，不是功能清单；用 OP 解释其兑现方式 |
| state | 命名的抽象集合/关系及类型；明确需要的基数、初态与不变量。`A -> B` 只列关联类型，不能据箭头猜总函数/唯一性；等价自然语言须能无歧义恢复这些约束 |
| actions | 具名输入和具名输出，零个参数写 `[]`，无返回值也显式写 `=> []`；每个 case 说明条件、效果和输出，不把内部算法当接口 |
| OP | 典型且有区分力的行为场景，使用真实动作名/字段/结果，必要时含后续观察；支持代表性测试，不穷举所有行为 |

同一动作可有多种输入/输出 case；字段名是匹配契约的一部分。成功与拒绝条件应可区分；若重叠会产生不同效果，说明选择规则或标未决，不能让模板暗定优先级。失败不默认保持状态，成功也不默认改状态；例如校验凭据可以是有用户意义的只读动作，仍产生 completion。

规格可以有意省略与当前设计无关的细节；必须明确影响同步的签名、分支和状态含义。进入实现时，再补齐会改变可观察行为的歧义；不因模板要求而发明错误、权限或额外功能。

## 状态读取与可选 query 接口

概念拥有并维护状态；应用可查询它公开的**抽象状态**，包括跨概念 join。物理表、私有仓储及其他概念内部实现不因此开放。概念之间仍不互相读取或调用。

默认在 where 用已声明关系。项目采用 query API 时，在 CONCEPT 的可选 `## queries` 节声明 `_` 查询的具名参数、结果及零/一/多行语义，并注明与抽象状态的对应；查询只读且不产生 completion。这是本地接口映射，不是 §4 规定的第五核心节，也无需为每个字段制造 getter。

```text
_owners [item: Item] => [owner: T]
  returns owner 关系中匹配 item 的绑定；无匹配为零行
```

对应 where 可写 `Name/_owners: [item: ?item] => [owner: ?owner]`，但它是 query 扩展，不能放入 when/then。初态、基数或查询能力不明时保留缺口，不能把空集改写成未声明的 error。

## SYNCS：应用的因果规则

`app/include`、类型实例化和 `// flow:` 是本仓外层组织；`sync/when/where/then` 采用论文记录模式。每个 include 指向可定位的概念规格或明确的外部入口契约；实例别名及实际类型须有定义。Web 是论文入口例，已有 Requesting 可保留名称并明确签名；定时/消息同样声明根事件。

```text
# app AppName
include Source [Id]
include Target [Id]
include Web

// flow: transfer
sync Transfer
when {
  Web/request: [method: "transfer"] => [request: ?request]
  Source/finish: [] => [item: ?item]
}
where {
  Source: { ?item owner: ?owner }
}
then {
  Target/accept: [item: ?item; owner: ?owner]
}
```

以上是语法槽位，不是已定义的产品。源动作成功返回 item、Source.owner 及目标输入均须从真实规格核对；是否需要响应由入口契约决定。

| 部分 | 精确语义 |
| --- | --- |
| sync | 应用内唯一、稳定的规则名；一条可解释的设计决策，代码/溯源可追踪 |
| when | 必填；匹配动作**完成**，`Concept/action: [输入模式] => [输出模式]`。多个模式合取，来自同一运行时 flow |
| 部分匹配 | 仅约束写出的字段，省略字段是通配；`[]` 是空模式，**不是成功判据**。动作可能返回 error 时，成功路径须匹配成功字段/值或其他已证实的判别条件 |
| where | 可省；查询当前公开抽象状态、过滤、计算或 bind，输入 when 绑定，输出零/一/多组绑定；省略时保留原绑定 |
| then | 必填；每组绑定发出所列调用，只有具名输入，**不写 `=>` 输出**。输入须满足真实签名，不能把 when 的部分匹配许可用于漏填调用参数 |
| 变量 | `?name` 在整条规则内同名同值，字段由概念/动作命名空间限定；then 只用 when/where 已绑定变量或常量。同一 then 各调用无隐含先后，未来输出应在下一 sync 的 when 匹配 |

### 失败、关联与执行

- `=> [error: ?error]` 匹配已声明错误，`=> [valid: false]` 可表达普通否定结果；二者不能混同。需要授权/校验时先等待允许结果再发写动作；后置拒绝不会撤销已经完成的写入。
- where 零行是不触发，多行会展开多组调用；为需要响应的入口核查零行分支，多候选不默认选首项或执行全部。相同结果的重复投递另按幂等契约处理。
- flow 隔离不同根事件；同一 flow 内若含多个同类动作，仍须用业务 ID/关联参数配对，不能只靠相同 flow token。request 用于定位响应；`// flow:` 只分组规则，不是 token 或运行时边界。
- 完成事件不可被后续失败抹去；明确部分完成后的响应、重试、补偿或有意忽略。单动作维护自身不变量，where 的状态快照不能代替原子写检查。
- 记录动作发生身份、flow、触发规则与因果来源；持久记录已触发匹配及其产生的调用，避免重放重复发出。具体去重键依引擎语义验证，不能只按业务值去重；这不自动保证外部副作用 exactly-once。

## 旧规格兼容与交付核对

读取兼容 `principle`、旧四节次序、`act (arg: T) : (result: R)`、`Concept.act (...) : (...)` 及 actions 内的 `_` queries；这些不单独构成漂移。新写用上述格式；局部更新保留现有方言，整份格式迁移须在用户授权范围内，并同步其消费者与派生图。

迁移先确定旧规则的输入/输出、成功/错误判别及隐含关联，再映射符号。尤其不能把省略输出的旧 when 机械改成 `=> []` 而扩大为匹配错误。wyx 边界段和旧书版事务同步需单独辨认、保留行为与未决，不按字符替换处理。

交付逐项核对：类型实例化 → 状态/查询 → 动作输入与全部相关结果 → when 的 case → where 的绑定基数 → then 参数 → 入口结果/关联。OP 与应用场景分别可追溯，跨概念策略只在 SYNCS；总体 PRD 保留目的、依赖、排除与未决。代码落地再核查并发、故障恢复与可观察行为。
