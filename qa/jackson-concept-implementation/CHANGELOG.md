# jackson-concept-implementation Changelog

Skill-only history. Repository tooling changes: [../../CHANGELOG.md](../../CHANGELOG.md).

## 0.2.0 - 2026-08-28

### Changed

- Sync semantics updated to the author's current causal-rule model
  (when/where/then, Requesting pseudo-concept): transactions are an optional
  single-DB reinforcement, error syncs are the default failure path
- Add implementation-layer timing/error-isolation classification
  (post-action / pre-validation / scheduled), adapted from wyx, explicitly
  marked as engineering taxonomy that does not change design semantics
- Map underscore-prefixed queries to read-only module methods; add a spec
  colocation step (CONCEPT.md into module dirs, SYNCS.md into the syncs dir)
  enabling wyx drift detection and spec-first edits

## 0.1.0 - 2026-08-28

### Added

- Initial Jackson concept-implementation skill: map a confirmed concept model
  onto a modular monolith (one module per concept, syncs as mediators, the
  dependency graph as build/cut order)
- Two official sync landings: procedural mediator (default) and a declarative
  rule engine; concept modules stay mutually unreferenced
- Language notes for Rust, Java/Spring Modulith, and TypeScript, loaded only
  for the target language
