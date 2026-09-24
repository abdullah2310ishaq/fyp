import 'package:flutter/material.dart';

import '../models/story.dart';
import 'expanded_scenarios.dart';

const _guide = LocalText('Dost', 'دوست');
const _you = LocalText('You', 'آپ');
const _narrator = LocalText('Story', 'کہانی');

StoryChoice _choice(
  String id,
  String en,
  String ur,
  ChoiceQuality quality, {
  String? coachingEn,
  String? coachingUr,
}) => StoryChoice(
  id: id,
  text: LocalText(en, ur),
  quality: quality,
  coaching: coachingEn == null
      ? null
      : LocalText(coachingEn, coachingUr ?? coachingEn),
);

List<StoryStep> _story({
  required String id,
  required String scene,
  required LocalText opening,
  required LocalText lesson,
  required LocalText question,
  required List<StoryChoice> choices,
  required LocalText practice,
  required LocalText ending,
  StoryKind practiceKind = StoryKind.text,
  String character = 'peer',
}) => [
  StoryStep(
    id: '${id}_welcome',
    kind: StoryKind.dialogue,
    speaker: _guide,
    text: opening,
    scene: scene,
  ),
  StoryStep(
    id: '${id}_feeling',
    kind: StoryKind.feeling,
    speaker: _guide,
    text: const LocalText(
      'How does this situation make you feel?',
      'اس صورتحال میں آپ کیسا محسوس کرتے ہیں؟',
    ),
    scene: scene,
  ),
  StoryStep(
    id: '${id}_lesson',
    kind: StoryKind.info,
    speaker: _guide,
    text: lesson,
    scene: scene,
  ),
  StoryStep(
    id: '${id}_choice',
    kind: StoryKind.choice,
    speaker: _narrator,
    text: question,
    choices: choices,
    scene: scene,
    character: character,
  ),
  StoryStep(
    id: '${id}_practice',
    kind: practiceKind,
    speaker: _you,
    text: practice,
    scene: scene,
  ),
  StoryStep(
    id: '${id}_end',
    kind: StoryKind.terminal,
    speaker: _guide,
    text: ending,
    scene: scene,
  ),
];

final scenarios = expandedScenarios;

