import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import 'circle_screen.dart';
import 'components.dart';

class SafetyScreen extends StatefulWidget {
  const SafetyScreen({
    super.key,
    required this.apiClient,
    required this.sessionStore,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  String? jurisdiction;
  Future<void> dial(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(uri) && mounted)
      showCalmMessage(
        context,
        'Could not open the phone app. Call $number directly.',
      );
  }

  Future<void> text(String number) async {
      final uri = Uri(scheme: 'sms', path: number);
      if (!await launchUrl(uri) && mounted)
        showCalmMessage(
          context,
          'Could not open the messaging app. Text $number directly.',
        );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: ListView(
      padding: screenPadding,
      children: [
        const Icon(
          Icons.health_and_safety_outlined,
          color: AppColors.coral,
          size: 64,
        ),
        const SizedBox(height: 20),
        const PageIntro(
          title: 'Support is available',
          subtitle:
              "If you're feeling unsafe or need urgent help, you deserve immediate support. If you're in immediate danger, contact emergency services in your country. You can also reach out to someone you trust or a qualified professional.",
        ),
        const SizedBox(height: 22),
        const HearteliCard(
          color: AppColors.blush,
          child: Text(
            'Hearteli is not emergency monitoring, crisis triage or a guaranteed response service.',
          ),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: jurisdiction,
          decoration: const InputDecoration(labelText: 'Find local support'),
          items: const [
            DropdownMenuItem(value: 'Australia', child: Text('Australia')),
            DropdownMenuItem(
              value: 'United States',
              child: Text('United States'),
            ),
            DropdownMenuItem(
              value: 'Elsewhere',
              child: Text('Elsewhere / not sure'),
            ),
          ],
          onChanged: (v) => setState(() => jurisdiction = v),
        ),
        const SizedBox(height: 18),
        if (jurisdiction == 'Australia') ...[
          FilledButton.icon(
            onPressed: () => dial('000'),
            icon: const Icon(Icons.call),
            label: const Text('Emergency services — 000'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => dial('131114'),
            icon: const Icon(Icons.support_agent),
            label: const Text('Lifeline — 13 11 14 (24/7)'),
          ),
          OutlinedButton.icon(
            onPressed: () => dial('1300224636'),
            icon: const Icon(Icons.support_agent),
            label: const Text('Beyond Blue — 1300 22 4636 (24/7)'),
          ),
        ] else if (jurisdiction == 'United States') ...[
          FilledButton.icon(
            onPressed: () => dial('911'),
            icon: const Icon(Icons.call),
            label: const Text('Emergency services — 911'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => dial('988'),
            icon: const Icon(Icons.support_agent),
            label: const Text('Suicide & Crisis Lifeline — call 988'),
          ),
          OutlinedButton.icon(
            onPressed: () => text('988'),
            icon: const Icon(Icons.sms_outlined),
            label: const Text('Text 988'),
          ),
        ] else if (jurisdiction == 'Elsewhere')
          const StatusPanel(
            message: 'Call your local emergency number now. Hearteli cannot identify your location or verify local services.',
          )
        else
          const StatusPanel(
            message: 'Choose your location to see relevant emergency support information.',
          ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CircleScreen(
                apiClient: widget.apiClient,
                sessionStore: widget.sessionStore,
              ),
            ),
          ),
          icon: const Icon(Icons.people_outline),
          label: const Text('Contact someone in my Circle'),
        ),
        const HearteliCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A next small step',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Move somewhere safer, stay near another person if you can, and contact someone you trust directly.',
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
