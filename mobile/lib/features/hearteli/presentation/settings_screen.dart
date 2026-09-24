import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/login_screen.dart';
import 'circle_screen.dart';
import 'components.dart';
import 'safety_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
    required this.apiClient,
    required this.sessionStore,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Settings')),
    body: ListView(
      padding: screenPadding,
      children: [
        const PageIntro(title: 'Your space, your choices'),
        const SizedBox(height: 22),
        HearteliCard(
          child: Column(
            children: [
              LabelRow(
                icon: Icons.lock_outline,
                title: 'Privacy & Consent',
                subtitle: 'See who can know what',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PrivacyCenter(
                      apiClient: apiClient,
                      sessionStore: sessionStore,
                    ),
                  ),
                ),
              ),
              LabelRow(
                icon: Icons.notifications_none,
                title: 'Notifications & quiet hours',
                subtitle: 'Set how and when Hearteli reaches you',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NotificationSettings(apiClient: apiClient),
                  ),
                ),
              ),
              LabelRow(
                icon: Icons.folder_outlined,
                title: 'Your data',
                subtitle: 'Export or request deletion',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DataSettings(
                      apiClient: apiClient,
                      sessionStore: sessionStore,
                    ),
                  ),
                ),
              ),
              LabelRow(
                icon: Icons.health_and_safety_outlined,
                title: 'Immediate support',
                subtitle: 'Find help when you need it',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SafetyScreen()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        OutlinedButton(
          onPressed: () async {
            await AuthRepository(apiClient, sessionStore).logout();
            if (context.mounted)
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => LoginScreen(
                    sessionStore: sessionStore,
                    apiClient: apiClient,
                  ),
                ),
                (_) => false,
              );
          },
          child: const Text('Sign out'),
        ),
      ],
    ),
  );
}

class PrivacyCenter extends StatefulWidget {
  const PrivacyCenter({
    super.key,
    required this.apiClient,
    required this.sessionStore,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
  @override
  State<PrivacyCenter> createState() => _PrivacyCenterState();
}

class _PrivacyCenterState extends State<PrivacyCenter> {
  List<dynamic> grants = [], circle = [];
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final values = await Future.wait([
        widget.apiClient.get('/api/tracking/hearteli/therapy-context/'),
        widget.apiClient.get('/api/tracking/hearteli/circle/'),
      ]);
      if (mounted)
        setState(() {
          grants = items(values[0]);
          circle = items(values[1]);
          error = null;
        });
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    }
  }

  Future<void> revoke(int id) async {
    try {
      await widget.apiClient.delete(
        '/api/tracking/hearteli/therapy-context/$id/',
      );
      await load();
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Privacy & Consent')),
    body: RefreshIndicator(
      onRefresh: load,
      child: ListView(
        padding: screenPadding,
        children: [
          const PageIntro(
            title: 'Who can see what?',
            subtitle: 'You control each relationship and each share.',
          ),
          const SizedBox(height: 18),
          const StatusPanel(
            message: 'New check-ins are private. Circle invitations do not share history. Each nudge requires your preview and confirmation.',
            icon: Icons.lock_outline,
          ),
          const SizedBox(height: 20),
          const Text(
            'Your Circle',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          if (error != null)
            StatusPanel(message: error!, action: 'Retry', onAction: load),
          if (circle.isEmpty) const Text('No active Circle relationships.'),
          for (final raw in circle)
            HearteliCard(
              child: LabelRow(
                icon: Icons.people_outline,
                title: '${raw['recipient_name']}',
                subtitle:
                    '${raw['relationship']} · ${raw['accepted_at'] == null ? 'Pending' : 'Accepted'}',
              ),
            ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: const Text('Circle permissions')),
                  body: CircleScreen(
                    apiClient: widget.apiClient,
                    sessionStore: widget.sessionStore,
                  ),
                ),
              ),
            ).then((_) => load()),
            child: const Text('Manage Circle permissions'),
          ),
          const SizedBox(height: 22),
          const Text(
            'Therapist context',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          if (grants.isEmpty) const Text('No context grants.'),
          for (final raw in grants)
            if ('${raw['therapist']}' != widget.sessionStore.userId)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: HearteliCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${raw['therapist_name']}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        '${(raw['selected_context'] as List? ?? []).length} selected check-ins · expires ${raw['expires_at']?.toString().substring(0, 10)}',
                      ),
                      if (raw['revoked_at'] == null)
                        TextButton(
                          onPressed: () => revoke(raw['id'] as int),
                          child: const Text('Revoke access'),
                        )
                      else
                        const Text('Revoked'),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: 20),
          const Text(
            'Workplace data',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
          ),
          const StatusPanel(
            message: 'Membership never grants access to your personal check-ins. You can choose a separate, reviewed nudge for one support person.',
          ),
        ],
      ),
    ),
  );
}

