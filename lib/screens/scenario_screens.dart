import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/life_theme.dart';
import '../data/scenario_data.dart';
import '../models/story.dart';
import '../state/app_state.dart';
import '../widgets/life_widgets.dart';

class ScenarioIntroScreen extends StatelessWidget {
  const ScenarioIntroScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final story = scenarios.firstWhere((item) => item.id == id);
    final locked = !state.canOpen(story);
    final ur = state.isUrdu;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: 'Hint — 10 coins',
            onPressed: () async {
              final message = await state.useHint();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
              }
            },
            icon: Badge(
              label: Text('${3 - state.hintsUsed}'),
              isLabelVisible: state.isPremium,
              child: const Icon(Icons.lightbulb_outline_rounded),
            ),
          ),
          IconButton(
            tooltip: 'Get help',
            onPressed: () => showHelpSheet(context),
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: PageWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 210,
                decoration: BoxDecoration(
                  color: story.color.withValues(alpha: .15),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: CircleAvatar(
                        radius: 90,
                        backgroundColor: story.color.withValues(alpha: .12),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: 112,
                        height: 112,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(34),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1522304A),
                              blurRadius: 20,
                              offset: Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(story.icon, size: 62, color: story.color),
                      ),
                    ),
                    if (locked)
                      const Positioned(
                        right: 18,
                        top: 18,
                        child: Pill(icon: Icons.lock_rounded, label: 'Premium'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                story.category.get(ur),
                style: TextStyle(
                  color: story.color,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                story.title.get(ur),
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 12),
              Text(
                story.description.get(ur),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              SoftCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ur ? 'آپ مشق کریں گے' : 'You will practise',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ...story.practice.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: LifeColors.green,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                item.get(ur),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              SoftCard(
                color: const Color(0xFFFFF0D4),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.favorite_rounded, color: LifeColors.coral),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Try this story with a grown-up. You can pause, leave, or open Help at any time. This is practice—not a test of real-life safety.',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () async {
                  if (locked) {
                    context.push('/paywall');
                    return;
                  }
                  await state.startScenario(story.id);
                  if (context.mounted) context.go('/story');
                },
                icon: Icon(
                  locked ? Icons.lock_open_rounded : Icons.play_arrow_rounded,
                ),
                label: Text(
                  locked
                      ? 'Ask a grown-up to unlock'
                      : (ur ? 'کہانی شروع کریں' : 'Start story'),
                ),
              ),
              TextButton.icon(
                onPressed: () => showHelpSheet(context),
                icon: const Icon(Icons.support_agent_rounded),
                label: Text(ur ? 'ابھی مدد چاہیے؟' : 'Need help now?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SimulationScreen extends StatefulWidget {
  const SimulationScreen({super.key});
  @override
  State<SimulationScreen> createState() => _SimulationScreenState();
}

class _SimulationScreenState extends State<SimulationScreen> {
  final textController = TextEditingController();
  final Set<String> selectedIds = {};
  List<StoryChoice> rankedChoices = [];
  String? interactionStepId;
  String? localFeedback;
  int groundingTaps = 0;
  bool listening = false;
  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final story = state.activeScenario;
    final step = state.activeStep;
    if (story == null || step == null) {
      return Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/home'),
            child: const Text('Back to home'),
          ),
        ),
      );
    }
    if (interactionStepId != step.id) {
      interactionStepId = step.id;
      selectedIds.clear();
      rankedChoices = List.of(step.choices);
      textController.clear();
      localFeedback = null;
      groundingTaps = 0;
      listening = false;
    }
    final ur = state.isUrdu;
    final progress = (state.activeStepIndex + 1) / story.steps.length;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Pause and leave',
          onPressed: () => _pause(context),
          icon: const Icon(Icons.close_rounded),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              story.title.get(ur),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900),
            ),
            Text(
              '${state.activeStepIndex + 1} of ${story.steps.length}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Help',
            onPressed: () => showHelpSheet(context),
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(5),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: LifeColors.mint,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 30),
          child: PageWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                StoryStage(
                  scene: step.scene,
                  character: step.character,
                  speaker: step.speaker.get(ur),
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: state.reduceMotion
                      ? Duration.zero
                      : const Duration(milliseconds: 260),
                  child: SoftCard(
                    key: ValueKey(step.id),
                    color: step.speaker == const LocalText('Dost', 'دوست')
                        ? LifeColors.mint
                        : Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: step.speaker.en == 'Dost'
                                  ? LifeColors.teal
                                  : story.color,
                              child: Icon(
                                step.speaker.en == 'Dost'
                                    ? Icons.auto_awesome_rounded
                                    : Icons.chat_bubble_rounded,
                                size: 17,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 9),
                            Text(
                              step.speaker.get(ur),
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                color: LifeColors.tealDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          step.text.get(ur),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (state.coaching != null)
                  _CoachingCard(text: state.coaching!),
                if (state.coaching != null) const SizedBox(height: 12),
                if (localFeedback != null) _CoachingCard(text: localFeedback!),
                if (localFeedback != null) const SizedBox(height: 12),
                _interaction(context, state, story, step),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _interaction(
    BuildContext context,
    AppState state,
    LifeScenario story,
    StoryStep step,
  ) => switch (step.kind) {
    StoryKind.choice => Column(
      children: step.choices.map((choice) {
        final disabled = state.disabledChoices.contains(choice.id);
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: disabled ? null : () => state.choose(choice),
              style: OutlinedButton.styleFrom(
                alignment: AlignmentDirectional.centerStart,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 16,
                ),
                backgroundColor: disabled
                    ? Colors.black.withValues(alpha: .04)
                    : Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(child: Text(choice.text.get(state.isUrdu))),
                  if (disabled) const Icon(Icons.refresh_rounded),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    ),
    StoryKind.checklist => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...step.choices.map(
          (choice) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: CheckboxListTile(
              value: selectedIds.contains(choice.id),
              onChanged: (value) => setState(() {
                value == true
                    ? selectedIds.add(choice.id)
                    : selectedIds.remove(choice.id);
              }),
              title: Text(
                choice.text.get(state.isUrdu),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(
                state.isUrdu
                    ? 'نہیں معلوم ہو تو خالی چھوڑ دیں'
                    : 'Leave unticked if you are not sure',
              ),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          ),
        ),
        FilledButton(
          onPressed: state.nextStep,
          child: Text(
            state.isUrdu
                ? 'ہر جواب قبول ہے — جاری رکھیں'
                : 'Every answer is okay — continue',
          ),
        ),
      ],
    ),
    StoryKind.multiChoice => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...step.choices.map(
          (choice) => Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: CheckboxListTile(
              value: selectedIds.contains(choice.id),
              onChanged: (value) => setState(() {
                value == true
                    ? selectedIds.add(choice.id)
                    : selectedIds.remove(choice.id);
                localFeedback = null;
              }),
              title: Text(
                choice.text.get(state.isUrdu),
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
        FilledButton.icon(
          onPressed: selectedIds.isEmpty
              ? null
              : () async {
                  final expected = step.acceptedChoiceIds.toSet();
                  final correct =
                      selectedIds.length == expected.length &&
                      selectedIds.containsAll(expected);
                  if (!correct) {
                    setState(
                      () => localFeedback = state.isUrdu
                          ? 'اچھی کوشش۔ مکمل محفوظ منصوبے کے لیے انتخاب دوبارہ دیکھیں۔'
                          : 'Good thinking. Review the choices once more for the complete safety plan.',
                    );
                    return;
                  }
                  await state.completeInteraction(correct: true);
                },
          icon: const Icon(Icons.fact_check_rounded),
          label: Text(state.isUrdu ? 'انتخاب چیک کریں' : 'Check my choices'),
        ),
      ],
    ),
    StoryKind.ranking => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: rankedChoices.length,
          onReorderItem: (oldIndex, newIndex) => setState(() {
            final item = rankedChoices.removeAt(oldIndex);
            rankedChoices.insert(newIndex, item);
            localFeedback = null;
          }),
          itemBuilder: (context, index) {
            final choice = rankedChoices[index];
            return Container(
              key: ValueKey(choice.id),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: LifeColors.mint,
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                title: Text(
                  choice.text.get(state.isUrdu),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Move up',
                      onPressed: index == 0
                          ? null
                          : () => setState(() {
                              final item = rankedChoices.removeAt(index);
                              rankedChoices.insert(index - 1, item);
                            }),
                      icon: const Icon(Icons.arrow_upward_rounded),
                    ),
                    const Icon(Icons.drag_handle_rounded),
                    IconButton(
                      tooltip: 'Move down',
                      onPressed: index == rankedChoices.length - 1
                          ? null
                          : () => setState(() {
                              final item = rankedChoices.removeAt(index);
                              rankedChoices.insert(index + 1, item);
                            }),
                      icon: const Icon(Icons.arrow_downward_rounded),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () async {
            final actual = rankedChoices.map((item) => item.id).toList();
            final correct =
                actual.join('|') == step.acceptedChoiceIds.join('|');
            if (!correct) {
              setState(
                () => localFeedback = state.isUrdu
                    ? 'اچھی کوشش۔ سب سے پہلے قابلِ اعتماد مدد اور ثبوت، اور غیر محفوظ انتخاب آخر میں رکھیں۔'
                    : 'Good try. Put trusted support and evidence first, and the unsafe option last.',
              );
              return;
            }
            await state.completeInteraction(correct: true);
          },
          icon: const Icon(Icons.sort_rounded),
          label: Text(state.isUrdu ? 'ترتیب چیک کریں' : 'Check this order'),
        ),
      ],
    ),
    StoryKind.feeling => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SoftCard(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('😌 Calm'),
                  Text('😐 Unsure'),
                  Text('😟 Worried'),
                ],
              ),
              Slider(value: state.feelingValue, onChanged: state.updateFeeling),
              const Text(
                'Every feeling is accepted and unscored.',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(onPressed: state.nextStep, child: const Text('Continue')),
      ],
    ),
    StoryKind.grounding => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SoftCard(
          color: LifeColors.sky,
          child: Column(
            children: [
              Text(
                '${groundingTaps.clamp(0, 5)} / 5',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 9,
                runSpacing: 9,
                alignment: WrapAlignment.center,
                children: List.generate(
                  5,
                  (index) => Semantics(
                    button: true,
                    label: 'Grounding point ${index + 1}',
                    child: InkWell(
                      onTap: index <= groundingTaps
                          ? () => setState(() {
                              if (groundingTaps < 5) groundingTaps += 1;
                            })
                          : null,
                      borderRadius: BorderRadius.circular(99),
                      child: CircleAvatar(
                        radius: 27,
                        backgroundColor: index < groundingTaps
                            ? LifeColors.teal
                            : Colors.white,
                        child: Icon(
                          index < groundingTaps
                              ? Icons.check_rounded
                              : Icons.touch_app_rounded,
                          color: index < groundingTaps
                              ? Colors.white
                              : LifeColors.teal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                state.isUrdu
                    ? 'ہر نقطے پر آہستہ توجہ دیں۔ جلدی ضروری نہیں۔'
                    : 'Notice each point slowly. There is no need to rush.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: groundingTaps < 5 ? null : state.nextStep,
          child: Text(
            state.isUrdu ? 'مکمل — جاری رکھیں' : 'Finished — continue',
          ),
        ),
      ],
    ),
    StoryKind.text || StoryKind.mockVoice => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (step.kind == StoryKind.mockVoice && state.isPremium) ...[
          FilledButton.tonalIcon(
            onPressed: listening
                ? null
                : () async {
                    setState(() => listening = true);
                    await Future<void>.delayed(
                      const Duration(milliseconds: 800),
                    );
                    if (!mounted) return;
                    setState(() {
                      listening = false;
                      textController.text = state.isUrdu
                          ? 'مجھے ایک غیر محفوظ بات بتانی ہے۔ براہِ کرم میری مدد کریں۔'
                          : 'I need to tell you about something unsafe. Please help me.';
                    });
                  },
            icon: Icon(
              listening ? Icons.graphic_eq_rounded : Icons.mic_none_rounded,
            ),
            label: Text(
              listening
                  ? (state.isUrdu ? 'ڈیمو سن رہا ہے…' : 'Demo listening…')
                  : (state.isUrdu ? 'ڈیمو آواز آزمائیں' : 'Try demo voice'),
            ),
          ),
          const SizedBox(height: 10),
        ],
        TextField(
          controller: textController,
          onChanged: (_) => setState(() {}),
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Type a practice sentence (not real personal details)',
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: () => setState(
            () => textController.text =
                'I need to tell you something that made me feel unsafe. Please help me.',
          ),
          icon: const Icon(Icons.lightbulb_outline_rounded),
          label: const Text('Use a guided example'),
        ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: textController.text.trim().isEmpty
              ? null
              : () => state.completeInteraction(correct: true),
          child: const Text('Continue safely'),
        ),
        const SizedBox(height: 8),
        const Text(
          'Demo transcript • No audio is recorded • Practice text is not saved',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    ),
    StoryKind.terminal => FilledButton.icon(
      onPressed: () async {
        final id = story.id;
        final score = await state.completeScenario();
        if (context.mounted) context.go('/debrief/$id/$score');
      },
      icon: const Icon(Icons.celebration_rounded),
      label: const Text('See what I practised'),
    ),
    _ => FilledButton(
      onPressed: state.nextStep,
      child: Text(state.isUrdu ? 'جاری رکھیں' : 'Continue'),
    ),
  };

  Future<void> _pause(BuildContext context) async {
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pause story?'),
        content: const Text(
          'Your place is saved on this device. You can continue from Home anytime.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep playing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save & leave'),
          ),
        ],
      ),
    );
    if (leave == true && context.mounted) context.go('/home');
  }
}

class _CoachingCard extends StatelessWidget {
  const _CoachingCard({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => SoftCard(
    color: const Color(0xFFFFF0D4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: LifeColors.yellow,
          child: Icon(Icons.favorite_rounded, color: LifeColors.navy),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Let’s think again',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 4),
              Text(text),
            ],
          ),
        ),
      ],
    ),
  );
}

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});
  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  bool gatePassed = false;
  bool annual = true;
  final answer = TextEditingController();
  @override
  void dispose() {
    answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Grown-up area')),
    body: SingleChildScrollView(
      child: PageWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!gatePassed) ...[
              const Center(child: LifeLogo(size: 76)),
              const SizedBox(height: 24),
              Text(
                'Ask a grown-up',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              const Text(
                'This simple check helps keep purchase-style controls away from children.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: answer,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'What is 7 + 8?',
                  prefixIcon: Icon(Icons.calculate_rounded),
                ),
              ),
              const SizedBox(height: 14),
              FilledButton(
                onPressed: () {
                  if (answer.text.trim() == '15') {
                    setState(() => gatePassed = true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please ask a grown-up to try again.'),
                      ),
                    );
                  }
                },
                child: const Text('Continue'),
              ),
            ] else ...[
              const Center(
                child: CircleAvatar(
                  radius: 43,
                  backgroundColor: LifeColors.yellow,
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    size: 49,
                    color: LifeColors.navy,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Unlock every practice story',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 10),
              const Text(
                'This is a simulated subscription for the offline FYP demo. No payment or billing occurs.',
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 22),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Monthly • PKR 499')),
                ButtonSegment(value: true, label: Text('Annual • PKR 3,999')),
              ],
              selected: {annual},
              onSelectionChanged: (value) => setState(() => annual = value.first),
            ),
            const SizedBox(height: 12),
            Text(
              annual ? 'Demo selection • Save 33% label only' : 'Demo selection • Cancel anytime label only',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 18),
            const SoftCard(
                color: LifeColors.mint,
                child: Column(
                  children: [
                    _Feature(
                      icon: Icons.menu_book_rounded,
                      text: 'All 8 safety stories',
                    ),
                    _Feature(
                      icon: Icons.translate_rounded,
                      text: 'English and Urdu mode',
                    ),
                    _Feature(
                      icon: Icons.insights_rounded,
                      text: 'Practice history and full breakdown',
                    ),
                    _Feature(
                      icon: Icons.replay_rounded,
                      text: 'Replay and improvement rewards',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: () async {
                  await context.read<AppState>().activatePremium();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Premium demo activated — no charge made.',
                        ),
                      ),
                    );
                    context.go('/home');
                  }
                },
                icon: const Icon(Icons.lock_open_rounded),
                label: const Text('Activate premium demo'),
              ),
              TextButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Demo restore: no real purchase found.'),
                  ),
                ),
                child: const Text('Restore demo purchase'),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, color: LifeColors.teal),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w800),
          ),
        ),
      ],
    ),
  );
}

Future<void> showHelpSheet(BuildContext context) => showModalBottomSheet<void>(
  context: context,
  showDragHandle: true,
  isScrollControlled: true,
  builder: (context) => SafeArea(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Pause. Move safe. Tell.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          const Text(
            'If a story reminds you of something real, you can stop. Move near a safe person and tell a trusted adult in your life. If the first person cannot help, tell another.',
          ),
          const SizedBox(height: 14),
          const SoftCard(
            color: LifeColors.mint,
            child: Text(
              'LifeIQ is a learning demo. It is not an emergency service and does not contact anyone for you.',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('I understand'),
          ),
        ],
      ),
    ),
  ),
);
