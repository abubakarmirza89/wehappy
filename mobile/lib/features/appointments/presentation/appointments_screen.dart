import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../hearteli/presentation/components.dart';

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

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Your appointments')),
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
            const StatusPanel(
              message: 'No appointments yet. Explore therapists to request your first session.',
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
                      if (raw['status'] == 'BOOKED')
                        Wrap(
                          spacing: 10,
                          children: [
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
