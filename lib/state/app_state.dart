import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/scenario_data.dart';
import '../models/story.dart';

enum SubscriptionState { free, active, expired }

class AppState extends ChangeNotifier {
  SharedPreferences? _prefs;

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
  final Set<String> badges = {};

  String? activeScenarioId;
  int activeStepIndex = 0;
  int earnedPoints = 0;
  int possiblePoints = 0;
  int attempts = 0;
  String? coaching;
  final Set<String> disabledChoices = {};
  double feelingValue = 0.5;

  bool get isPremium => subscription == SubscriptionState.active;
  LifeScenario? get activeScenario => activeScenarioId == null
      ? null
      : scenarios.where((item) => item.id == activeScenarioId).firstOrNull;
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
    childAge = _prefs!.getInt('childAge') ?? 10;
    avatar = _prefs!.getString('avatar') ?? 'boy';
    isUrdu = _prefs!.getBool('urdu') ?? false;
    soundOn = _prefs!.getBool('sound') ?? true;
    reduceMotion = _prefs!.getBool('reduceMotion') ?? false;
    subscription =
        SubscriptionState.values[_prefs!.getInt('subscription') ?? 0];
    coins = _prefs!.getInt('coins') ?? 40;
    streak = _prefs!.getInt('streak') ?? 1;
    activeScenarioId = _prefs!.getString('activeScenario');
    activeStepIndex = _prefs!.getInt('activeStep') ?? 0;
    earnedPoints = _prefs!.getInt('earned') ?? 0;
    possiblePoints = _prefs!.getInt('possible') ?? 0;
    final scores = _prefs!.getString('scores');
    if (scores != null) {
      final decoded = jsonDecode(scores) as Map<String, dynamic>;
      bestScores.addAll(
        decoded.map((key, value) => MapEntry(key, value as int)),
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
    childAge = age;
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
    await _save();
  }

  Future<void> nextStep() async {
    coaching = null;
    disabledChoices.clear();
    activeStepIndex += 1;
    await _save();
  }

  Future<bool> choose(StoryChoice choice) async {
    if (disabledChoices.contains(choice.id)) return false;
    possiblePoints += attempts == 0 ? 10 : 0;
    attempts += 1;
    if (choice.quality == ChoiceQuality.best) {
      if (attempts == 1) earnedPoints += 10;
      coaching = null;
      disabledChoices.clear();
      attempts = 0;
      activeStepIndex += 1;
      await _save();
      return true;
    }
    if (choice.quality == ChoiceQuality.okay && attempts == 1) {
      earnedPoints += 5;
    }
    coaching =
        choice.coaching?.get(isUrdu) ??
        (isUrdu
            ? 'آئیے محفوظ راستے پر دوبارہ سوچیں۔'
            : 'Let’s think about the safer path together.');
    disabledChoices.add(choice.id);
    await _save();
    return false;
  }

  void updateFeeling(double value) {
    feelingValue = value;
    notifyListeners();
  }

  Future<int> completeScenario() async {
    final id = activeScenarioId;
    if (id == null) return 0;
    final score = possiblePoints == 0
        ? 100
        : ((earnedPoints / possiblePoints) * 100).round().clamp(0, 100);
    final previous = bestScores[id] ?? 0;
    bestScores[id] = score > previous ? score : previous;
    final baseCoins = score >= 90
        ? 100
        : score >= 75
        ? 75
        : score >= 60
        ? 50
        : 20;
    final firstBonus = previous == 0 ? 25 : 0;
    final improvement = previous > 0 && score > previous
        ? (score - previous).clamp(10, 100)
        : 0;
    coins += baseCoins + firstBonus + improvement;
    if (score >= 75) badges.add(_badgeFor(id));
    activeScenarioId = null;
    activeStepIndex = 0;
    await _save();
    return score;
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
    badges.clear();
    activeScenarioId = null;
    notifyListeners();
  }

  String _badgeFor(String id) => switch (id) {
    's1' => 'Brave Voice',
    's2' => 'Kind & Strong',
    's3' => 'Safety Scout',
    's4' => 'Safe Surfer',
    's5' => 'Boundary Hero',
    's6' => 'Calm Captain',
    's7' => 'Smart Helper',
    _ => 'Trusted Adult Finder',
  };

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
      prefs.setStringList('badges', badges.toList()),
    ]);
    if (activeScenarioId == null) {
      await prefs.remove('activeScenario');
    } else {
      await prefs.setString('activeScenario', activeScenarioId!);
      await prefs.setInt('activeStep', activeStepIndex);
      await prefs.setInt('earned', earnedPoints);
      await prefs.setInt('possible', possiblePoints);
    }
    notifyListeners();
  }
}
