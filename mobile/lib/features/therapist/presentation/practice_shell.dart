import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../hearteli/presentation/components.dart';
import '../../hearteli/presentation/settings_screen.dart';
import '../../appointments/presentation/appointments_screen.dart';
import 'therapist_dashboard_screen.dart';

class PracticeShell extends StatefulWidget {
  const PracticeShell({
    super.key,
    required this.apiClient,
    required this.sessionStore,
    required this.onPersonal,
  });
  final VoidCallback onPersonal;
  final ApiClient apiClient;
  final SessionStore sessionStore;
  @override
  State<PracticeShell> createState() => _PracticeShellState();
}

class _PracticeShellState extends State<PracticeShell> {
  int selected = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Hearteli · Your practice'),
      actions: [
        IconButton(
          onPressed: widget.onPersonal,
          icon: const Icon(Icons.home_outlined),
          tooltip: 'Personal space',
        ),
      ],
    ),
    body: IndexedStack(
      index: selected,
      children: [
        TherapistDashboardScreen(apiClient: widget.apiClient),
        AppointmentsScreen(apiClient: widget.apiClient),
        PracticeProfile(apiClient: widget.apiClient),
        SettingsScreen(
          apiClient: widget.apiClient,
          sessionStore: widget.sessionStore,
        ),
      ],
    ),
    bottomNavigationBar: NavigationBar(
      selectedIndex: selected,
      onDestinationSelected: (v) => setState(() => selected = v),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined),
          label: 'Practice',
        ),
        NavigationDestination(
          icon: Icon(Icons.calendar_month),
          label: 'Sessions',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    ),
  );
}

class TherapistApplicationScreen extends StatefulWidget {
  const TherapistApplicationScreen({super.key, required this.apiClient});
  final ApiClient apiClient;
  @override
  State<TherapistApplicationScreen> createState() =>
      _TherapistApplicationState();
}

