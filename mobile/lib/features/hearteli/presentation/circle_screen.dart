import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import 'components.dart';

class CircleScreen extends StatefulWidget {
  const CircleScreen({
    super.key,
    required this.apiClient,
    required this.sessionStore,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
  @override
  State<CircleScreen> createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  List<dynamic> connections = [];
  bool loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final data = await widget.apiClient.get('/api/tracking/hearteli/circle/');
      if (mounted) setState(() => connections = items(data));
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> add() async {
    final email = TextEditingController();
    String relationship = 'Friend';
    await showDialog(
      context: context,
      builder: (dialog) => StatefulBuilder(
        builder: (dialog, update) => AlertDialog(
          title: const Text('Add someone'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'They will only receive an invitation. Your check-ins remain private.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Their Hearteli email',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: relationship,
                decoration: const InputDecoration(labelText: 'Relationship'),
                items:
                    [
                          'Partner',
                          'Parent',
                          'Family',
                          'Friend',
                          'Colleague',
                          'Other',
                        ]
                        .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                        .toList(),
                onChanged: (v) =>
                    update(() => relationship = v ?? relationship),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialog),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await widget.apiClient.post(
                    '/api/tracking/hearteli/circle/',
                    body: {
                      'recipient_email_input': email.text.trim(),
                      'relationship': relationship,
                    },
                  );
                  if (dialog.mounted) Navigator.pop(dialog);
                  await load();
                } catch (e) {
                  if (dialog.mounted) showCalmMessage(dialog, '$e');
                }
              },
              child: const Text('Send invite'),
            ),
          ],
        ),
      ),
    );
    email.dispose();
  }

  Future<void> updateConnection(int id, Map<String, dynamic> payload) async {
    try {
      await widget.apiClient.patch(
        '/api/tracking/hearteli/circle/$id/',
        body: payload,
      );
      await load();
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    }
  }

  Future<void> remove(Map<String, dynamic> person) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Remove from Circle?'),
        content: const Text(
          'Future access to your nudges will stop immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await widget.apiClient.delete(
        '/api/tracking/hearteli/circle/${person['id']}/',
      );
      await load();
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    }
  }

  void open(Map<String, dynamic> person) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => CircleDetail(
        person: person,
        isOwner: '${person['owner']}' == widget.sessionStore.userId,
        onUpdate: (data) => updateConnection(person['id'] as int, data),
        onRemove: () => remove(person),
      ),
    ),
  ).then((_) => load());
  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: load,
    child: ListView(
      padding: screenPadding,
      children: [
        const BrandLogo(height: 38),
        const SizedBox(height: 26),
        const PageIntro(
          title: 'Your Circle',
          subtitle: 'People who care about you.',
        ),
        const SizedBox(height: 14),
        if (loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(),
            ),
          )
        else if (error != null)
          StatusPanel(message: error!, action: 'Retry', onAction: load)
        else if (connections.isEmpty)
          const StatusPanel(
            message: 'Your Circle is yours to build. Check-ins work privately even without adding someone.',
            icon: Icons.people_outline,
          )
        else
          for (final raw in connections)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: HearteliCard(
                child: LabelRow(
                  icon: Icons.person_outline,
                  title: '${raw['owner']}' == widget.sessionStore.userId
                      ? '${raw['recipient_name']}'
                      : '${raw['owner_name']}',
                  subtitle:
                      '${raw['relationship']} · ${raw['accepted_at'] == null
                          ? 'Pending'
                          : raw['may_receive_nudges'] == true
                          ? 'Nudges enabled'
                          : 'Paused'}',
                  onTap: () => open(Map<String, dynamic>.from(raw as Map)),
                ),
              ),
            ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: add,
          icon: const Icon(Icons.add),
          label: const Text('Add someone'),
        ),
        const SizedBox(height: 10),
        const Text(
          'No one sees a private check-in simply by joining your Circle.',
          style: TextStyle(color: AppColors.neutralGrey),
        ),
      ],
    ),
  );
}

class CircleDetail extends StatefulWidget {
  const CircleDetail({
    super.key,
    required this.person,
    required this.isOwner,
    required this.onUpdate,
    required this.onRemove,
  });
  final Map<String, dynamic> person;
  final bool isOwner;
  final Future<void> Function(Map<String, dynamic>) onUpdate;
  final Future<void> Function() onRemove;
  @override
  State<CircleDetail> createState() => _CircleDetailState();
}

class _CircleDetailState extends State<CircleDetail> {
  late bool nudge = widget.person['may_receive_nudges'] == true;
  late bool preference = widget.person['may_receive_preference'] == true;
  bool busy = false;
  Future<void> change(Map<String, dynamic> value) async {
    setState(() => busy = true);
    await widget.onUpdate(value);
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final pending = widget.person['accepted_at'] == null;
    final personName = widget.isOwner
        ? '${widget.person['recipient_name']}'
        : '${widget.person['owner_name']}';
    return Scaffold(
      appBar: AppBar(title: const Text('Circle person')),
      body: ListView(
        padding: screenPadding,
        children: [
          const SizedBox(height: 12),
          CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.blush,
            child: Text(
              personName.isEmpty
                  ? '?'
                  : personName.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 30, color: AppColors.coral),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            personName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            '${widget.person['relationship']} · ${pending ? 'Invitation pending' : 'Connected'}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          if (!widget.isOwner && pending) ...[
            const StatusPanel(
              message: 'Accepting does not share any history or private check-ins with you.',
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: busy ? null : () => change({'accept': true}),
              child: const Text('Accept invitation'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: busy
                  ? null
                  : () async {
                      await change({'accept': false});
                      if (context.mounted) Navigator.pop(context);
                    },
              child: const Text('Decline'),
            ),
          ] else ...[
            HearteliCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Who can see what?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Private notes and full check-in history are never included.',
                  ),
                  if (widget.isOwner)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Include support preference'),
                      subtitle: const Text(
                        'Only when you choose it in a nudge preview.',
                      ),
                      value: preference,
                      onChanged: pending || busy
                          ? null
                          : (v) async {
                              await change({'may_receive_preference': v});
                              if (mounted) setState(() => preference = v);
                            },
                    )
                  else
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Receive nudges'),
                      subtitle: const Text('Pause or resume any time.'),
                      value: nudge,
                      onChanged: busy
                          ? null
                          : (v) async {
                              await change({'may_receive_nudges': v});
                              if (mounted) setState(() => nudge = v);
                            },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: busy
                  ? null
                  : () async {
                      await widget.onRemove();
                      if (context.mounted) Navigator.pop(context);
                    },
              child: const Text('Remove and revoke future access'),
            ),
          ],
        ],
      ),
    );
  }
}
