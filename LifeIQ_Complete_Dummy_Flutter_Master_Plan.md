# LifeIQ — Complete Dummy Flutter App: 2D Visual Novel Master Plan

**Status:** implementation blueprint, not implemented application. **Scope:** complete, offline-first, frontend-only Flutter demo. **Source of truth:** `LifeIQ_Cursor_Master_Spec.md` for product/architecture/eight-category scope and `Scenario.md` for expanded narrative and interactions where provided. Any recommendations or adaptations below are marked as implementation decisions; do not silently rewrite source scenario dialogue.

## 1. Product objective
Build a polished child-safety learning visual novel for ages 6–15: parent demo onboarding → child avatar → scenario catalogue → readiness checklist → illustrated, interactive story → coaching and trusted-adult safety path → debrief, local rewards and progress. All visible actions must function with deterministic local data. No Firebase, Supabase, Flask, n8n, .NET, SQL Server, payment gateway, speech recognition, generative AI, network authentication, or remote telemetry. Show a discreet **DEMO / SIMULATED** label. Never claim mock text or mock voice was analyzed by AI.

**Definition of complete:** all eight scenario cards and full navigable experiences, local profile and progress, access states, reusable scene engine, responsive artwork, accessibility, EN/UR coverage, demo controls, automated tests, and a repeatable walkthrough. The four expanded narratives in `Scenario.md` must not be reduced to the shorter scripts in the older master spec. The master spec provides shorter scripts for S5–S8; write and review their expanded scenes before claiming equal narrative depth.

## 2. Source reconciliation / decisions required
- The master spec describes short five-step stories and one MCQ-first engine; `Scenario.md` contains longer, richer S1–S4 stories, including checklists, neutral self-report, teaching scenes, critical retries, multi-select, drag/rank, voice/text, and contextual branches. Implement the **expanded structure** for S1–S4. S5–S8 have short source outlines and require new, clearly identified expanded scripts.
- The master spec calls the guide Buddy; the expanded scenarios use Dost. Select **Dost** for displayed guide identity and make it configurable, rather than alternating names accidentally.
- The master spec offers a free-tier MCQ voice fallback; the expanded scenarios describe free text as the free fallback in some scenes. Implement a configurable per-node fallback and explicitly specify the intended tier behavior per scenario; never discard the user's ability to continue.
- The master spec scores best/okay/poor and retries at zero; the expanded scenarios accept all answers on feelings/disclosure scenes. Separate **unscored reflective questions** from **scored safety decisions**. Never penalize fear, confusion, freezing, delayed disclosure, or imperfect wording.
- The original sample S1 opens with an incident, whereas the expanded S1 begins with checklist and guide introduction. Use the expanded order.
- The master spec describes all eight scenarios, but the expanded scenario file explicitly details scenarios **01–04**. Treat S5–S8 as content-writing work, not as if full expanded scripts already exist.
- Do not hard-code 'parents are always safe' or 'all adults always believe children': some stories involve unsafe household members. Say **a trusted adult who is not involved**, and if the first adult cannot help, seek another safe adult or local child-protection service.
- The source's dummy helpline `0000-000` must be labeled **NOT A REAL HELP NUMBER** and never be presented as usable emergency help. Before any public release, verify local resources with qualified reviewers.
- Scoring is a game-learning indicator, **not a validated intelligence, trauma, psychological, or real-world safety assessment**. Label SIS as a simulated practice score; do not show diagnostic claims.

## 3. Technical architecture
**Flutter/Dart**, Material 3, `provider`, `go_router`, `shared_preferences`, `google_fonts`, `flutter_animate`, `flutter_localizations`/`intl`, `confetti`. Use native Flutter animation (`AnimationController`, `AnimatedSwitcher`, `TweenAnimationBuilder`) before adding extra dependencies. `ReorderableListView` for drag/rank; `CustomPainter` only for small decorative elements. Use optimized layered 2D PNG/WebP assets for visual novel scenes. Do not introduce Flame or Rive unless a later, measured requirement justifies it.