final compactScenarios = <LifeScenario>[
  LifeScenario(
    id: 's1',
    title: const LocalText('My Body, My Rules', 'میرا جسم، میرے اصول'),
    category: const LocalText('Body Safety', 'جسمانی حفاظت'),
    description: const LocalText(
      'Practice trusting your feelings, saying no, and telling a safe adult.',
      'اپنے احساس پر بھروسہ، صاف انکار اور محفوظ بڑے کو بتانے کی مشق کریں۔',
    ),
    practice: const [
      LocalText('Use a clear “No”', 'صاف “نہیں” کہیں'),
      LocalText('Move to a safe place', 'محفوظ جگہ جائیں'),
      LocalText('Tell a trusted adult', 'قابلِ اعتماد بڑے کو بتائیں'),
    ],
    icon: Icons.health_and_safety_rounded,
    color: const Color(0xFF2A9D8F),
    isFree: true,
    steps: _story(
      id: 's1',
      scene: 'home',
      opening: const LocalText(
        'Assalam-o-Alaikum! I’m Dost. We will practise what to do when a touch or secret feels uncomfortable. Nothing here is your fault.',
        'السلام علیکم! میں دوست ہوں۔ ہم سیکھیں گے کہ بے آرام لمس یا راز کی صورت میں کیا کرنا ہے۔ اس میں آپ کی کوئی غلطی نہیں۔',
      ),
      lesson: const LocalText(
        'Your body belongs to you. Private parts are covered by a swimsuit. You can say no to anyone, move away, and keep telling safe adults until someone helps.',
        'آپ کا جسم آپ کا ہے۔ نجی حصے سوئمنگ سوٹ سے ڈھکے ہوتے ہیں۔ آپ کسی کو بھی انکار کر سکتے ہیں، دور جا سکتے ہیں اور مدد ملنے تک محفوظ بڑوں کو بتاتے رہیں۔',
      ),
      question: const LocalText(
        'A relative asks you to keep an uncomfortable touch secret. What do you do first?',
        'ایک رشتہ دار بے آرام لمس کو راز رکھنے کو کہتا ہے۔ آپ پہلے کیا کریں گے؟',
      ),
      choices: [
        _choice(
          'tell',
          'Say “No”, move away, and tell Ammi, Baba, or a teacher',
          '“نہیں” کہیں، دور جائیں اور امی، ابو یا استاد کو بتائیں',
          ChoiceQuality.best,
        ),
        _choice(
          'wait',
          'Wait to see if it happens again',
          'دوبارہ ہونے کا انتظار کریں',
          ChoiceQuality.okay,
          coachingEn:
              'You deserve safety now, not later. Move away and tell a trusted adult.',
          coachingUr:
              'آپ ابھی محفوظ رہنے کے حقدار ہیں۔ دور جائیں اور قابلِ اعتماد بڑے کو بتائیں۔',
        ),
        _choice(
          'secret',
          'Keep the secret so nobody is upset',
          'راز رکھیں تاکہ کوئی ناراض نہ ہو',
          ChoiceQuality.tryAgain,
          coachingEn:
              'Unsafe secrets should never be kept. A safe adult will want to help you.',
          coachingUr:
              'غیر محفوظ راز کبھی نہیں رکھنا چاہیے۔ محفوظ بڑا آپ کی مدد کرنا چاہے گا۔',
        ),
      ],
      practice: const LocalText(
        'Practise telling a safe adult. Type one sentence, or use the guided example below.',
        'محفوظ بڑے کو بتانے کی مشق کریں۔ ایک جملہ لکھیں یا نیچے دی گئی مثال استعمال کریں۔',
      ),
      ending: const LocalText(
        'You were brave. Remember: say no, move away, and tell a safe adult. If one adult does not help, tell another.',
        'آپ بہادر تھے۔ یاد رکھیں: انکار کریں، دور جائیں، اور محفوظ بڑے کو بتائیں۔ اگر ایک مدد نہ کرے تو دوسرے کو بتائیں۔',
      ),
    ),
  ),
  LifeScenario(
    id: 's2',
    title: const LocalText('The Lunch-Time Bully', 'دوپہر کا بدمعاش'),
    category: const LocalText('Bullying', 'بدمعاشی'),
    description: const LocalText(
      'Respond safely to repeated bullying and ask school adults for support.',
      'بار بار بدمعاشی کا محفوظ جواب دیں اور اسکول کے بڑوں سے مدد مانگیں۔',
    ),
    practice: const [
      LocalText('Stay near safe people', 'محفوظ لوگوں کے قریب رہیں'),
      LocalText('Report clear details', 'واضح تفصیل بتائیں'),
      LocalText('Keep asking for help', 'مدد مانگتے رہیں'),
    ],
    icon: Icons.school_rounded,
    color: const Color(0xFF5D78C8),
    isFree: false,
    steps: _story(
      id: 's2',
      scene: 'school',
      character: 'peer',
      opening: const LocalText(
        'A student has taken your lunch money more than once. Let’s practise a calm, safe response.',
        'ایک طالب علم ایک سے زیادہ بار آپ کے دوپہر کے پیسے لے چکا ہے۔ آئیے پرسکون اور محفوظ جواب کی مشق کریں۔',
      ),
      lesson: const LocalText(
        'Bullying is repeated hurtful behaviour with a power difference. It is not your fault, and reporting is not “telling tales.”',
        'بدمعاشی طاقت کے فرق کے ساتھ بار بار تکلیف دہ رویہ ہے۔ یہ آپ کی غلطی نہیں اور اطلاع دینا شکایت بازی نہیں۔',
      ),
      question: const LocalText(
        'The student blocks your way again. What is the safest next step?',
        'طالب علم دوبارہ راستہ روکتا ہے۔ سب سے محفوظ اگلا قدم کیا ہے؟',
      ),
      choices: [
        _choice(
          'teacher',
          'Say “Stop”, move toward others, and tell a teacher',
          '“رکو” کہیں، دوسروں کی طرف جائیں اور استاد کو بتائیں',
          ChoiceQuality.best,
        ),
        _choice(
          'money',
          'Give the money and say nothing',
          'پیسے دے کر خاموش رہیں',
          ChoiceQuality.okay,
          coachingEn:
              'Getting away is understandable, but an adult needs the full story to stop the pattern.',
          coachingUr:
              'دور ہونا سمجھ میں آتا ہے، مگر اس سلسلے کو روکنے کے لیے بڑے کو پوری بات بتانا ضروری ہے۔',
        ),
        _choice(
          'fight',
          'Push back and start a fight',
          'دھکا دیں اور لڑائی شروع کریں',
          ChoiceQuality.tryAgain,
          coachingEn:
              'Fighting can put you in more danger. Create distance and get a school adult.',
          coachingUr:
              'لڑائی آپ کو مزید خطرے میں ڈال سکتی ہے۔ فاصلہ بنائیں اور اسکول کے بڑے کو بلائیں۔',
        ),
      ],
      practice: const LocalText(
        'Tell Miss Fatima what happened, who was there, and that it has happened before.',
        'مس فاطمہ کو بتائیں کہ کیا ہوا، کون موجود تھا، اور یہ پہلے بھی ہو چکا ہے۔',
      ),
      ending: const LocalText(
        'Strong choices can be calm choices. Stay with safe people, report every new incident, and keep your family informed.',
        'مضبوط فیصلے پرسکون بھی ہو سکتے ہیں۔ محفوظ لوگوں کے ساتھ رہیں، ہر نئے واقعے کی اطلاع دیں اور گھر والوں کو بتاتے رہیں۔',
      ),
    ),
  ),
  LifeScenario(
    id: 's3',
    title: const LocalText('A Ride from a Stranger', 'اجنبی کی سواری'),
    category: const LocalText('Stranger Safety', 'اجنبی سے حفاظت'),
    description: const LocalText(
      'Practise distance, a loud voice, and finding an identifiable safe helper.',
      'فاصلہ، بلند آواز اور پہچانے جانے والے محفوظ مددگار کی مشق کریں۔',
    ),
    practice: const [
      LocalText('Keep distance', 'فاصلہ رکھیں'),
      LocalText('Be loud if needed', 'ضرورت پر بلند آواز کریں'),
      LocalText('Find a safe helper', 'محفوظ مددگار تلاش کریں'),
    ],
    icon: Icons.directions_walk_rounded,
    color: const Color(0xFFE69A3B),
    isFree: false,
    steps: _story(
      id: 's3',
      scene: 'road',
      character: 'stranger',
      opening: const LocalText(
        'You are waiting near the school gate. An unfamiliar adult offers you a ride.',
        'آپ اسکول کے گیٹ کے قریب انتظار کر رہے ہیں۔ ایک ناواقف بڑا آپ کو سواری کی پیشکش کرتا ہے۔',
      ),
      lesson: const LocalText(
        'A safe adult will not ask a child to break a family safety rule. Keep two big steps away and never go near a vehicle.',
        'محفوظ بڑا بچے کو گھر کے حفاظتی اصول توڑنے کو نہیں کہے گا۔ دو بڑے قدم دور رہیں اور گاڑی کے قریب نہ جائیں۔',
      ),
      question: const LocalText(
        'The adult says your parent sent him and steps closer. What do you do?',
        'بڑا کہتا ہے کہ آپ کے والدین نے بھیجا ہے اور قریب آتا ہے۔ آپ کیا کریں گے؟',
      ),
      choices: [
        _choice(
          'shop',
          'Move into the school/shop and call your parent with a safe adult',
          'اسکول/دکان کے اندر جائیں اور محفوظ بڑے کے ساتھ والدین کو فون کریں',
          ChoiceQuality.best,
        ),
        _choice(
          'ask',
          'Walk closer and ask for proof',
          'قریب جا کر ثبوت مانگیں',
          ChoiceQuality.okay,
          coachingEn:
              'Check from a safe place. Do not move closer to a person or vehicle.',
          coachingUr: 'محفوظ جگہ سے تصدیق کریں۔ شخص یا گاڑی کے قریب نہ جائیں۔',
        ),
        _choice(
          'ride',
          'Get in because he knows your name',
          'بیٹھ جائیں کیونکہ وہ آپ کا نام جانتا ہے',
          ChoiceQuality.tryAgain,
          coachingEn:
              'Knowing your name does not prove someone is safe. Move toward known adults now.',
          coachingUr:
              'آپ کا نام جاننا محفوظ ہونے کا ثبوت نہیں۔ فوراً پہچانے ہوئے بڑوں کی طرف جائیں۔',
        ),
      ],
      practice: const LocalText(
        'Practise a strong phrase: “I don’t know you. Stay back. I’m calling my parent.”',
        'مضبوط جملے کی مشق کریں: “میں آپ کو نہیں جانتا۔ دور رہیں۔ میں والدین کو فون کر رہا ہوں۔”',
      ),
      ending: const LocalText(
        'Distance gives you time. Go toward people, make noise, and ask a uniformed worker, teacher, or family for help.',
        'فاصلہ آپ کو وقت دیتا ہے۔ لوگوں کی طرف جائیں، آواز کریں اور وردی والے کارکن، استاد یا خاندان سے مدد مانگیں۔',
      ),
    ),
  ),
  LifeScenario(
    id: 's4',
    title: const LocalText('The New Gaming Friend', 'نیا گیمنگ دوست'),
    category: const LocalText('Online Safety', 'آن لائن حفاظت'),
    description: const LocalText(
      'Spot warning signs, save evidence, block, report, and tell an adult.',
      'خطرے کی نشانیاں پہچانیں، ثبوت محفوظ کریں، بلاک و رپورٹ کریں اور بڑے کو بتائیں۔',
    ),
    practice: const [
      LocalText('Protect private info', 'نجی معلومات بچائیں'),
      LocalText('Save evidence', 'ثبوت محفوظ کریں'),
      LocalText('Block and tell', 'بلاک کریں اور بتائیں'),
    ],
    icon: Icons.phonelink_lock_rounded,
    color: const Color(0xFF7B62A3),
    isFree: false,
    steps: _story(
      id: 's4',
      scene: 'online',
      character: 'online',
      opening: const LocalText(
        'A gaming account asks for your school, photo, and private chat. Then it threatens to share messages.',
        'ایک گیمنگ اکاؤنٹ آپ کا اسکول، تصویر اور نجی چیٹ مانگتا ہے۔ پھر پیغامات شیئر کرنے کی دھمکی دیتا ہے۔',
      ),
      lesson: const LocalText(
        'Pressure, secrecy, gifts, personal questions, and threats are warning signs. You are not in trouble for asking for help.',
        'دباؤ، رازداری، تحفے، ذاتی سوال اور دھمکیاں خطرے کی نشانیاں ہیں۔ مدد مانگنے پر آپ مشکل میں نہیں پڑتے۔',
      ),
      question: const LocalText(
        'What should you do before blocking the account?',
        'اکاؤنٹ بلاک کرنے سے پہلے کیا کرنا چاہیے؟',
      ),
      choices: [
        _choice(
          'evidence',
          'Do not reply; save screenshots, then block, report, and tell a parent',
          'جواب نہ دیں؛ اسکرین شاٹ لیں، پھر بلاک، رپورٹ اور والدین کو بتائیں',
          ChoiceQuality.best,
        ),
        _choice(
          'delete',
          'Delete the chat quickly',
          'چیٹ فوراً حذف کر دیں',
          ChoiceQuality.okay,
          coachingEn:
              'Deleting may remove useful evidence. Save the full conversation first.',
          coachingUr:
              'حذف کرنے سے ضروری ثبوت ضائع ہو سکتا ہے۔ پہلے پوری گفتگو محفوظ کریں۔',
        ),
        _choice(
          'photo',
          'Send a photo so the threat stops',
          'دھمکی روکنے کے لیے تصویر بھیجیں',
          ChoiceQuality.tryAgain,
          coachingEn:
              'Never send more. Stop replying and bring a trusted adult to the screen.',
          coachingUr:
              'مزید کچھ نہ بھیجیں۔ جواب بند کریں اور قابلِ اعتماد بڑے کو اسکرین دکھائیں۔',
        ),
      ],
      practice: const LocalText(
        'Practise explaining the username, platform, messages, threat, and screenshots to a parent.',
        'والدین کو یوزرنیم، پلیٹ فارم، پیغامات، دھمکی اور اسکرین شاٹس بتانے کی مشق کریں۔',
      ),
      ending: const LocalText(
        'You protected the evidence and brought in help. A new account gets the same response: screenshot, block, report, tell.',
        'آپ نے ثبوت محفوظ کیا اور مدد لی۔ نئے اکاؤنٹ پر بھی یہی کریں: اسکرین شاٹ، بلاک، رپورٹ، اور بتائیں۔',
      ),
    ),
  ),
  ..._extraScenarios,
];

