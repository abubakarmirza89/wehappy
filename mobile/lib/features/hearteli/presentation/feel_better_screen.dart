import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import 'components.dart';

class FeelBetterScreen extends StatefulWidget {
  const FeelBetterScreen({super.key, required this.apiClient, required this.onDone});
  final ApiClient apiClient;
  final VoidCallback onDone;
  @override State<FeelBetterScreen> createState() => _FeelBetterScreenState();
}
class _FeelBetterScreenState extends State<FeelBetterScreen> {
  List<dynamic> checkIns = [], nudges = [];
  String? error;
  @override void initState() { super.initState(); load(); }
  Future<void> load() async {
    try {
      final values = await Future.wait([
        widget.apiClient.get('/api/tracking/mood-check-ins/'),
        widget.apiClient.get('/api/tracking/hearteli/nudges/'),
      ]);
      if (mounted) setState(() { checkIns = items(values[0]); nudges = items(values[1]); error = null; });
    } catch (_) { if (mounted) setState(() => error = 'Your progress could not load. Try again.'); }
  }
  @override Widget build(BuildContext context) {
    final days = checkIns.map((e) => '${e['date'] ?? ''}').where((s) => s.isNotEmpty).toSet();
    final latest = checkIns.isEmpty ? null : checkIns.first;
    final mood = '${latest?['feeling_category'] ?? ''}'.replaceAll('_', ' ');
    final reached = nudges.where((n) => n['status'] == 'acknowledged').length;
    return Scaffold(appBar: AppBar(title: const Text('Your progress')),
      body: SafeArea(child: ListView(padding: screenPadding, children: [
        const SizedBox(height: 48),
        const Center(child: Icon(Icons.favorite, color: AppColors.coral, size: 66)),
        const SizedBox(height: 18),
        Text('You showed up.', textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 8),
        const Text('Connecting with someone can make a big difference.',
          textAlign: TextAlign.center, style: TextStyle(color: AppColors.neutralGrey)),
        const SizedBox(height: 30),
        if (error != null) StatusPanel(message: error!, action: 'Retry', onAction: load)
        else ...[
          _ProgressRow(icon: Icons.mood_outlined, label: 'Latest check-in', value: mood.isEmpty ? 'No check-in yet' : mood),
          _ProgressRow(icon: Icons.people_outline, label: 'Support acknowledged', value: '$reached'),
          _ProgressRow(icon: Icons.calendar_today_outlined, label: 'Days checked in', value: '${days.length}'),
        ],
        const SizedBox(height: 28),
        FilledButton(onPressed: widget.onDone, child: const Text('Back to Home')),
        const SizedBox(height: 12),
        const Text('Every small step counts. These insights are visible only to you.',
          textAlign: TextAlign.center, style: TextStyle(color: AppColors.neutralGrey)),
      ])),
    );
  }
}
class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label, value;
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(bottom: 10),
    child: HearteliCard(child: Row(children: [
      Icon(icon, color: AppColors.coral), const SizedBox(width: 12),
      Expanded(child: Text(label)), Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
    ])));
}
