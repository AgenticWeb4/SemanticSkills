# jackson-concept-implementation Changelog

Skill-only history. Repository tooling changes: [../../CHANGELOG.md](../../CHANGELOG.md).

## 0.1.0 - 2026-08-28

### Added

- Initial Jackson concept-implementation skill: map a confirmed concept model
  onto a modular monolith (one module per concept, syncs as mediators, the
  dependency graph as build/cut order)
- Two official sync landings: procedural mediator (default) and a declarative
  rule engine; concept modules stay mutually unreferenced
- Language notes for Rust, Java/Spring Modulith, and TypeScript, loaded only
  for the target language
