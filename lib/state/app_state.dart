import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/expanded_scenarios.dart';
import '../models/story.dart';

enum SubscriptionState { free, active, expired }

class AppState extends ChangeNotifier {
  SharedPreferences? _prefs;
  bool _transitioning = false;

  bool onboardingComplete = false;
  bool profileComplete = false;
  String childName = 'Ayaan';
  int childAge = 10;
  String avatar = 'boy';
  bool isUrdu = false;
  bool soundOn = true;
  bool reduceMotion = false;
  SubscriptionState subscription = SubscriptionState.free;
  int coins = 40;
  int streak = 1;
  final Map<String, int> bestScores = {};
  final Map<String, List<int>> scoreHistory = {};
  final Set<String> badges = {};
  String? lastCompletionDay;

  String? activeScenarioId;
  int activeStepIndex = 0;
  int earnedPoints = 0;
  int possiblePoints = 0;
  int attempts = 0;
  String? coaching;
  final Set<String> disabledChoices = {};
  final List<Map<String, dynamic>> decisionHistory = [];
  double feelingValue = 0.5;
  int hintsUsed = 0;
  final Map<String, int> dimensionEarned = {};
  final Map<String, int> dimensionPossible = {};
  Map<String, int> lastDimensionScores = {};

  bool get isPremium => subscription == SubscriptionState.active;
  bool get isTransitioning => _transitioning;
  String tr(String en, String ur) => isUrdu ? ur : en;
  LifeScenario? get activeScenario => activeScenarioId == null
      ? null
      : expandedScenarios
            .where((item) => item.id == activeScenarioId)
            .firstOrNull;
  StoryStep? get activeStep {
    final story = activeScenario;
    if (story == null || activeStepIndex >= story.steps.length) return null;
    return story.steps[activeStepIndex];
  }

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    onboardingComplete = _prefs!.getBool('onboarding') ?? false;
    profileComplete = _prefs!.getBool('profile') ?? false;
    childName = _prefs!.getString('childName') ?? 'Ayaan';
    childAge = _readSavedAge(_prefs!.get('childAge'));
    avatar = _prefs!.getString('avatar') ?? 'boy';
    isUrdu = _prefs!.getBool('urdu') ?? false;
    soundOn = _prefs!.getBool('sound') ?? true;
    reduceMotion = _prefs!.getBool('reduceMotion') ?? false;
    subscription =
        SubscriptionState.values[_prefs!.getInt('subscription') ?? 0];
    coins = _prefs!.getInt('coins') ?? 40;
    streak = _prefs!.getInt('streak') ?? 1;
    lastCompletionDay = _prefs!.getString('lastCompletionDay');
    activeScenarioId = _prefs!.getString('activeScenario');
    activeStepIndex = _prefs!.getInt('activeStep') ?? 0;
    earnedPoints = _prefs!.getInt('earned') ?? 0;
    possiblePoints = _prefs!.getInt('possible') ?? 0;
    hintsUsed = _prefs!.getInt('hintsUsed') ?? 0;
    attempts = _prefs!.getInt('attempts') ?? 0;
    coaching = _prefs!.getString('coaching');
    disabledChoices.addAll(
      _prefs!.getStringList('disabledChoices') ?? const [],
    );
    feelingValue = _prefs!.getDouble('feelingValue') ?? .5;
    final decisions = _prefs!.getString('activeDecisions');
    if (decisions != null) {
      decisionHistory.addAll(
        (jsonDecode(decisions) as List<dynamic>)
            .map((item) => Map<String, dynamic>.from(item as Map))
            .toList(),
      );
    }
    final earnedDimensions = _prefs!.getString('dimensionEarned');
    if (earnedDimensions != null) {
      final decoded = jsonDecode(earnedDimensions) as Map<String, dynamic>;
      dimensionEarned.addAll(
        decoded.map((key, value) => MapEntry(key, value as int)),
      );
    }
    final possibleDimensions = _prefs!.getString('dimensionPossible');
    if (possibleDimensions != null) {
      final decoded = jsonDecode(possibleDimensions) as Map<String, dynamic>;
      dimensionPossible.addAll(
        decoded.map((key, value) => MapEntry(key, value as int)),
      );
    }
    final scores = _prefs!.getString('scores');
    if (scores != null) {
      final decoded = jsonDecode(scores) as Map<String, dynamic>;
      bestScores.addAll(
        decoded.map((key, value) => MapEntry(key, value as int)),
      );
    }
    final history = _prefs!.getString('history');
    if (history != null) {
      final decoded = jsonDecode(history) as Map<String, dynamic>;
      scoreHistory.addAll(
        decoded.map(
          (key, value) => MapEntry(key, (value as List<dynamic>).cast<int>()),
        ),
      );
    }
    badges.addAll(_prefs!.getStringList('badges') ?? const []);
  }

  Future<void> finishWelcome() async {
    onboardingComplete = true;
    await _save();
  }

  Future<void> saveProfile(String name, int age, String selectedAvatar) async {
    childName = name.trim().isEmpty ? 'Ayaan' : name.trim();
    childAge = age.clamp(6, 15);
    avatar = selectedAvatar;
    profileComplete = true;
    await _save();
  }

  Future<void> setLanguage(bool value) async {
    isUrdu = value;
    await _save();
  }

  Future<void> setSound(bool value) async {
    soundOn = value;
    await _save();
  }

  Future<void> setReduceMotion(bool value) async {
    reduceMotion = value;
    await _save();
  }

  bool canOpen(LifeScenario story) => story.isFree || isPremium;

  Future<void> startScenario(String id) async {
    activeScenarioId = id;
    activeStepIndex = 0;
    earnedPoints = 0;
    possiblePoints = 0;
    attempts = 0;
    coaching = null;
    disabledChoices.clear();
    decisionHistory.clear();
    dimensionEarned.clear();
    dimensionPossible.clear();
    hintsUsed = 0;
    await _save();
  }

  Future<void> startAtStep(String id, String stepId) async {
    await startScenario(id);
    final story = activeScenario;
    final index = story?.steps.indexWhere((step) => step.id == stepId) ?? -1;
    activeStepIndex = index < 0 ? 0 : index;
    await _save();
  }

  Future<void> loadPresentationSample() async {
    onboardingComplete = true;
    profileComplete = true;
    childName = 'Ayaan';
    childAge = 10;
    avatar = 'boy';
    subscription = SubscriptionState.active;
    coins = 350;
    streak = 4;
    bestScores.addAll({'s1': 92, 's2': 81});
    scoreHistory.addAll({
      's1': [74, 92],
      's2': [81],
    });
    badges.addAll({'Brave Voice', 'I Reported It'});
    await _save();
  }

  Future<void> nextStep() async {
    if (_transitioning) return;
    _transitioning = true;
    try {
      await _advanceStepAndSave();
    } finally {
      _transitioning = false;
    }
  }

  Future<void> _advanceStepAndSave() async {
    coaching = null;
    disabledChoices.clear();
    attempts = 0;
    activeStepIndex += 1;
    await _save();
  }

  Future<bool> choose(StoryChoice choice) async {
    if (_transitioning || disabledChoices.contains(choice.id)) return false;
    _transitioning = true;
    try {
      final step = activeStep;
      final isScored = step != null && !step.unscored;
      if (isScored && attempts == 0) {
        possiblePoints += 10;
        dimensionPossible.update(
          step.dimension,
          (value) => value + 10,
          ifAbsent: () => 10,
        );
      }
      attempts += 1;
      decisionHistory.add({
        'stepId': step?.id,
        'choiceId': choice.id,
        'quality': choice.quality.name,
        'dimension': step?.dimension,
        'attempt': attempts,
        'timestamp': DateTime.now().toIso8601String(),
      });
      if (choice.quality == ChoiceQuality.best) {
        if (isScored && attempts == 1) {
          earnedPoints += 10;
          dimensionEarned.update(
            step.dimension,
            (value) => value + 10,
            ifAbsent: () => 10,
          );
        }
        await _advanceStepAndSave();
        return true;
      }
      if (isScored && choice.quality == ChoiceQuality.okay && attempts == 1) {
        earnedPoints += 5;
        dimensionEarned.update(
          step.dimension,
          (value) => value + 5,
          ifAbsent: () => 5,
        );
      }
      coaching =
          choice.coaching?.get(isUrdu) ??
          (isUrdu
              ? 'آئیے محفوظ راستے پر دوبارہ سوچیں۔'
              : 'Let’s think about the safer path together.');
      disabledChoices.add(choice.id);
      await _save();
      return false;
    } finally {
      _transitioning = false;
    }
  }

  void updateFeeling(double value) {
    feelingValue = value;
    notifyListeners();
  }

  Future<void> completeFeeling() async {
    if (_transitioning) return;
    _transitioning = true;
    try {
      decisionHistory.add({
        'stepId': activeStep?.id,
        'interaction': 'feeling',
        'value': feelingValue,
        'scored': false,
        'timestamp': DateTime.now().toIso8601String(),
      });
      await _advanceStepAndSave();
    } finally {
      _transitioning = false;
    }
  }

  Future<void> completeChecklist(Set<String> selectedIds) async {
    if (_transitioning) return;
    _transitioning = true;
    try {
      decisionHistory.add({
        'stepId': activeStep?.id,
        'interaction': 'checklist',
        'selectedIds': selectedIds.toList(),
        'scored': false,
        'timestamp': DateTime.now().toIso8601String(),
      });
      await _advanceStepAndSave();
    } finally {
      _transitioning = false;
    }
  }

  Future<void> completeInteraction({
    required bool correct,
    String interaction = 'activity',
    List<String> selectedIds = const [],
  }) async {
    if (_transitioning) return;
    _transitioning = true;
    try {
      final step = activeStep;
      decisionHistory.add({
        'stepId': step?.id,
        'interaction': interaction,
        'selectedIds': selectedIds,
        'correct': correct,
        'timestamp': DateTime.now().toIso8601String(),
      });
      if (step != null && !step.unscored) {
        possiblePoints += 10;
        dimensionPossible.update(
          step.dimension,
          (value) => value + 10,
          ifAbsent: () => 10,
        );
        if (correct) {
          earnedPoints += 10;
          dimensionEarned.update(
            step.dimension,
            (value) => value + 10,
            ifAbsent: () => 10,
          );
        }
      }
      await _advanceStepAndSave();
    } finally {
      _transitioning = false;
    }
  }

  Future<String> useHint() async {
    if (_transitioning) return 'Please wait for the current action to finish.';
    _transitioning = true;
    try {
      if (!isPremium) return 'Hints are available in premium demo mode.';
      if (hintsUsed >= 3) return 'You have used all 3 hints in this story.';
      if (coins < 10) return 'You need 10 practice coins for a hint.';
      final step = activeStep;
      if (step == null ||
          (step.kind != StoryKind.choice &&
              step.kind != StoryKind.multiChoice)) {
        return 'A hint will be available at the next decision.';
      }
      final removable = step.choices
          .where(
            (choice) =>
                choice.quality == ChoiceQuality.tryAgain &&
                !disabledChoices.contains(choice.id),
          )
          .firstOrNull;
      if (removable == null) {
        return 'Dost has already narrowed this decision for you.';
      }
      coins -= 10;
      hintsUsed += 1;
      disabledChoices.add(removable.id);
      coaching = isUrdu
          ? 'دوست کا اشارہ: محفوظ انتخاب فاصلہ بڑھاتا، قابلِ اعتماد مدد لاتا، یا واضح اطلاع دیتا ہے۔'
          : 'Dost’s hint: the safer choice creates distance, brings trusted help, or communicates clearly.';
      await _save();
      return 'Hint used • 10 coins • ${3 - hintsUsed} remaining';
    } finally {
      _transitioning = false;
    }
  }

  Future<int> completeScenario() async {
    if (_transitioning) return 0;
    _transitioning = true;
    try {
      final id = activeScenarioId;
      if (id == null) return 0;
      lastDimensionScores = {
        for (final entry in dimensionPossible.entries)
          entry.key: entry.value == 0
              ? 0
              : (((dimensionEarned[entry.key] ?? 0) / entry.value) * 100)
                    .round()
                    .clamp(0, 100),
      };
      final story = expandedScenarios.firstWhere((item) => item.id == id);
      var weighted = 0.0;
      var usedWeight = 0.0;
      for (final entry in story.weights.entries) {
        final dimensionScore = lastDimensionScores[entry.key];
        if (dimensionScore != null) {
          weighted += dimensionScore * entry.value;
          usedWeight += entry.value;
        }
      }
      final score = usedWeight == 0
          ? (possiblePoints == 0
                ? 100
                : ((earnedPoints / possiblePoints) * 100).round().clamp(0, 100))
          : (weighted / usedWeight).round().clamp(0, 100);
      final previous = bestScores[id] ?? 0;
      scoreHistory.update(
        id,
        (items) => [...items, score],
        ifAbsent: () => [score],
      );
      bestScores[id] = score > previous ? score : previous;
      final baseCoins = score >= 90
          ? 100
          : score >= 75
          ? 75
          : score >= 60
          ? 50
          : 20;
      _updateStreak();
      final firstBonus = isPremium && previous == 0 ? 25 : 0;
      final perfectBonus = isPremium && score == 100 ? 50 : 0;
      final streakBonus = isPremium ? (streak * 10).clamp(0, 50) : 0;
      final improvement = isPremium && previous > 0 && score > previous
          ? (score - previous).clamp(10, 100)
          : 0;
      coins +=
          baseCoins + firstBonus + perfectBonus + streakBonus + improvement;
      if (score >= 75) {
        badges.addAll(story.badges.isEmpty ? [story.badge] : story.badges);
      }
      activeScenarioId = null;
      activeStepIndex = 0;
      await _save();
      return score;
    } finally {
      _transitioning = false;
    }
  }

  Future<void> activatePremium() async {
    subscription = SubscriptionState.active;
    await _save();
  }

  Future<void> setDemoSubscription(SubscriptionState value) async {
    subscription = value;
    await _save();
  }

  Future<void> setDemoCoins(int value) async {
    coins = value;
    await _save();
  }

  Future<void> resetAll() async {
    await _prefs?.clear();
    onboardingComplete = false;
    profileComplete = false;
    childName = 'Ayaan';
    childAge = 10;
    avatar = 'boy';
    isUrdu = false;
    soundOn = true;
    reduceMotion = false;
    subscription = SubscriptionState.free;
    coins = 40;
    streak = 1;
    bestScores.clear();
    scoreHistory.clear();
    badges.clear();
    activeScenarioId = null;
    lastCompletionDay = null;
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = _prefs;
    if (prefs == null) return;
    await Future.wait([
      prefs.setBool('onboarding', onboardingComplete),
      prefs.setBool('profile', profileComplete),
      prefs.setString('childName', childName),
      prefs.setInt('childAge', childAge),
      prefs.setString('avatar', avatar),
      prefs.setBool('urdu', isUrdu),
      prefs.setBool('sound', soundOn),
      prefs.setBool('reduceMotion', reduceMotion),
      prefs.setInt('subscription', subscription.index),
      prefs.setInt('coins', coins),
      prefs.setInt('streak', streak),
      prefs.setString('scores', jsonEncode(bestScores)),
      prefs.setString('history', jsonEncode(scoreHistory)),
      prefs.setStringList('badges', badges.toList()),
      if (lastCompletionDay != null)
        prefs.setString('lastCompletionDay', lastCompletionDay!),
    ]);
    if (activeScenarioId == null) {
      for (final key in [
        'activeScenario',
        'activeStep',
        'earned',
        'possible',
        'hintsUsed',
        'attempts',
        'feelingValue',
        'disabledChoices',
        'activeDecisions',
        'coaching',
        'dimensionEarned',
        'dimensionPossible',
      ]) {
        await prefs.remove(key);
      }
    } else {
      await prefs.setString('activeScenario', activeScenarioId!);
      await prefs.setInt('activeStep', activeStepIndex);
      await prefs.setInt('earned', earnedPoints);
      await prefs.setInt('possible', possiblePoints);
      await prefs.setInt('hintsUsed', hintsUsed);
      await prefs.setInt('attempts', attempts);
      await prefs.setDouble('feelingValue', feelingValue);
      await prefs.setStringList('disabledChoices', disabledChoices.toList());
      await prefs.setString('activeDecisions', jsonEncode(decisionHistory));
      if (coaching != null) {
        await prefs.setString('coaching', coaching!);
      } else {
        await prefs.remove('coaching');
      }
      await prefs.setString('dimensionEarned', jsonEncode(dimensionEarned));
      await prefs.setString('dimensionPossible', jsonEncode(dimensionPossible));
    }
    notifyListeners();
  }

  void _updateStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayKey = '${today.year}-${today.month}-${today.day}';
    if (lastCompletionDay == todayKey) return;
    if (lastCompletionDay != null) {
      final parts = lastCompletionDay!.split('-').map(int.parse).toList();
      final previous = DateTime(parts[0], parts[1], parts[2]);
      streak = today.difference(previous).inDays == 1 ? streak + 1 : 1;
    } else {
      streak = 1;
    }
    lastCompletionDay = todayKey;
  }

  int _readSavedAge(Object? value) {
    final parsed = switch (value) {
      int number => number,
      double number => number.round(),
      String text => int.tryParse(text.trim()) ?? 10,
      _ => 10,
    };
    return parsed.clamp(6, 15);
  }
}
