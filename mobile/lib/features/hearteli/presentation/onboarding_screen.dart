import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/validation/form_feedback.dart';
import '../../../core/validation/validators.dart';
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
  bool demoSharing = false;
  static const headlines = [
    'Some days are harder to put into words.',
    'Check in with yourself. Choose what to share.',
    'A little understanding can make a difference.',
  ];
  static const descriptions = [
    'You deserve support, even when it is hard to ask for it.',
    'Your check-ins are private. Choose who to tell, what to share and when.',
    'A kind message or a quiet moment together can help someone feel less alone.',
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: AppColors.cream,
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, bounds) => SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: bounds.maxHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const BrandLogo(height: 64, alignment: Alignment.center),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (step > 0)
                        TextButton.icon(
                          onPressed: () => setState(() => step--),
                          icon: const Icon(Icons.arrow_back, size: 18),
                          label: const Text('Back'),
                        )
                      else
                        const SizedBox(width: 80),
                      Semantics(
                        liveRegion: true,
                        child: Text('${step + 1} of 3',
                          style: const TextStyle(color: AppColors.neutralGrey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      key: ValueKey(step),
                      children: [
                        _PitchVisual(
                          step: step,
                          sharing: demoSharing,
                          onSharingChanged: (value) => setState(() => demoSharing = value),
                        ),
                        const SizedBox(height: 26),
                        Text(headlines[step], textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 29, height: 1.18,
                            fontWeight: FontWeight.w800, color: AppColors.ink)),
                        const SizedBox(height: 16),
                        Text(descriptions[step], textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, height: 1.5,
                            color: AppColors.neutralGrey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: step == index ? 24 : 8, height: 8,
                        decoration: BoxDecoration(
                          color: step == index ? AppColors.coral : AppColors.blush,
                          borderRadius: BorderRadius.circular(8)),
                      ),
                    )),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      if (step < 2) {
                        setState(() => step++);
                      } else {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => SignupScreen(
                            sessionStore: widget.sessionStore,
                            apiClient: widget.apiClient)));
                      }
                    },
                    child: Text(step == 2 ? 'Create account' : 'Continue'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(
                      builder: (_) => LoginScreen(
                        sessionStore: widget.sessionStore,
                        apiClient: widget.apiClient))),
                    child: const Text('I already have an account'),
                  ),
                  const SizedBox(height: 12),
                  const HearteliFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class _PitchVisual extends StatelessWidget {
  const _PitchVisual({required this.step, required this.sharing,
    required this.onSharingChanged});
  final int step;
  final bool sharing;
  final ValueChanged<bool> onSharingChanged;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(color: AppColors.blush,
      borderRadius: BorderRadius.circular(28)),
    child: step == 0 ? _problem() : step == 1 ? _control() : _payoff(),
  );

  Widget _problem() => Semantics(
    label: 'One person turns away, feeling low. Another person does not yet know.',
    child: Column(children: [
      const Align(alignment: Alignment.centerLeft,
        child: _GestureNote(icon: Icons.chat_bubble_outline, text: '“I’m okay.”')),
      const SizedBox(height: 18),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Transform.flip(flipX: true, child: const Icon(Icons.person,
          size: 96, color: AppColors.neutralGrey)),
        const Icon(Icons.more_horiz, color: AppColors.neutralGrey),
        const Icon(Icons.person_outline, size: 96, color: AppColors.coral),
      ]),
      const SizedBox(height: 12),
      const Text('So much can go unsaid.',
        style: TextStyle(color: AppColors.ink)),
    ]),
  );

  Widget _control() => Column(children: [
    AnimatedOpacity(
      opacity: sharing ? 1 : 0.3,
      duration: const Duration(milliseconds: 300),
      child: Image.asset('assets/brand/hearteli_symbol_transparent.png',
        height: 105, fit: BoxFit.contain),
    ),
    const SizedBox(height: 12),
    SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: const Text('Let my person know',
        style: TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(sharing ? 'Your choice. Turn it off anytime.' : 'Private by default'),
      value: sharing,
      activeColor: AppColors.coral,
      onChanged: onSharingChanged,
    ),
    const Text('Try the demo — nothing is shared.', textAlign: TextAlign.center,
      style: TextStyle(fontSize: 12, color: AppColors.neutralGrey)),
  ]);

  Widget _payoff() => const Column(children: [
    _GestureNote(icon: Icons.chat_bubble_outline, text: 'I’m here if you want to talk.'),
    SizedBox(height: 14),
    Icon(Icons.favorite_outline, size: 74, color: AppColors.coral),
    SizedBox(height: 14),
    _GestureNote(icon: Icons.schedule, text: 'No pressure. I can make time when you are ready.'),
  ]);
}

class _GestureNote extends StatelessWidget {
  const _GestureNote({required this.icon, required this.text});
  final IconData icon;
  final String text;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.circular(16)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 20, color: AppColors.coral),
      const SizedBox(width: 10),
      Flexible(child: Text(text, style: const TextStyle(color: AppColors.ink))),
    ]),
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
  String? error, emailError;
  final emailFocus = FocusNode();
  bool busy = false;
  @override
  void dispose() {
    email.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  Future<void> next() async {
    if (busy) return;
    if (step < 2) {
      setState(() => step++);
      return;
    }
    final address = email.text.trim();
    if (address.isNotEmpty && Validators.email(address) != null) {
      setState(() => emailError = 'Enter a valid email address or leave this blank.');
      focusInvalidField(emailFocus);
      return;
    }
    setState(() {
      busy = true;
      emailError = null;
      error = null;
    });
    try {
      await widget.apiClient.patch(
        '/api/tracking/hearteli/preferences/update_mine/',
        body: {'use_contexts': selected.toList()},
      );
      if (address.isNotEmpty)
        await widget.apiClient.post(
          '/api/tracking/hearteli/circle/invite-signup/',
          body: {
            'email': address,
            'relationship': 'Friend',
          },
        );
      if (mounted) widget.onDone();
    } catch (e) {
      if (mounted) setState(() => error = formRequestError(e));
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
              title: 'Welcome to Hearteli ❤️',
              subtitle:
                  'A little more understanding starts here. Take your time, settle in, and make this space your own.',
            ),
            const SizedBox(height: 16),
            const Text(
              'What brings you here?',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
            ),
            const Text(
              'Choose any that fit. These choices only tailor the app; they do not share information.',
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
              title: "Who's in your corner?",
              subtitle:
                  'Invite someone you trust to be there for the moments when a little understanding matters most.',
            ),
            const SizedBox(height: 22),
            TextField(
              controller: email,
              focusNode: emailFocus,
              onChanged: (_) => setState(() => emailError = null),
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Their email (optional)',
                error: inlineFieldError(emailError),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'The recipient must accept and enable nudges before you can send one.',
            ),
          ],
          const SizedBox(height: 24),
          if (error != null)
            Semantics(liveRegion: true, child: StatusPanel(message: error!)),
          FilledButton(
            onPressed: busy ? null : next,
            child: Text(
              step == 2
                  ? 'Continue to Hearteli'
                  : step == 1
                  ? 'I understand'
                  : 'Get started',
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