```
lib/
  main.dart
  app/app.dart app_router.dart app_bootstrap.dart
  core/theme/ core/localization/ core/widgets/ core/accessibility/
  domain/models/{scenario,scene_node,choice,character,session,decision,score,profile}.dart
  domain/repositories/{scenario_repository,profile_repository,session_repository,subscription_repository}.dart
  domain/services/{simulation_engine,score_calculator,reward_calculator,scenario_validator}.dart
  data/local/{asset_scenario_repository,local_profile_repository,local_session_repository,local_subscription_repository}.dart
  data/demo/{demo_auth_service,demo_voice_service,demo_text_feedback_service,demo_purchase_service}.dart
  features/onboarding/ features/auth/ features/avatar/ features/home/
  features/scenario_intro/ features/readiness/ features/simulation/
  features/debrief/ features/profile/ features/paywall/ features/settings/
  features/demo_panel/ features/help/
assets/
  art/backgrounds/ art/characters/ art/props/ art/ui/
  scenarios/{s01,s02,s03,s04,s05,s06,s07,s08}.json
  localization/
test/{domain,repository,widget,golden,integration}/
docs/{ART_BIBLE,SCENARIO_SCHEMA,CONTENT_MATRIX,DEMO_SCRIPT,TEST_PLAN}.md
```

**Boundaries:** UI reads providers/view models; providers call pure simulation/score services and repository interfaces; local repository implementations load assets and persist serialized session/profile state. The scene renderer never contains scenario-specific switch/case statements. Use versioned save models and a content-version field to reject or migrate incompatible sessions safely. Prefer stable IDs over list indexes.

## 4. 2D art direction and screen composition
**Look:** premium, warm, contemporary illustrated storybook; consistent 2D proportions and perspective; soft shadows; expressive faces; no horror or graphic violence. Use original cohesive artwork rather than mixing unrelated emojis, photos and illustration styles. Primary teal `#2BB3A3`, sunny yellow `#FFC94D`, soft coral `#FF7A6B`, cream `#FFF8EE`, navy `#22304A`, green `#4CAF7D`; keep accessible contrast. Rounded cards 20–28 logical px; touch targets >=56 logical px. Scalable body/dialogue typography, with Urdu font and RTL testing.

**Scene stage:** background fills the stage with aspect-ratio-aware cropping; foreground prop layer; NPC/child sprite layers with stable anchor points; optional guide floating sprite; speech bubble/dialogue layer; bottom interaction panel; top progress/pause/hint controls. In landscape or tablet, dialogue and choices may move beside the scene; on narrow phones, keep the dialogue panel scrollable and never obscure critical buttons. Honor safe areas, text scaling and reduced motion.

**Required background sets:** welcome/safe space, home living room, school classroom, school corridor, teacher office, school gate/road, park, market/mall, online/game chat UI, family support scene. Each scene has day/neutral variants only where needed. Use blurred/color-gradient fallback when a file is missing; report missing art in development logs.

**Character bible:** Dost guide (idle, listening, concerned, explaining, encouraging); selectable boy/girl child avatars (idle, unsure, confident, relieved); adult guardian, teacher/counselor, school peer, unfamiliar adult, shop worker/guard. Each character needs transparent full/half-body sprites, consistent scale and anchors, and a small set of non-graphic facial expressions. Avoid depicting actual inappropriate contact. Store character identity, emotion, position, scale, entrance/exit and speaking state as node data.

**Animation vocabulary:** 180–350 ms fades/slides, restrained sprite idle breathing, blink/eye movement where assets permit, character cross-fade for expressions, speaker highlight, progressive dialogue reveal with tap-to-complete, choice stagger, gentle coaching card, short completion celebration. Never animate distress for entertainment. Add `reduceMotion` mode that disables typewriter, idle movement and confetti.

**Asset pipeline:** make a single art bible and character turnaround before generating the full asset set. Export layered transparent sprites at 2x/3x appropriate display resolution, compress assets, use descriptive IDs, inspect edge halos, verify license/originality, and measure app size/performance. **A text-only coding assistant cannot create polished custom art by substituting emoji placeholders**; commission/generate and review the actual art as a separate deliverable.

