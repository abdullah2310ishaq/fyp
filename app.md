# SmartSpend — master plan

Android-first, offline-first. Cursor rules: `.cursor/rules/smartspend.mdc`.  
UI: **Material 3 + shadcn_ui + fossui**, one quiet theme, **light + dark** (system default).  
l10n: **`en` + `ur` (RTL)** from day one (`gen-l10n`). No hardcoded user-facing copy.

People do **not** want to become accountants. Table stakes (income, expenses, categories, charts, classic budgets) are **plumbing**. The product is **situation**: paisa bina dimagh khapaye samajh aaye.

Update this file when a product decision changes. Nothing below is “deleted”; later phases are still in scope.

---

## 1. Vision & the loophole

### 1.1 What almost every app does

Record a form → dump charts → user decides. AI chat is often online-only and generic.

### 1.2 What people actually want

> “Bhai petrol is month kitna gaya? Last months se compare karke bata, aur bata kaise kam karun?”

> “Where the hell did my money go?” — sentences, not 10 pies.

> “How much can I safely spend **today**?”

**Signature loop:** talk / one line → save or answer. App also **speaks first** (insights). Local life: petrol, mobile load, rickshaw, raashan, salary on the 1st or 15th. Roman Urdu + English in notes/chat.

**Non-goal:** prettier Mint/Wallet. Bank linking is **not** v1.

**Users:** individuals / small families in PK / IN / SEA.

---

## 2. Ranked: people use vs sounds cool

| People actually open the app | Sounds cool, often unused |
|---|---|
| Safe to spend + days to payday | 8 pie charts on Home |
| Play money left (no category nag) | 40-category budget police |
| What changed this month (story) | Heatmaps as the main UI |
| One picture: bank + cash + JazzCash + card | Fake “Open Banking” without APIs |
| One-line / later voice log | Perfect OCR on week one |
| ATM → pocket cash leftover | SMS scrape every bank |
| Can I afford / wait 3 months | Family sharing v1 |
| Recurring + “looks like Netflix” | Unused-sub without usage APIs |

**North-star on Home:**

> How much can I safely spend today — without wrecking rent, bills, or the savings I already promised myself?

---

## 3. Full use-case catalogue (all still in the product)

Nothing here is dropped. Phase number = when we **ship** it, not whether it exists.

### 3.1 Conversational + voice (talk first)

- Type/speak: `Petrol 1200 PSO aaj` → classify → confirm → save.  
- Ask: `Is month petrol kitna hua?` → figure + vs last months + one cut suggestion.  
- Single-line bar: `dinner with friends 4500 card` → amount, Food, tag Friends, mode Card. Zero extra taps when parse is confident.  
- Full form always available. Voice = mic permission only when used. Typing heuristics Phase 1; Gemini Phase 3; voice Phase 4.

### 3.2 Proactive insights

App speaks on Home, not only in chat:

> Is month petrol already 38% above last 3 months average. 2 din carpool ≈ Rs 1,800.

Offline / no API key → **same idea from on-device rules**. Model only if user opted in + key set.

### 3.3 “Where the hell did my money go?” (month-end narrative)

Not charts as the answer:

> You earned Rs 180,000  
> Fixed: Rs 72,000  
> Food: Rs 31,400 ↑ 28%  
> Shopping: Rs 18,200 ↑ 41%  
> You spent Rs 22,000 more than your usual pattern.

Phase 1: shorter rule-based **What changed**. Phase 3: full narrative (rules + optional AI wording).

### 3.4 Subscription / recurring detector

User does not have to add Netflix by hand.

> You paid Rs 1,499 to Netflix 3 months consecutively. This looks like a subscription.

> Unused? No related logged spend in 47 days.

Honest limit: we only know **logged** activity, not whether they opened Netflix. Phase 2.

### 3.5 “Can I afford this?”

User enters e.g. iPhone Rs 350,000:

> This would consume ~2.3 months of discretionary savings.  
> or: Affordable without touching emergency/savings floor.

**Buy now vs wait 3 months:**

> Buy now → savings Rs 420k · Wait 3 months → est. Rs 570k  

Math is local (runway + buckets). AI optional for tone. Phase 3.

### 3.6 Salary-day intelligence / daily burn

Payday set (e.g. 25th):

