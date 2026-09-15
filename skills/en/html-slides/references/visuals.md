# Visual Workflow

In the draft, use a typed placeholder containing visual type, intended content/source, and aspect
ratio. Do not create a generic “image placeholder.”

For supplied sources, extract the original image at sufficient resolution, crop captions and chrome,
then write a consistent local caption. For mechanisms and architecture, draw semantic HTML/SVG using
straight flows, branching decisions, or swimlanes. Expand heterogeneous units rather than replacing
them with an abstract layer list.

Use standard tables for exact comparisons: concise headers, consistent alignment, explicit units,
and a nearby takeaway. Use color only with a legend or a true emphasis rule.

Final QA checks crop, resolution, text inside SVG bounds, arrow direction and attachment, formula
glyphs, contrast, source/caption, and `data-todo=0`. Screenshot SVGs at scale because DOM overflow
checks cannot detect text overflowing an SVG view box.
