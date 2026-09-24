import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import 'components.dart';
import 'support_screen.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({
    super.key,
    required this.apiClient,
    required this.sessionStore,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  List<dynamic> workspaces = [];
  bool loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data = await widget.apiClient.get('/api/tracking/workspaces/');
      if (mounted)
        setState(() {
          workspaces = items(data)
              .where((w) => w['workspace_type'] == 'office')
              .toList();
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

  Future<void> join() async {
    final code = TextEditingController();
    await showDialog(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Join a workplace'),
        content: TextField(
          controller: code,
          decoration: const InputDecoration(labelText: 'Invite code'),
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
                  '/api/tracking/workspaces/join/',
                  body: {'invite_code': code.text.trim()},
                );
                if (dialog.mounted) Navigator.pop(dialog);
                load();
              } catch (e) {
                if (dialog.mounted) showCalmMessage(dialog, '$e');
              }
            },
            child: const Text('Join'),
          ),
        ],
      ),
    );
    code.dispose();
  }

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: load,
    child: ListView(
      padding: screenPadding,
      children: [
        const PageIntro(
          title: 'For Work',
          subtitle: 'Your personal check-ins stay yours. Work support is a separate choice.',
        ),
        const SizedBox(height: 18),
        const StatusPanel(
          message: 'Your employer does not get access to private moods, notes, or check-in history by paying for or inviting you to Hearteli.',
          icon: Icons.lock_outline,
        ),
        const SizedBox(height: 20),
        if (loading)
          const Center(child: CircularProgressIndicator())
        else if (error != null)
          StatusPanel(message: error!, action: 'Retry', onAction: load)
        else if (workspaces.isEmpty)
          const StatusPanel(
            message: 'You are not part of an active workplace yet.',
          )
        else
          for (final raw in workspaces)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: HearteliCard(
                child: LabelRow(
                  icon: Icons.work_outline,
                  title: '${raw['name']}',
                  subtitle: 'Separate workplace context',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WorkDetail(
                        apiClient: widget.apiClient,
                        sessionStore: widget.sessionStore,
                        workspace: Map<String, dynamic>.from(raw as Map),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: join,
          child: const Text('Join with invite code'),
        ),
      ],
    ),
  );
}

class WorkDetail extends StatefulWidget {
  const WorkDetail({
    super.key,
    required this.apiClient,
    required this.sessionStore,
    required this.workspace,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
  final Map<String, dynamic> workspace;
  @override
  State<WorkDetail> createState() => _WorkDetailState();
}

class _WorkDetailState extends State<WorkDetail> {
  Map<String, dynamic>? dashboard;
  List<dynamic> resources = [];
  String? error;
  bool get owner =>
      '${widget.workspace['owner']}' == widget.sessionStore.userId;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final resourceData = await widget.apiClient.get('/api/tracking/workspace-resources/');
      if (mounted) setState(() => resources = items(resourceData).where(
        (item) => item['workspace'] == widget.workspace['id']).toList());
      if (!owner) return;
      final data = await widget.apiClient.get(
        '/api/tracking/workspaces/${widget.workspace['id']}/office_dashboard/',
      );
      if (mounted)
        setState(() => dashboard = Map<String, dynamic>.from(data as Map));
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    }
  }

  Future<void> invite() async {
    final email = TextEditingController();
    await showDialog(
      context: context,
      builder: (dialog) => AlertDialog(
        title: const Text('Invite member'),
        content: TextField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Existing member email'),
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
                  '/api/tracking/workspaces/${widget.workspace['id']}/bulk_invite/',
                  body: {
                    'emails': [email.text.trim()],
                  },
                );
                if (dialog.mounted) Navigator.pop(dialog);
                load();
              } catch (e) {
                if (dialog.mounted) showCalmMessage(dialog, '$e');
              }
            },
            child: const Text('Invite'),
          ),
        ],
      ),
    );
    email.dispose();
  }

  Future<void> changeRole(Map member, String role) async {
    try {
      await widget.apiClient.post(
        '/api/tracking/workspaces/${widget.workspace['id']}/set_member_role/',
        body: {'member_id': member['id'], 'role': role},
      );
      await load();
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text('${widget.workspace['name']} · Work')),
    body: RefreshIndicator(
      onRefresh: load,
      child: ListView(
        padding: screenPadding,
        children: [
          PageIntro(
            title: '${widget.workspace['name']}',
            subtitle: 'Work support and personal wellbeing stay separate.',
          ),
          const SizedBox(height: 18),
          const HearteliCard(
            color: AppColors.softBlue,
            child: Text(
              'No individual personal mood or check-in history is visible to workplace owners or managers.',
            ),
          ),
          const SizedBox(height: 16),
          HearteliCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Support routes',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  'You can choose a trusted work contact for a single reviewed nudge. Joining a workspace alone never sends one.',
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SupportInboxScreen(apiClient: widget.apiClient),
                    ),
                  ),
                  child: const Text('View authorised nudges'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('Workplace resources', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          if (resources.isEmpty) const StatusPanel(message: 'No support resources configured yet.'),
          for (final raw in resources) HearteliCard(child: LabelRow(icon: Icons.folder_open_outlined,
            title: '${raw['title']}', subtitle: '${raw['description']} · ${raw['url']}',
            onTap: () async {
              final uri = Uri.tryParse('${raw['url']}');
              if (uri != null && uri.scheme == 'https') await launchUrl(uri, mode: LaunchMode.externalApplication);
            })),
          if (owner) ...[
            const SizedBox(height: 22),
            const Text(
              'Admin overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            ),
            if (error != null)
              StatusPanel(message: error!)
            else if (dashboard == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              const SizedBox(height: 12),
              HearteliCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${dashboard!['total_members']} members',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      dashboard!['aggregate_available'] == true
                          ? 'Aggregate wellbeing trends require separately authorised work-context data.'
                          : 'Aggregate trends suppressed below ${dashboard!['privacy_threshold']} members.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Members & roles',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              for (final raw in dashboard!['members'] as List)
                HearteliCard(
                  child: LabelRow(
                    icon: Icons.person_outline,
                    title: '${raw['name']}',
                    subtitle: '${raw['designation']} · ${raw['role']}',
                    trailing: raw['id'] == widget.workspace['owner']
                        ? null
                        : PopupMenuButton<String>(
                            tooltip: 'Change member role',
                            onSelected: (v) => changeRole(raw as Map, v),
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: 'employee',
                                child: Text('Employee'),
                              ),
                              PopupMenuItem(
                                value: 'manager',
                                child: Text('Manager'),
                              ),
                            ],
                          ),
                  ),
                ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: invite,
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: const Text('Invite member'),
              ),
            ],
          ],
        ],
      ),
    ),
  );
}
