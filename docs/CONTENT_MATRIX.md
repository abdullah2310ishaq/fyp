# LifeIQ source-to-node content matrix

This matrix is the implementation audit for `LifeIQ_Cursor_Master_Spec.md`, `LifeIQ_Complete_Dummy_Flutter_Master_Plan.md`, and `Scenario.md`. Every displayed story node has a `sourceRef` in code and bilingual EN/UR text.

## S01 — Body safety

| Source | App node | Interaction | Scoring |
|---|---|---|---|
| Checklist | `s1_checklist` | checklist | unscored |
| Scene 1 guide disclosure prompt | `s1_scene1` | accepted choice | unscored |
| Scene 2 non-graphic situation | `s1_scene2` | dialogue | unscored |
| Scene 3 body-safety teaching | `s1_scene3` | info | unscored |
| Body-zone recognition extension | `s1_body_map` | tappable full-body map | safety |
| Scene 4 feelings | `s1_scene4` | slider | unscored |
| Scene 5 unsafe-secret decision | `s1_scene5` | coached critical choice | safety |
| Scene 6 trusted adults | `s1_scene6` | accessible reorder | social |
| Scene 7 telling Ammi | `s1_scene7` | mock voice/text | communication |
| Scene 8 adult response | `s1_scene8` | info | unscored |
| Scene 8 wanted comfort extension | `s1_scene8_comfort` | info | unscored |
| Scene 9 next protection step | `s1_scene9` | coached critical choice | safety |
| Scene 10 rules/debrief | `s1_scene10` | terminal | result |

## S02 — Bullying response

Checklist → `s2_checklist`; numbered Scenes 1–12 → `s2_scene1`…`s2_scene12` in the same order. Scene 5 is the first critical report decision, Scene 6 is the teacher report practice, Scene 7 preserves the “just joking” consequence, Scene 8 covers retaliation, Scene 9 is the safety-plan rank activity, Scene 10 involves parents, Scene 11 resolves after two weeks, and Scene 12 carries the four final rules.

## S03 — Stranger safety

Checklist → `s3_checklist`; numbered Scenes 1–12 → `s3_scene1`…`s3_scene12`. The implementation retains the friendly/well-dressed approach, researched family details, direct-confirmation rule, phone excuse, parent confirmation/alternative helper teaching, specific public shout, shop safe space, descriptive report practice, official reporting decision, and five-rule ending.

## S04 — Online safety

Checklist → `s4_checklist`; numbered Scenes 1–13 → `s4_scene1`…`s4_scene13`. The nodes retain the three-week grooming context, five warning signs, threats and feelings, evidence-first choice, multi-select screenshot record, block plus report, trusted-adult decision, parent report practice, official evidence report, full account audit, repeat-account response, and six-rule ending.

## S05–S08 editorial expansions

`Scenario.md` does not contain expanded numbered scripts for these stories. The following nodes are new writing derived from the master-spec outlines and are marked as editorial expansions in every `sourceRef`:

- S05 `s5_checklist` + `s5_scene1`…`s5_scene8`: peer pressure, broken-record refusal, safe alternative, leaving and adult support.
- S06 `s6_checklist` + `s6_scene1`…`s6_scene8`: feelings slider, unscored grounding, breathing, small action and support request.
- S07 `s7_checklist` + `s7_scene1`…`s7_scene8`: stop, visible helper, helper ranking, fictional help request, direct confirmation and waiting.
- S08 `s8_checklist` + `s8_scene1`…`s8_scene9`: non-intervention, safe exit, independent trusted adult, repeated disclosure and safe consequence.

## Safety mapping

- Feelings, disclosure readiness, checklists and grounding are always unscored.
- Unsafe critical choices provide specific coaching and cannot terminate a story.
- Every story ends with an adult-help or safe-support path.
- No app node depicts contact or violence graphically.
- No real address, phone number, audio, disclosure or payment is requested or stored.
- Help, pause and exit remain available from every simulation node.
