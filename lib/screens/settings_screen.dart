import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/life_theme.dart';
import '../state/app_state.dart';
import '../widgets/life_widgets.dart';
import 'home_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return HomeFirstBackScope(
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        bottomNavigationBar: const LifeNavigation(index: 2),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
          children: [
            PageWidth(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Experience',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  SoftCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        SwitchListTile(
                          secondary: const Icon(Icons.translate_rounded),
                          title: const Text(
                            'Urdu / اردو',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: Text(
                            state.isPremium
                                ? 'Switch app and story direction'
                                : 'Available in premium demo mode',
                          ),
                          value: state.isUrdu,
                          onChanged: state.isPremium
                              ? state.setLanguage
                              : (_) => context.push('/paywall'),
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          secondary: const Icon(Icons.volume_up_rounded),
                          title: const Text(
                            'Sound',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: const Text(
                            'Interface sound setting (demo)',
                          ),
                          value: state.soundOn,
                          onChanged: state.setSound,
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          secondary: const Icon(
                            Icons.motion_photos_off_rounded,
                          ),
                          title: const Text(
                            'Reduce motion',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          subtitle: const Text(
                            'Use instant, calmer transitions',
                          ),
                          value: state.reduceMotion,
                          onChanged: state.setReduceMotion,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Grown-up demo controls',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  SoftCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Subscription, coins, scene shortcuts, and reset are behind a grown-up maths gate.',
                        ),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: () => _openDemoPanel(context),
                          icon: const Icon(Icons.admin_panel_settings_rounded),
                          label: const Text('Open grown-up demo panel'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'About LifeIQ',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  const SoftCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LifeIQ offline FYP prototype',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'All accounts, scores, purchases, conversations, and rewards are simulated on this device. The app is educational practice, not an emergency service, mental-health assessment, or replacement for a trusted adult.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDemoPanel(BuildContext context) async {
    final answer = TextEditingController();
    final passed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Grown-up check'),
        content: TextField(
          controller: answer,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'What is 9 + 7?'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, answer.text.trim() == '16'),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    answer.dispose();
    if (passed != true || !context.mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => Consumer<AppState>(
        builder: (panelContext, state, _) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Demo panel',
                  style: Theme.of(panelContext).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Every setting below is local and simulated. No billing or server is contacted.',
                ),
                const SizedBox(height: 16),
                SegmentedButton<SubscriptionState>(
                  segments: const [
                    ButtonSegment(
                      value: SubscriptionState.free,
                      label: Text('Free'),
                    ),
                    ButtonSegment(
                      value: SubscriptionState.active,
                      label: Text('Active'),
                    ),
                    ButtonSegment(
                      value: SubscriptionState.expired,
                      label: Text('Expired'),
                    ),
                  ],
                  selected: {state.subscription},
                  onSelectionChanged: (value) =>
                      state.setDemoSubscription(value.first),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => state.setDemoCoins(state.coins + 100),
                  child: Text('Add 100 coins • Current ${state.coins}'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: state.loadPresentationSample,
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: const Text('Load presentation sample data'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () async {
                    await state.startAtStep('s4', 's4_scene6');
                    if (sheetContext.mounted) Navigator.pop(sheetContext);
                    if (context.mounted) context.go('/story');
                  },
                  icon: const Icon(Icons.skip_next_rounded),
                  label: const Text('Jump to S04 multi-select scene'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(sheetContext);
                    _confirmReset(context, state);
                  },
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Reset all local demo data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, AppState state) async {
    final reset = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset local demo?'),
        content: const Text(
          'This removes the local child profile, story progress, badges, and demo subscription from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: LifeColors.coral),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (reset == true) {
      await state.resetAll();
      if (context.mounted) context.go('/welcome');
    }
  }
}
