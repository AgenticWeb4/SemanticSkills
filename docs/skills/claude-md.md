# CLAUDE.md

仅手动调用 `$claude-md`，根据仓库事实生成或精简 CLAUDE.md。

- 技能：[SKILL.md](../../skills/claude-md/SKILL.md)
- 版本：0.1.0；[变更记录](../../qa/claude-md/CHANGELOG.md)
- 验证：`./qa/claude-md/validate.sh`

## 模板来源

从 [Apple containerization 的 CLAUDE.md](https://github.com/apple/containerization/blob/main/CLAUDE.md)
提炼四类句式：操作入口、架构边界、修改约定、环境限制。
保留条件、例外与具体入口；不移植 Apple 项目的命令或平台要求。

每条规则以“删掉它，AI 会具体做错什么？”筛选；无依据的新规则不写，无法核实的旧约束保留并报告。
