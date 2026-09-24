import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import 'components.dart';
import 'support_screen.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key, required this.apiClient});
  final ApiClient apiClient;
  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  String period = 'Week';
  List<dynamic> history = [], nudges = [];
  bool loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final results = await Future.wait([
        widget.apiClient.get('/api/tracking/mood-check-ins/'),
        widget.apiClient.get('/api/tracking/hearteli/nudges/'),
      ]);
      if (mounted)
        setState(() {
          history = items(results[0]);
          nudges = items(results[1]);
          loading = false;
          error = null;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          error = '$e';
          loading = false;
        });
    }
  }

  String label(Map entry) {
    const names = {
      'great': 'Great',
      'good': 'Good',
      'okay': 'Okay',
      'not_great': 'Not great',
      'struggling': 'Struggling',
    };
    final category = '${entry['feeling_category'] ?? ''}';
    if (names.containsKey(category)) return names[category]!;
    final moods = entry['moods'] as List? ?? [];
    return moods.isEmpty ? 'Check-in' : moods.map((m) => m['name']).join(', ');
  }

  List<dynamic> get filtered {
    final today = DateTime.now();
    final days = period == 'Week'
        ? 7
        : period == 'Month'
        ? 30
        : 365;
    return history.where((h) {
      final date = DateTime.tryParse('${h['date']}');
      return date != null && today.difference(date).inDays < days;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final raw in filtered) {
      final name = label(raw as Map);
      counts[name] = (counts[name] ?? 0) + 1;
    }
    return RefreshIndicator(
      onRefresh: load,
      child: ListView(
        padding: screenPadding,
        children: [
          const PageIntro(
            title: 'Insights',
            subtitle: 'A gentle look at your own patterns.',
          ),
          const SizedBox(height: 18),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Week', label: Text('Week')),
              ButtonSegment(value: 'Month', label: Text('Month')),
              ButtonSegment(value: 'Year', label: Text('Year')),
            ],
            selected: {period},
            onSelectionChanged: (v) => setState(() => period = v.first),
          ),
          const SizedBox(height: 18),
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (error != null)
            StatusPanel(message: error!, action: 'Try again', onAction: load)
          else ...[
            HearteliCard(
              color: AppColors.softBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${filtered.length}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const Text('Check-ins this period'),
                  const SizedBox(height: 8),
                  Text(
                    filtered.isEmpty
                        ? 'Your reflections will appear here after you check in.'
                        : 'You’re showing up for yourself. That matters.',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            if (counts.isNotEmpty)
              HearteliCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How your days felt',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 15),
                    for (final e in counts.entries)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            SizedBox(width: 92, child: Text(e.key)),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: e.value / filtered.length,
                                  minHeight: 12,
                                  backgroundColor: AppColors.softBlue,
                                  color: AppColors.coral,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text('${e.value}'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Check-in history',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
                Text(
                  '${history.length} total',
                  style: const TextStyle(color: AppColors.neutralGrey),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (history.isEmpty)
              const StatusPanel(
                message: 'No history yet. A first check-in can be private.',
              )
            else
              for (final raw in history.take(15))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: HearteliCard(
                    child: LabelRow(
                      icon: Icons.favorite_outline,
                      title: label(raw as Map),
                      subtitle:
                          '${raw['date']} · ${raw['notes']?.toString().isNotEmpty == true ? 'Private note saved' : 'Private check-in'}',
                    ),
                  ),
                ),
            const SizedBox(height: 20),
            const Text(
              'Support history',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 10),
            if (nudges.isEmpty)
              const StatusPanel(message: 'No support interactions yet.')
            else
              for (final raw in nudges.take(8))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: HearteliCard(
                    child: LabelRow(
                      icon: Icons.send_outlined,
                      title: '${raw['sender_name']} → ${raw['recipient_name']}',
                      subtitle: '${raw['status']} · ${raw['delivery_status']}',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NudgeDetail(
                            apiClient: widget.apiClient,
                            id: raw['id'] as int,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }
}
