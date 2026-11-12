import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../therapist/presentation/practice_shell.dart';

import '../../../core/network/api_client.dart';
import '../../hearteli/presentation/components.dart';
import '../../hearteli/presentation/therapy_screen.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key, required this.apiClient});
  final ApiClient apiClient;
  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  List<dynamic> appointments = [];
  bool loading = true, busy = false;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data = await widget.apiClient.get('/api/users/appointment/');
      if (mounted)
        setState(() {
          appointments = items(data);
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

  Future<void> change(Map item, bool cancel) async {
    Map<String, dynamic> payload = {};
    if (!cancel) {
      final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
      );
      if (date == null || !mounted) return;
      final time = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 10, minute: 0),
      );
      if (time == null || !mounted) return;
      payload = {
        'date': date.toIso8601String().substring(0, 10),
        'time':
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      };
    }
    if (!mounted) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(cancel ? 'Cancel appointment?' : 'Review new time'),
        content: Text(
          cancel
              ? 'Your booking history will remain available. Any payment refund follows your provider’s policy.'
              : '${payload['date']} at ${payload['time']} UTC. Confirm the timezone with your provider.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Keep current'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (!mounted || yes != true) return;
    setState(() => busy = true);
    try {
      if (cancel) {
        await widget.apiClient.post(
          '/api/users/appointment/${item['id']}/cancel/',
          body: {},
        );
      } else {
        await widget.apiClient.patch(
          '/api/users/appointment/${item['id']}/',
          body: payload,
        );
      }
      await load();
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> review(Map item) async {
    int rating = 5;
    final comment = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: const Text('Rate your completed session'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Your rating and review will appear on the therapist profile. Keep personal health details private.',
                ),
                DropdownButton<int>(
                  value: rating,
                  items: [1, 2, 3, 4, 5]
                      .map(
                        (v) =>
                            DropdownMenuItem(value: v, child: Text('$v / 5')),
                      )
                      .toList(),
                  onChanged: (v) => update(() => rating = v ?? 5),
                ),
                TextField(
                  controller: comment,
                  maxLength: 2000,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Review (optional)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialog, true),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true) {
      try {
        await widget.apiClient.post(
          '/api/users/feedback/${item['therapist_id']}/',
          body: {
            'appointment_id': item['id'],
            'rating': rating,
            'comment': comment.text.trim(),
          },
        );
        await load();
      } catch (e) {
        if (mounted) showCalmMessage(context, '$e');
      }
    }
    comment.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: RefreshIndicator(
      onRefresh: load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: screenPadding,
        children: [
          const PageIntro(
            title: 'Professional support',
            subtitle: 'Appointment times below use UTC. Confirm any provider-specific timezone before attending.',
          ),
          const SizedBox(height: 20),
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (error != null)
            StatusPanel(message: error!, action: 'Try again', onAction: load)
          else if (appointments.isEmpty)
            StatusPanel(
              message:
                  'No appointments yet. Explore therapists to request your first session.',
              action: 'Explore therapists',
              onAction: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TherapyScreen(apiClient: widget.apiClient),
                ),
              ),
            )
          else
            for (final raw in appointments)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HearteliCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${raw['therapist'] ?? raw['user'] ?? 'Session'}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text('${raw['date']} · ${raw['time']} UTC'),
                      Text('${raw['location']} · ${raw['status']}'),
                      if (raw.containsKey('therapist_id') &&
                          raw['status'] == 'COMPLETED')
                        TextButton(
                          onPressed: raw['review_submitted'] == true
                              ? null
                              : () => review(raw as Map),
                          child: Text(
                            raw['review_submitted'] == true
                                ? 'Review submitted'
                                : 'Rate this session',
                          ),
                        ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AppointmentChatScreen(
                              apiClient: widget.apiClient,
                              id: raw['id'] as int,
                            ),
                          ),
                        ),
                        child: const Text('Session chat'),
                      ),
                      if (raw.containsKey('therapist') &&
                          raw['payment_status'] == 'pending' &&
                          raw['status'] == 'BOOKED')
                        TextButton(
                          onPressed: () async {
                            try {
                              final data = await widget.apiClient.post(
                                '/api/users/appointment/${raw['id']}/checkout/',
                                body: {},
                              );
                              if (!await launchUrl(
                                    Uri.parse('${data['url']}'),
                                    mode: LaunchMode.externalApplication,
                                  ) &&
                                  mounted)
                                showCalmMessage(
                                  context,
                                  'Could not open secure payment.',
                                );
                            } catch (e) {
                              if (mounted) showCalmMessage(context, '$e');
                            }
                          },
                          child: const Text('Pay securely'),
                        ),
                      if (raw.containsKey('user') &&
                          ['BOOKED', 'IN_PROGRESS'].contains(raw['status']))
                        PopupMenuButton<String>(
                          onSelected: (status) async {
                            try {
                              await widget.apiClient.patch(
                                '/api/users/appointment/${raw['id']}/',
                                body: {'status': status},
                              );
                              await load();
                            } catch (e) {
                              if (mounted) showCalmMessage(context, '$e');
                            }
                          },
                          itemBuilder: (_) => raw['status'] == 'BOOKED'
                              ? const [
                                  PopupMenuItem(
                                    value: 'IN_PROGRESS',
                                    child: Text('Start session'),
                                  ),
                                ]
                              : const [
                                  PopupMenuItem(
                                    value: 'COMPLETED',
                                    child: Text('Complete session'),
                                  ),
                                ],
                          child: const Padding(
                            padding: EdgeInsets.all(14),
                            child: Text('Update session status'),
                          ),
                        ),
                      if (raw['status'] == 'BOOKED')
                        Wrap(
                          spacing: 10,
                          children: [
                            if (raw.containsKey('therapist'))
                              OutlinedButton(
                                onPressed: busy
                                    ? null
                                    : () => change(raw as Map, false),
                                child: const Text('Reschedule'),
                              ),
                            TextButton(
                              onPressed: busy
                                  ? null
                                  : () => change(raw as Map, true),
                              child: const Text('Cancel appointment'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    ),
  );
}
