import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/life_theme.dart';
import '../data/scenario_data.dart';
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
                          radius: 27,
                          backgroundColor: LifeColors.yellow,
                          child: Icon(
                            state.avatar == 'girl'
                                ? Icons.girl_rounded
                                : Icons.boy_rounded,
                            size: 38,
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
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [LifeColors.teal, LifeColors.tealDark],
                        ),
                        borderRadius: BorderRadius.circular(30),
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
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  ur
                                      ? 'کہانیوں میں محفوظ فیصلوں کی مشق کریں۔ ہر کوشش اہم ہے۔'
                                      : 'Practise safe choices in stories. Every try counts.',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          const CircleAvatar(
                            radius: 38,
                            backgroundColor: LifeColors.yellow,
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              size: 42,
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
                              Icons.play_circle_fill_rounded,
                              size: 42,
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
                              icon: const Icon(Icons.arrow_forward_rounded),
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
                          icon: Icons.local_fire_department_rounded,
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
                      childAspectRatio: columns == 2 ? .77 : .86,
                    ),
                    itemCount: scenarios.length,
                    itemBuilder: (context, index) => ScenarioCard(
                      story: scenarios[index],
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
        borderRadius: BorderRadius.circular(26),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
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
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: story.color.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(story.icon, color: story.color, size: 28),
                  ),
                  const Spacer(),
                  if (locked)
                    const Icon(Icons.lock_rounded, color: Colors.black45)
                  else if (score != null)
                    Pill(
                      icon: Icons.star_rounded,
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
                  fontSize: 18,
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
  Widget build(BuildContext context) => NavigationBar(
    selectedIndex: index,
    onDestinationSelected: (value) {
      if (value == index) return;
      context.go(switch (value) {
        0 => '/home',
        1 => '/profile',
        _ => '/settings',
      });
    },
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.home_outlined),
        selectedIcon: Icon(Icons.home_rounded),
        label: 'Home',
      ),
      NavigationDestination(
        icon: Icon(Icons.emoji_events_outlined),
        selectedIcon: Icon(Icons.emoji_events_rounded),
        label: 'Progress',
      ),
      NavigationDestination(
        icon: Icon(Icons.settings_outlined),
        selectedIcon: Icon(Icons.settings_rounded),
        label: 'Settings',
      ),
    ],
  );
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
                  'Best practice scores',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ...scenarios
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
                                child: Text(
                                  item.title.get(state.isUrdu),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
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
