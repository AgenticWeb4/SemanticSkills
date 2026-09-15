---
name: html-slides
description:
  Builds a presentation as plain single-file 1920×1080 HTML in generic, Huawei, or Apple style,
  confirming the outline and per-page plan first, with optional PPTX export. Use only when the user
  explicitly invokes $html-slides; not for general slide-design discussion.
compatibility:
  File read/write only; optional PPTX export requires Python 3, Playwright, and python-pptx, which
  are never auto-installed
metadata:
  language: en
  translation_of: html-slides-cn
  author: ontology-of-everything
  version: "0.1.1"
  openclaw:
    homepage: https://github.com/ontology-of-everything/concept-skills/tree/main/skills/en/html-slides
---

# Multi-Style HTML Presentations

Turn a one-sentence request into a readable, editable, single-file HTML deck: 1920×1080, inline CSS,
and at most 120 lines of runtime JavaScript.

Keep code and guidance separate. `assets/core/` contains base CSS, runtime, and layout skeletons;
`assets/<style>/` contains variables, style-specific patterns, and assets; Markdown under
`references/` defines rules and points to those files. Core code uses variables only; styles supply
values. Built-in styles are `generic` (default), `huawei`, and `apple`; add a style through
`references/styles/_template.md` plus `assets/<style>/`.

Activate only when the user names `$html-slides` or the skill. Do not invent data or citations,
install dependencies, or export PPTX unless requested. When exporting, state whether the result is
image-based or natively editable.

## Principles

1. Confirm the topic and outline before writing pages; read `references/process.md`.
2. Every content-page title is an arguable sentence naming the key technology or method; the titles
   alone form the argument chain.
3. Always include cover, agenda, and final thank-you pages; rebuild the agenda from the current
   outline.
4. Fix every `section` at 1920×1080 with `overflow:hidden`; deliver only when `?debug` shows no red
   overflow frames.
5. Use at least 21px for teaching prose and 18px for presentation/self-read cards; tables, axes, and
   diagram labels may use 15px.
6. Change visual family within every three consecutive pages and follow a dense page with a light
   one. Use a compound pattern for two or more coupled dimensions.
7. Peer cards with the same role use identical fill, border, radius, and typography; highlight one
   only when the copy explains why.
8. Write plain, verifiable language without slogans, invented metaphors, or “click to view”
   instructions.
9. Prefer diagrams to tables and tables to prose. Use typed placeholders in the draft and clear
   every `data-todo` in the final.
10. Animation advances manually and is used only for teaching by default; reports and self-read
    decks remain static.
11. Style changes only variables and style-specific patterns. Core assets and skeletons contain no
    hard-coded brand colors.
12. Inline every image as a data URI so the deck is portable.

## Workflow

| Stage      | Output                                                                                                       | Gate                    |
| ---------- | ------------------------------------------------------------------------------------------------------------ | ----------------------- |
| Topic      | One agreed paragraph covering audience, setting/duration, objective, source material, style, and deliverable | User confirmation       |
| Outline    | Chapter/problem/minutes/page-count table saved to `<deck>.plan.md`                                           | User confirmation       |
| Patterns   | Outline-to-pattern, visual-family, and density map                                                           | Delivered with draft    |
| Draft      | Per-page plan plus `<deck>.html` with typed image placeholders                                               | —                       |
| Revision   | Chapter-by-chapter feedback and page-level change list                                                       | User confirms structure |
| Final      | Images, teaching animation if applicable, zero overflow, optional PPTX                                       | —                       |
| Acceptance | Copy edits, number verification, and delivery notes                                                          | User acceptance         |

If the user says “just do it,” ask the five topic questions once with disclosed defaults;
confirmation gates remain. Default to `generic` when no style is selected.

## Artifacts

`<deck>.plan.md` records title, style, scenario, duration, deliverable, outline, and each page's
label, claim, pattern, visual family/density, image requirement, and animation beats.

Build `<deck>.html` in the order defined by `references/deck-format.md`: inline style variables,
core CSS, style CSS, copied sections, then core runtime. Keep every `<section data-label>` directly
readable and editable.

For an image-based PPTX run `python3 tools/export_pptx.py <deck>.html [--notes <deck>.plan.md]`; it
is pixel-faithful but not editable. For an editable PPTX, rebuild natively with python-pptx using
the deck-format guidance. State the selected tier and tradeoff.

## Completion

- Plan and HTML have identical page count, order, and labels; cover, agenda, and thank-you exist,
  and agenda chapters match the outline.
- Every content title is a technical claim; no slogans or interaction hints remain.
- `?debug` has no overflow; no visual family repeats for three consecutive pages.
- Final `data-todo` count is zero; all images are data URIs.
- The variable contract is complete; core CSS/runtime are inlined unchanged; skeletons contain no
  hard-coded colors.
- Delivery notes explain playback keys, text editing, and the PPTX tier when present.

Load references only when needed: process and scenario adaptation (`references/process.md`),
typography/cards/copy (`references/style-guide.md`), patterns (`references/page-patterns.md`),
assembly/debug/PPTX (`references/deck-format.md`), visuals (`references/visuals.md`), teaching
motion (`references/motion.md`), and the chosen style (`references/styles/<style>.md`).
