import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/life_theme.dart';
import '../data/expanded_scenarios.dart';
import '../state/app_state.dart';
import '../widgets/life_widgets.dart';

class DebriefScreen extends StatelessWidget {
  const DebriefScreen({super.key, required this.id, required this.score});
  final String id;
  final int score;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final story = expandedScenarios.firstWhere((item) => item.id == id);
    final label = score >= 75
        ? 'Practised well'
        : score >= 50
        ? 'Keep practising'
        : 'Let’s practise together';
    final message = score >= 75
        ? 'You spotted the safe path and used a strong voice.'
        : 'Trying again helps your safety skills grow. Dost is proud of your effort.';
    return HomeFirstBackScope(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: PageWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 14),
                  const Center(
                    child: CircleAvatar(
                      radius: 38,
                      backgroundColor: LifeColors.yellow,
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: 42,
                        color: LifeColors.navy,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Story complete!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  SoftCard(
                    color: LifeColors.mint,
                    child: Column(
                      children: [
                        SizedBox(
                          width: 154,
                          height: 154,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox.expand(
                                child: CircularProgressIndicator(
                                  value: score / 100,
                                  strokeWidth: 14,
                                  backgroundColor: Colors.white,
                                  color: LifeColors.teal,
                                  strokeCap: StrokeCap.round,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$score',
                                    style: const TextStyle(
                                      fontSize: 44,
                                      height: 1,
                                      fontWeight: FontWeight.w900,
                                      color: LifeColors.tealDark,
                                    ),
                                  ),
                                  const Text(
                                    'practice score',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          label,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Demo feedback—not a diagnosis or measure of real-world safety.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  if (state.isPremium) ...[
                    Text(
                      'Skills practised',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    ...state.lastDimensionScores.entries.map(
                      (entry) => _SkillBar(
                        label: _dimensionLabel(entry.key),
                        value: entry.value / 100,
                        color: _dimensionColor(entry.key),
                      ),
                    ),
                  ] else ...[
                    SoftCard(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.lock_rounded,
                            color: LifeColors.purple,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'The full practice breakdown is available in premium demo mode.',
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.push('/paywall'),
                            child: const Text('View'),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SoftCard(
                    color: const Color(0xFFFFF0D4),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: LifeColors.yellow,
                          child: Icon(
                            Icons.stars_rounded,
                            color: LifeColors.navy,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'You now have ${state.coins} practice coins.',
                            style: const TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                        if (score >= 75)
                          Pill(
                            icon: Icons.workspace_premium_rounded,
                            label: story.badge,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Remember these steps',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  ...story.practice.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SoftCard(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: story.color.withValues(
                                alpha: .15,
                              ),
                              child: Text(
                                '${entry.key + 1}',
                                style: TextStyle(
                                  color: story.color,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry.value.get(state.isUrdu),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  FilledButton.icon(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.home_rounded),
                    label: const Text('Back to home'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: state.isPremium
                        ? () async {
                            await state.startScenario(id);
                            if (context.mounted) context.go('/story');
                          }
                        : () => context.push('/paywall'),
                    icon: Icon(
                      state.isPremium
                          ? Icons.replay_rounded
                          : Icons.lock_rounded,
                    ),
                    label: Text(
                      state.isPremium ? 'Replay story' : 'Unlock replay',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _dimensionLabel(String key) => switch (key) {
    'safety' => 'Safety awareness',
    'resilience' => 'Psychological resilience',
    'social' => 'Social intelligence',
    'communication' => 'Communication clarity',
    'emotional' => 'Emotional preparedness',
    _ => key,
  };

  Color _dimensionColor(String key) => switch (key) {
    'safety' => LifeColors.teal,
    'resilience' => LifeColors.purple,
    'social' => LifeColors.green,
    'communication' => LifeColors.coral,
    _ => const Color(0xFFE69A3B),
  };
}

class _SkillBar extends StatelessWidget {
  const _SkillBar({
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final double value;
  final Color color;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 13),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            Text('${(value * 100).round()}'),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 10,
            color: color,
            backgroundColor: color.withValues(alpha: .13),
          ),
        ),
      ],
    ),
  );
}
