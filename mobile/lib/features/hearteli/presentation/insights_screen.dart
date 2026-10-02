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
              for (final raw in history)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: HearteliCard(
                    child: LabelRow(
                      icon: Icons.favorite_outline,
                      title: label(raw as Map),
                      subtitle:
                          '${raw['date']} · ${raw['notes']?.toString().isNotEmpty == true ? 'Private note saved' : 'Private check-in'}',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CheckInDetail(
                            apiClient: widget.apiClient,
                            entry: Map<String, dynamic>.from(raw),
                            nudges: nudges
                                .where((n) => n['check_in'] == raw['id'])
                                .toList(),
                          ),
                        ),
                      ).then((_) => load()),
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

class CheckInDetail extends StatefulWidget {
  const CheckInDetail({
    super.key,
    required this.apiClient,
    required this.entry,
    required this.nudges,
  });
  final ApiClient apiClient;
  final Map<String, dynamic> entry;
  final List<dynamic> nudges;
  @override
  State<CheckInDetail> createState() => _CheckInDetailState();
}

class _CheckInDetailState extends State<CheckInDetail> {
  late final TextEditingController note = TextEditingController(
    text: '${widget.entry['notes'] ?? ''}',
  );
  bool busy = false;
  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  Future<void> save() async {
    setState(() => busy = true);
    try {
      await widget.apiClient.patch(
        '/api/tracking/mood-check-ins/${widget.entry['id']}/',
        body: {'notes': note.text},
      );
      if (mounted)
        showCalmMessage(
          context,
          'Private note saved. Previous nudge messages are unchanged.',
        );
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> remove() async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Delete this check-in?'),
        content: const Text(
          'This permanently removes the private entry and its linked nudges and support conversation. People who already read a message may still remember it.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Keep'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (yes != true) return;
    setState(() => busy = true);
    try {
      await widget.apiClient.delete(
        '/api/tracking/mood-check-ins/${widget.entry['id']}/',
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Private check-in')),
    body: ListView(
      padding: screenPadding,
      children: [
        PageIntro(
          title: '${widget.entry['feeling_category']}'.replaceAll('_', ' '),
          subtitle:
              '${widget.entry['date']} · Only you can view this private entry.',
        ),
        const SizedBox(height: 20),
        TextField(
          controller: note,
          maxLength: 500,
          minLines: 3,
          maxLines: 8,
          decoration: const InputDecoration(labelText: 'Private note'),
        ),
        FilledButton(
          onPressed: busy ? null : save,
          child: const Text('Save private note'),
        ),
        const SizedBox(height: 24),
        const Text(
          'What you chose to share',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        if (widget.nudges.isEmpty)
          const StatusPanel(message: 'No nudge was sent from this check-in.')
        else
          for (final n in widget.nudges)
            HearteliCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('To ${n['recipient_name']}'),
                  Text('${n['message']}'),
                  if ('${n['support_preference'] ?? ''}'.isNotEmpty)
                    Text('${n['support_preference']}'),
                  Text('${n['status']} · ${n['delivery_status']}'),
                ],
              ),
            ),
        const SizedBox(height: 20),
        OutlinedButton(
          onPressed: busy ? null : remove,
          child: const Text('Delete check-in'),
        ),
      ],
    ),
  );
}
