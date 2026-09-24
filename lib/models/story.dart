import 'package:flutter/material.dart';

enum StoryKind { dialogue, info, choice, feeling, ranking, text, terminal }

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
  });
  final String id;
  final StoryKind kind;
  final LocalText speaker;
  final LocalText text;
  final List<StoryChoice> choices;
  final String scene;
  final String character;
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
}