class _TherapistApplicationState extends State<TherapistApplicationScreen> {
  final form = GlobalKey<FormState>();
  final fields = {
    for (final key in [
      'bio',
      'credentials',
      'license_number',
      'location',
      'modalities',
    ])
      key: TextEditingController(),
  };
  Map<String, dynamic>? application;
  String? error;
  bool busy = false;
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    for (final c in fields.values) c.dispose();
    super.dispose();
  }

  Future<void> load() async {
    try {
      final value = await widget.apiClient.get(
        '/api/users/therapist/application/',
      );
      if (mounted)
        setState(() => application = Map<String, dynamic>.from(value));
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    }
  }

  Future<void> submit() async {
    if (!form.currentState!.validate()) return;
    setState(() => busy = true);
    try {
      await widget.apiClient.post(
        '/api/users/therapist/application/',
        body: fields.map((key, c) => MapEntry(key, c.text.trim())),
      );
      await load();
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Become a therapist')),
    body: ListView(
      padding: screenPadding,
      children: [
        const PageIntro(
          title: 'Bring your practice to Hearteli',
          subtitle: 'Submit your credentials for review. Approval is required before you can offer sessions. Hearteli retains 10% of verified session payments.',
        ),
        if (error != null)
          StatusPanel(message: error!, action: 'Retry', onAction: load),
        if (application == null && error == null)
          const Center(child: CircularProgressIndicator()),
        if (application != null) ...[
          Text('Status: ${application!['status']}'),
          if ('${application!['review_note'] ?? ''}'.isNotEmpty)
            Text('${application!['review_note']}'),
          if (application!['status'] == 'approved')
            const Text(
              'Your application is approved. Sign out and sign back in to open your practice workspace.',
            ),
          if (['not_applied', 'rejected'].contains(application!['status']))
            Form(
              key: form,
              child: Column(
                children: [
                  for (final entry in fields.entries)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextFormField(
                        controller: entry.value,
                        maxLength: entry.key == 'bio' ? 2000 : 500,
                        decoration: InputDecoration(
                          labelText: entry.key.replaceAll('_', ' '),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                    ),
                  FilledButton(
                    onPressed: busy ? null : submit,
                    child: Text(busy ? 'Submitting…' : 'Submit for review'),
                  ),
                ],
              ),
            ),
        ],
      ],
    ),
  );
}

class PracticeProfile extends StatefulWidget {
  const PracticeProfile({super.key, required this.apiClient});
  final ApiClient apiClient;
  @override
  State<PracticeProfile> createState() => _PracticeProfileState();
}

class _PracticeProfileState extends State<PracticeProfile> {
  final degrees = TextEditingController(),
      certifications = TextEditingController(),
      rate = TextEditingController();
  bool available = false, busy = false, loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    degrees.dispose();
    certifications.dispose();
    rate.dispose();
    super.dispose();
  }

  Future<void> load() async {
    try {
      final d = await widget.apiClient.get('/api/users/therapist/profile/');
      degrees.text = '${d['degrees'] ?? ''}';
      certifications.text = '${d['certifications'] ?? ''}';
      rate.text = '${d['hourly_rate'] ?? ''}';
      if (mounted)
        setState(() {
          available = d['is_available'] == true;
          loading = false;
        });
    } catch (e) {
      if (mounted)
        setState(() {
          error = '$e';
          loading = false;
        });
    }
  }

  Future<void> save() async {
    setState(() => busy = true);
    try {
      await widget.apiClient.patch(
        '/api/users/therapist/profile/',
        body: {
          'degrees': degrees.text,
          'certifications': certifications.text,
          'hourly_rate': rate.text,
          'is_available': available,
        },
      );
      if (mounted) showCalmMessage(context, 'Practice profile saved.');
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: screenPadding,
    children: [
      const PageIntro(
        title: 'Your professional profile',
        subtitle: 'Set your hourly fee in USD. Your net earning is 90% of a verified session payment.',
      ),
      if (loading) const Center(child: CircularProgressIndicator()),
      if (error != null) StatusPanel(message: error!),
      TextField(
        controller: degrees,
        decoration: const InputDecoration(labelText: 'Degrees & credentials'),
      ),
      TextField(
        controller: certifications,
        decoration: const InputDecoration(labelText: 'Certifications'),
      ),
      TextField(
        controller: rate,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: const InputDecoration(labelText: 'Hourly fee (USD)'),
      ),
      SwitchListTile(
        title: const Text('Available for new clients'),
        value: available,
        onChanged: (v) => setState(() => available = v),
      ),
      FilledButton(
        onPressed: busy || loading ? null : save,
        child: const Text('Save profile'),
      ),
    ],
  );
}

class AppointmentChatScreen extends StatefulWidget {
  const AppointmentChatScreen({
    super.key,
    required this.apiClient,
    required this.id,
  });
  final ApiClient apiClient;
  final int id;
  @override
  State<AppointmentChatScreen> createState() => _AppointmentChatState();
}

class _AppointmentChatState extends State<AppointmentChatScreen> {
  List<dynamic> messages = [];
  final text = TextEditingController();
  String? error;
  bool busy = false;
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  Future<void> load() async {
    try {
      final d = await widget.apiClient.get(
        '/api/users/appointment/${widget.id}/messages/',
      );
      if (mounted)
        setState(() {
          messages = items(d);
          error = null;
        });
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    }
  }

  Future<void> send() async {
    if (text.text.trim().isEmpty) return;
    setState(() => busy = true);
    try {
      await widget.apiClient.post(
        '/api/users/appointment/${widget.id}/messages/',
        body: {'body': text.text.trim()},
      );
      text.clear();
      await load();
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Private session chat'),
      actions: [
        IconButton(
          onPressed: load,
          icon: const Icon(Icons.refresh),
          tooltip: 'Refresh messages',
        ),
      ],
    ),
    body: ListView(
      padding: screenPadding,
      children: [
        if (error != null) StatusPanel(message: error!),
        for (final m in messages)
          HearteliCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('${m['body']}'), Text('${m['created_at']}')],
            ),
          ),
        TextField(
          controller: text,
          maxLength: 2000,
          minLines: 2,
          maxLines: 5,
          decoration: const InputDecoration(labelText: 'Private message'),
        ),
        FilledButton(
          onPressed: busy ? null : send,
          child: const Text('Send message'),
        ),
      ],
    ),
  );
}
