# claude-md QA

Per-skill quality gate. Run `validate.sh` locally and in CI via
`tools/validate-all.sh`.

## Layout

```text
qa/claude-md/
├── validate.sh              # entry point (required)
├── README.md
├── evals/evals.json         # Skill Creator eval cases
├── assertions/README.md     # assertion rubric for eval authors
├── fixtures/                # optional: contract YAML, golden files
└── bin/                     # optional: helper scripts
```

Claude/Codex explicit-invocation settings are checked separately. The generic
`skills-ref` validator receives a temporary copy without the Claude extension;
the installed skill retains it. Markdownlint and skillcheck read the original.

## Commands

```bash
./qa/claude-md/validate.sh
```