class NotificationSettings extends StatefulWidget {
  const NotificationSettings({super.key, required this.apiClient});
  final ApiClient apiClient;
  @override
  State<NotificationSettings> createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  bool reminder = false, nudge = true, rich = false, busy = false;
  TimeOfDay? start, end;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  TimeOfDay? parse(dynamic text) {
    if (text == null) return null;
    final parts = '$text'.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String? format(TimeOfDay? value) => value == null
      ? null
      : '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
  Future<void> load() async {
    try {
      final data = await widget.apiClient.get(
        '/api/tracking/hearteli/preferences/',
      );
      if (mounted)
        setState(() {
          reminder = data['reminder_enabled'] == true;
          nudge = data['nudge_notifications'] != false;
          rich = data['rich_lock_preview'] == true;
          start = parse(data['quiet_start']);
          end = parse(data['quiet_end']);
        });
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    }
  }

  Future<void> save() async {
    setState(() => busy = true);
    try {
      await widget.apiClient.patch(
        '/api/tracking/hearteli/preferences/update_mine/',
        body: {
          'reminder_enabled': reminder,
          'nudge_notifications': nudge,
          'rich_lock_preview': rich,
          'quiet_start': format(start),
          'quiet_end': format(end),
        },
      );
      if (mounted)
        showCalmMessage(
          context,
          'Preferences saved. Device notification delivery requires OS permission and server setup.',
        );
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Notifications')),
    body: ListView(
      padding: screenPadding,
      children: [
        const PageIntro(
          title: 'A gentle pace',
          subtitle: 'You choose when to hear from Hearteli.',
        ),
        const SizedBox(height: 18),
        SwitchListTile(
          title: const Text('Daily reminder'),
          value: reminder,
          onChanged: (v) => setState(() => reminder = v),
        ),
        SwitchListTile(
          title: const Text('Nudge notifications'),
          value: nudge,
          onChanged: (v) => setState(() => nudge = v),
        ),
        SwitchListTile(
          title: const Text('Show details on lock screen'),
          subtitle: const Text('Off by default for privacy.'),
          value: rich,
          onChanged: (v) => setState(() => rich = v),
        ),
        const SizedBox(height: 12),
        const Text(
          'Quiet hours',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        OutlinedButton(
          onPressed: () async {
            final t = await showTimePicker(
              context: context,
              initialTime: start ?? const TimeOfDay(hour: 22, minute: 0),
            );
            if (t != null) setState(() => start = t);
          },
          child: Text(
            start == null ? 'Start time' : 'From ${start!.format(context)}',
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () async {
            final t = await showTimePicker(
              context: context,
              initialTime: end ?? const TimeOfDay(hour: 8, minute: 0),
            );
            if (t != null) setState(() => end = t);
          },
          child: Text(
            end == null ? 'End time' : 'Until ${end!.format(context)}',
          ),
        ),
        const SizedBox(height: 12),
        if (error != null) StatusPanel(message: error!),
        FilledButton(
          onPressed: busy ? null : save,
          child: const Text('Save preferences'),
        ),
        const SizedBox(height: 10),
        const Text(
          'These preferences are saved to your account. Automatic reminder and push delivery are not enabled yet.',
          style: TextStyle(color: AppColors.neutralGrey),
        ),
      ],
    ),
  );
}

class DataSettings extends StatefulWidget {
  const DataSettings({
    super.key,
    required this.apiClient,
    required this.sessionStore,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
  @override
  State<DataSettings> createState() => _DataSettingsState();
}

class _DataSettingsState extends State<DataSettings> {
  bool busy = false;
  String? error;
  Future<void> export() async {
    setState(() => busy = true);
    try {
      final data = await widget.apiClient.get('/api/tracking/hearteli/data/');
      await Clipboard.setData(
        ClipboardData(text: const JsonEncoder.withIndent('  ').convert(data)),
      );
      if (mounted)
        showCalmMessage(
          context,
          'Your data was copied as JSON. Paste it into a document you control.',
        );
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> delete() async {
    final password = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Delete your account?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'This permanently removes your account and Hearteli data. This action cannot be undone.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('Delete account'),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      password.dispose();
      return;
    }
    setState(() => busy = true);
    try {
      await widget.apiClient.post(
        '/api/tracking/hearteli/data/delete_account/',
        body: {'password': password.text},
      );
      await const FlutterSecureStorage().delete(
        key: 'hearteli_private_draft_${widget.sessionStore.userId ?? ''}',
      );
      await widget.sessionStore.clear();
      if (mounted)
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => LoginScreen(
              sessionStore: widget.sessionStore,
              apiClient: widget.apiClient,
            ),
          ),
          (_) => false,
        );
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      password.dispose();
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Your data')),
    body: ListView(
      padding: screenPadding,
      children: [
        const PageIntro(
          title: 'Your data, your decision',
          subtitle: 'Review or remove your Hearteli information.',
        ),
        const SizedBox(height: 18),
        const StatusPanel(
          message: 'Export contains your private check-ins, sent nudges, private outcomes and consent events. Keep copies secure.',
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: busy ? null : export,
          child: const Text('Copy my data as JSON'),
        ),
        const SizedBox(height: 25),
        const Text(
          'Delete account',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        const SizedBox(height: 8),
        const Text(
          'Deletion is permanent. We will ask for your current password to confirm.',
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: busy ? null : delete,
          child: const Text('Delete my account'),
        ),
        if (error != null) ...[
          const SizedBox(height: 14),
          StatusPanel(message: error!),
        ],
      ],
    ),
  );
}
