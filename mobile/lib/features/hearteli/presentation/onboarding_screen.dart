import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/presentation/login_screen.dart';
import '../../auth/presentation/signup_screen.dart';
import 'components.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({
    super.key,
    required this.apiClient,
    required this.sessionStore,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, bounds) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: bounds.maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 30, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BrandLogo(
                    height: step == 0 ? 92 : 56,
                    alignment: Alignment.center,
                  ),
                  SizedBox(height: step == 0 ? 90 : 48),
                  if (step == 0) ...[
                    SizedBox(height: 155, child: Stack(children: [
                      Positioned(left: 4, bottom: 6, child: Container(width: 104, height: 104,
                        decoration: const BoxDecoration(color: AppColors.blush, shape: BoxShape.circle))),
                      Positioned(right: 18, top: 0, child: Container(width: 70, height: 70,
                        decoration: const BoxDecoration(color: AppColors.blush, shape: BoxShape.circle))),
                      Positioned(right: 48, bottom: 12, child: Container(width: 36, height: 36,
                        decoration: const BoxDecoration(color: AppColors.blush, shape: BoxShape.circle))),
                    ])),
                    const SizedBox(height: 12),
                    const Text(
                      'A kinder way\nto stay connected.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'A kinder way to check in, show you care, and support when it matters.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.neutralGrey,
                      ),
                    ),
                  ] else ...[
                    const PageIntro(
                      title: 'How Hearteli works',
                      subtitle: 'Small check-ins make a big difference.',
                    ),
                    const SizedBox(height: 28),
                    const _HowCard(
                      icon: Icons.favorite_outline,
                      index: '01',
                      title: 'Check in privately',
                      body: 'Take a moment to name how you feel.',
                    ),
                    const SizedBox(height: 10),
                    const _HowCard(
                      icon: Icons.visibility_outlined,
                      index: '02',
                      title: 'Choose who can know',
                      body: 'You decide if and what to share.',
                    ),
                    const SizedBox(height: 10),
                    const _HowCard(
                      icon: Icons.send_outlined,
                      index: '03',
                      title: 'Send a gentle nudge',
                      body: 'One trusted person gets a helpful prompt.',
                    ),
                    const SizedBox(height: 10),
                    const _HowCard(
                      icon: Icons.people_outline,
                      index: '04',
                      title: 'Be there',
                      body: 'Real people make the difference.',
                    ),
                  ],
                  const SizedBox(height: 44),
                  FilledButton(
                    onPressed: () {
                      if (step == 0) {
                        setState(() => step = 1);
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SignupScreen(
                              sessionStore: widget.sessionStore,
                              apiClient: widget.apiClient,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(step == 0 ? 'Get Started' : 'Create account'),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoginScreen(
                          sessionStore: widget.sessionStore,
                          apiClient: widget.apiClient,
                        ),
                      ),
                    ),
                    child: Text(
                      step == 0
                          ? 'I already have an account'
                          : 'Sign in instead',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _HowCard extends StatelessWidget {
  const _HowCard({
    required this.icon,
    required this.index,
    required this.title,
    required this.body,
  });
  final IconData icon;
  final String index, title, body;
  @override
  Widget build(BuildContext context) => HearteliCard(
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.blush,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.coral),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$index  $title',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Text(
                body,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.neutralGrey,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class FirstRunSetup extends StatefulWidget {
  const FirstRunSetup({
    super.key,
    required this.apiClient,
    required this.onDone,
  });
  final ApiClient apiClient;
  final VoidCallback onDone;
  @override
  State<FirstRunSetup> createState() => _FirstRunSetupState();
}

class _FirstRunSetupState extends State<FirstRunSetup> {
  int step = 0;
  final selected = <String>{};
  final email = TextEditingController();
  String? error;
  bool busy = false;
  @override
  void dispose() {
    email.dispose();
    super.dispose();
  }

  Future<void> next() async {
    if (step < 2) {
      setState(() => step++);
      return;
    }
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await widget.apiClient.patch(
        '/api/tracking/hearteli/preferences/update_mine/',
        body: {'use_contexts': selected.toList()},
      );
      if (email.text.trim().isNotEmpty)
        await widget.apiClient.post(
          '/api/tracking/hearteli/circle/',
          body: {
            'recipient_email_input': email.text.trim(),
            'relationship': 'Friend',
          },
        );
      widget.onDone();
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Welcome to Hearteli')),
    body: SafeArea(
      child: ListView(
        padding: screenPadding,
        children: [
          Text(
            '${step + 1} of 3',
            style: const TextStyle(
              color: AppColors.coral,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          if (step == 0) ...[
            const PageIntro(
              title: 'What brings you here?',
              subtitle: 'Choose any that fit. These choices only tailor the app; they do not share information.',
            ),
            const SizedBox(height: 22),
            for (final label in [
              'Myself',
              'My partner',
              'My family',
              'My team',
              'My clients',
              'Other',
            ])
              CheckboxListTile(
                title: Text(label),
                value: selected.contains(label),
                activeColor: AppColors.coral,
                onChanged: (v) => setState(
                  () =>
                      v == true ? selected.add(label) : selected.remove(label),
                ),
              ),
          ] else if (step == 1) ...[
            const PageIntro(
              title: 'Your privacy promise',
              subtitle: 'Support starts with your choice.',
            ),
            const SizedBox(height: 22),
            const HearteliCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LabelRow(
                    icon: Icons.lock_outline,
                    title: 'Private by default',
                    subtitle: 'Only you see a new check-in.',
                  ),
                  LabelRow(
                    icon: Icons.visibility_outlined,
                    title: 'You choose who knows',
                    subtitle: 'Review the exact message before each send.',
                  ),
                  LabelRow(
                    icon: Icons.person_remove_outlined,
                    title: 'Revoke anytime',
                    subtitle: 'You control each Circle relationship.',
                  ),
                  LabelRow(
                    icon: Icons.work_outline,
                    title: 'Work stays separate',
                    subtitle:
                        'A workplace never sees your private moods by joining.',
                  ),
                ],
              ),
            ),
          ] else ...[
            const PageIntro(
              title: 'Your Circle',
              subtitle: 'Invite someone you trust, or skip for now. No check-in is shared with an invite.',
            ),
            const SizedBox(height: 22),
            TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Their Hearteli email (optional)',
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'The recipient must accept and enable nudges before you can send one.',
            ),
          ],
          const SizedBox(height: 24),
          if (error != null)
            Text(error!, style: const TextStyle(color: AppColors.error)),
          FilledButton(
            onPressed: busy ? null : next,
            child: Text(
              step == 2
                  ? 'Continue to Hearteli'
                  : step == 1
                  ? 'I understand'
                  : 'Continue',
            ),
          ),
          if (step == 2)
            TextButton(
              onPressed: busy ? null : widget.onDone,
              child: const Text('Skip for now'),
            ),
        ],
      ),
    ),
  );
}
