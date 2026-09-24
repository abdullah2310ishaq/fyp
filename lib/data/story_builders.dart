import '../models/story.dart';

const dost = LocalText('Dost', 'دوست');
const narrator = LocalText('Story', 'کہانی');
const child = LocalText('You', 'آپ');

LocalText t(String en, String ur) => LocalText(en, ur);

StoryChoice c(
  String id,
  String en,
  String ur,
  ChoiceQuality quality, {
  String? coachEn,
  String? coachUr,
}) => StoryChoice(
  id: id,
  text: t(en, ur),
  quality: quality,
  coaching: coachEn == null ? null : t(coachEn, coachUr ?? coachEn),
);

StoryStep node(
  String id,
  StoryKind kind,
  String en,
  String ur, {
  LocalText speaker = dost,
  String scene = 'home',
  String character = 'guide',
  List<StoryChoice> choices = const [],
  List<String> accepted = const [],
  String dimension = 'safety',
  bool unscored = false,
  String? sourceRef,
}) => StoryStep(
  id: id,
  kind: kind,
  speaker: speaker,
  text: t(en, ur),
  scene: scene,
  character: character,
  choices: choices,
  acceptedChoiceIds: accepted,
  dimension: dimension,
  unscored: unscored,
  sourceRef: sourceRef,
);

StoryChoice yes(String id, String en, String ur) =>
    c(id, en, ur, ChoiceQuality.best);

StoryChoice retry(
  String id,
  String en,
  String ur,
  String coachEn,
  String coachUr,
) => c(id, en, ur, ChoiceQuality.tryAgain, coachEn: coachEn, coachUr: coachUr);

StoryChoice partial(
  String id,
  String en,
  String ur,
  String coachEn,
  String coachUr,
) => c(id, en, ur, ChoiceQuality.okay, coachEn: coachEn, coachUr: coachUr);
