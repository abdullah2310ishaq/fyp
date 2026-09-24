# LifeIQ implementation phases

LifeIQ is a new offline Flutter app (`com.fyp.lifeiq`). The old expense-manager application architecture is not reused.

## Phase 1 — Foundation (complete)

- Material 3 design system, responsive page width, safe-area handling
- Provider state, `go_router`, local `shared_preferences`
- English/Urdu direction support and bilingual story content
- Offline-only Android manifest and minimal dependency set

## Phase 2 — 2D visual system (complete for dummy build)

- Native Flutter scene painter with home, school, road, online, park and market compositions
- Layered characters, scene semantics, responsive 16:10 stage
- Gentle transitions and reduced-motion setting

Production illustration commissioning remains a separate art deliverable; the dummy app deliberately uses cohesive code-drawn art rather than claiming placeholder images are final artwork.

## Phase 3 — Family onboarding (complete)

- Demo parent register/login and OTP (`1234`)
- Nickname, age 6–15 and child avatar selection
- Local route state, eight-card home, resume card and help sheet

## Phase 4 — Story engine (complete)

- Dialogue, teaching, checklist, unscored feeling slider, critical coaching loop, multi-select, accessible reorder/rank, grounding, text/mock voice and terminal nodes
- Saved active story/step, disabled unsafe retry choices and double-reward prevention through terminal completion state
- Pause, resume, exit and contextual help

## Phase 5 — Eight scenario catalogue (complete)

- S01 contains its checklist and all 10 numbered source scenes
- S02 contains its checklist and all 12 numbered source scenes
- S03 contains its checklist and all 12 numbered source scenes
- S04 contains its checklist and all 13 numbered source scenes
- S05–S08 are explicitly marked editorial expansions of the shorter master-spec outlines
- Every story has bilingual teaching, critical decisions, tailored coaching, practice and a safe ending
- `docs/CONTENT_MATRIX.md` records the source-to-node mapping

## Phase 6 — Rewards and debrief (complete)

- Deterministic practice score, effort coins, first-completion bonus, best score and badges
- Non-diagnostic language, best-path recap and premium breakdown
- Feelings and free expression are never scored

## Phase 7 — Premium demo and settings (complete)

- Parent maths gate, simulated premium activation and restore message
- Free/active/expired demo states, local coins and reset controls
- Urdu toggle, sound preference and reduced motion

## Phase 8 — Hardening (verified in repository)

- Scenario catalogue/state tests
- Flutter analyzer and test suite
- Android application ID and display name updated
- No Firebase, analytics, authentication, payment, camera, microphone, notification or network package

## Production follow-ups

- Commission and review final original 2D sprite/background packs
- Complete line-by-line S01–S04 source matrix and approved expanded scripts for S05–S08
- Qualified child-safety and Urdu-language review
- Device-based screen reader, large-text, narrow-phone and tablet QA
