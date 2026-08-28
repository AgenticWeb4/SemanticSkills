# jackson-concept-audit Changelog

Skill-only history. Repository tooling changes: [../../CHANGELOG.md](../../CHANGELOG.md).

## 0.1.0 - 2026-08-28

### Added

- Initial Jackson concept-audit skill: read-only five-dimension check of an
  existing codebase against its concept model or PRD family
- Dimensions: spec drift, boundary violations, criteria review, composition
  quality, and dependency/subset integrity, each with a single fix-routing
  target
- Findings require location and evidence; repair order is upstream-first
  (design → prd → implementation)