> 18 days until payday. Safe daily limit: **Rs 2,140**.  
> You’re spending 23% faster than usual this month.

Overspend today → **tomorrow’s daily cap recomputes**. Phase 1 (core), notifications Phase 2.

### 3.7 Safe to spend (hero, not balance)

Balance Rs 94,500 is misleading.

```
Current net (wallets)
- remaining locked (rent/bills/EMI this cycle)
- savings set-aside
- upcoming known bills / planned
= Safe to spend / play money
```

Phase 1 hero number.

### 3.8 Bill prediction

Learned rent 40k, internet 4k, electric 8–15k, mobile 2k:

> Estimated upcoming bills: Rs 61,000 between Sep 1–7.  
> After those, ~Rs 42,000 available.

Phase 2 (needs recurrences).

### 3.9 “What changed this month?” (killer Home card)

> Food **+32%** · Transport **+18%** · Shopping **+Rs 7,200** · Savings **-12%**  
> Biggest reason: 6 unusually large shopping transactions.

Financial storytelling. Tiny chart optional underneath. Phase 1 rules.

### 3.10 Cash-flow calendar

Days with expected hits:

```
25 Aug  +180,000 salary
27 Aug  -40,000 rent
30 Aug  -12,000 bills
05 Sep  -25,000 card
10 Sep  -15,000 planned
```

> Projected balance on Sep 10: **Rs 88,400**

Phase 4 as full calendar UI; Phase 1–2 can use the same numbers inside Safe-to-spend without a month grid.

### 3.11 Pakistan: one financial picture

Fragmented: cash + bank + Easypaisa/JazzCash + cards.

```
Bank             82,400
Cash             14,000
JazzCash          7,600
Credit Card     -18,500
-----------------------
Net available     85,500
```

**Transfer ≠ expense** (Bank → JazzCash). Phase 1.

### 3.12 Guilt-free buckets vs strict budgets

Classic “Entertainment Rs 10,000” → guilt → user quits the app.

**Three numbers only:**

- **Locked** — rent, bills, fees, EMI  
- **Savings target** — % or fixed of income  
- **Play money** — jo marzi, no category nag until it hits 0  

Classic per-category budgets still exist later (typeId reserved) for power users — **not** the mass-market Home. Phase 1 = buckets.

### 3.13 Cash vs digital (“paisa kahan gaya?”)

ATM Rs 20,000 → 3 days later pocket Rs 2,000.

**Cash leftover prompt** (evening after cash/ATM txn): “Pocket mein kitna cash?” User enters remaining; difference → Uncategorized daily cash burn. Phase 2 (notifications).

### 3.14 Smart receipt / screenshot OCR

Share sheet: Daraz / Foodpanda / Careem / paper photo → amount, vendor, date. On-device if feasible. Phase 4. Camera permission only then.

### 3.15 Planned purchases

Future-dated / planned rows so Safe-to-spend and calendar stay honest. Phase 1 field; richer UI Phase 4.

### 3.16 Don’t punish skip days

Missed logging ≠ shame wall. Optional rough cash-burn, not a lecture.

### 3.17 Duplicate detection, soft-delete, undo, photos

Same amount + payee + near timestamp. Soft-delete + undo. Receipt path on txn for later OCR. Always in model; camera Phase 4.

### 3.18 Reports & export

Daily/weekly/monthly/custom, category breakdown, trends, period-over-period, PDF/CSV/Excel, heatmap. Phase 1 = simple month + story; export/heatmap Phase 4.
    
### 3.19 Notifications

Budget/bucket thresholds, daily/weekly digest, “no log in 3 days” (gentle), AI suggestion of the day, quiet hours, cash leftover, bill upcoming. Phase 2+.

### 3.20 Settings (full list)

Theme light/dark/system, accent, language, currency & number format, payday, savings %, AI provider + key (secure storage), backup/restore, biometric lock, data wipe, privacy statement. Phase 1 = theme, locale, currency, payday, savings, privacy. Rest phased.

### 3.21 Auth & sync (optional)

Anonymous / Google / email — only if cloud backup. No forced login. Apple Sign-In only if we ship iOS + social login. Firestore opt-in. **Not Phase 1.**

### 3.22 Multi-currency

