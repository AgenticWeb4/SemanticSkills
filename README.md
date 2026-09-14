# concept-skills
[![skills.sh](https://skills.sh/b/ontology-of-everything/concept-skills)](https://skills.sh/ontology-of-everything/concept-skills)

> Name the meaning first — then write code, run a CLI, or draft a spec.

[concept-skills](https://github.com/ontology-of-everything/concept-skills) is a set of eight [Agent Skills](https://agentskills.io/) for ontology, semantic layers, concept design, and presentation authoring. Each skill keeps its protocol in a thin `SKILL.md` and loads bulky domain material from `references/` only when the task needs it.

Huawei Cloud operational skills now live in [`concept-git/cloud-concept-skills`](https://github.com/concept-git/cloud-concept-skills) and are no longer distributed from this repository.

The concept-design skills adapt Daniel Jackson's concepts-and-synchronizations model — [The Essence of Software](https://essenceofsoftware.com/) (2021), with the current when/where/then sync notation from *Beyond Objects* ([arXiv:2606.27258](https://arxiv.org/abs/2606.27258)) — for agent use; an adaptation, not endorsed by the author.

中文说明见 [README-CN.md](README-CN.md).

Current baseline is **1.0.0**. The `concept-*` family is explicit-only; `concept-guardrails` modes consume Jackson notation only.

## Table of Contents

- [Skills](#skills)
- [Install](#install)
- [Usage](#usage)
- [Contributing](#contributing)
- [Changelog](CHANGELOG.md)
- [License](#license)

## Skills

### Concept design

Requirements to modules, with the concept model as the contract. Each skill stops at its own boundary and hands off: `design` → `prd` / `implementation` → `audit`.

| Skill | Version | What it does |
| --- | --- | --- |
| [`concept-design`](docs/skills/concept-design.md) | 0.7.0 | Explicit-invocation-only — designs independent concepts and synchronizations; reviews concept purposes through operational principles and application purposes through end-to-end scenarios, with evidence and counterexamples. |
| [`concept-prd`](docs/skills/concept-prd.md) | 0.6.0 | Explicit-invocation-only — transcribes confirmed models into an overall PRD, per-concept specifications and synchronizations, preserving concept/application purposes, assumptions, unresolved decisions and acceptance traceability. |
| [`concept-implementation`](docs/skills/concept-implementation.md) | 0.7.0 | Explicit-invocation-only — implements confirmed concept models as modular monoliths with independent modules, causal synchronization, colocated specifications, and tests tied to concept and application purposes. |
| [`concept-audit`](docs/skills/concept-audit.md) | 0.6.0 | Explicit-invocation-only — read-only audit of concept and application design arguments, with optional implementation conformance checks; covers fitness for purpose, independence, composition, drift and product subsets, routing evidenced findings by root cause. |
| [`concept-guardrails`](docs/skills/concept-guardrails.md) | 0.31.0 | Explicit-invocation-only — six modes for specification coverage, concept backfill, drift, pipelines, synchronizations and derived maps; distinguishes evidence, inferred purposes and design gaps in the local Jackson notation, with optional wyx hooks. |

### Ontology and semantics

Enterprise knowledge from APIs and databases (`semantic-km-creator`); personal knowledge from source text (`semantic-pkm-creator`).

| Skill | Version | What it does |
| --- | --- | --- |
| [`semantic-km-creator`](docs/skills/semantic-km-creator.md) | 0.6.0 | Enterprise knowledge: turns an API, CLI, or table/database into a grain-first Kimball semantic layer through an HTML decision workbench; emits OKF or YAML, every field traceable to observed evidence |
| [`semantic-pkm-creator`](docs/skills/semantic-pkm-creator.md) | 0.3.0 | Personal knowledge: extracts scenes, concepts, and entities from source text in two rounds — skeleton for human confirmation, then IPO, decomposition, assembly, and eight relation types |

### Presentation

| Skill | Version | What it does |
| --- | --- | --- |
| [`html-slides`](docs/skills/html-slides.md) | 0.1.1 | Explicit-only deck builder: outline → per-page table → plain single-file HTML deck in a pluggable style (generic, Huawei official light/dark, Apple); optional PPTX export |
| [`claude-md`](docs/skills/claude-md.md) | 0.1.0 | Explicit-only generation and pruning of CLAUDE.md from repository evidence |

Per-skill details and safety boundaries: [docs/skills/](docs/skills/). Machine-readable index: [docs/catalog.yml](docs/catalog.yml). Monorepo changelog: [CHANGELOG.md](CHANGELOG.md). Per-skill changelogs: `qa/<name>/CHANGELOG.md`.

## Install

Requires Node.js for `npx`.

```bash
npx skills add ontology-of-everything/concept-skills \
  --skill <skill-name> \
  --agent cursor \
  --copy -y
```

`--agent` accepts `cursor`, `claude-code`, or `codex`. Several skills at once, and `--global` to install into `~/.agents/skills/` (scanned by both Cursor and Codex) instead of the project's `.agents/skills/`:

```bash
npx skills add ontology-of-everything/concept-skills \
  --skill concept-design concept-prd concept-guardrails \
  --agent cursor codex \
  --global --copy -y
```

List what's available, or install from a local checkout while developing:

```bash
npx skills add ontology-of-everything/concept-skills --list
npx skills add ./skills/<skill-name> --skill <skill-name> --agent cursor --copy -y
```

Discovery: [skills.sh](https://skills.sh/ontology-of-everything/concept-skills) (groups in [`skills.sh.json`](skills.sh.json)) · [SkillsMP](https://skillsmp.com/) (GitHub topics `claude-skills`, `claude-code-skill`) · [ClawHub](https://clawhub.ai/).

Agent-specific notes: [Cursor](docs/agents/cursor.md) · [Claude Code](docs/agents/claude-code.md) · [Codex](docs/agents/codex.md).

Read a skill before using it — skills run with your agent's permissions.

## Usage

Skills normally activate from their description, so plain requests are enough. The `concept-*` family is explicit-only and must be named (`/concept-design` in Cursor, `$concept-design` in Codex):

```text
$concept-design 把这个需求建成概念模型
$concept-prd 模型定了，出一份 PRD 规格
$concept-guardrails 给 src/orders 写概念规格，然后查漂移
把这套接口做成语义层                        → semantic-km-creator
做一份 15 分钟产品介绍网页胶片               → $html-slides
```

To pin a skill explicitly: `/skill-name` in Cursor, `$skill-name` in Codex.

## Contributing

[docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) · [docs/authoring.md](docs/authoring.md)

```bash
./tools/skill-scaffold.sh <skill-name>   # new skill
./tools/install-git-hooks.sh             # pre-commit → validate-all.sh
./tools/validate-all.sh                  # all skills, same as CI
./qa/<skill-name>/validate.sh            # one skill
```

`skills/<name>/` is the install payload; gates and evals live in `qa/<name>/` and are never installed. Sync on every skill change: `skills/`, `qa/` (`VERSION`, `CHANGELOG.md`), `docs/catalog.yml`, `docs/skills/<name>.md`.

## License

[Apache-2.0](LICENSE) © concept-skills contributors. Bundles published to [ClawHub](https://clawhub.ai/) are MIT-0 there; the repository source stays Apache-2.0.