## 5. Full screen map
1. Splash and optional intro carousel (demo branding and parent note).
2. Parent-facing login/register, OTP mock (`1234`), child profile (name, age 6–15), avatar selection; persist local fake session, do not imply real account security.
3. Home with 8 illustrated scenario cards, resume, local coins/streak, lock status, bottom navigation.
4. Scenario intro with objectives, age/context note, help/exit, parent co-play suggestion.
5. Pre-simulation readiness checklist, all answers accepted; content flags affect teaching dialogue, not access or safety scores.
6. Simulation stage: narrator/guide/NPC dialogue, teaching panels, MCQ, multi-select, slider, drag-rank, grounding taps, text, mock voice, coaching, branching consequence scenes, pause/resume and exit.
7. Debrief: encouragement, simulated practice score and optional dimensions, actions learned, best-path recap, badges/coins, replay when entitled, home/help.
8. Parent gate → dummy monthly/annual paywall → local subscription activation; no real money charged.
9. Profile: avatar, achievements, history, progress and dummy billing entries.
10. Settings: English/Urdu, sound/reduced motion, privacy/demo notice, demo panel, reset, help.
11. Help sheet reachable from intro, simulation and debrief; demo numbers are not dialable.

## 6. Scenario content inventory
| ID | Master-spec category | Expanded scenario source | Build requirement |
|---|---|---|---|
| S01 | Good Touch / Bad Touch | `Scenario.md` Scenario 01 | Checklist, guide, non-graphic home situation, body-safety teaching, feeling slider, critical choice/coaching, trusted-adult activity, simulated disclosure, adult response, next steps, debrief. |
| S02 | Harassment & Bullying | `Scenario.md` Scenario 02 | Checklist, repeated school bullying, neutral feelings, teaching, critical decisions, teacher reporting, consequences/retaliation, safety planning, family involvement, debrief. |
| S03 | Stranger Danger | `Scenario.md` Scenario 03 | Use its complete expanded scene order, critical choices, safe-help path and mock voice/text interaction. |
| S04 | Online Safety & Cyberbullying | `Scenario.md` Scenario 04 | Use its complete expanded scene order, multi-select and critical decisions, reporting and mock voice/text interactions. |
| S05 | Peer Pressure Resistance | Master spec §11.2 only | Expand 'Just Try It' into checklist, story, refusal practice, rank activity, support path and debrief. Mark new writing for review. |
| S06 | Emotional Regulation | Master spec §11.2 only | Expand 'The Big Feelings' into checklist, feelings slider, breathing/grounding interaction, support path and debrief. Do not score feeling intensity. |
| S07 | Emergency Response | Master spec §11.2 only | Expand 'Lost in the Market' into checklist, seek identifiable safe helper, contact guardian, waiting safely and debrief. |
| S08 | Home & Family Safety | Master spec §11.2 only | Expand 'The Home Secret' into checklist, identify a safe adult outside the unsafe situation, alternative help if dismissed, safe exit and debrief. |

**Content fidelity rule:** extract every numbered scene, all answer choices, response branches, coaching text, interaction modes and terminal conditions from the expanded source for S01–S04 into a content matrix before JSON authoring. Preserve source copy in a reference field or sidecar for editorial review; any safer alternative copy must be marked `editorialRevision` and approved rather than silently substituted. Do not invent detailed S05–S08 content and attribute it to `Scenario.md`.

## 7. Versioned scenario schema (illustrative)
```json
{
  "schemaVersion": 1,
  "id": "s01",
  "titleKey": "scenario.s01.title",
  "isFree": true,
  "startNodeId": "s01_checklist",
  "weights": {"safety": 0.5, "resilience": 0.2, "communication": 0.3},
  "nodes": [
    {
      "id": "s01_checklist",
      "type": "checklist",
      "backgroundId": "safe_space",
      "speakerId": "dost",
      "emotion": "listening",
      "textKey": "s01.checklist.prompt",
      "items": ["s01.checklist.address", "s01.checklist.phone", "s01.checklist.adult", "s01.checklist.bodySafety"],
      "scorePolicy": "unscored",
      "nextNodeId": "s01_guide_intro"
    }
  ]
}
```