Each txn stores `currencyCode`; optional `fxRateAtEntry`. Base currency in Settings. Don’t silently rewrite history. Phase 4. Default **PKR**.

### 3.23 Extra (keep, don’t build first)

- Credit card wallet + due date, not mixed into play money as “negative cash.”  
- SMS bank scrape — skip for now (privacy + OEM).  
- True “unused Netflix” without usage APIs — detector is payee-repeat only.  
- Family sharing, bank-statement import — later monetization, not v1.

---

## 4. MVP we implement first (Phase 1)

Ship these **together** (not “tracker then maybe insights”):

1. Safe to spend (hero)  
2. Payday runway + daily cap (recompute)  
3. Three buckets (Locked / Savings / Play)  
4. PK wallets + transfers  
5. What-changed story  
6. Line-add + form  
7. l10n en/ur + light/dark theme  

Classic charts sit **under** the story. No Gemini, no Firebase, no OCR, no voice.

---

## 5. Platform

| Now | Later |
|---|---|
| Android phones | iOS, web, desktop |
| Play internal / APK | App Store, Apple Sign-In, TestFlight |
| Adaptive Android icon + splash | iOS assets |

Permissions only when a feature needs them.

---

## 6. Tech stack

| Layer | Choice |
|---|---|
| Flutter | Latest stable, Android |
| State | Cubit (`flutter_bloc`) |
| Layout | flutter_screenutil |
| UI | Material 3 + shadcn_ui + fossui |
| i18n | flutter_localizations, ARB `en` / `ur` |
| Local DB | Hive (typed boxes) |
| Flags | shared_preferences |
| Secrets | flutter_secure_storage |
| Charts | fl_chart (pre-aggregated) |
| Nav | GoRouter + shell |
| DI | get_it + injectable |
| Auth | Firebase Auth — Phase 2+ if backup |
| Sync | Firestore — opt-in later |
| AI | Gemini primary; OpenAI / Groq optional; user key |
| Notify | flutter_local_notifications (+ FCM later) |
| Crash | Crashlytics when Firebase exists |
| Encryption | AES-256 local backup (`encrypt`) Phase 4 |
| Other | intl, uuid, path_provider, connectivity_plus, permission_handler, image_picker, speech_to_text, local_auth — add when the phase needs them |

---

## 7. Theme

- One accent, quiet surfaces, clear type. Dark = first-class (same layout).  
- Safe-to-spend = largest number on Home.  
- fossui for buttons, fields, selects, toggles, alerts, toasts, dialogs.  
- shadcn for `ShadApp` theme + payday `ShadCalendar`. Material for shell, FAB, charts.

---

## 8. Information architecture

```
Home        Safe to spend, runway, buckets, what-changed, wallets strip, recent
Activity    Transaction list, filters, accounts
Add         FAB: line field + form (transfer / expense / income)
Insights    Month story + breakdown; Phase 3 = chat
Settings    Theme, language, currency, payday, privacy; later AI key, backup, lock
```

---

## 9. Development phases (complete)

**Phase 1 — Android offline core (next)**  
Splash, onboarding (language, PKR, income optional, payday, savings %, seed wallets), Hive, CRUD, Home hero metrics, line-add heuristics, Settings shell, seed/wipe demo data, CI later (analyze/format/test).

**Phase 2 — Habits + polish**  
Recurring + bill prediction, subscription detector, cash leftover notifications, local notifications, biometric + PIN, onboarding polish, logger, Crashlytics if Firebase added. Auth only with backup.

**Phase 3 — Conversation**  
`AIRepository`, system prompt, chat, NL log confirm sheet, insight cards, Can I afford + wait-3-months, full Where-did-money-go, prompt/response local QA log (no secrets).

**Phase 4 — Advanced**  
Voice, OCR/share sheet, cash-flow calendar UI, CSV/PDF/Excel, heatmap, classic category budgets optional, encrypted backup, FX, optional Firestore, iOS if ever.

**Phase 5 — Launch polish**  
Edge cases, performance vs targets, animation, store listing, Data Safety. Hindi locale optional.

---

## 10. Architecture

```
lib/
  core/           theme, constants, failures, logger, network
  data/           models, datasources (Hive, prefs, later Firebase/AI), repo impls
  domain/         entities, repo interfaces, usecases (safe-to-spend, forecast, parse)
  presentation/   cubits/<feature>/ + state files, screens, widgets
  routes/
  l10n/           app_en.arb, app_ur.arb
  main.dart
```

