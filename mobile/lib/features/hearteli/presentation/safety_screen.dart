import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import 'components.dart';

/// Resource configuration must be reviewed for each release and jurisdiction.
/// Pakistan entries are sourced from rescue.gov.pk and umang.com.pk.
class SafetyScreen extends StatefulWidget {
  const SafetyScreen({super.key});
  @override
  State<SafetyScreen> createState() => _SafetyScreenState();
}

class _SafetyScreenState extends State<SafetyScreen> {
  String jurisdiction = 'Pakistan';
  Future<void> dial(String number) async {
    final uri = Uri(scheme: 'tel', path: number);
    if (!await launchUrl(uri) && mounted)
      showCalmMessage(
        context,
        'Could not open the phone app. Call $number directly.',
      );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Immediate support')),
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
          title: 'You do not have to handle this alone.',
          subtitle: 'If you may be in immediate danger, call emergency services or go to a safe place now.',
        ),
        const SizedBox(height: 22),
        const HearteliCard(
          color: AppColors.blush,
          child: Text(
            'Hearteli is not an emergency service and does not continuously monitor check-ins or guarantee a response.',
          ),
        ),
        const SizedBox(height: 20),
        DropdownButtonFormField<String>(
          value: jurisdiction,
          decoration: const InputDecoration(labelText: 'Your location'),
          items: const [
            DropdownMenuItem(value: 'Pakistan', child: Text('Pakistan')),
            DropdownMenuItem(
              value: 'Elsewhere',
              child: Text('Elsewhere / not sure'),
            ),
          ],
          onChanged: (v) => setState(() => jurisdiction = v ?? jurisdiction),
        ),
        const SizedBox(height: 18),
        if (jurisdiction == 'Pakistan') ...[
          FilledButton.icon(
            onPressed: () => dial('1122'),
            icon: const Icon(Icons.call),
            label: const Text('Call emergency services — 1122'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => dial('03117786264'),
            icon: const Icon(Icons.support_agent),
            label: const Text('Call Umang mental health helpline'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Umang: 0311 7786264. For immediate danger, use emergency services.',
            style: TextStyle(color: AppColors.neutralGrey),
          ),
        ] else
          const StatusPanel(
            message: 'Call your local emergency number now. Hearteli cannot identify your location or verify local services.',
          ),
        const SizedBox(height: 20),
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
