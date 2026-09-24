import 'package:flutter/material.dart';

import '../core/life_theme.dart';

class BodySafetyActivity extends StatefulWidget {
  const BodySafetyActivity({
    super.key,
    required this.isUrdu,
    required this.onComplete,
  });

  final bool isUrdu;
  final Future<void> Function(List<String> selectedIds, bool correct)
  onComplete;

  @override
  State<BodySafetyActivity> createState() => _BodySafetyActivityState();
}

class _BodySafetyActivityState extends State<BodySafetyActivity> {
  final Set<String> selectedZones = {};
  String? judgement;
  String? feedback;
  String? lastZone;
  bool coachingShown = false;
  bool submitting = false;

  String tr(String en, String ur) => widget.isUrdu ? ur : en;

  static const zoneLabels = {
    'head_face': ('Head / face', 'سر / چہرہ'),
    'chest_tummy': ('Chest / tummy', 'سینہ / پیٹ'),
    'arms_hands': ('Arms / hands', 'بازو / ہاتھ'),
    'shoulder_back': ('Shoulder / back', 'کندھا / کمر'),
    'swimsuit_area': ('Swimsuit-covered area', 'سوئمنگ سوٹ سے ڈھکا حصہ'),
    'legs_feet': ('Legs / feet', 'ٹانگیں / پاؤں'),
  };

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF4),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE5ECE8)),
        ),
        child: Column(
          children: [
            Text(
              tr(
                'Explore every circle. Tap again to remove a selection.',
                'ہر دائرہ دیکھیں۔ انتخاب ہٹانے کے لیے دوبارہ دبائیں۔',
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            LayoutBuilder(
              builder: (context, outerConstraints) {
                final mapWidth = outerConstraints.maxWidth > 280
                    ? 280.0
                    : outerConstraints.maxWidth;
                return Center(
                  child: SizedBox(
                    width: mapWidth,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                tr('Front', 'سامنے'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                tr('Back', 'پیچھے'),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        AspectRatio(
                          aspectRatio: 2 / 3,
                          child: LayoutBuilder(
                            builder: (context, constraints) => Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/scenarios/s1/s1_body_map.png',
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.medium,
                                ),
                                _zone(
                                  constraints,
                                  id: 'head_face',
                                  left: .17,
                                  top: .12,
                                  width: .20,
                                  height: .15,
                                ),
                                _zone(
                                  constraints,
                                  id: 'chest_tummy',
                                  left: .18,
                                  top: .32,
                                  width: .22,
                                  height: .20,
                                ),
                                _zone(
                                  constraints,
                                  id: 'arms_hands',
                                  left: .03,
                                  top: .37,
                                  width: .13,
                                  height: .27,
                                ),
                                _zone(
                                  constraints,
                                  id: 'shoulder_back',
                                  left: .57,
                                  top: .28,
                                  width: .34,
                                  height: .20,
                                ),
                                _zone(
                                  constraints,
                                  id: 'swimsuit_area',
                                  left: .18,
                                  top: .57,
                                  width: .22,
                                  height: .14,
                                ),
                                _zone(
                                  constraints,
                                  id: 'legs_feet',
                                  left: .15,
                                  top: .73,
                                  width: .28,
                                  height: .20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Text(
        tr('Selected places', 'منتخب حصے'),
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 8),
      if (selectedZones.isEmpty)
        Text(
          tr('Tap the circles on the child.', 'بچے پر دائروں کو دبائیں۔'),
          style: const TextStyle(color: Colors.black54),
        )
      else
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: selectedZones
              .map(
                (id) => InputChip(
                  label: Text(_label(id)),
                  selected: true,
                  onDeleted: () => _toggleZone(id),
                ),
              )
              .toList(),
        ),
      if (lastZone != null) ...[
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: LifeColors.sky,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _label(lastZone!),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(_zoneGuidance(lastZone!)),
            ],
          ),
        ),
      ],
      const SizedBox(height: 18),
      Text(
        tr('Was the whole situation safe?', 'کیا پوری صورتحال محفوظ تھی؟'),
        style: const TextStyle(fontWeight: FontWeight.w900),
      ),
      const SizedBox(height: 8),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _judgementChip('safe', tr('Safe', 'محفوظ')),
          _judgementChip('unsafe', tr('Unsafe', 'غیر محفوظ')),
          _judgementChip('unsure', tr('Not sure', 'یقین نہیں')),
        ],
      ),
      if (feedback != null) ...[
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF0D4),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(feedback!, style: const TextStyle(height: 1.4)),
        ),
      ],
      const SizedBox(height: 14),
      FilledButton.icon(
        key: const Key('body-map-submit'),
        onPressed: selectedZones.isEmpty || judgement == null || submitting
            ? null
            : _checkAnswer,
        icon: const Icon(Icons.shield_outlined),
        label: Text(
          coachingShown
              ? tr('I understand — continue', 'میں سمجھ گیا/گئی — جاری رکھیں')
              : tr('Check and continue', 'چیک کریں اور جاری رکھیں'),
        ),
      ),
      const SizedBox(height: 8),
      Text(
        tr(
          'A body part alone does not make every touch safe or unsafe. Permission, purpose, feelings, and requests for secrecy all matter.',
          'صرف جسم کا حصہ ہر لمس کو محفوظ یا غیر محفوظ نہیں بناتا۔ اجازت، مقصد، احساسات اور راز رکھنے کی بات سب اہم ہیں۔',
        ),
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black54,
          height: 1.35,
        ),
      ),
    ],
  );

  Widget _zone(
    BoxConstraints constraints, {
    required String id,
    required double left,
    required double top,
    required double width,
    required double height,
  }) {
    final selected = selectedZones.contains(id);
    return Positioned(
      left: constraints.maxWidth * left,
      top: constraints.maxHeight * top,
      width: constraints.maxWidth * width,
      height: constraints.maxHeight * height,
      child: Semantics(
        button: true,
        selected: selected,
        label: _label(id),
        child: Material(
          color: selected
              ? LifeColors.coral.withValues(alpha: .34)
              : Colors.white.withValues(alpha: .16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
            side: BorderSide(
              color: selected ? LifeColors.coral : LifeColors.teal,
              width: selected ? 3 : 2,
            ),
          ),
          child: InkWell(
            key: Key('body-zone-$id'),
            borderRadius: BorderRadius.circular(99),
            onTap: () => _toggleZone(id),
            child: selected
                ? const Icon(Icons.check_rounded, color: LifeColors.navy)
                : const SizedBox.expand(),
          ),
        ),
      ),
    );
  }

  Widget _judgementChip(String value, String label) => ChoiceChip(
    key: Key('body-judgement-$value'),
    label: Text(label),
    selected: judgement == value,
    onSelected: (_) => setState(() {
      judgement = value;
      feedback = null;
      coachingShown = false;
    }),
  );

  String _label(String id) {
    final labels = zoneLabels[id]!;
    return widget.isUrdu ? labels.$2 : labels.$1;
  }

  void _toggleZone(String id) => setState(() {
    selectedZones.contains(id)
        ? selectedZones.remove(id)
        : selectedZones.add(id);
    lastZone = id;
    feedback = null;
    coachingShown = false;
  });

  String _zoneGuidance(String id) => switch (id) {
    'head_face' => tr(
      'Care such as washing or a medical check should be explained, necessary, and supported by a trusted adult. Unwanted, painful, or secret touch is unsafe.',
      'صفائی یا طبی معائنے جیسی دیکھ بھال کی وجہ بتائی جائے، ضروری ہو اور قابلِ اعتماد بڑا ساتھ ہو۔ ناپسندیدہ، تکلیف دہ یا خفیہ لمس غیر محفوظ ہے۔',
    ),
    'chest_tummy' => tr(
      'This is a personal area. Safe care has a clear reason and respects your feelings. You can say stop and tell a trusted adult.',
      'یہ ذاتی حصہ ہے۔ محفوظ دیکھ بھال کی واضح وجہ ہوتی ہے اور آپ کے احساسات کا احترام ہوتا ہے۔ آپ رکنے کو کہہ سکتے ہیں اور قابلِ اعتماد بڑے کو بتا سکتے ہیں۔',
    ),
    'arms_hands' => tr(
      'A wanted handshake or high-five can be safe. Grabbing, hurting, forcing, or asking for secrecy is unsafe.',
      'رضامندی سے ہاتھ ملانا یا ہائی فائیو محفوظ ہو سکتا ہے۔ پکڑنا، تکلیف دینا، مجبور کرنا یا راز کہنا غیر محفوظ ہے۔',
    ),
    'shoulder_back' => tr(
      'A wanted pat may be safe, but context matters. In this story it was part of an unsafe situation that caused discomfort and secrecy.',
      'رضامندی والی تھپکی محفوظ ہو سکتی ہے، مگر صورتحال اہم ہے۔ اس کہانی میں یہ بے آرامی اور راز والی غیر محفوظ صورتحال کا حصہ تھا۔',
    ),
    'swimsuit_area' => tr(
      'Swimsuit-covered areas are private. Health or hygiene care must have a clear reason and safe adult support; secrets or unwanted touch are unsafe.',
      'سوئمنگ سوٹ سے ڈھکے حصے نجی ہیں۔ صحت یا صفائی کی دیکھ بھال کی واضح وجہ اور محفوظ بڑے کی مدد ضروری ہے؛ راز یا ناپسندیدہ لمس غیر محفوظ ہے۔',
    ),
    _ => tr(
      'A wanted, gentle touch may be safe. Kicking, hurting, forcing, or secret touch is unsafe, and you should tell a trusted adult.',
      'رضامندی والا نرم لمس محفوظ ہو سکتا ہے۔ لات مارنا، تکلیف دینا، مجبور کرنا یا خفیہ لمس غیر محفوظ ہے، اور قابلِ اعتماد بڑے کو بتانا چاہیے۔',
    ),
  };

  Future<void> _checkAnswer() async {
    if (coachingShown) {
      await _finish(correct: false);
      return;
    }
    final correctZones =
        selectedZones.contains('shoulder_back') &&
        selectedZones.contains('swimsuit_area');
    if (!correctZones || judgement != 'unsafe') {
      setState(() {
        feedback = tr(
          'Look again: the story described the shoulder/back and the swimsuit-covered area. The whole situation was unsafe because the child felt uncomfortable, a private area was involved, and an adult asked for secrecy.',
          'دوبارہ دیکھیں: کہانی میں کندھے/کمر اور سوئمنگ سوٹ سے ڈھکے حصے کا ذکر تھا۔ پوری صورتحال غیر محفوظ تھی کیونکہ بچہ بے آرام تھا، نجی حصہ شامل تھا اور بڑے نے راز رکھنے کو کہا۔',
        );
        coachingShown = true;
      });
      return;
    }
    await _finish(correct: true);
  }

  Future<void> _finish({required bool correct}) async {
    setState(() => submitting = true);
    await widget.onComplete([
      ...selectedZones,
      'judgement:$judgement',
    ], correct);
    if (mounted) setState(() => submitting = false);
  }
}
