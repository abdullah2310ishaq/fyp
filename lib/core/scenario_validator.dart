import '../models/story.dart';

List<String> validateScenario(LifeScenario story) {
  final errors = <String>[];
  if (story.steps.isEmpty) return ['${story.id}: has no steps'];
  final ids = <String>{};
  for (final step in story.steps) {
    if (!ids.add(step.id)) errors.add('${story.id}: duplicate step ${step.id}');
    if (step.text.en.trim().isEmpty || step.text.ur.trim().isEmpty) {
      errors.add('${step.id}: missing bilingual text');
    }
    if (step.sourceRef == null || step.sourceRef!.trim().isEmpty) {
      errors.add('${step.id}: missing source reference');
    }
    if ({
          StoryKind.feeling,
          StoryKind.checklist,
          StoryKind.grounding,
        }.contains(step.kind) &&
        !step.unscored) {
      errors.add('${step.id}: self-report/practice node must be unscored');
    }
    if ({
          StoryKind.choice,
          StoryKind.multiChoice,
          StoryKind.ranking,
          StoryKind.checklist,
        }.contains(step.kind) &&
        step.choices.isEmpty) {
      errors.add('${step.id}: interaction has no choices');
    }
    for (final choice in step.choices) {
      if (choice.text.en.trim().isEmpty || choice.text.ur.trim().isEmpty) {
        errors.add('${step.id}/${choice.id}: missing bilingual choice');
      }
      if (choice.quality != ChoiceQuality.best && choice.coaching == null) {
        errors.add('${step.id}/${choice.id}: non-best choice missing coaching');
      }
    }
    final choiceIds = step.choices.map((choice) => choice.id).toSet();
    if (!choiceIds.containsAll(step.acceptedChoiceIds)) {
      errors.add('${step.id}: accepted choice does not exist');
    }
  }
  if (story.steps.last.kind != StoryKind.terminal) {
    errors.add('${story.id}: final node is not terminal');
  }
  final totalWeight = story.weights.values.fold<double>(
    0,
    (sum, value) => sum + value,
  );
  if ((totalWeight - 1).abs() > .001) {
    errors.add('${story.id}: weights total $totalWeight');
  }
  return errors;
}

List<String> validateCatalogue(List<LifeScenario> stories) {
  final errors = <String>[];
  final ids = <String>{};
  for (final story in stories) {
    if (!ids.add(story.id)) errors.add('Duplicate scenario ${story.id}');
    errors.addAll(validateScenario(story));
  }
  return errors;
}
