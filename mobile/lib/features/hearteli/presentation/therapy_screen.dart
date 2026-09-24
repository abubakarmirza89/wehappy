import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import 'components.dart';

class TherapyScreen extends StatefulWidget {
  const TherapyScreen({super.key, required this.apiClient});
  final ApiClient apiClient;
  @override
  State<TherapyScreen> createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> {
  List<dynamic> professionals = [];
  bool loading = true;
  String? error;
  String query = '';
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data = await widget.apiClient.get('/api/users/therapists/');
      if (mounted)
        setState(() {
          professionals = items(data);
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

  @override
  Widget build(BuildContext context) {
    final filtered = professionals
        .where(
          (p) => '${p['name']}'.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Professional support')),
      body: ListView(
        padding: screenPadding,
        children: [
          const PageIntro(
            title: 'Find a therapist',
            subtitle: 'Professional support is here if you want it.',
          ),
          const SizedBox(height: 18),
          TextField(
            onChanged: (v) => setState(() => query = v),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search by name',
            ),
          ),
          const SizedBox(height: 16),
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (error != null)
            StatusPanel(message: error!, action: 'Retry', onAction: load)
          else if (filtered.isEmpty)
            const StatusPanel(message: 'No professionals match right now.')
          else
            for (final raw in filtered)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: HearteliCard(
                  child: LabelRow(
                    icon: Icons.psychology_outlined,
                    title: '${raw['name']}',
                    subtitle: raw['therapist_profile']?['is_available'] == true
                        ? 'Available · Fee: ${raw['therapist_profile']?['hourly_rate'] ?? 'Ask provider'}'
                        : 'Availability not confirmed',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TherapistDetail(
                          apiClient: widget.apiClient,
                          therapist: Map<String, dynamic>.from(raw as Map),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          const SizedBox(height: 12),
          const Text(
            'Hearteli is not emergency care. For urgent safety concerns, use Immediate support.',
            style: TextStyle(color: AppColors.neutralGrey),
          ),
        ],
      ),
    );
  }
}

class TherapistDetail extends StatelessWidget {
  const TherapistDetail({
    super.key,
    required this.apiClient,
    required this.therapist,
  });
  final ApiClient apiClient;
  final Map<String, dynamic> therapist;
  @override
  Widget build(BuildContext context) {
    final profile = therapist['therapist_profile'] as Map? ?? {};
    return Scaffold(
      appBar: AppBar(title: const Text('Therapist profile')),
      body: ListView(
        padding: screenPadding,
        children: [
          Center(
            child: CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.blush,
              child: const Icon(
                Icons.person_outline,
                color: AppColors.coral,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '${therapist['name']}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          HearteliCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Professional details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text('Credentials: ${profile['degrees'] ?? 'Not provided'}'),
                const SizedBox(height: 7),
                Text(
                  'Certifications: ${profile['certifications'] ?? 'Not provided'}',
                ),
                const SizedBox(height: 7),
                Text(
                  'Fee: ${profile['hourly_rate'] ?? 'Confirm with provider'}',
                ),
                const SizedBox(height: 7),
                Text(
                  'Availability: ${profile['is_available'] == true ? 'Ask for a time' : 'Not confirmed'}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    BookTherapist(apiClient: apiClient, therapist: therapist),
              ),
            ),
            child: const Text('Request a session'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ShareTherapyContext(
                  apiClient: apiClient,
                  therapist: therapist,
                ),
              ),
            ),
            child: const Text('Share selected context'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Sharing context is separate from booking and is always optional.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.neutralGrey),
          ),
        ],
      ),
    );
  }
}

class BookTherapist extends StatefulWidget {
  const BookTherapist({
    super.key,
    required this.apiClient,
    required this.therapist,
  });
  final ApiClient apiClient;
  final Map<String, dynamic> therapist;
  @override
  State<BookTherapist> createState() => _BookTherapistState();
}

class _BookTherapistState extends State<BookTherapist> {
  DateTime? date;
  TimeOfDay? time;
  String format = 'Online';
  bool busy = false;
  final reason = TextEditingController();
  @override
  void dispose() {
    reason.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (date == null || time == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Review session request'),
        content: Text(
          '${widget.therapist['name']}\n${date!.toIso8601String().substring(0, 10)} · ${time!.format(context)} (${DateTime.now().timeZoneName})\n$format\nFee: ${widget.therapist['therapist_profile']?['hourly_rate'] ?? 'Confirm with provider'}\n\nThis request does not share your private check-ins.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Edit'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => busy = true);
    try {
      await widget.apiClient.post(
        '/api/users/create-appointment/${widget.therapist['id']}/',
        body: {
          'date': date!.toIso8601String().substring(0, 10),
          'time':
              '${time!.hour.toString().padLeft(2, '0')}:${time!.minute.toString().padLeft(2, '0')}',
          'location': format,
          'reason': reason.text.trim().isEmpty
              ? 'Support session'
              : reason.text.trim(),
        },
      );
      if (mounted) {
        showCalmMessage(
          context,
          'Session request saved. Confirm availability with the provider.',
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Request a session')),
    body: ListView(
      padding: screenPadding,
      children: [
        PageIntro(
          title: 'Book ${widget.therapist['name']}',
          subtitle: 'Choose a time and review details before submitting.',
        ),
        const SizedBox(height: 18),
        OutlinedButton(
          onPressed: () async {
            final result = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 180)),
            );
            if (result != null) setState(() => date = result);
          },
          child: Text(
            date == null
                ? 'Select date'
                : date!.toIso8601String().substring(0, 10),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () async {
            final result = await showTimePicker(
              context: context,
              initialTime: const TimeOfDay(hour: 10, minute: 0),
            );
            if (result != null) setState(() => time = result);
          },
          child: Text(
            time == null
                ? 'Select time'
                : '${time!.format(context)} · ${DateTime.now().timeZoneName}',
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: format,
          decoration: const InputDecoration(labelText: 'Session format'),
          items: [
            'Online',
            'In person',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => setState(() => format = v ?? format),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: reason,
          maxLength: 200,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Reason (optional; shared with therapist)',
          ),
        ),
        const SizedBox(height: 14),
        const StatusPanel(
          message: 'Booking does not grant access to your check-ins. You can share selected context separately.',
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: date == null || time == null || busy ? null : submit,
          child: Text(busy ? 'Submitting…' : 'Review booking'),
        ),
      ],
    ),
  );
}

class ShareTherapyContext extends StatefulWidget {
  const ShareTherapyContext({
    super.key,
    required this.apiClient,
    required this.therapist,
  });
  final ApiClient apiClient;
  final Map<String, dynamic> therapist;
  @override
  State<ShareTherapyContext> createState() => _ShareTherapyContextState();
}

class _ShareTherapyContextState extends State<ShareTherapyContext> {
  List<dynamic> checkins = [];
  final selected = <int>{};
  bool notes = false, busy = false;
  int days = 7;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data = await widget.apiClient.get('/api/tracking/mood-check-ins/');
      if (mounted) setState(() => checkins = items(data));
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    }
  }

  Future<void> share() async {
    if (selected.isEmpty) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Who can see this?'),
        content: Text(
          '${widget.therapist['name']} can view ${selected.length} selected check-in(s)${notes ? ', including their private notes' : ', without notes'}, for $days days. You can revoke access earlier.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Edit'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('Share selected'),
          ),
        ],
      ),
    );
    if (yes != true) return;
    setState(() => busy = true);
    try {
      await widget.apiClient.post(
        '/api/tracking/hearteli/therapy-context/',
        body: {
          'therapist': widget.therapist['id'],
          'check_in_ids': selected.toList(),
          'include_notes': notes,
          'expires_at': DateTime.now()
              .toUtc()
              .add(Duration(days: days))
              .toIso8601String(),
        },
      );
      if (mounted) {
        showCalmMessage(
          context,
          'Selected context shared. Revoke it in Privacy & Consent.',
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Share context')),
    body: ListView(
      padding: screenPadding,
      children: [
        PageIntro(
          title: 'Choose what to share',
          subtitle: 'Nothing is preselected. Booking stays separate.',
        ),
        const SizedBox(height: 16),
        if (error != null) StatusPanel(message: error!),
        if (checkins.isEmpty)
          const StatusPanel(
            message: 'No check-ins available. You can skip context sharing.',
          ),
        for (final raw in checkins.take(20))
          CheckboxListTile(
            title: Text(
              '${raw['date']} · ${raw['feeling_category'] ?? 'Check-in'}',
            ),
            subtitle: const Text('Only selected details'),
            value: selected.contains(raw['id']),
            onChanged: (v) => setState(
              () => v == true
                  ? selected.add(raw['id'] as int)
                  : selected.remove(raw['id']),
            ),
          ),
        SwitchListTile(
          title: const Text('Include private notes'),
          subtitle: const Text('Off by default'),
          value: notes,
          onChanged: (v) => setState(() => notes = v),
        ),
        DropdownButtonFormField<int>(
          value: days,
          decoration: const InputDecoration(labelText: 'Access expires in'),
          items: [1, 7, 30]
              .map(
                (v) => DropdownMenuItem(
                  value: v,
                  child: Text('$v day${v == 1 ? '' : 's'}'),
                ),
              )
              .toList(),
          onChanged: (v) => setState(() => days = v ?? days),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: selected.isEmpty || busy ? null : share,
          child: const Text('Preview selected context'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Skip'),
        ),
      ],
    ),
  );
}
