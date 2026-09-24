import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/life_theme.dart';
import '../state/app_state.dart';
import '../widgets/life_widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      final state = context.read<AppState>();
      context.go(
        !state.onboardingComplete
            ? '/welcome'
            : !state.profileComplete
            ? '/auth'
            : '/home',
      );
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [LifeColors.mint, LifeColors.cream, Color(0xFFFFE8B8)],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LifeLogo(size: 96),
            const SizedBox(height: 24),
            Text(
              'LifeIQ',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontSize: 46),
            ),
            const SizedBox(height: 10),
            const Text(
              'Learn. Practise. Stay safe.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: LifeColors.tealDark,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: PageWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Center(child: LifeLogo(size: 84)),
            const SizedBox(height: 30),
            Text(
              'Big life skills, safe little stories.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'LifeIQ is an offline practice app for children and their grown-ups. Explore choices with Dost, our friendly guide.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 30),
            const SoftCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundColor: LifeColors.mint,
                    child: Icon(Icons.shield_rounded, color: LifeColors.teal),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      'No real account, recording, payment, or personal disclosure is collected.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () async {
                await context.read<AppState>().finishWelcome();
                if (context.mounted) context.go('/auth');
              },
              child: const Text('Continue with a grown-up'),
            ),
            const SizedBox(height: 12),
            const Text(
              'FYP interactive prototype • Works fully offline',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      ),
    ),
  );
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool register = true;
  final email = TextEditingController(text: 'parent@demo.com');
  final password = TextEditingController(text: 'lifeiq123');

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Grown-up sign in')),
    body: SingleChildScrollView(
      child: PageWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Text(
              register ? 'Create your demo family' : 'Welcome back',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'This is a local demo. Any email and password work; nothing is sent online.',
            ),
            const SizedBox(height: 24),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Register')),
                ButtonSegment(value: false, label: Text('Log in')),
              ],
              selected: {register},
              onSelectionChanged: (value) =>
                  setState(() => register = value.first),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Parent email',
                prefixIcon: Icon(Icons.mail_outline_rounded),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline_rounded),
              ),
            ),
            const SizedBox(height: 22),
            FilledButton(
              onPressed: () => _showOtp(context),
              child: Text(register ? 'Create demo account' : 'Continue'),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _showOtp(BuildContext context) async {
    final controller = TextEditingController(text: '1234');
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          8,
          24,
          24 + MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Verify this grown-up',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('Enter the 4-digit demo code. Hint: 1234'),
            const SizedBox(height: 18),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                letterSpacing: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(sheetContext);
                context.go('/profile-setup');
              },
              child: const Text('Verify demo code'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
  }
}

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});
  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final name = TextEditingController(text: 'Ayaan');
  double age = 10;
  String avatar = 'boy';

  @override
  void dispose() {
    name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Child profile')),
    body: SingleChildScrollView(
      child: PageWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Who is learning today?',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text(
              'Use a nickname. Please do not enter sensitive personal information.',
            ),
            const SizedBox(height: 22),
            TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: 'Nickname',
                prefixIcon: Icon(Icons.face_rounded),
              ),
            ),
            const SizedBox(height: 20),
            SoftCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Age: ${age.round()}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Slider(
                    value: age,
                    min: 6,
                    max: 15,
                    divisions: 9,
                    label: age.round().toString(),
                    onChanged: (value) => setState(() => age = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _AvatarCard(
                    label: 'Explorer',
                    icon: Icons.boy_rounded,
                    selected: avatar == 'boy',
                    onTap: () => setState(() => avatar = 'boy'),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _AvatarCard(
                    label: 'Adventurer',
                    icon: Icons.girl_rounded,
                    selected: avatar == 'girl',
                    onTap: () => setState(() => avatar = 'girl'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 26),
            FilledButton(
              onPressed: () async {
                await context.read<AppState>().saveProfile(
                  name.text,
                  age.round(),
                  avatar,
                );
                if (context.mounted) context.go('/home');
              },
              child: const Text('Meet Dost'),
            ),
          ],
        ),
      ),
    ),
  );
}

class _AvatarCard extends StatelessWidget {
  const _AvatarCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(26),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: selected ? LifeColors.mint : Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: selected ? LifeColors.teal : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 74,
            color: selected ? LifeColors.teal : LifeColors.purple,
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    ),
  );
}
