import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeiq/data/expanded_scenarios.dart';
import 'package:lifeiq/core/scenario_validator.dart';
import 'package:lifeiq/models/story.dart';
import 'package:lifeiq/screens/home_screen.dart';
import 'package:lifeiq/screens/onboarding_screens.dart';
import 'package:lifeiq/state/app_state.dart';
import 'package:lifeiq/widgets/life_widgets.dart';
import 'package:lifeiq/widgets/body_safety_activity.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('catalogue contains eight terminating bilingual stories', () {
    expect(expandedScenarios, hasLength(8));
    for (final story in expandedScenarios) {
      expect(story.title.en, isNotEmpty);
      expect(story.title.ur, isNotEmpty);
      expect(story.steps, isNotEmpty);
      expect(story.steps.last.kind, StoryKind.terminal);
      expect(
        story.steps.where((step) => step.kind == StoryKind.choice),
        isNotEmpty,
      );
    }
  });

  test('complete catalogue passes schema and safety validation', () {
    expect(validateCatalogue(expandedScenarios), isEmpty);
  });

  test('expanded source scene inventory is complete', () {
    expect(
      {for (final story in expandedScenarios) story.id: story.steps.length},
      {
        's1': 13,
        's2': 13,
        's3': 13,
        's4': 14,
        's5': 9,
        's6': 9,
        's7': 9,
        's8': 10,
      },
    );
    expect(
      expandedScenarios[3].steps.any(
        (step) => step.kind == StoryKind.multiChoice,
      ),
      isTrue,
    );
    expect(
      expandedScenarios[1].steps.any((step) => step.kind == StoryKind.ranking),
      isTrue,
    );
    expect(
      expandedScenarios[5].steps.any(
        (step) => step.kind == StoryKind.grounding,
      ),
      isTrue,
    );
    expect(
      expandedScenarios
          .expand((story) => story.steps)
          .where((step) => step.kind == StoryKind.mockVoice),
      hasLength(8),
    );
  });

  test('only story one is free', () {
    expect(
      expandedScenarios.where((story) => story.isFree).map((story) => story.id),
      ['s1'],
    );
  });

  test('scenario one has generated artwork mapped to every step', () {
    final story = expandedScenarios.firstWhere((item) => item.id == 's1');
    expect(story.steps.every((step) => step.imageAsset != null), isTrue);
    expect(story.steps.map((step) => step.imageAsset).toSet(), hasLength(11));
    expect(story.coverImageAsset, isNotNull);
  });

  test('every scenario one illustration is bundled and non-empty', () async {
    final story = expandedScenarios.firstWhere((item) => item.id == 's1');
    final assets = {
      ...story.steps.map((step) => step.imageAsset!),
      story.coverImageAsset!,
      'assets/scenarios/s1/s1_body_map.png',
    };

    for (final asset in assets) {
      final data = await rootBundle.load(asset);
      expect(data.lengthInBytes, greaterThan(0), reason: asset);
    }
  });

  test('scenario two has generated artwork mapped to every step', () {
    final story = expandedScenarios.firstWhere((item) => item.id == 's2');
    expect(story.steps.every((step) => step.imageAsset != null), isTrue);
    expect(story.steps.map((step) => step.imageAsset).toSet(), hasLength(11));
    expect(story.coverImageAsset, isNotNull);
  });

  test('every scenario two illustration is bundled and non-empty', () async {
    final story = expandedScenarios.firstWhere((item) => item.id == 's2');
    final assets = {
      ...story.steps.map((step) => step.imageAsset!),
      story.coverImageAsset!,
    };

    for (final asset in assets) {
      final data = await rootBundle.load(asset);
      expect(data.lengthInBytes, greaterThan(0), reason: asset);
    }
  });

  test('scenario three has generated artwork mapped to every step', () {
    final story = expandedScenarios.firstWhere((item) => item.id == 's3');
    expect(story.steps.every((step) => step.imageAsset != null), isTrue);
    expect(story.steps.map((step) => step.imageAsset).toSet(), hasLength(12));
    expect(story.coverImageAsset, isNotNull);
  });

  test('every scenario three illustration is bundled and non-empty', () async {
    final story = expandedScenarios.firstWhere((item) => item.id == 's3');
    final assets = {
      ...story.steps.map((step) => step.imageAsset!),
      story.coverImageAsset!,
    };

    for (final asset in assets) {
      final data = await rootBundle.load(asset);
      expect(data.lengthInBytes, greaterThan(0), reason: asset);
    }
  });

  test('scenario four has generated artwork mapped to every step', () {
    final story = expandedScenarios.firstWhere((item) => item.id == 's4');
    expect(story.steps.every((step) => step.imageAsset != null), isTrue);
    expect(story.steps.map((step) => step.imageAsset).toSet(), hasLength(13));
    expect(story.coverImageAsset, isNotNull);
  });

  test('every scenario four illustration is bundled and non-empty', () async {
    final story = expandedScenarios.firstWhere((item) => item.id == 's4');
    final assets = {
      ...story.steps.map((step) => step.imageAsset!),
      story.coverImageAsset!,
    };

    for (final asset in assets) {
      final data = await rootBundle.load(asset);
      expect(data.lengthInBytes, greaterThan(0), reason: asset);
    }
  });

  test('scenario five has generated artwork mapped to every step', () {
    final story = expandedScenarios.firstWhere((item) => item.id == 's5');
    expect(story.steps.every((step) => step.imageAsset != null), isTrue);
    expect(story.steps.map((step) => step.imageAsset).toSet(), hasLength(9));
    expect(story.coverImageAsset, isNotNull);
  });

  test('every scenario five illustration is bundled and non-empty', () async {
    final story = expandedScenarios.firstWhere((item) => item.id == 's5');
    final assets = {
      ...story.steps.map((step) => step.imageAsset!),
      story.coverImageAsset!,
    };

    for (final asset in assets) {
      final data = await rootBundle.load(asset);
      expect(data.lengthInBytes, greaterThan(0), reason: asset);
    }
  });

  test('unsafe choice coaches and safe choice advances', () async {
    final state = AppState();
    await state.load();
    await state.startScenario('s1');
    while (state.activeStep!.choices.every(
      (item) => item.quality != ChoiceQuality.tryAgain,
    )) {
      await state.nextStep();
    }
    final choiceStep = state.activeStep!;
    final unsafe = choiceStep.choices.firstWhere(
      (item) => item.quality == ChoiceQuality.tryAgain,
    );
    final safe = choiceStep.choices.firstWhere(
      (item) => item.quality == ChoiceQuality.best,
    );
    final before = state.activeStepIndex;

    expect(await state.choose(unsafe), isFalse);
    expect(state.activeStepIndex, before);
    expect(state.coaching, isNotEmpty);
    expect(state.disabledChoices, contains(unsafe.id));

    expect(await state.choose(safe), isTrue);
    expect(state.activeStepIndex, before + 1);
  });

  test('retry state and decision history survive app restart', () async {
    final state = AppState();
    await state.load();
    await state.startScenario('s1');
    while (state.activeStep!.choices.every(
      (item) => item.quality != ChoiceQuality.tryAgain,
    )) {
      await state.nextStep();
    }
    final unsafe = state.activeStep!.choices.firstWhere(
      (item) => item.quality == ChoiceQuality.tryAgain,
    );
    await state.choose(unsafe);

    final restored = AppState();
    await restored.load();
    expect(restored.activeScenarioId, 's1');
    expect(restored.activeStepIndex, state.activeStepIndex);
    expect(restored.disabledChoices, contains(unsafe.id));
    expect(restored.coaching, isNotEmpty);
    expect(restored.decisionHistory.last['choiceId'], unsafe.id);
  });

  test('completed session cannot award coins twice', () async {
    final state = AppState();
    await state.load();
    await state.startScenario('s1');
    final firstScore = await state.completeScenario();
    final coinsAfterFirst = state.coins;
    final secondScore = await state.completeScenario();
    expect(firstScore, 100);
    expect(secondScore, 0);
    expect(state.coins, coinsAfterFirst);
  });

  test('rapid repeated choice advances and scores only once', () async {
    final state = AppState();
    await state.load();
    await state.startScenario('s1');
    while (state.activeStep!.choices.every(
      (item) => item.quality != ChoiceQuality.best,
    )) {
      await state.nextStep();
    }
    final safe = state.activeStep!.choices.firstWhere(
      (item) => item.quality == ChoiceQuality.best,
    );
    final beforeStep = state.activeStepIndex;

    final results = await Future.wait([state.choose(safe), state.choose(safe)]);

    expect(results.where((result) => result), hasLength(1));
    expect(state.activeStepIndex, beforeStep + 1);
    expect(
      state.decisionHistory.where((item) => item['choiceId'] == safe.id),
      hasLength(1),
    );
  });

  test('legacy string age is migrated to a safe integer', () async {
    SharedPreferences.setMockInitialValues({'childAge': '12'});
    final state = AppState();

    await state.load();

    expect(state.childAge, 12);
    expect(state.childAge, isA<int>());
  });

  testWidgets('visual stage has an accessible scene label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: StoryStage(
            scene: 'school',
            character: 'peer',
            speaker: 'Dost',
            reduceMotion: true,
          ),
        ),
      ),
    );
    expect(
      find.bySemanticsLabel('school scene with Dost speaking'),
      findsOneWidget,
    );
  });

  testWidgets('OTP sheet closes before auth navigation replaces the page', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/auth',
      routes: [
        GoRoute(path: '/auth', builder: (_, _) => const AuthScreen()),
        GoRoute(
          path: '/profile-setup',
          builder: (_, _) => const Scaffold(body: Text('Profile setup')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('Create demo account'));
    await tester.pumpAndSettle();
    expect(find.text('Verify this grown-up'), findsOneWidget);

    await tester.tap(find.text('Verify demo code'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Profile setup'), findsOneWidget);
  });

  testWidgets('profile age text is converted and saved as an integer', (
    tester,
  ) async {
    final state = AppState();
    await state.load();
    final router = GoRouter(
      initialLocation: '/profile-setup',
      routes: [
        GoRoute(
          path: '/profile-setup',
          builder: (_, _) => const ProfileSetupScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (_, _) => const Scaffold(body: Text('Home')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.enterText(find.byKey(const Key('profile-age-field')), '12');
    final submitButton = find.text('Meet Dost');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(state.childAge, 12);
    expect(state.childAge, isA<int>());
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('home story card renders scenario artwork without overflow', (
    tester,
  ) async {
    final state = AppState();
    await state.load();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: state,
        child: const MaterialApp(home: HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(Image), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('body map recognises the story zones as unsafe', (tester) async {
    List<String>? answer;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: BodySafetyActivity(
              isUrdu: false,
              onComplete: (selectedIds, _) async => answer = selectedIds,
            ),
          ),
        ),
      ),
    );

    final headZone = find.byKey(const Key('body-zone-head_face'));
    await tester.ensureVisible(headZone);
    await tester.tap(headZone);
    await tester.pump();
    final shoulderZone = find.byKey(const Key('body-zone-shoulder_back'));
    await tester.ensureVisible(shoulderZone);
    await tester.tap(shoulderZone);
    await tester.pump();
    final swimsuitZone = find.byKey(const Key('body-zone-swimsuit_area'));
    await tester.ensureVisible(swimsuitZone);
    await tester.tap(swimsuitZone);
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('body-judgement-unsafe')));
    await tester.tap(find.byKey(const Key('body-judgement-unsafe')));
    await tester.pump();
    await tester.ensureVisible(find.byKey(const Key('body-map-submit')));
    await tester.tap(find.byKey(const Key('body-map-submit')));
    await tester.pumpAndSettle();

    expect(
      answer,
      containsAll(['head_face', 'shoulder_back', 'swimsuit_area']),
    );
    expect(answer, contains('judgement:unsafe'));
    expect(tester.takeException(), isNull);
  });
}
