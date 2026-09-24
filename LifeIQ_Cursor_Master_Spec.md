# LifeIQ — Master Spec for Cursor (Flutter Frontend, Dummy Data)

> **How to use this file:** Put it in the project root (or `/docs/SPEC.md`). Tell Cursor: *"Read SPEC.md fully. We build phase by phase. Do ONLY the phase I name. Stop after its acceptance checklist passes."*
> Do not paste all phases at once. One phase = one Cursor chat.

---

## 0. Cursor Rules (paste into `.cursorrules` or Project Rules)

```
You are building "LifeIQ", a Flutter (Dart) child-safety simulation app (ages 6-15).
- FRONTEND ONLY. No real backend, no AI, no Stripe, no Firebase. Everything is dummy/local.
- State management: Provider. Navigation: go_router. Persistence: shared_preferences.
- All UI text comes from data/localization files, never hard-coded in widgets.
- Every data source sits behind an abstract Repository so a real API can replace the dummy later.
- Tone of content: gentle, empathetic, non-graphic, never scary or blaming. Wrong choice = coaching, never "Wrong!" / red failure screens.
- Large tap targets (min 56px), large readable text, bright warm colors, one main action per screen.
- Null-safe, small widgets, no file over ~300 lines, no unused code, run `flutter analyze` clean.
- Work only on the phase I request. After finishing, list what changed and what I should test.
```

---

## 1. Product in One Paragraph

LifeIQ is an AI-powered **child-safety and cognitive-development simulation app** for Pakistani children (ages 6–15), created as an Air University Islamabad FYP. It is a **visual novel**: a background scene, an NPC character sprite, a dialogue box, and 3 choices. A friendly **Guide NPC** first asks the child *"what happened?"*, validates their feelings, then guides them step by step to the safest action. Wrong choices trigger **gentle coaching**, not failure. At the end the child gets a **Situational Intelligence Score (SIS)**, coins, safety badges, and a prompt to replay and improve.

**For this build:** the real AI (Flask + n8n), .NET API, SQL Server, Stripe, Google STT, Blazor admin are **all replaced by dummy local data**. The goal is a **complete, believable, demo-ready frontend flow**.

---

## 2. Users & Accounts (dummy)

- **Parent/guardian** registers (email + password + OTP). **Child profile** lives under the parent.
- Dummy rule: any email/password works; OTP is any 4 digits (show hint "Demo: use 1234").
- After first login → **one-time character selection** (Boy / Girl avatar), saved locally.
- Subscription flag: `free | active | expired`. Demo toggle to switch it.
- **Parent gate** before Paywall: simple maths question ("What is 7 + 8?") so kids can't buy. This is a sensible child-app pattern.

---

## 3. Tech Stack (frontend)

| Need | Package |
|---|---|
| State | `provider` |
| Routing | `go_router` |
| Storage | `shared_preferences` |
| Fonts | `google_fonts` (rounded, friendly, e.g. Nunito; Urdu: Noto Nastaliq Urdu) |
| Animations | `flutter_animate` |
| Localization | `flutter_localizations` + `intl` (or simple JSON map) |
| Confetti (debrief) | `confetti` |

No other packages unless needed.

---

## 4. Design System