- `presentation/` never imports `data/`.  
- One Cubit per feature. Repos own Hive/Firebase/AI.  
- Cubit states: Equatable, **every** field in `props`.  
- Failures: Loading / Loaded / Error. `Either<Failure, T>` at repo boundary.  
- get_it + injectable. No `Repository()` inline in widgets.

---

## 11. Hive models & migrations

Never reuse `@HiveField(n)`. Only append. `AppSchemaVersion` box; sequential idempotent `migrateV1toV2()`; fail → export + warn, don’t crash. Deprecated fields stay unused, not renumbered.

### Transaction `typeId: 0`

| Field | Index | Notes |
|---|---|---|
| id | 0 | |
| amount | 1 | |
| type | 2 | `income` \| `expense` \| `transfer` |
| categoryId | 3 | null on transfer |
| subCategory | 4 | optional |
| note | 5 | |
| date | 6 | UTC |
| paymentMethod | 7 | or infer from account |
| receiptPath | 8 | Phase 4 |
| isRecurring | 9 | |
| recurringRule | 10 | |
| isDeleted | 11 | soft-delete |
| currencyCode | 12 | ISO, e.g. PKR |
| fxRateAtEntry | 13 | Phase 4 |
| fromAccountId | 14 | |
| toAccountId | 15 | transfer dest |
| isLocked | 16 | counts as fixed/bucket locked |
| isPlanned | 17 | |
| payee | 18 | for sub detector |

### Category `typeId: 1`

id, nameKey (l10n) or custom name, iconKey, colorValue, isCustom, bucket (`locked` | `play` | `ignore`).

### Budget `typeId: 2`

Reserved for optional classic budgets: id, categoryId?, limit, period, startDate, endDate?, carryOver. **MVP uses buckets + savings % instead.**

### AIInsightCache `typeId: 3`

id, prompt, response, generatedAt. Phase 3.

### AppSchemaVersion `typeId: 4`

int version.

### Account `typeId: 5`

id, name, kind (`cash` | `bank` | `jazzcash` | `easypaisa` | `card` | `other`), display order. **Source of truth:** txn stream + opening balance field (append `openingBalance` if needed — do not reuse indexes).

**Box names:** constants in `core/constants/`. Bulk writes: `putAll()`.

**Prefs:** theme, locale, currency, onboardingCompleted, salaryPayday, savingsPercent, incomeEstimate, aiEnabled, aiProvider, lastFilterUsed, lastSyncAt (later).

---

## 12. Safe-to-spend & forecast (domain)

Compute **outside** `build()`. Cubit holds a DTO:

- `safeToSpend`, `playMoney`, `lockedRemaining`, `savingsSetAside`  
- `dailyCap`, `daysToPayday`, `spendPaceVsUsual`  
- `walletRows`, `netAvailable`  
- `whatChanged` (category deltas, spike reason)  
- later: `upcomingBills`, `projectedByDate`

Inputs: accounts, txns, payday, savings rule, recurrences, planned txns.

---

## 13. AI (Phase 3) — data flow + prompt

1. Aggregate last 30–90 days (category totals, deltas, budgets/buckets, payday, wallets). **Never** send raw ledger.  
2. Prompt = system + summary JSON + user message.  
3. `AIRepository` — Gemini default; swap OpenAI/Groq in Settings only.  
4. Cache in Hive. Timeout ~15s → rule-based path.  
5. Keys: secure storage only. Never prefs, never logs.

**Draft system prompt:**

```
You are SmartSpend — a sharp friend, not a bank report. Use only the JSON
summary below. Never invent numbers. Match English, Urdu, or Roman Urdu
as the user wrote.

Local context: PKR, petrol/load/rickshaw/raashan, salary payday if present.
Advice fits that life (carpool, load packs, rickshaw vs bike) — not US
credit-card / 401k tips.

- Factual question → exact figure + vs last period or last 3 months.
- Advice / proactive card → one specific saving idea tied to a real number.
- Natural-language log → JSON only:
  { "action": "log_expense", "amount": number, "category": string,
    "note": string, "date": "YYYY-MM-DD", "confidence": number }
- Afford / wait-3-months → use summary cash-flow fields only.
- Ambiguous → one short question, no guess.
- Stay on personal finance for this app.

Summary (last {N} days):
{aggregated_json_summary}

User: {user_message}
```

