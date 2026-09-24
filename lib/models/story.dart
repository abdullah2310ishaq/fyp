import 'package:flutter/material.dart';

enum StoryKind {
  dialogue,
  info,
  checklist,
  choice,
  multiChoice,
  feeling,
  bodyMap,
  ranking,
  grounding,
  text,
  mockVoice,
  terminal,
}

enum ChoiceQuality { best, okay, tryAgain }

class LocalText {
  const LocalText(this.en, this.ur);
  final String en;
  final String ur;
  String get(bool isUrdu) => isUrdu ? ur : en;
}

class StoryChoice {
  const StoryChoice({
    required this.id,
    required this.text,
    required this.quality,
    this.coaching,
  });
  final String id;
  final LocalText text;
  final ChoiceQuality quality;
  final LocalText? coaching;
}

class StoryStep {
  const StoryStep({
    required this.id,
    required this.kind,
    required this.speaker,
    required this.text,
    this.choices = const [],
    this.scene = 'home',
    this.character = 'guide',
    this.imageAsset,
    this.acceptedChoiceIds = const [],
    this.dimension = 'safety',
    this.unscored = false,
    this.sourceRef,
  });
  final String id;
  final StoryKind kind;
  final LocalText speaker;
  final LocalText text;
  final List<StoryChoice> choices;
  final String scene;
  final String character;
  final String? imageAsset;
  final List<String> acceptedChoiceIds;
  final String dimension;
  final bool unscored;
  final String? sourceRef;
}

class LifeScenario {
  const LifeScenario({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.practice,
    required this.icon,
    required this.color,
    required this.isFree,
    required this.steps,
    this.coverImageAsset,
    this.weights = const {
      'safety': .3,
      'resilience': .2,
      'social': .2,
      'communication': .2,
      'emotional': .1,
    },
    this.badge = 'Safety Star',
    this.badges = const [],
  });
  final String id;
  final LocalText title;
  final LocalText category;
  final LocalText description;
  final List<LocalText> practice;
  final IconData icon;
  final Color color;
  final bool isFree;
  final List<StoryStep> steps;
  final String? coverImageAsset;
  final Map<String, double> weights;
  final String badge;
  final List<String> badges;
}