- **Mood:** safe, warm, playful, calm. Never dark or scary, even for "threatening" NPCs (use a stern face, not horror).
- **Palette:** Primary teal `#2BB3A3`, Accent sunny yellow `#FFC94D`, Soft coral `#FF7A6B` (for gentle warnings only), Background cream `#FFF8EE`, Text deep navy `#22304A`, Success green `#4CAF7D`.
- **Shape:** rounded 20–28px corners, soft shadows, big pill buttons.
- **Text:** body ≥ 18sp, dialogue ≥ 20sp, headings 28sp+.
- **Guide NPC:** a friendly character (name it **"Nora"** for girls' flow / **"Zain"** optional; simplest: one Guide named **"Buddy"**, a kind owl/lantern/star character). Always warm expression.
- **Assets are placeholders:** use colored gradient backgrounds + emoji/simple vector characters. Naming convention below so real art drops in later.

Asset naming:
```
assets/backgrounds/bg_home.png, bg_school.png, bg_road.png, bg_park.png, bg_market.png, bg_online.png, bg_mall.png
assets/characters/guide_neutral.png, guide_friendly.png, guide_concerned.png
assets/characters/npc_relative_friendly.png, npc_relative_threatening.png (etc.)
assets/characters/boy_*.png, girl_*.png
```
If a file is missing, the app falls back to a colored box + emoji (never crash).

---

## 5. Project Structure

```
lib/
├── main.dart
├── app_router.dart
├── core/            theme.dart, colors.dart, constants.dart, gate_helper.dart
├── models/          scenario.dart, step.dart, choice.dart, session.dart, sis_result.dart, user_profile.dart
├── data/
│   ├── repositories/    scenario_repository.dart (abstract), dummy_scenario_repository.dart
│   │                    user_repository.dart, dummy_user_repository.dart
│   └── localization/    en.dart, ur.dart
├── providers/       auth_provider, simulation_provider, coins_provider, settings_provider, progress_provider
├── screens/
│   ├── splash/  auth/  character_select/  home/  scenario_intro/
│   ├── simulation/  debrief/  paywall/  profile/  settings/
└── widgets/         dialogue_box, choice_button, npc_sprite, scene_background, sis_bar, coin_chip, badge_chip, lock_overlay
assets/scenarios/    s1_good_bad_touch.json … s8_home_family_safety.json
```

---

## 6. Core Data Models

```dart
enum Speaker { narrator, guide, npc, child }
enum Emotion { neutral, friendly, concerned, threatening, happy }
enum Quality { best, okay, poor }          // drives score + coaching
enum Dimension { safety, resilience, social, communication, emotional }
enum InteractionType { mcq, freeText, voice, slider, dragRank, debrief }
enum Outcome { safe, partial, unsafeCoached }

class Choice {
  String id; String textEn; String textUr;
  Quality quality;
  Dimension dimension;      // which SIS dimension this step measures
  String nextStepId;        // where to go after this choice
  String? coachingEn;       // shown by Guide if quality != best
  String? coachingUr;
}

class Step {
  String id; Speaker speaker; Emotion emotion;
  String background;        // asset key
  String textEn; String textUr;
  InteractionType type;     // default mcq
  List<Choice> choices;     // 3 for mcq
  String? nextStepId;       // for non-interactive steps
  bool isTerminal; Outcome? outcome;
}

class Scenario {
  String id; int order; String categoryEn, categoryUr; String titleEn, titleUr;
  String emoji; bool isFree; String startStepId;
  Map<Dimension,double> weights;   // sum = 1.0, drives overall SIS
  List<Step> steps;
}

class SisResult {
  Map<Dimension,int> dimensionScores;  // 0..100
  int overall;                          // 0..100
  Outcome outcome; int coinsEarned; int improvementBonus; List<String> badges;
}
```

---

## 7. Simulation Engine (the heart)

`SimulationProvider` is a small **state machine**. No AI: it reads the next step from the scenario JSON.

**Flow per choice:**
1. Child taps a choice.
2. Record `{stepId, choiceId, quality, dimension}` in `session.decisions` (decision history, exactly like the real AI prompt-context will be later).
3. If `quality == best` → go to `choice.nextStepId`.
4. If `quality != best` → show **Coaching step** (Guide speaks `coachingEn`), then **return to the same question** with that option greyed ("Let's think again 💛"). Retry earns 0 points for that step.
5. Loop until a terminal step → build `SisResult` → Debrief.

**Session persistence:** after every decision, save `session` to `shared_preferences`. On app reopen mid-scenario, Home shows **"Resume"** card.

**Hints (premium):** max 3 per scenario, costs 10 coins each. A hint reveals a short Guide line that softly points toward the best option (never states the answer directly), and greys one poor option. Needs coins ≥ 10.

**Interaction types** (implement MCQ first; others in Phase 7):
- `mcq` (primary), `freeText` (mock: any text accepted, canned keyword check), `voice` (mock mic: tap → 2 sec "listening…" → fixed transcript), `slider` (e.g. "how worried do you feel?"), `dragRank` (order 3 actions safest-first), `debrief` (final screen).

---

## 8. Scoring (dummy but real logic)

**Per decision points:** `best = 10`, `okay = 5`, `poor = 0`. Retries after coaching = 0.
**Dimension score** = `earned / possible × 100` for steps measuring that dimension (dimensions with no steps are hidden).
**Overall SIS** = weighted sum using the scenario's `weights`.

**Outcome:** SIS ≥ 75 → `safe`; 50–74 → `partial`; < 50 → `unsafeCoached`.

**Coins on completion (from proposal):**
- SIS 60–74 → 50 coins · 75–89 → 75 coins · 90+ → 100 coins · below 60 → 20 "effort" coins (never zero, so kids stay motivated)
- Bonuses: first-time completion +25 · perfect score (100) +50 · daily streak +10 per day (max +50)
- **Improvement bonus:** replay SIS higher than previous best → `+ (newScore − oldBest)` coins, min 10.

**Badges (examples):** "Brave Voice" (refused clearly), "Trusted Adult Finder" (chose to tell an adult), "Cool Head" (resilience ≥ 80), "Comeback Kid" (improved on replay), "Safe Surfer" (online scenario ≥ 75).

**SIS dimensions (labels in UI):** Safety Awareness · Psychological Resilience · Social Intelligence · Communication Clarity · Emotional Preparedness. Show as 5 colored bars in Debrief.

---

## 9. Freemium Rules (dummy enforcement)

| Feature | Free | Premium |
|---|---|---|
| Scenario 1 | ✓ | ✓ |
| Scenarios 2–8 | 🔒 | ✓ |
| Full SIS breakdown & debrief | Overall score only | Full 5-dimension debrief |
| Score history | 🔒 | ✓ |
| Hints (coins) | 🔒 | ✓ |
| Voice input | 🔒 (MCQ fallback) | ✓ |
| Urdu mode | 🔒 | ✓ |
| Replay with improvement tracking | 🔒 | ✓ |
| Coins | Limited (base only) | Full (all bonuses) |

Demo: tapping **Subscribe** (after the parent gate) sets `subscription = active`. Add a hidden **Demo Panel** in Settings to toggle free/active/expired and reset all data.

---

## 10. Screens Spec

1. **Splash** – logo, tagline "Learn to stay safe, one story at a time", 2 sec → route by auth state.
2. **Auth** – Login / Register tabs, parent-facing wording, OTP screen (dummy 1234), "Add child name & age (6–15)".
3. **Character Select** – Boy / Girl cards with idle bounce animation; one-time; Confirm button.
4. **Home** – greeting, coin chip, streak, **Resume** card (if any), 8 category cards in a grid/list with emoji, title, lock overlay for premium, "Best SIS" badge if played. Bottom nav: Home · Profile · Settings.
5. **Scenario Intro** – category, title, short description, "You'll practice: …", age note, **Start** button. Small "Need help now?" link (see §13).
6. **Simulation** – top: back/pause, hint bulb (with coin cost), progress dots. Middle: background + NPC sprite (+ child avatar). Bottom: dialogue box with typewriter effect, then choice buttons slide in. Guide's lines have a soft glow/different color than adversarial NPC lines.
7. **Debrief** – confetti, Guide message, big SIS ring, 5 dimension bars (premium; free sees overall + "Unlock full breakdown"), coins earned (with breakdown), badges, **"Best path"** recap (list of ideal choices), **Replay** + **Home** buttons.
8. **Paywall** – reached from locked card; parent gate first; monthly vs annual cards (dummy prices), feature list, "Subscribe (Demo)" button, "Restore purchase" (dummy toast).
9. **Profile** – avatar, child name, coins, streak, badges shelf, score history list (premium), subscription status, billing history (dummy list).
10. **Settings** – language (EN/UR, Urdu premium; RTL layout), sound toggle, Roman Urdu toggle (optional), Demo Panel, About/Privacy.

---

## 11. Dummy Scenario Content (real-life simulations)

**Writing rules:** age-appropriate, non-graphic, never blame the child, always say *"it is not your fault"* where relevant, always end with a trusted-adult / help path. Keep sentences short. Tags: `[BEST]` `[OK]` `[POOR]`.

Names used: child = **{childName}** (from profile). Guide = **Buddy**.

### 11.1 Full JSON Example — Scenario 1 (Free): Good Touch / Bad Touch

`assets/scenarios/s1_good_bad_touch.json`

```json
{
  "id": "s1", "order": 1, "isFree": true, "emoji": "🛡️",
  "categoryEn": "Good Touch / Bad Touch", "categoryUr": "اچھا لمس / برا لمس",
  "titleEn": "The Visiting Uncle", "titleUr": "مہمان انکل",
  "startStepId": "s1_a",
  "weights": { "safety": 0.5, "resilience": 0.2, "communication": 0.3 },
  "steps": [
    { "id": "s1_a", "speaker": "narrator", "emotion": "neutral", "background": "bg_home",
      "textEn": "A relative you know well is visiting. He sits close and says, 'Come sit on my lap. It's our little secret.' You feel uncomfortable.",
      "textUr": "ایک جاننے والے رشتہ دار آئے ہیں۔ وہ قریب بیٹھ کر کہتے ہیں 'میری گود میں بیٹھو۔ یہ ہمارا راز ہے۔' آپ کو بے چینی ہو رہی ہے۔",
      "type": "mcq",
      "choices": [
        { "id": "a1", "textEn": "Say 'No, I don't like that' and walk away", "textUr": "کہو 'نہیں، مجھے یہ پسند نہیں' اور چلے جاؤ", "quality": "best", "dimension": "safety", "nextStepId": "s1_b" },
        { "id": "a2", "textEn": "Stay quiet so nobody gets upset", "textUr": "خاموش رہو تاکہ کوئی ناراض نہ ہو", "quality": "poor", "dimension": "safety", "nextStepId": "s1_b",
          "coachingEn": "Feeling uncomfortable is a signal. You are allowed to say no to anyone, even family.", "coachingUr": "بے چینی ایک اشارہ ہے۔ آپ کسی کو بھی، حتیٰ کہ گھر والوں کو بھی، نہ کہہ سکتے ہیں۔" },
        { "id": "a3", "textEn": "Laugh and pretend it's a joke", "textUr": "ہنس کر مذاق سمجھو", "quality": "okay", "dimension": "safety", "nextStepId": "s1_b",
          "coachingEn": "It's okay to feel unsure. But a clear 'no' is stronger than a laugh.", "coachingUr": "الجھن ہونا ٹھیک ہے، مگر صاف 'نہیں' ہنسی سے زیادہ مضبوط ہے۔" }
      ] },
    { "id": "s1_b", "speaker": "guide", "emotion": "concerned", "background": "bg_home",
      "textEn": "Hi, I'm Buddy. I can see something felt wrong just now. Can you tell me what happened?",
      "textUr": "میں بڈی ہوں۔ لگتا ہے کچھ ٹھیک نہیں لگا۔ کیا آپ بتا سکتے ہیں کیا ہوا؟",
      "type": "mcq",
      "choices": [
        { "id": "b1", "textEn": "Someone made me feel uncomfortable with touch", "textUr": "کسی نے مجھے لمس سے بے چین کیا", "quality": "best", "dimension": "communication", "nextStepId": "s1_c" },
        { "id": "b2", "textEn": "Nothing happened", "textUr": "کچھ نہیں ہوا", "quality": "poor", "dimension": "communication", "nextStepId": "s1_c",
          "coachingEn": "It's okay if it's hard to say. Buddy is here and won't judge you.", "coachingUr": "بتانا مشکل ہو تو کوئی بات نہیں۔ بڈی آپ کو کبھی برا نہیں کہے گا۔" },
        { "id": "b3", "textEn": "I don't know how to say it", "textUr": "مجھے بتانا نہیں آ رہا", "quality": "okay", "dimension": "communication", "nextStepId": "s1_c",
          "coachingEn": "That's okay. Even a few words like 'I felt uncomfortable' is enough.", "coachingUr": "کوئی بات نہیں۔ 'مجھے بے چینی ہوئی' کہنا بھی کافی ہے۔" }
      ] },
    { "id": "s1_c", "speaker": "guide", "emotion": "friendly", "background": "bg_home",
      "textEn": "Thank you for telling me. That was not okay, and it is NOT your fault. Your body belongs to you. What should you do first?",
      "textUr": "بتانے کا شکریہ۔ یہ ٹھیک نہیں تھا اور اس میں آپ کی کوئی غلطی نہیں۔ آپ کا جسم آپ کا ہے۔ سب سے پہلے کیا کرنا چاہیے؟",
      "type": "mcq",
      "choices": [
        { "id": "c1", "textEn": "Tell a trusted adult (parent, teacher)", "textUr": "کسی قابلِ اعتماد بڑے کو بتاؤ", "quality": "best", "dimension": "resilience", "nextStepId": "s1_d" },
        { "id": "c2", "textEn": "Keep it a secret", "textUr": "راز رکھو", "quality": "poor", "dimension": "resilience", "nextStepId": "s1_d",
          "coachingEn": "Unsafe secrets should never be kept. Grown-ups who care will always want to know.", "coachingUr": "غیر محفوظ راز کبھی نہیں رکھنا چاہیے۔ جو بڑے آپ سے پیار کرتے ہیں وہ ضرور جاننا چاہیں گے۔" },
        { "id": "c3", "textEn": "Tell only a friend", "textUr": "صرف دوست کو بتاؤ", "quality": "okay", "dimension": "resilience", "nextStepId": "s1_d",
          "coachingEn": "Friends can listen, but a trusted adult can actually keep you safe.", "coachingUr": "دوست سن سکتے ہیں مگر قابلِ اعتماد بڑا آپ کو محفوظ رکھ سکتا ہے۔" }
      ] },
    { "id": "s1_d", "speaker": "guide", "emotion": "friendly", "background": "bg_home",
      "textEn": "Great. You found your mom. How will you start the conversation?",
      "textUr": "بہت اچھے۔ آپ کو امی مل گئیں۔ بات کیسے شروع کریں گے؟",
      "type": "mcq",
      "choices": [
        { "id": "d1", "textEn": "'Mom, someone made me feel uncomfortable. I need to tell you something.'", "textUr": "'امی، کسی نے مجھے بے چین کیا۔ مجھے آپ کو کچھ بتانا ہے۔'", "quality": "best", "dimension": "communication", "nextStepId": "s1_end" },
        { "id": "d2", "textEn": "'Never mind, it's nothing.'", "textUr": "'چھوڑیں، کچھ نہیں۔'", "quality": "poor", "dimension": "communication", "nextStepId": "s1_end",
          "coachingEn": "You did the hard part by coming here. Try saying what you feel, even in one sentence.", "coachingUr": "یہاں آنا مشکل حصہ تھا۔ ایک جملے میں ہی سہی، جو محسوس ہوا وہ کہہ دو۔" },
        { "id": "d3", "textEn": "Just cry and hope she understands", "textUr": "بس رو دو", "quality": "okay", "dimension": "communication", "nextStepId": "s1_end",
          "coachingEn": "Crying is okay. Adding a few words helps your mom know how to help.", "coachingUr": "رونا ٹھیک ہے۔ کچھ الفاظ بھی کہو تو امی بہتر مدد کر سکیں گی۔" }
      ] },
    { "id": "s1_end", "speaker": "guide", "emotion": "happy", "background": "bg_home", "type": "debrief",
      "isTerminal": true,
      "textEn": "You were brave. Telling a trusted adult is always the right step. Let's see how you did!",
      "textUr": "آپ بہادر تھے۔ قابلِ اعتماد بڑے کو بتانا ہمیشہ درست ہے۔ دیکھتے ہیں آپ نے کیسا کیا!" }
  ]
}
```

*(Design note: the coaching loop returns to the same step; `nextStepId` is used only when the child ends on the best answer or after retry.)*

### 11.2 Scenarios 2–8 (script format → Cursor converts to JSON in Phase 4)

Each scenario = **5 steps** (1 scene, 1 Guide "what happened", 2–3 action steps, 1 terminal). Each step has 3 choices with tags. Provide EN text; UR fields to be filled in Phase 8.

**S2 — Harassment & Bullying (bg_school) — "The Lunch Bully"** · weights: resilience 0.4, social 0.4, communication 0.2
1. *Scene:* An older student blocks your way and says, "Give me your lunch money or everyone will laugh at you."
   - [BEST] Stay calm, say "Stop. That's not okay," and walk toward a teacher
   - [OK] Give the money quickly to avoid trouble
   - [POOR] Push him back and start a fight
2. *Guide:* "That sounds scary. Thank you for telling me. How are you feeling?" → [BEST] "Upset, but I want to fix it" · [OK] "Scared, I don't know" · [POOR] "It's my fault, I'm weak"
3. *Guide:* "Bullying is never your fault. Who can help you?" → [BEST] Class teacher / counselor · [OK] A classmate only · [POOR] No one, ignore it
4. *Guide:* "What will you say to the teacher?" → [BEST] "A student is threatening me and taking money. It happened today near the canteen." · [OK] "Someone is being mean." · [POOR] "Nothing, forget it."
5. *End.*

**S3 — Stranger Danger (bg_road) — "The Car Ride"** · weights: safety 0.6, communication 0.2, emotional 0.2 · *includes a voice step*
1. *Scene:* You're waiting after school. A stranger in a car says, "Your dad sent me. Hop in, I'll take you home."
   - [BEST] Step back, say "No!" loudly, and walk to a group of people/shop
   - [OK] Ask him his name first
   - [POOR] Go with him because he knows your dad's name
2. *Voice step (mock):* Guide: "Practice saying NO loudly and clearly. Tap the mic and say: *'No! I don't know you. I'm going to my teacher.'*" → mock transcript accepted; tone score shows "Clear and confident ✓" (free users see MCQ fallback: pick the best sentence).
3. *Guide:* "You reached the school gate. Who do you tell?" → [BEST] Guard/teacher, and describe the car · [OK] Wait for parents · [POOR] Tell nobody
4. *Guide:* "Family safety tip: what's a good idea?" → [BEST] Make a family 'secret code word' that only trusted people know · [OK] Memorise number plates · [POOR] Trust anyone who knows your name
5. *End.*

**S4 — Online Safety & Cyberbullying (bg_online) — "The Unknown Chat"** · weights: safety 0.5, resilience 0.2, communication 0.3 · *includes a free-text step (mock)*
1. *Scene:* A stranger on a game chat says, "You're so mature. Send me your photo and don't tell your parents."
   - [BEST] Don't reply, take a screenshot, block and report
   - [OK] Reply "Who are you?"
   - [POOR] Send a photo since he's being nice
2. *Guide:* "It's great that you noticed this. What made it feel unsafe?" → [BEST] He asked for a photo and a secret · [OK] He's a stranger · [POOR] Nothing, I'm just curious
3. *Free text (mock):* "Write a short message to your parent about it." (any text ≥ 5 chars accepted; canned "Great, clear message ✓")
4. *Guide:* "Which of these is safe to share online?" → [BEST] Nothing private: no address, school, photos · [OK] Only my first name · [POOR] My school and location, to make friends
5. *End.*

**S5 — Peer Pressure Resistance (bg_park) — "Just Try It"** · weights: social 0.5, resilience 0.3, communication 0.2 · *includes a drag-to-rank step*
1. *Scene:* Older friends say, "Skip class and come to the abandoned building with us. Don't be a baby."
   - [BEST] "No thanks, I'm going to class"
   - [OK] "Maybe later" (avoids saying no)
   - [POOR] Go along so they don't laugh
2. *Guide:* "Real friends respect your no. How do you feel?" → [BEST] "Proud of standing up" · [OK] "A bit left out" · [POOR] "I should have gone"
3. *Drag-to-rank:* "Order these from safest to least safe": (a) Leave and go to class (b) Ask a teacher for help (c) Go along quietly
4. *Guide:* "They keep pushing. What now?" → [BEST] Repeat "no", leave, and tell a trusted adult · [OK] Ignore them silently · [POOR] Give in
5. *End.*

**S6 — Emotional Regulation (bg_school) — "The Big Feelings"** · weights: emotional 0.6, resilience 0.2, communication 0.2 · *includes a slider step*
1. *Scene:* Someone shouts at you in front of the class. Your heart is racing and your hands are shaking.
   - [BEST] Breathe in slowly (4 seconds), breathe out (4 seconds)
   - [OK] Look down and stay silent
   - [POOR] Shout back louder
2. *Slider:* "How big is the feeling right now? (1 small — 10 huge)" → any value; Guide reacts differently (≤4 calm reply, ≥7 grounding reply).
3. *Guide:* "Let's try grounding: name 3 things you can see." → [BEST] Do it (interactive tap x3) · [OK] Skip · [POOR] "This is silly"
4. *Guide:* "After you feel calmer, what next?" → [BEST] Tell the teacher or a friend how you felt · [OK] Say nothing · [POOR] Hold it in forever
5. *End.*

**S7 — Emergency Response (bg_mall) — "Lost in the Market"** · weights: emotional 0.4, communication 0.4, safety 0.2
1. *Scene:* You look up and can't find your parents in a busy market.
   - [BEST] Stay where you are and look for a shop worker or a police officer
   - [OK] Walk around searching
   - [POOR] Leave with a friendly stranger who offers help
2. *Guide:* "Who are safe adults to ask for help?" → [BEST] Police, shopkeeper with a shop, a mom with children · [OK] Any adult nearby · [POOR] Someone who offers candy
3. *Guide:* "What information will you tell them?" → [BEST] Full name, parents' names, and a phone number · [OK] Only your name · [POOR] Nothing
4. *Guide:* "While you wait, what helps?" → [BEST] Stay put, breathe slowly, and keep talking to the helper · [OK] Cry silently · [POOR] Run around
5. *End.*

**S8 — Home & Family Safety (bg_home) — "The Home Secret"** · weights: safety 0.4, resilience 0.3, communication 0.3
1. *Scene:* Someone in the household keeps making you feel unsafe and says, "Don't tell anyone or you'll be in trouble."
   - [BEST] Remember that unsafe secrets shouldn't be kept, and plan to tell a trusted adult
   - [OK] Hope it stops on its own
   - [POOR] Stay quiet forever
2. *Guide:* "That sounds really hard. You're very brave for even thinking about it. Who do you trust most?" → [BEST] Mom/Dad/aunt/teacher/counselor · [OK] A friend only · [POOR] Nobody
3. *Guide:* "If the person you trust doesn't listen, what next?" → [BEST] Tell another trusted adult, and use the child helpline · [OK] Wait and try later · [POOR] Give up
4. *Guide:* "What should you remember?" → [BEST] It's never my fault and help is available · [OK] Maybe I'm exaggerating · [POOR] I'll get in trouble
5. *End.* (Guide shows the dummy helpline card, see §13.)

---

## 12. Localization (English + Urdu)

- All strings in `en.dart` / `ur.dart`; scenario JSON holds `textEn` / `textUr`.
- **English default; Urdu is a premium toggle.** Urdu mode → RTL layout (use `Directionality` + `TextDirection.rtl` + Noto Nastaliq Urdu font).
- Optional Roman Urdu toggle (dummy: a simple third text field `textRu` on scenario 1 only).
- Test every screen for RTL overflow.

---

## 13. Safety & Ethics Requirements

- **"Need help now?"** button on Scenario Intro & Debrief: opens a card with a **dummy child-helpline placeholder** ("Demo number: 0000-000"). *Before the FYP demo, replace with real, verified local helpline numbers (confirm with your supervisor).*
- No graphic descriptions ever. Scenes imply, never depict.
- Adult "threatening" NPCs are stern, not horror.
- Debrief always ends on encouragement.
- Add a small line for parents: "Best played together with a parent or guardian."
- All data is dummy/local; show a "Demo mode" ribbon somewhere unobtrusive.

---

## 14. BUILD PHASES

Each phase ends with an **acceptance checklist**. Only move on when all boxes pass. Each phase has a ready-to-paste **Cursor prompt**.

### Phase 1 — Foundation: Project, Theme, Router, Models

**Tasks**
- Create Flutter project, add packages, set folders per §5.
- `theme.dart` with palette, fonts, button styles (§4).
- `go_router` with placeholder routes for all screens in §10.
- All models from §6 (with `fromJson`), abstract repositories.
- Splash screen.

**Acceptance**
- [ ] App runs; Splash → placeholder Login.
- [ ] Theme applied consistently, `flutter analyze` clean.
- [ ] Models compile; a unit test parses the s1 JSON.

**Cursor prompt:** *"Read SPEC.md. Do Phase 1 only: create project structure, theme, go_router with placeholders, models with fromJson, and Splash screen. Follow the Cursor Rules."*

---

### Phase 2 — Auth (Dummy) & Character Select

**Tasks**
- Login/Register tabs, OTP screen (1234), child name + age (6–15) form.
- `AuthProvider` + `DummyUserRepository`, persistence via shared_preferences.
- Character select (boy/girl), one-time, saved to profile.
- Route guard: not logged in → auth; no avatar → character select; else Home.

**Acceptance**
- [ ] Register → OTP → child details → avatar → Home placeholder.
- [ ] Restart app keeps login + avatar.
- [ ] Logout works.

**Cursor prompt:** *"Do Phase 2 only from SPEC.md: dummy auth, OTP 1234, child profile, character select, persistence, and route guards."*

---

### Phase 3 — Home, Scenario Intro, Lock System

**Tasks**
- Load scenario list from `DummyScenarioRepository` (assets JSON).
- Home with 8 cards, locks for premium, coin chip, streak placeholder, bottom nav.
- Scenario Intro screen with "Need help now?" card (§13).
- Tapping locked card → temporary Paywall placeholder.
- Only **s1 JSON** required to exist; others can be stub files (title + isFree) until Phase 8.

**Acceptance**
- [ ] 8 cards render; only Scenario 1 opens.
- [ ] Locked cards show overlay + route to paywall placeholder.
- [ ] Intro screen opens with Start button.

**Cursor prompt:** *"Do Phase 3 only: Home grid, lock overlay, Scenario Intro, help card, bottom nav, scenario repository loading from assets."*

---

### Phase 4 — Simulation Engine + Screen (MCQ) ⭐ Core

**Tasks**
- `SimulationProvider` state machine per §7 (decisions log, coaching loop, retry rules).
- Simulation screen: `scene_background`, `npc_sprite` (emoji fallback + expression swap), `dialogue_box` (typewriter), `choice_button` (slide-in), progress dots.
- Coaching UI (Guide bubble, gentle color; retried option greyed).
- Persist session after each decision; Resume on Home.
- Complete **Scenario 1** end-to-end, then convert S2–S8 scripts (§11.2) into JSON.

**Acceptance**
- [ ] S1 plays start to end with best/okay/poor paths.
- [ ] Wrong choice → coaching → same question with option greyed.
- [ ] Close and reopen mid-scenario → Resume works.
- [ ] All 8 scenarios load and finish (MCQ only for now).

**Cursor prompt:** *"Do Phase 4 only: implement SimulationProvider state machine and the Simulation screen with MCQ, coaching loop, and session persistence. Play Scenario 1 fully, then convert scenarios 2-8 from the SPEC scripts to JSON (English only)."*

---

### Phase 5 — Scoring, Coins, Debrief, Replay

**Tasks**
- Scoring per §8 (`SisResult`), outcome, coins, bonuses, badges, streak.
- `CoinsProvider`, `ProgressProvider` (best scores, history), persistence.
- Debrief screen: confetti, SIS ring, 5 bars, coins breakdown, badges, best-path recap, Replay.
- Improvement bonus on replay.
- Free-tier debrief shows overall only (+ unlock hint).

**Acceptance**
- [ ] Perfect run = 100 and correct coins; poor run < 50 with 20 effort coins.
- [ ] Replay with higher score grants improvement bonus.
- [ ] Coins & best scores survive app restart.

**Cursor prompt:** *"Do Phase 5 only: scoring engine, coins/bonuses/badges, Debrief screen, replay + improvement bonus, persistence. Use the exact numbers in SPEC §8."*

---

### Phase 6 — Paywall, Premium Gating, Hints, Profile

**Tasks**
- Parent gate (maths question), Paywall (monthly/annual dummy), Subscribe → `active`.
- Enforce §9 across the app (locks, debrief depth, score history, replay).
- Hint system: 3 per scenario, 10 coins each, greys a poor option.
- Profile screen: coins, streak, badges, history, subscription, dummy billing list, restore purchase toast.
- Settings **Demo Panel**: switch free/active/expired, reset data, add coins.

**Acceptance**
- [ ] Free vs Premium behaviour matches §9 table.
- [ ] Hints deduct coins, max 3, disabled when coins < 10.
- [ ] Demo Panel can reset the whole app for a clean demo.

**Cursor prompt:** *"Do Phase 6 only: parent gate, paywall, premium gating per SPEC §9, hints, profile, and the Demo Panel."*

---

### Phase 7 — Extra Interaction Types (Voice Mock, Free Text, Slider, Drag-Rank)

**Tasks**
- `voice` (mock mic animation + canned transcript + tone result; free-tier MCQ fallback).
- `freeText` (canned keyword check), `slider`, `dragRank` (ReorderableListView).
- Wire into S3, S4, S5, S6 as per §11.2. Each contributes to SIS dimensions.

**Acceptance**
- [ ] S3 voice, S4 free text, S5 drag-rank, S6 slider all work and affect score.
- [ ] Free users see the MCQ fallback instead of voice.

**Cursor prompt:** *"Do Phase 7 only: add voice (mock), freeText, slider, and dragRank interaction types and wire them into scenarios 3-6."*

---

### Phase 8 — Urdu/RTL, Localization, Polish

**Tasks**
- Complete `textUr` for all scenarios, `ur.dart` UI strings, RTL layouts, Urdu font.
- Language toggle (premium), optional Roman Urdu on S1.
- Animations (page transitions, choice slide-in, badge pop), sounds toggle (no real audio required).
- Empty states, error fallbacks (missing asset → emoji), accessibility (contrast, tap size).

**Acceptance**
- [ ] Every screen works in RTL with no overflow.
- [ ] No hard-coded UI text remains.
- [ ] App looks polished on small and large phones.

**Cursor prompt:** *"Do Phase 8 only: full Urdu and RTL support, localization cleanup, animations, empty states, accessibility polish."*

---

### Phase 9 — Demo Hardening & Backend-Ready Cleanup

**Tasks**
- Guided **demo script** button (jumps to a good demo path).
- Unit tests: scoring, coins, state machine. A couple of widget tests.
- Document `ApiRepository` stubs (endpoints from proposal: auth, subscription status, session, AI next-step JSON `{npcText, choices[3], sceneType, emotion}`) so backend/AI can be plugged in later.
- README with run instructions and demo walkthrough.

**Acceptance**
- [ ] `flutter test` passes; `flutter analyze` clean.
- [ ] Full demo (register → play S1 → debrief → paywall → Urdu) runs in under 5 minutes.
- [ ] Swapping `DummyScenarioRepository` for a stub `ApiRepository` needs no UI changes.

**Cursor prompt:** *"Do Phase 9 only: tests for scoring/coins/engine, demo shortcuts, ApiRepository stubs and README."*

---

## 15. Future (NOT in this build)

Real AI via n8n (multi-agent NPCs + Guide + supervisor agent), Python Flask microservice, .NET Web API + SQL Server, Google Speech-to-Text, Stripe payments, FCM push, Blazor admin panel, expert-reviewed content, testing with children under parental consent.

The `AI next-step` contract to keep in mind now (so dummy → real is easy):
```json
{ "npcText": "…", "choices": ["…","…","…"], "sceneType": "…", "emotion": "friendly|neutral|threatening" }
```

---

## 16. Golden Rules (repeat to Cursor if it drifts)

1. One phase at a time. 2. Dummy data only. 3. Gentle tone, no scary visuals. 4. Wrong = coaching. 5. No hard-coded strings. 6. Everything behind repositories. 7. Keep the app runnable after every phase.
