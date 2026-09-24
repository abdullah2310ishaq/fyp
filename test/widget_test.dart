import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeiq/data/scenario_data.dart';
import 'package:lifeiq/core/scenario_validator.dart';
import 'package:lifeiq/models/story.dart';
import 'package:lifeiq/state/app_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('catalogue contains eight terminating bilingual stories', () {
    expect(scenarios, hasLength(8));
    for (final story in scenarios) {
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
    expect(validateCatalogue(scenarios), isEmpty);
  });

  test('only story one is free', () {
    expect(scenarios.where((story) => story.isFree).map((story) => story.id), [
      's1',
    ]);
  });

  test('unsafe choice coaches and safe choice advances', () async {
    final state = AppState();
    await state.load();
    await state.startScenario('s1');
    while (state.activeStep!.choices.every((item) => item.quality != ChoiceQuality.tryAgain)) {
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
      MaterialApp(
        home: Scaffold(
          body: Semantics(
            label: 'story canvas',
            child: ColoredBox(color: Colors.teal),
          ),
        ),
      ),
    );
    expect(find.bySemanticsLabel('story canvas'), findsOneWidget);
  });
}
