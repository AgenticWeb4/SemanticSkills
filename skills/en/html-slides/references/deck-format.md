# Single-File HTML Contract

Assemble in this order: style variables, `assets/core/base.css`, optional style CSS, navigation and
page sections from skeletons/patterns, then `assets/core/runtime.js`. Inline all CSS, JavaScript,
and images.

Each page is one `<section data-label="...">` fixed at 1920×1080 with header, flexible body
(`flex:1; min-height:0`), and optional footer. Cover and thank-you pages may omit the standard
footer. Keep semantic HTML directly editable.

Every style defines `--bg`, `--bg-alt`, `--bg-cover`, `--surface`, `--line`, `--fg`, `--fg-body`,
`--fg-muted`, `--accent`, `--accent-soft`, `--accent-2`, `--font-sans`, `--font-mono`, `--radius`,
`--shadow`, and `--table-head`. Core assets contain no brand values.

Convert images to data URIs, preserve useful resolution, crop deliberately, and write accessible alt
text. External URLs are not a portable deliverable.

Runtime provides scroll/slide modes, keyboard navigation, manual build/layer steps, fullscreen, page
persistence, and `?debug`. Debug marks section overflow red, nested clipping orange, and reports
each issue in the console. Final delivery has zero warnings.

For image-based PPTX use `tools/export_pptx.py`; for editable PPTX rebuild with python-pptx using
native text, shapes, tables, and images. State which tier was delivered.

Check variable completeness, section count/order/labels, fixed dimensions, no external dependencies,
zero `data-todo`, unmodified core assets, and valid keyboard behavior.
