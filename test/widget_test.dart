import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeiq/data/expanded_scenarios.dart';
import 'package:lifeiq/core/scenario_validator.dart';
import 'package:lifeiq/models/story.dart';
import 'package:lifeiq/state/app_state.dart';
import 'package:lifeiq/widgets/life_widgets.dart';
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
        's1': 11,
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
}