Iterate against real transcripts in Phase 3. Log prompt/response **locally** in debug, never amounts in Crashlytics.

---

## 14. Edge cases

| Scenario | Handling |
|---|---|
| No internet | Full app; AI → local rules |
| Bad/expired API key | Inline error + Settings |
| Rate limit | Cache + degrade |
| Empty first week | Guided first expense; Safe-to-spend explains missing income |
| Overspend / negative play | Calm warning, not guilt wall |
| Currency change | History keeps original code + rate |
| Huge txn volume | Pagination, indexed Hive, background aggregates |
| App killed mid-AI | Cancel, retry, no stuck spinner |
| Category deleted | Uncategorized or pick replacement |
| Timezone | Store UTC, show local |
| Biometric fail | PIN fallback |
| Storage full | Warn, export, cleanup |
| Multi-device sync | Last-write-wins first; merge later |
| Transfer mis-tagged as expense | Type `transfer` required; detect same-day opposite wallets |
| Privacy | On-device unless backup or AI query (summary only) |

---

## 15. Security

- API keys: flutter_secure_storage.  
- Local backup: AES-256, passphrase/biometric-derived key, salt stored not the key.  
- PIN: salted hash.  
- Firestore: `/users/{uid}/...` only.  
- HTTPS only; no cleartext in Android network config.  
- Release logs: no amounts, notes, keys.

---

## 16. Performance targets

- Cold start to Home: &lt; 2s mid-range.  
- 10k+ txns dashboard: &lt; 300ms via pre-aggregation.  
- Lists 60fps: `ListView.builder` + `ValueKey(id)`.  
- AI: loading after 150ms, hard timeout 15s.  
- Download size: watch shadcn + Firebase + charts (~40MB goal).

---

## 17. Observability & CI

- Logger package; no `print` in prod.  
- Crashlytics + Analytics (feature use only, not txn content) when Firebase exists.  
- In-app feedback with redacted logs.  
- CI later: analyze, `dart format --set-exit-if-changed`, test on PR. App Distribution on main. Secrets in CI, never git.

---

## 18. Testing

- Every Cubit: `bloc_test` initial / success / failure. Forecast cubit tests Safe-to-spend math.  
- Repos: mocked Hive/Firebase. No real Firebase in tests.  
- Widget smoke: Home, add form, later chat.  
- Goldens light/dark when UI is stable.  
- Manual: offline, payday, transfer vs expense, locale UR RTL, theme.

---

## 19. Store (when we ship)

**Android:** Data Safety, privacy policy URL, permission justifications, light+dark screenshots, adaptive icon, low-end device, crash-free on testers.

**iOS later:** nutrition label, Apple Sign-In if any other social login.

---

## 20. Privacy copy (in-app Phase 1)

On-device by default. AI/backup opt-in. No ledger in analytics.

---

## 21. Monetization (optional, not Phase 1)

Cloud sync, premium models, family sharing, statement import.

---

## 22. Next (implementation)

1. Replace assignment app with Phase 1 scaffold.  
2. l10n + theme + Hive accounts/txns.  
3. Home metrics + what-changed + line-add.  
4. Stop before Gemini/Firebase until Safe-to-spend is right on a device.

---

## 23. Feature checklist (nothing “cut”)

- [ ] Onboarding (lang, currency, income, payday, savings, wallets, permissions lazy)  
- [ ] Form add/edit, line-add, later voice, later OCR  
- [ ] Categories local defaults + custom  
- [ ] Accounts + transfers  
- [ ] Soft-delete, undo, duplicates  
- [ ] Recurring, bill prediction, subscription detector, cash leftover  
- [ ] Buckets + optional classic budgets  
- [ ] Safe to spend, runway, what-changed, where-did-money-go, can-I-afford, calendar  
- [ ] Charts, reports, export, heatmap  
- [ ] AI chat + cache + offline rules  
- [ ] Notifications, quiet hours, biometric  
- [ ] Backup encrypt, Firebase optional  
- [ ] FX, iOS, Hindi, family, SMS scrape (explicitly last / skip SMS)  