**Node types:** `narration`, `dialogue`, `checklist`, `info`, `singleChoice`, `multiChoice`, `slider`, `dragRank`, `groundingTap`, `freeText`, `mockVoice`, `coaching`, `consequence`, `terminal`. Common fields: stable node ID, localized text key, background/character/sprite layout, interaction config, validation policy, optional flags/conditions, next node or choice-specific branch, score policy and dimension, accessibility label, help availability. Store all displayed strings in EN/UR localization maps or localized scenario content, not widget source.

**Choice model:** `{id,textKey,nextNodeId,quality?,dimension?,coachingNodeId?,setFlags?,requiresFlags?}`. For feelings/self-report nodes omit quality and use `scorePolicy: unscored`. Critical decision nodes can show coaching then return to the same node; preserve previously selected options and permit a safe path to continue. A multi-select node has a set of accepted option IDs; a drag-rank node has an explicit evaluation rule and optional partial credit. No unbounded loop.

**Validation:** unique IDs, reachable start/terminal, all links resolve, no accidental cycles, every critical choice has coaching and a safe exit, all localization keys exist, asset keys resolve/fallback, weights are valid, no score on self-report nodes, all paths can terminate, all required help routes accessible. Provide a CLI/unit-test validator before adding large JSON files.

## 8. Deterministic simulation state machine
`idle → loading → presenting → awaitingInput → evaluating → coaching/branching → presenting → completed`; `paused` and `errorRecoverable` are explicit states. Record node ID, selected choice(s), attempt count, flags, score award and timestamp in a local session. Save after every meaningful transition; restore node, animation completion and disabled choices safely. Debounce taps to prevent double advancement or duplicate rewards. A terminal node creates an immutable result once; reopening debrief must not mint coins again.

**Mock interaction contract:** voice button shows a simulated listening animation and prewritten transcript; explicitly label `Demo transcript — no audio recorded`. Text can use deterministic, transparent rule-based demo responses, but do not claim to infer abuse, emotional state or confidence from keywords. A child may skip speaking/typing and choose a guided example. Sliders representing feelings always advance without judgment. Multi-select and drag-rank use predictable rules and explain the safer actions gently. Any safety-related coaching offers `Pause`, `Exit story` and `Find help`.

## 9. Scores, rewards and premium behavior
Implement the master-spec sample values as **configurable demo game rules**: best 10, okay 5, poor 0, first-attempt vs coached retry tracked separately; dimension = awarded/available; overall = normalized weighted average of dimensions with eligible scored decisions. Handle dimensions with zero eligible steps without dividing by zero or treating them as 0. Do not use scores for emotional disclosure or verbal fluency. Master-spec outcome bands: >=75 safe, 50–74 partial, <50 coached; rename display labels to non-diagnostic learning labels such as `Practiced well`, `Keep practicing`, `Let's practice together` while retaining raw demo values if needed for compatibility.

Master-spec coin bands: <60 = 20 effort coins; 60–74 = 50; 75–89 = 75; >=90 = 100. Bonuses: first completion +25, perfect +50, daily streak +10/day capped +50, improvement on replay = max(10, new score − previous best) when new score is higher. Grant completion rewards only once per unique session. Store badge conditions as data and test thresholds/boundaries. A score is **not** a measure of a child's real-world safety, psychological resilience or intelligence.

Free: S01, overall demo score, base coins. Premium (local simulated flag): S02–S08, full practice breakdown/history, hints, replay and Urdu per the original master spec. Parent gate before paywall and before demo subscription changes; subscription flags `free|active|expired`. Hints cost 10 coins, max 3 per scenario, and must not disable the only safe answer. `Restore purchase` is a simulated message, not a real purchase restoration. For child safety, **help/exit and core safety explanations are never paywalled**; if Urdu is gated in the demo, still provide critical help in the child's accessible language.

## 10. Local persistence and demo controls
Persist parent demo profile, child avatar, selected language, subscription state, per-scenario completion/best/history, badges, coins, streak, and active session. Provide seeded sample profiles and a demo panel for free/active/expired, coins, completed/uncompleted scenario, restart current scene, clear all data, and direct entry to a documented scene for presentations. Hide demo controls from child-facing primary navigation. Never store actual disclosures, audio, real addresses or real phone numbers; fictional examples only. `shared_preferences` is suitable for a small dummy prototype, not a secure store for sensitive child data.

