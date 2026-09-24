import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/life_theme.dart';
import '../data/expanded_scenarios.dart';
import '../models/story.dart';
import '../state/app_state.dart';
import '../widgets/life_widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final ur = state.isUrdu;
    return Scaffold(
      bottomNavigationBar: const LifeNavigation(index: 0),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: PageWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 23,
                          backgroundColor: LifeColors.yellow,
                          child: const Icon(
                            CupertinoIcons.person_crop_circle_fill,
                            size: 32,
                            color: LifeColors.navy,
                          ),
                        ),
                        const SizedBox(width: 13),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ur
                                    ? 'السلام علیکم، ${state.childName}!'
                                    : 'Salaam, ${state.childName}!',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                ur
                                    ? 'آج ہم کیا سیکھیں گے؟'
                                    : 'What will we practise today?',
                              ),
                            ],
                          ),
                        ),
                        Pill(
                          icon: Icons.stars_rounded,
                          label: '${state.coins}',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [LifeColors.teal, LifeColors.tealDark],
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ur
                                      ? 'دوست آپ کے ساتھ ہے'
                                      : 'Dost is here for you',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  ur
                                      ? 'کہانیوں میں محفوظ فیصلوں کی مشق کریں۔ ہر کوشش اہم ہے۔'
                                      : 'Practise safe choices in stories. Every try counts.',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const CircleAvatar(
                            radius: 32,
                            backgroundColor: LifeColors.yellow,
                            child: Icon(
                              CupertinoIcons.sparkles,
                              size: 32,
                              color: LifeColors.navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (state.activeScenario != null) ...[
                      const SizedBox(height: 18),
                      SoftCard(
                        color: LifeColors.sky,
                        child: Row(
                          children: [
                            const Icon(
                              CupertinoIcons.play_circle_fill,
                              size: 38,
                              color: LifeColors.teal,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ur
                                        ? 'کہانی جاری رکھیں'
                                        : 'Continue your story',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(state.activeScenario!.title.get(ur)),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => context.go('/story'),
                              icon: const Icon(
                                CupertinoIcons.arrow_right_circle_fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ur ? 'حفاظتی کہانیاں' : 'Safety stories',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ),
                        Pill(
                          icon: CupertinoIcons.flame_fill,
                          label: '${state.streak} day',
                          color: const Color(0xFFFFE6D8),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.crossAxisExtent > 680 ? 3 : 2;
                  return SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: columns == 2 ? .82 : .9,
                    ),
                    itemCount: expandedScenarios.length,
                    itemBuilder: (context, index) => ScenarioCard(
                      story: expandedScenarios[index],
                      number: index + 1,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScenarioCard extends StatelessWidget {
  const ScenarioCard({super.key, required this.story, required this.number});
  final LifeScenario story;
  final int number;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final locked = !state.canOpen(story);
    final score = state.bestScores[story.id];
    return Semantics(
      button: true,
      label:
          '${story.title.get(state.isUrdu)}, ${locked ? 'locked' : 'available'}',
      child: InkWell(
        onTap: () => context.push('/intro/${story.id}'),
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1022304A),
                blurRadius: 16,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (story.coverImageAsset != null)
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: SizedBox(
                        width: double.infinity,
                        height: 76,
                        child: Image.asset(
                          story.coverImageAsset!,
                          fit: BoxFit.cover,
                          alignment: const Alignment(-.25, 0),
                          errorBuilder: (_, _, _) => ColoredBox(
                            color: story.color.withValues(alpha: .15),
                            child: Icon(story.icon, color: story.color),
                          ),
                        ),
                      ),
                    ),
                    if (score != null)
                      PositionedDirectional(
                        top: 6,
                        end: 6,
                        child: Pill(
                          icon: CupertinoIcons.star_fill,
                          label: '$score',
                          color: LifeColors.mint,
                        ),
                      ),
                  ],
                )
              else
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: story.color.withValues(alpha: .15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(story.icon, color: story.color, size: 25),
                    ),
                    const Spacer(),
                    if (locked)
                      const Icon(
                        CupertinoIcons.lock_fill,
                        color: Colors.black45,
                      )
                    else if (score != null)
                      Pill(
                        icon: CupertinoIcons.star_fill,
                        label: '$score',
                        color: LifeColors.mint,
                      ),
                  ],
                ),
              const Spacer(),
              Text(
                '${state.isUrdu ? 'کہانی' : 'Story'} $number',
                style: TextStyle(
                  color: story.color,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                story.title.get(state.isUrdu),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                story.category.get(state.isUrdu),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LifeNavigation extends StatelessWidget {
  const LifeNavigation({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    const items = [
      (CupertinoIcons.house, CupertinoIcons.house_fill, 'Home'),
      (CupertinoIcons.chart_bar, CupertinoIcons.chart_bar_fill, 'Progress'),
      (CupertinoIcons.gear, CupertinoIcons.gear_solid, 'Settings'),
    ];
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: const Color(0xFFE6EEEC)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1C183A38),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: List.generate(items.length, (itemIndex) {
            final item = items[itemIndex];
            final selected = itemIndex == index;
            return Expanded(
              child: Semantics(
                button: true,
                selected: selected,
                label: item.$3,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(26),
                    onTap: () {
                      if (selected) return;
                      context.go(switch (itemIndex) {
                        0 => '/home',
                        1 => '/profile',
                        _ => '/settings',
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: selected
                                ? LifeColors.teal
                                : Colors.transparent,
                          ),
                          child: Icon(
                            selected ? item.$2 : item.$1,
                            size: 21,
                            color: selected ? Colors.white : Colors.black45,
                          ),
                        ),
                        if (selected) ...[
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              item.$3,
                              overflow: TextOverflow.fade,
                              softWrap: false,
                              style: const TextStyle(
                                color: LifeColors.navy,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('My progress')),
      bottomNavigationBar: const LifeNavigation(index: 1),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          PageWidth(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SoftCard(
                  color: LifeColors.mint,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 38,
                        backgroundColor: LifeColors.yellow,
                        child: Icon(
                          state.avatar == 'girl'
                              ? Icons.girl_rounded
                              : Icons.boy_rounded,
                          size: 54,
                          color: LifeColors.navy,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.childName,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              'Age ${state.childAge} • ${state.isPremium ? 'Premium demo' : 'Free demo'}',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _Stat(
                        value: '${state.bestScores.length}/8',
                        label: 'Stories',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Stat(value: '${state.coins}', label: 'Coins'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _Stat(value: '${state.streak}', label: 'Streak'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'Badge shelf',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (state.badges.isEmpty)
                  const SoftCard(
                    child: Text(
                      'Complete a story with a score of 75+ to earn your first practice badge.',
                    ),
                  )
                else
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: state.badges
                        .map(
                          (badge) => Pill(
                            icon: Icons.workspace_premium_rounded,
                            label: badge,
                            color: LifeColors.yellow.withValues(alpha: .5),
                          ),
                        )
                        .toList(),
                  ),
                const SizedBox(height: 24),
                Text(
                  'Score history',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (!state.isPremium)
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
                            'Score history is available in premium demo mode.',
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/paywall'),
                          child: const Text('View'),
                        ),
                      ],
                    ),
                  )
                else ...[
                  ...expandedScenarios
                      .where((item) => state.bestScores.containsKey(item.id))
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: SoftCard(
                            child: Row(
                              children: [
                                Icon(item.icon, color: item.color),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title.get(state.isUrdu),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        (state.scoreHistory[item.id] ??
                                                const <int>[])
                                            .map((value) => '$value')
                                            .join('  •  '),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '${state.bestScores[item.id]}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: LifeColors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  const SizedBox(height: 20),
                  Text(
                    'Demo billing history',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  const SoftCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: LifeColors.mint,
                        child: Icon(
                          Icons.receipt_long_rounded,
                          color: LifeColors.teal,
                        ),
                      ),
                      title: Text(
                        'Premium demo activation',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                      subtitle: Text('Simulated locally • No charge'),
                      trailing: Text('PKR 0'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => SoftCard(
    padding: const EdgeInsets.symmetric(vertical: 17),
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.w900,
            color: LifeColors.teal,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}
