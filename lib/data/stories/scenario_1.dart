import 'package:flutter/material.dart';

import '../../models/story.dart';
import '../story_builders.dart';

const _introArt = 'assets/scenarios/s1/s1_intro.jpg';
const _boundaryArt = 'assets/scenarios/s1/s1_boundary.jpg';
const _teachingArt = 'assets/scenarios/s1/s1_teaching.jpg';
const _feelingsArt = 'assets/scenarios/s1/s1_feelings.jpg';
const _trustedHelpersArt = 'assets/scenarios/s1/s1_trusted_helpers.jpg';
const _trustedAdultArt = 'assets/scenarios/s1/s1_trusted_adult.jpg';
const _protectiveCallArt = 'assets/scenarios/s1/s1_protective_call.jpg';
const _secretArt = 'assets/scenarios/s1/s1_secret.jpg';
const _approachAmmiArt = 'assets/scenarios/s1/s1_approach_ammi.jpg';
const _comfortArt = 'assets/scenarios/s1/s1_comfort.jpg';
const _hopefulFinalArt = 'assets/scenarios/s1/s1_hopeful_final.jpg';

final scenario1 = LifeScenario(
  id: 's1',
  title: t('My Body, My Rules', 'میرا جسم، میرے اصول'),
  category: t('Body Safety', 'جسمانی حفاظت'),
  description: t(
    'A complete body-safety story about trusting feelings, leaving, telling, and getting adult help.',
    'احساس پر بھروسہ، دور جانے، بتانے اور بڑوں سے مدد لینے کی مکمل کہانی۔',
  ),
  practice: [
    t('Say no and move away', 'انکار کریں اور دور جائیں'),
    t('Tell a trusted adult clearly', 'قابلِ اعتماد بڑے کو صاف بتائیں'),
    t('Keep telling until someone helps', 'مدد ملنے تک بتاتے رہیں'),
  ],
  icon: Icons.health_and_safety_rounded,
  color: const Color(0xFF2A9D8F),
  isFree: true,
  coverImageAsset: _introArt,
  weights: const {'safety': .5, 'resilience': .2, 'communication': .3},
  badge: 'Brave Voice',
  badges: const ['Brave Voice', 'Trusted Adult Finder', 'Body Safety Star'],
  steps: [
    node(
      's1_checklist',
      StoryKind.checklist,
      'Before we begin, tick what you already know. Every answer is accepted: your home area, a parent phone number, a trusted adult, and body-safety rules.',
      'شروع کرنے سے پہلے جو باتیں آپ جانتے ہیں نشان لگائیں۔ ہر جواب قبول ہے: گھر کا علاقہ، والدین کا فون، قابلِ اعتماد بڑا، اور جسمانی حفاظت کے اصول۔',
      choices: [
        yes(
          'address',
          'I know my home area',
          'میں اپنے گھر کا علاقہ جانتا/جانتی ہوں',
        ),
        yes(
          'phone',
          'I know a parent phone number',
          'میں والدین کا فون نمبر جانتا/جانتی ہوں',
        ),
        yes(
          'adult',
          'I can name a trusted adult',
          'میں قابلِ اعتماد بڑے کا نام جانتا/جانتی ہوں',
        ),
        yes(
          'body',
          'I have learned body safety',
          'میں نے جسمانی حفاظت سیکھی ہے',
        ),
      ],
      imageAsset: _introArt,
      unscored: true,
      sourceRef: 'Scenario 01 checklist',
    ),
    node(
      's1_scene1',
      StoryKind.choice,
      'Assalam-o-Alaikum. Did someone touch you in a way that felt confusing or upsetting?',
      'السلام علیکم۔ کیا کسی نے ایسا لمس کیا جو الجھن یا پریشانی کا باعث بنا؟',
      choices: [
        yes('yes', 'Yes, it felt wrong', 'ہاں، یہ غلط لگا'),
        yes(
          'unsure',
          'I am not sure; it felt strange',
          'مجھے یقین نہیں؛ عجیب لگا',
        ),
        yes(
          'normal',
          'Maybe, but they said it was normal',
          'شاید، مگر انہوں نے اسے معمول کہا',
        ),
      ],
      imageAsset: _introArt,
      dimension: 'communication',
      unscored: true,
      sourceRef: 'Scenario 01 Scene 1',
    ),
    node(
      's1_scene2',
      StoryKind.choice,
      'Uncle Hamza visits. A welcome hug changes into a touch near a private area. He says, “This is how I show love.” You feel uncomfortable. The scene never shows the touch.',
      'انکل حمزہ آتے ہیں۔ خوش آمدیدی گلے کے بعد نجی حصے کے قریب لمس ہوتا ہے۔ وہ کہتے ہیں، “میں ایسے پیار کرتا ہوں۔” آپ بے آرام محسوس کرتے ہیں۔ منظر میں لمس نہیں دکھایا جاتا۔',
      speaker: narrator,
      scene: 'home',
      character: 'adult',
      imageAsset: _boundaryArt,
      choices: [
        yes(
          'confused',
          'Confused; I am not sure it was okay',
          'الجھن؛ یقین نہیں یہ ٹھیک تھا',
        ),
        yes('scared', 'Uncomfortable and scared', 'بے آرام اور خوفزدہ'),
        yes(
          'elder',
          'It felt wrong, but he is an elder',
          'غلط لگا، مگر وہ بڑے ہیں',
        ),
      ],
      unscored: true,
      sourceRef: 'Scenario 01 Scene 2',
    ),
    node(
      's1_scene3',
      StoryKind.info,
      'Your body belongs to you. A wanted handshake, pat, or hug can feel safe. A touch that feels confusing, scary, secret, or involves swimsuit-covered parts is unsafe. A doctor only checks with a parent present.',
      'آپ کا جسم آپ کا ہے۔ رضامندی والا ہاتھ ملانا، تھپکی یا گلے ملنا محفوظ ہو سکتا ہے۔ الجھن، خوف، راز یا سوئمنگ سوٹ سے ڈھکے حصوں کا لمس غیر محفوظ ہے۔ ڈاکٹر صرف والدین کی موجودگی میں معائنہ کرتا ہے۔',
      imageAsset: _teachingArt,
      sourceRef: 'Scenario 01 Scene 3',
    ),
    node(
      's1_body_map',
      StoryKind.bodyMap,
      'Tap the places described in the story: the shoulder or back and the swimsuit-covered area. Then decide whether the whole situation was safe, unsafe, or confusing.',
      'کہانی میں بیان کیے گئے حصوں کو دبائیں: کندھا یا کمر اور سوئمنگ سوٹ سے ڈھکا حصہ۔ پھر بتائیں کہ پوری صورتحال محفوظ، غیر محفوظ یا الجھن والی تھی۔',
      imageAsset: _teachingArt,
      dimension: 'safety',
      sourceRef: 'Scenario 01 body-safety recognition activity',
    ),
    node(
      's1_scene4',
      StoryKind.feeling,
      'Move the slider to show how the situation felt. Safe, confused, or scared—every feeling is valid and is never scored.',
      'سلائیڈر سے بتائیں صورتحال کیسی لگی۔ محفوظ، الجھن یا خوف—ہر احساس درست ہے اور اس پر نمبر نہیں۔',
      imageAsset: _feelingsArt,
      unscored: true,
      dimension: 'emotional',
      sourceRef: 'Scenario 01 Scene 4',
    ),
    node(
      's1_scene5',
      StoryKind.choice,
      'Uncle Hamza says, “This is our secret.” What do you do?',
      'انکل حمزہ کہتے ہیں، “یہ ہمارا راز ہے۔” آپ کیا کریں گے؟',
      choices: [
        retry(
          'secret',
          'Keep it secret because he is an elder',
          'بڑا ہونے کی وجہ سے راز رکھیں',
          'Secrets about touches are never safe. A safe adult never asks a child to hide body contact.',
          'لمس کے راز محفوظ نہیں۔ محفوظ بڑا بچے سے جسمانی لمس چھپانے کو نہیں کہتا۔',
        ),
        yes(
          'tell',
          'Say “No”, move away, and tell Ammi or Baba now',
          '“نہیں” کہیں، دور جائیں اور ابھی امی یا ابو کو بتائیں',
        ),
        retry(
          'wait',
          'Wait to see whether it happens again',
          'دوبارہ ہونے کا انتظار کریں',
          'You deserve safety now, not later. Move away and tell.',
          'آپ ابھی حفاظت کے حقدار ہیں۔ دور جائیں اور بتائیں۔',
        ),
      ],
      imageAsset: _secretArt,
      dimension: 'safety',
      sourceRef: 'Scenario 01 Scene 5',
    ),
    node(
      's1_scene6',
      StoryKind.ranking,
      'Put trusted helpers in the safest order: parent, teacher/counsellor, older sibling, and the unsafe adult’s close friend.',
      'محفوظ مددگار ترتیب دیں: والدین، استاد/کونسلر، بڑا بہن بھائی، اور غیر محفوظ بڑے کا قریبی دوست۔',
      choices: [
        yes('parent', 'Ammi or Baba', 'امی یا ابو'),
        yes('teacher', 'Teacher or school counsellor', 'استاد یا اسکول کونسلر'),
        yes('sibling', 'Older sibling', 'بڑا بہن بھائی'),
        partial(
          'friend',
          'Uncle Hamza’s close friend',
          'انکل حمزہ کا قریبی دوست',
          'The unsafe person’s close friend may not be independent. Choose a parent, teacher, counsellor, or another safe adult.',
          'غیر محفوظ شخص کا دوست آزاد مددگار نہ ہو۔ والدین، استاد، کونسلر یا دوسرا محفوظ بڑا چنیں۔',
        ),
      ],
      accepted: ['parent', 'teacher', 'sibling', 'friend'],
      imageAsset: _trustedHelpersArt,
      dimension: 'social',
      sourceRef: 'Scenario 01 Scene 6',
    ),
    node(
      's1_scene7',
      StoryKind.mockVoice,
      'Ammi says, “You look upset. You can tell me anything.” Practise saying who was involved, what happened, and how it felt. You may type or use the demo transcript; no audio is recorded.',
      'امی کہتی ہیں، “آپ پریشان لگتے ہیں۔ مجھے سب بتا سکتے ہیں۔” نام، واقعہ اور احساس بتانے کی مشق کریں۔ لکھیں یا ڈیمو عبارت استعمال کریں؛ آواز ریکارڈ نہیں ہوتی۔',
      scene: 'home',
      character: 'parent',
      imageAsset: _approachAmmiArt,
      dimension: 'communication',
      sourceRef: 'Scenario 01 Scene 7',
    ),
    node(
      's1_scene8',
      StoryKind.info,
      'Ammi believes you: “Thank you for telling me. It was wrong and not your fault—not even a little. I will keep you safe.” If one adult does not listen, tell another.',
      'امی یقین کرتی ہیں: “بتانے کا شکریہ۔ یہ غلط تھا اور آپ کی ذرا بھی غلطی نہیں۔ میں آپ کو محفوظ رکھوں گی۔” اگر ایک بڑا نہ سنے تو دوسرے کو بتائیں۔',
      scene: 'home',
      character: 'parent',
      imageAsset: _trustedAdultArt,
      sourceRef: 'Scenario 01 Scene 8',
    ),
    node(
      's1_scene8_comfort',
      StoryKind.info,
      'Ammi stays close and offers comfort that you want. Safe comfort feels caring, is never secret, and can stop whenever you want.',
      'امی قریب رہتی ہیں اور ایسا دلاسہ دیتی ہیں جو آپ چاہتے ہیں۔ محفوظ دلاسہ خیال رکھنے والا ہوتا ہے، کبھی راز نہیں ہوتا، اور آپ جب چاہیں اسے روک سکتے ہیں۔',
      scene: 'home',
      character: 'parent',
      imageAsset: _comfortArt,
      sourceRef: 'Scenario 01 trusted-adult comfort extension',
    ),
    node(
      's1_scene9',
      StoryKind.choice,
      'What should the safe adult do next?',
      'محفوظ بڑے کو اب کیا کرنا چاہیے؟',
      choices: [
        retry(
          'private',
          'Confront the unsafe adult alone',
          'غیر محفوظ بڑے کا اکیلے سامنا کریں',
          'Confronting alone may increase danger. Keep the child separate and seek qualified local help.',
          'اکیلے سامنا خطرہ بڑھا سکتا ہے۔ بچے کو الگ محفوظ رکھیں اور مستند مقامی مدد لیں۔',
        ),
        yes(
          'report',
          'Keep the child safe and contact appropriate local protection or police support',
          'بچے کو محفوظ رکھیں اور مناسب مقامی حفاظتی یا پولیس مدد لیں',
        ),
        retry(
          'quiet',
          'Keep it inside the family',
          'بات خاندان میں چھپا دیں',
          'Silence protects the unsafe person, not the child.',
          'خاموشی غیر محفوظ شخص کو بچاتی ہے، بچے کو نہیں۔',
        ),
      ],
      imageAsset: _protectiveCallArt,
      dimension: 'safety',
      sourceRef: 'Scenario 01 Scene 9',
    ),
    node(
      's1_scene10',
      StoryKind.terminal,
      'Remember: your body belongs to you; “no” applies even with elders; move away; and always tell a trusted adult. Unsafe touch is never your fault.',
      'یاد رکھیں: آپ کا جسم آپ کا ہے؛ بڑوں کو بھی “نہیں” کہہ سکتے ہیں؛ دور جائیں؛ اور قابلِ اعتماد بڑے کو ضرور بتائیں۔ غیر محفوظ لمس آپ کی غلطی نہیں۔',
      imageAsset: _hopefulFinalArt,
      sourceRef: 'Scenario 01 Scene 10',
    ),
  ],
);