## 11. Localization and accessibility
English and Urdu text keys for **all** UI and authored scenario nodes; support proper RTL alignment and mixed-direction names/numbers. Test text scale 1.0/1.3/1.6, 320–430 logical px widths and tablets, screen-reader labels, focus order, button semantics, high contrast and reduced motion. Distinguish speaker through name and accessible label, not color alone. Give every interaction a non-drag alternative and every voice mock a text/choice fallback. Review translated child-safety language with a qualified Urdu speaker.

## 12. Build phases (one Cursor chat per phase)

### Phase 0 — Content audit and art bible
**Deliver:** source-to-node matrix for S01–S04, list of S05–S08 content gaps, screen inventory, UI wireframes, character/background art bible, naming and export conventions, safety/editorial change log. **Accept:** every expanded source scene accounted for; no artwork presented as complete before assets exist. **Cursor:** `Read both source files fully. Produce docs/CONTENT_MATRIX.md and docs/ART_BIBLE.md. Do not write Flutter screens yet. Identify source conflicts and unexpanded scenarios.`

### Phase 1 — Flutter foundation and design system
**Deliver:** runnable project, dependencies, theme, typography, reusable buttons/cards, routing skeleton, models, repository interfaces, localization scaffolding, asset registry/fallbacks. **Accept:** clean analyze; splash → placeholder home; sample schema parses; responsive component preview. **Cursor:** `Implement Phase 1 only from this plan. Keep the app runnable and write model/validator tests.`

### Phase 2 — Real 2D asset integration and scene renderer
**Deliver:** actual reviewed S01 art set, layered stage, sprites/expressions, dialogue/typewriter, choice layout, animation presets, responsive layout and reduced motion. **Accept:** S01 sample scene looks coherent on small/large phones; no clipped dialogue; no emoji as primary production art. **Cursor:** `Implement Phase 2 only. Use supplied approved art; do not claim placeholders are final artwork.`

### Phase 3 — Demo auth, child onboarding and home
**Deliver:** parent-facing dummy auth/OTP, child profile, avatar choice, route guards, home catalogue, resume card, intro, help sheet. **Accept:** first-run → home and restart → persisted home; eight cards visible; only S01 free; all routes functional. **Cursor:** `Implement Phase 3 only with local fake repositories and no network calls.`

### Phase 4 — Generic story engine and interaction primitives
**Deliver:** versioned JSON loader/validator, state machine, session save/resume, narrator/NPC/guide, info/checklist, single/multi-choice, slider, drag-rank, grounding taps, text/mock voice, coaching/branching, safe pause/exit. **Accept:** synthetic test story exercises every node type; all branches terminate; interrupted session resumes; no double-tap duplicate events. **Cursor:** `Implement Phase 4 only; write engine tests before importing long scenarios.`

### Phase 5 — Scenario 01 complete vertical slice
**Deliver:** full expanded S01 checklist and scenes from `Scenario.md`, approved S01 art, branch-specific guide responses, coaching, adult-help ending, end-to-end replay. **Accept:** source-to-node matrix 100% mapped, all choices tested, no graphic depiction, unscored feelings, all paths reach safe end/help. **Cursor:** `Implement Phase 5 only. Use Scenario.md Scenario 01 as narrative source; preserve scene order and record any editorial changes.`

### Phase 6 — Scenarios 02–04 full fidelity
**Deliver:** expanded bullying, stranger-danger and online-safety narratives from `Scenario.md`, with their distinct backgrounds, NPCs, multi-select/voice/text/critical-choice branches. **Accept:** each numbered source scene and option is accounted for; scenario-specific regression tests pass; no short-script replacement. **Cursor:** `Implement Phase 6 only; use Scenario.md Scenarios 02–04 and the content matrix, not the abbreviated five-step outlines.`

