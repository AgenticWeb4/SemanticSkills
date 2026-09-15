# TypeScript 落地

## 工程骨架

pnpm workspace（monorepo），一个 concept 一个包：

```text
packages/
  concepts/
    user/            # 独立包：src/domain.ts, actions.ts, ports.ts, adapters/
    password/
  syncs/             # 组合层：每个 flow 一个模块
  app/               # 装配、DTO/协议适配；路由 → syncs
  shared-kernel/     # 仅基础类型
```

- port 用 `interface`，adapter 实现之，组合根构造注入；概念包的 `package.json` 不声明其他概念包为依赖。
- 类型参数直接用 TS 泛型（`Password<U>`）或不透明 ID（branded type）。
- 分组嵌套目录时更新 workspace glob，保留包名与边界规则；syncs 可按职责群拆包。

## Sync 两种落地

- **过程式**：syncs 包中每 flow 一个模块，async mediator 保留因果依赖及允许并发，不将无序规则任意串行化。
- **声明式**：候选引擎包括社区 [LegibleSync](https://github.com/mastepanoski/legiblesync)。采用前核验实际版本与接口，验证完成事件匹配、多 when、where 绑定、flow 隔离与持久化，不依赖未经核对的 API 示例。

## 架构看护

- **dependency-cruiser**（边界检查工具）：固化规则——概念包互不引用、只有 syncs 与 app 可引用多个概念、概念的 domain 不得引协议库；`depcruise` 进 CI，违规即失败。
- **eslint-plugin-boundaries**：同样的规则做成 IDE 实时反馈，写代码时即报错。
