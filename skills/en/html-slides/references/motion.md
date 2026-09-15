# Manual Motion

Tell users: `P` toggles presentation mode; right/PageDown/space/click/down-wheel advances one beat
then the next page; left/PageUp/up-wheel reverses; Home/End jump; `F` toggles fullscreen; refresh
restores the hash or last page.

Use `.build` only for elements hidden on entry. Put it on a panel's outer frame as well as its
content so empty frames do not appear early. Order builds with `data-step` after planning the whole
page.

Use layers for mutually exclusive states. Give layer controls `data-step` when arrow keys should
advance them; otherwise they remain click-only. One group shows one layer at a time and has a clear
default.

Plan beats before numbering: each beat must communicate one claim, preserve reading order, and avoid
more than the audience can hold. Teaching may use motion; reports and self-read decks default to
static. Verify forward, backward, page transitions, refresh, and exported static state.
