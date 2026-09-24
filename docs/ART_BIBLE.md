# LifeIQ 2D art bible

## Direction

Warm Pakistani storybook, calm rather than clinical, with rounded shapes, restrained expressions and high-contrast dialogue. Unsafe characters are never rendered as monsters; behaviour and context communicate risk. The current dummy build uses a coherent Flutter `CustomPainter` stage so it remains original, lightweight and offline.

## Palette

- Deep teal `#177E78`: guide, primary actions, safety
- Sun yellow `#FFC857`: hope, reward, focus
- Cream `#FFF9F0`: primary background
- Navy `#1F3049`: text and outlines
- Coral `#F57C73`: gentle warnings only
- Mint `#DFF5EE`: guide dialogue and success support

## Stage composition

The visual-novel stage occupies the upper 16:10 panel. Background, environment props, two character layers and speaker state are painted independently. Dialogue and interaction controls remain outside the art so 1.6× text never covers a critical action.

Implemented scene IDs: `home`, `school`, `road`, `online`, `park`, `market`. Character roles: `guide`, `parent`, `teacher`, `peer`, `stranger`, `online`, `worker`, `adult`. Missing variants intentionally fall back to the neutral storybook figure without throwing.

## Production asset handoff

Future reviewed art should use transparent WebP/PNG sprites at consistent anchor and scale:

- `characters/dost_{idle,listening,concerned,explaining,encouraging}`
- `characters/child_{boy,girl}_{idle,unsure,confident,relieved}`
- `characters/{parent,teacher,peer,stranger,worker}_{neutral,talking,concerned}`
- `backgrounds/{safe_space,home,school_corridor,teacher_office,road,park,market,online}`

No production asset may depict inappropriate contact, injury, terror or a child’s distress for entertainment. Verify originality/licensing, transparent-edge halos, small-phone readability, contrast and compressed size before replacing the painter.

## Motion

Transitions are 180–350 ms. Reduced-motion mode makes route/content transitions instant and disables decorative motion. Grounding and choices never rely on animation alone.