### Phase 7 — Expand and build Scenarios 05–08
**Deliver:** newly authored, clearly marked expanded scripts for peer pressure, emotional regulation, lost-in-market and home/family safety, followed by reviewed JSON and artwork. **Accept:** editorial review of new scripts, same interaction depth and technical validation as S01–S04, accessible trusted-adult/help route in each. **Cursor:** `First draft and review expanded S05–S08 scripts from the master-spec outlines; only implement the approved content. Do not attribute invented scenes to Scenario.md.`

### Phase 8 — Debrief, coins, badges, history and replay
**Deliver:** deterministic scoring/reward services, complete debrief, local achievements, best-path recap, streak, replay and score history. **Accept:** boundary and duplicate-award tests; unscored feelings do not affect SIS; completion persists across restart. **Cursor:** `Implement Phase 8 only. Follow configured demo score rules, but never score disclosure or emotion.`

### Phase 9 — Parent gate, simulated premium and profile
**Deliver:** parent gate, demo paywall, free/active/expired access states, hints, profile, billing placeholders and demo panel. **Accept:** locked stories cannot start in free mode; help is always accessible; no actual payment SDK; resetting restores a clean demo. **Cursor:** `Implement Phase 9 only. Every paid feature is simulated locally.`

### Phase 10 — Complete Urdu, accessibility and polish
**Deliver:** all EN/UR content, RTL layouts, responsive tuning, audio toggle, reduced motion, animation refinements, error/empty states and asset optimization. **Accept:** no missing translations/overflow; screen reader and keyboard alternatives work; stable performance on a mid-range Android phone. **Cursor:** `Implement Phase 10 only; fix localization, accessibility, visual consistency and performance without changing approved narrative meaning.`

### Phase 11 — Quality assurance and presentation package
**Deliver:** unit/widget/integration/golden tests, scenario graph validation, source-to-content audit, README, setup script, demo accounts, 5-minute guided demo, APK build instructions, screenshots and known-limitations document. **Accept:** `flutter analyze` clean, `flutter test` passes, full eight-scenario smoke test, no runtime network dependencies, no misleading AI/payment/helpline claims. **Cursor:** `Implement Phase 11 only. Run tests and report actual results and remaining limitations; do not mark unrun tests as passed.`

## 13. Cross-phase definition of done
At the end of **each** phase: run formatter/analyzer/tests relevant to changes; launch on an emulator/device; check one narrow and one large viewport; inspect new art and localization; confirm no broken navigation, placeholder CTA, uncaught asset exception or unintended network call; update changelog and remaining-work list. Stop before the next phase. A screen is not finished if it only looks clickable.

## 14. Cursor project rules — paste into `.cursor/rules/lifeiq.mdc`
```
You are implementing LifeIQ, an offline-only Flutter 2D visual-novel demo for children aged 6–15.
Read LifeIQ_Complete_Dummy_Flutter_Master_Plan.md and both source documents before implementation.
Implement ONLY the phase explicitly requested; do not silently compress detailed source scenes.
Use Provider, go_router, local repositories, versioned JSON nodes, and shared_preferences.
Keep story content, translations, assets and engine logic separate from widget layout.
No backend, real AI, real voice recognition, real authentication, real purchases, or real helpline placeholders presented as live services.
Use approved coherent 2D artwork; missing art gets an explicit development fallback, not a claim of final polish.
Never score emotions, disclosure, freezing or verbal ability; always provide help and exit paths.
Every screen/action must be functional, accessible and responsive. Keep the app runnable after every phase.
Before ending: run relevant checks, report files changed, tests actually run, manual test steps and unresolved issues.
```

## 15. First implementation request
`Read LifeIQ_Complete_Dummy_Flutter_Master_Plan.md, LifeIQ_Cursor_Master_Spec.md, and Scenario.md in full. Start Phase 0 ONLY. Build the source-to-scene inventory and art bible, identify source contradictions, and give me an approval checklist. Do not write app screens or generate short substitute stories.`

**Final limitation:** this plan specifies how to produce a polished app; it does not itself include finished illustration files, full transcribed scenario JSON, approved S05–S08 expanded scripts, or a compiled Flutter project. Those are explicit phase deliverables.