final _extraScenarios = <LifeScenario>[
  LifeScenario(
    id: 's5',
    title: const LocalText('Just Try It', 'بس آزما کر دیکھو'),
    category: const LocalText('Peer Pressure', 'ساتھیوں کا دباؤ'),
    description: const LocalText(
      'Use confident refusal skills when friends pressure you.',
      'دوستوں کے دباؤ میں پراعتماد انکار سیکھیں۔',
    ),
    practice: const [
      LocalText('Say no clearly', 'صاف انکار کریں'),
      LocalText('Offer another plan', 'دوسرا منصوبہ دیں'),
      LocalText('Leave if pressure continues', 'دباؤ جاری ہو تو چلے جائیں'),
    ],
    icon: Icons.groups_rounded,
    color: const Color(0xFFDE6D83),
    isFree: false,
    steps: _story(
      id: 's5',
      scene: 'park',
      character: 'peer',
      opening: const LocalText(
        'Friends dare you to take something from a shop “just for fun.”',
        'دوست آپ کو “صرف مزے کے لیے” دکان سے چیز اٹھانے کا چیلنج دیتے ہیں۔',
      ),
      lesson: const LocalText(
        'A real friend respects your no. You do not need a long explanation to protect your values.',
        'سچا دوست آپ کے انکار کا احترام کرتا ہے۔ اپنے اصول بچانے کے لیے لمبی وضاحت ضروری نہیں۔',
      ),
      question: const LocalText(
        'They laugh and pressure you again. What do you do?',
        'وہ ہنستے ہیں اور دوبارہ دباؤ ڈالتے ہیں۔ آپ کیا کریں گے؟',
      ),
      choices: [
        _choice(
          'leave',
          'Say “No. I’m not doing that,” suggest football, and leave if needed',
          'کہیں “نہیں، میں یہ نہیں کروں گا”، فٹ بال تجویز کریں اور ضرورت پر چلے جائیں',
          ChoiceQuality.best,
        ),
        _choice(
          'maybe',
          'Say “maybe later”',
          'کہیں “شاید بعد میں”',
          ChoiceQuality.okay,
          coachingEn:
              'A clear no closes the pressure. You can be kind and firm.',
          coachingUr:
              'صاف انکار دباؤ ختم کرتا ہے۔ آپ مہربان اور مضبوط دونوں ہو سکتے ہیں۔',
        ),
        _choice(
          'join',
          'Do it so they still like you',
          'کریں تاکہ وہ آپ کو پسند کرتے رہیں',
          ChoiceQuality.tryAgain,
          coachingEn:
              'Belonging should not cost your safety or values. Step away and contact a safe person.',
          coachingUr:
              'ساتھ رہنے کی قیمت آپ کی حفاظت یا اصول نہیں ہونے چاہئیں۔ دور جائیں اور محفوظ شخص سے رابطہ کریں۔',
        ),
      ],
      practice: const LocalText(
        'Write your short, confident refusal sentence.',
        'اپنا مختصر اور پراعتماد انکاری جملہ لکھیں۔',
      ),
      ending: const LocalText(
        'Your “no” is complete. Good friends respect boundaries; support is always available.',
        'آپ کا “نہیں” مکمل جواب ہے۔ اچھے دوست حدود کا احترام کرتے ہیں؛ مدد ہمیشہ موجود ہے۔',
      ),
    ),
  ),
  LifeScenario(
    id: 's6',
    title: const LocalText('The Big Feelings', 'بڑے احساسات'),
    category: const LocalText('Emotional Regulation', 'جذباتی توازن'),
    description: const LocalText(
      'Pause, name the feeling, and choose a calming action.',
      'رکیں، احساس کا نام دیں، اور پرسکون عمل چنیں۔',
    ),
    practice: const [
      LocalText('Pause', 'رکیں'),
      LocalText('Breathe and notice', 'سانس لیں اور غور کریں'),
      LocalText('Ask for support', 'مدد مانگیں'),
    ],
    icon: Icons.self_improvement_rounded,
    color: const Color(0xFF3B9AC7),
    isFree: false,
    steps: _story(
      id: 's6',
      scene: 'home',
      character: 'guide',
      opening: const LocalText(
        'A difficult homework problem leaves your body tense and your thoughts racing.',
        'مشکل ہوم ورک سے جسم تناؤ اور خیالات تیز ہو جاتے ہیں۔',
      ),
      lesson: const LocalText(
        'Feelings are not wrong and their size is never scored. A pause helps your thinking brain come back online.',
        'احساسات غلط نہیں اور ان کی شدت پر نمبر نہیں ملتے۔ وقفہ سوچنے والے دماغ کو واپس مدد دیتا ہے۔',
      ),
      question: const LocalText(
        'What is a helpful first response?',
        'پہلا مددگار ردعمل کیا ہے؟',
      ),
      choices: [
        _choice(
          'pause',
          'Put the pencil down, take five slow breaths, and ask for help',
          'پنسل رکھیں، پانچ آہستہ سانس لیں، اور مدد مانگیں',
          ChoiceQuality.best,
        ),
        _choice(
          'quit',
          'Hide the homework and avoid it',
          'ہوم ورک چھپا دیں اور بچیں',
          ChoiceQuality.okay,
          coachingEn:
              'A short pause can help; avoiding it keeps the worry waiting.',
          coachingUr: 'مختصر وقفہ مدد دیتا ہے؛ بچنے سے پریشانی باقی رہتی ہے۔',
        ),
        _choice(
          'throw',
          'Throw the book and shout at someone',
          'کتاب پھینکیں اور کسی پر چلائیں',
          ChoiceQuality.tryAgain,
          coachingEn:
              'Big feelings need space without hurting people or things. Pause and reset safely.',
          coachingUr:
              'بڑے احساسات کو جگہ چاہیے مگر لوگوں یا چیزوں کو نقصان نہیں۔ محفوظ وقفہ لیں۔',
        ),
      ],
      practice: const LocalText(
        'Follow the breathing orb: in… hold… and out slowly.',
        'سانس کے دائرے کے ساتھ چلیں: اندر… روکیں… اور آہستہ باہر۔',
      ),
      ending: const LocalText(
        'You noticed, paused, and chose support. That is a skill you can practise—not a test you can fail.',
        'آپ نے محسوس کیا، رکے، اور مدد چنی۔ یہ مشق کی مہارت ہے، ناکامی کا امتحان نہیں۔',
      ),
      practiceKind: StoryKind.feeling,
    ),
  ),
  LifeScenario(
    id: 's7',
    title: const LocalText('Lost in the Market', 'بازار میں گم'),
    category: const LocalText('Emergency Response', 'ہنگامی ردعمل'),
    description: const LocalText(
      'Find safe help and reunite with family without wandering.',
      'محفوظ مدد تلاش کریں اور بھٹکے بغیر خاندان سے ملیں۔',
    ),
    practice: const [
      LocalText('Stop and look', 'رکیں اور دیکھیں'),
      LocalText('Find staff/family', 'عملہ/خاندان تلاش کریں'),
      LocalText('Wait safely', 'محفوظ انتظار کریں'),
    ],
    icon: Icons.local_mall_rounded,
    color: const Color(0xFF5A9E6F),
    isFree: false,
    steps: _story(
      id: 's7',
      scene: 'market',
      character: 'worker',
      opening: const LocalText(
        'You look up in a busy market and cannot see your family.',
        'مصروف بازار میں آپ کو اپنا خاندان نظر نہیں آتا۔',
      ),
      lesson: const LocalText(
        'Stop moving. Find a uniformed worker, security desk, or a parent with children. Never leave with an unknown person.',
        'چلنا روک دیں۔ وردی والے کارکن، سیکیورٹی ڈیسک یا بچوں والے والدین کو تلاش کریں۔ نامعلوم شخص کے ساتھ نہ جائیں۔',
      ),
      question: const LocalText(
        'What is the safest plan?',
        'سب سے محفوظ منصوبہ کیا ہے؟',
      ),
      choices: [
        _choice(
          'desk',
          'Go to the nearby information desk and ask them to call your family',
          'قریب معلوماتی ڈیسک پر جائیں اور خاندان کو بلانے کو کہیں',
          ChoiceQuality.best,
        ),
        _choice(
          'search',
          'Run through the market looking everywhere',
          'بازار میں ہر طرف دوڑ کر تلاش کریں',
          ChoiceQuality.okay,
          coachingEn:
              'Moving farther makes it harder to reunite. Stop and use an identifiable helper.',
          coachingUr:
              'زیادہ دور جانے سے ملنا مشکل ہوتا ہے۔ رکیں اور پہچانے جانے والے مددگار کو بلائیں۔',
        ),
        _choice(
          'car',
          'Go outside with a stranger who offers help',
          'مدد کی پیشکش کرنے والے اجنبی کے ساتھ باہر جائیں',
          ChoiceQuality.tryAgain,
          coachingEn:
              'Stay in the public place. A safe helper can bring help to you.',
          coachingUr: 'عوامی جگہ میں رہیں۔ محفوظ مددگار مدد آپ تک لا سکتا ہے۔',
        ),
      ],
      practice: const LocalText(
        'Practise saying your first name, your guardian’s name, and “I am lost.” Never enter real personal details here.',
        'اپنا پہلا نام، سرپرست کا نام اور “میں گم ہو گیا ہوں” کہنا سیکھیں۔ یہاں حقیقی ذاتی معلومات نہ لکھیں۔',
      ),
      ending: const LocalText(
        'You stopped, found visible help, and waited safely. That makes reunions faster.',
        'آپ رکے، واضح مدد تلاش کی، اور محفوظ انتظار کیا۔ اس سے خاندان جلد ملتا ہے۔',
      ),
    ),
  ),
  LifeScenario(
    id: 's8',
    title: const LocalText('A Secret at Home', 'گھر کا راز'),
    category: const LocalText(
      'Home & Family Safety',
      'گھر اور خاندان کی حفاظت',
    ),
    description: const LocalText(
      'Find support outside an unsafe situation and keep telling.',
      'غیر محفوظ صورتحال سے باہر مدد لیں اور بتاتے رہیں۔',
    ),
    practice: const [
      LocalText('Notice unsafe behaviour', 'غیر محفوظ رویہ پہچانیں'),
      LocalText('Make a safe exit', 'محفوظ راستہ بنائیں'),
      LocalText('Tell another adult', 'دوسرے بڑے کو بتائیں'),
    ],
    icon: Icons.home_rounded,
    color: const Color(0xFFB46A5C),
    isFree: false,
    steps: _story(
      id: 's8',
      scene: 'home',
      character: 'adult',
      opening: const LocalText(
        'Someone at home shouts, breaks things, and tells you never to tell anyone.',
        'گھر میں کوئی چیختا، چیزیں توڑتا، اور کسی کو نہ بتانے کو کہتا ہے۔',
      ),
      lesson: const LocalText(
        'You did not cause an adult’s unsafe behaviour. Do not step into a fight. Move toward a safe exit or known neighbour when you can.',
        'بڑے کے غیر محفوظ رویے کی وجہ آپ نہیں۔ لڑائی میں نہ جائیں۔ موقع ملے تو محفوظ راستے یا پہچانے پڑوسی کی طرف جائیں۔',
      ),
      question: const LocalText(
        'The shouting begins again. What should you do?',
        'چیخنا دوبارہ شروع ہوتا ہے۔ آپ کیا کریں گے؟',
      ),
      choices: [
        _choice(
          'exit',
          'Take your safe exit and contact a trusted adult outside the situation',
          'محفوظ راستہ لیں اور صورتحال سے باہر قابلِ اعتماد بڑے سے رابطہ کریں',
          ChoiceQuality.best,
        ),
        _choice(
          'stop',
          'Stand between the adults and make them stop',
          'بڑوں کے درمیان کھڑے ہو کر روکیں',
          ChoiceQuality.okay,
          coachingEn:
              'It is not your job to physically stop adults. Protect your own space and get help.',
          coachingUr:
              'بڑوں کو جسمانی طور پر روکنا آپ کی ذمہ داری نہیں۔ اپنی جگہ محفوظ کریں اور مدد لیں۔',
        ),
        _choice(
          'hide',
          'Keep the secret forever',
          'راز ہمیشہ رکھیں',
          ChoiceQuality.tryAgain,
          coachingEn:
              'Unsafe secrets need outside help. If one adult dismisses you, tell another.',
          coachingUr:
              'غیر محفوظ راز کے لیے باہر کی مدد چاہیے۔ اگر ایک بڑا نہ سنے تو دوسرے کو بتائیں۔',
        ),
      ],
      practice: const LocalText(
        'Choose a trusted adult outside the unsafe situation and practise asking them for help.',
        'غیر محفوظ صورتحال سے باہر قابلِ اعتماد بڑا چنیں اور مدد مانگنے کی مشق کریں۔',
      ),
      ending: const LocalText(
        'Your safety matters. Leave when safe, call a trusted adult, and keep telling until someone helps.',
        'آپ کی حفاظت اہم ہے۔ محفوظ وقت پر نکلیں، قابلِ اعتماد بڑے کو بلائیں، اور مدد ملنے تک بتاتے رہیں۔',
      ),
    ),
  ),
];
