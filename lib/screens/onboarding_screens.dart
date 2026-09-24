import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../core/life_theme.dart';
import '../state/app_state.dart';
import '../widgets/life_widgets.dart';

// Presentation only: existing routes, state updates, and demo flows are unchanged.
const _ink = Color(0xFF172D36);
const _muted = Color(0xFF657780);
const _surface = Color(0xFFF7FAF9);
const _accent = LifeColors.teal;

class _ScreenHeading extends StatelessWidget {
  const _ScreenHeading({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: _ink,
          fontWeight: FontWeight.w800,
          height: 1.12,
        ),
      ),
      const SizedBox(height: 10),
      Text(
        subtitle,
        style: const TextStyle(color: _muted, fontSize: 14, height: 1.55),
      ),
    ],
  );
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xFFE5EEEA)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x080F3432),
          blurRadius: 28,
          offset: Offset(0, 12),
        ),
      ],
    ),
    child: child,
  );
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 54,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: _accent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
      ),
      child: Text(label),
    ),
  );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
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
          colors: [Color(0xFFE6F7F1), Colors.white, Color(0xFFFFF5E7)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LifeLogo(size: 96),
              const SizedBox(height: 22),
              Text(
                'LifeIQ',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: _ink,
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Learn. Practise. Stay safe.',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _muted,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _surface,
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
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: _ink,
                fontWeight: FontWeight.w800,
                height: 1.12,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'LifeIQ is an offline practice app for children and their grown-ups. Explore choices with Dost, our friendly guide.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 15, height: 1.55),
            ),
            const SizedBox(height: 28),
            const _Panel(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFE2F5EC),
                    child: Icon(Icons.shield_outlined, color: _accent),
                  ),
                  SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'No real account, recording, payment, or personal disclosure is collected.',
                      style: TextStyle(
                        color: _ink,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            _PrimaryAction(
              label: 'Continue with a grown-up',
              onPressed: () async {
                await context.read<AppState>().finishWelcome();
                if (context.mounted) context.go('/auth');
              },
            ),
            const SizedBox(height: 14),
            const Text(
              'FYP interactive prototype • Works fully offline',
              textAlign: TextAlign.center,
              style: TextStyle(color: _muted, fontSize: 12),
            ),
            const SizedBox(height: 18),
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
    backgroundColor: _surface,
    appBar: AppBar(
      title: const Text('Grown-up sign in'),
      backgroundColor: _surface,
      surfaceTintColor: Colors.transparent,
    ),
    body: SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: PageWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 26),
              const Center(child: LifeLogo(size: 64)),
              const SizedBox(height: 26),
              _ScreenHeading(
                title: register ? 'Create your demo family' : 'Welcome back',
                subtitle:
                    'This is a local demo. Any email and password work; nothing is sent online.',
              ),
              const SizedBox(height: 26),
              _Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: _surface,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: const Color(0xFFE5EEEA)),
                      ),
                      child: Row(
                        children: [
                          _AuthTab(
                            label: 'Register',
                            selected: register,
                            onTap: () => setState(() => register = true),
                          ),
                          _AuthTab(
                            label: 'Log in',
                            selected: !register,
                            onTap: () => setState(() => register = false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    TextField(
                      controller: email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Parent email',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline_rounded),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _PrimaryAction(
                      label: register ? 'Create demo account' : 'Continue',
                      onPressed: _showOtp,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    ),
  );

  Future<void> _showOtp() async {
    final verified = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) => const _OtpSheet(),
    );
    if (verified == true && mounted) context.go('/profile-setup');
  }
}

class _OtpSheet extends StatefulWidget {
  const _OtpSheet();

  @override
  State<_OtpSheet> createState() => _OtpSheetState();
}

class _OtpSheetState extends State<_OtpSheet> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: '1234');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        24,
        8,
        24,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _ScreenHeading(
            title: 'Verify this grown-up',
            subtitle: 'Enter the 4-digit demo code. Hint: 1234',
          ),
          const SizedBox(height: 22),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 4,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              letterSpacing: 16,
              fontWeight: FontWeight.w800,
              color: _ink,
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: _surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFE5EEEA)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _PrimaryAction(
            label: 'Verify demo code',
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    ),
  );
}

class _AuthTab extends StatelessWidget {
  const _AuthTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Semantics(
      button: true,
      selected: selected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              boxShadow: selected
                  ? const [BoxShadow(color: Color(0x100F3432), blurRadius: 8)]
                  : null,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? _ink : _muted,
                fontSize: 14,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final name = TextEditingController(text: 'Ayaan');
  final age = TextEditingController(text: '10');
  String avatar = 'boy';

  @override
  void dispose() {
    name.dispose();
    age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _surface,
    appBar: AppBar(
      title: const Text('Child profile'),
      backgroundColor: _surface,
      surfaceTintColor: Colors.transparent,
    ),
    body: SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: PageWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const _ScreenHeading(
                title: 'Who is learning today?',
                subtitle:
                    'Use a nickname. Please do not enter sensitive personal information.',
              ),
              const SizedBox(height: 26),
              _Panel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: name,
                      decoration: const InputDecoration(
                        labelText: 'Nickname',
                        prefixIcon: Icon(Icons.face_rounded),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      key: const Key('profile-age-field'),
                      controller: age,
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        hintText: '6–15',
                        helperText: 'Enter an age from 6 to 15',
                        counterText: '',
                        prefixIcon: Icon(Icons.cake_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
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
              const SizedBox(height: 28),
              _PrimaryAction(
                label: 'Meet Dost',
                onPressed: () async {
                  final enteredAge = int.tryParse(age.text.trim()) ?? 10;
                  await context.read<AppState>().saveProfile(
                    name.text,
                    enteredAge,
                    avatar,
                  );
                  if (context.mounted) context.go('/home');
                },
              ),
              const SizedBox(height: 28),
            ],
          ),
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
    borderRadius: BorderRadius.circular(22),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 10),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFE6F7F1) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: selected ? _accent : const Color(0xFFE5EEEA),
          width: selected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 66, color: selected ? _accent : LifeColors.purple),
          const SizedBox(height: 10),
          Text(
            label,
            style: const TextStyle(
              color: _ink,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ],
      ),
    ),
  );
}
