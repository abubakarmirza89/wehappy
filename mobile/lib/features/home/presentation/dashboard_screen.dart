import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/section_title.dart';
import '../../mood/presentation/mood_screen.dart';
import '../../workspaces/presentation/workspace_detail_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.sessionStore, required this.apiClient});

  final SessionStore sessionStore;
  final ApiClient apiClient;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Map<String, dynamic>> _load() async {
    final results = await Future.wait([
      widget.apiClient.get('/api/tracking/mood-check-ins/analytics/'),
      widget.apiClient.get('/api/users/notifications/'),
      widget.apiClient.get('/api/tracking/workspaces/'),
    ]);
    return {
      'analytics': results[0] as Map<String, dynamic>,
      'notifications': results[1] is List ? results[1] as List : const [],
      'workspaces': results[2] is List ? results[2] as List : const [],
    };
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView();
          if (snapshot.hasError) return ErrorView(message: '${snapshot.error}', onRetry: () => setState(() => _future = _load()));
          final analytics = snapshot.data!['analytics'] as Map<String, dynamic>;
          final notifications = snapshot.data!['notifications'] as List;
          final workspaces = snapshot.data!['workspaces'] as List;
          final name = widget.sessionStore.userName ?? 'there';
          final score = (analytics['average_mood_score'] as num?)?.toStringAsFixed(0) ?? '0';
          return RefreshIndicator(
            onRefresh: () async => setState(() => _future = _load()),
            child: ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 32), children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Good day,', style: Theme.of(context).textTheme.bodyLarge), Text(name, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.ink))]),
                CircleAvatar(backgroundColor: AppColors.lilac, child: Text(name.isEmpty ? '?' : name[0].toUpperCase())),
              ]),
              const SizedBox(height: 24),
              Card(color: AppColors.ink, child: Padding(padding: const EdgeInsets.all(22), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Your wellbeing snapshot', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Row(children: [Text('$score%', style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800)), const SizedBox(width: 12), const Text('average mood\nthis week', style: TextStyle(color: Colors.white70))]),
                const SizedBox(height: 16),
                Text('${analytics['last_7_days_check_ins'] ?? 0} check-ins in the last 7 days', style: const TextStyle(color: Colors.white)),
              ]))),
              const SizedBox(height: 24),
              SectionTitle(title: 'Today\'s care'),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const CircleAvatar(backgroundColor: AppColors.blush, child: Text('😊')),
                  title: const Text('How are you feeling today?'),
                  subtitle: const Text('A small check-in helps you notice patterns.'),
                  trailing: const Icon(Icons.arrow_forward_rounded),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MoodScreen(apiClient: widget.apiClient))),
                ),
              ),
              const SizedBox(height: 24),
              SectionTitle(title: 'Workspaces'),
              const SizedBox(height: 10),
              Column(children: _workspaceCards(workspaces)),
              const SizedBox(height: 24),
              SectionTitle(title: 'Recent notifications', actionLabel: 'View all'),
              const SizedBox(height: 10),
              Column(children: _notificationCards(notifications)),
            ]),
          );
        },
      ),
    );
  }

  List<Widget> _workspaceCards(List<dynamic> workspaces) {
    if (workspaces.isEmpty) {
      return const [
        Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('No workspaces yet.'),
          ),
        ),
      ];
    }

    return workspaces.take(3).map((item) {
      final workspace = item as Map<String, dynamic>;
      final workspaceType = workspace['workspace_type'] ?? 'family';
      final isOffice = workspaceType == 'office';
      final planLabel = isOffice ? 'Office plan • \$20/month' : 'Personal plan';

      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => WorkspaceDetailScreen(
                sessionStore: widget.sessionStore,
                apiClient: widget.apiClient,
                workspace: workspace,
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundColor: isOffice ? AppColors.lilac : AppColors.blush,
            child: Text(isOffice ? 'O' : 'W'),
          ),
          title: Text('${workspace['name'] ?? 'Workspace'}'),
          subtitle: Text(
            '${workspaceType[0].toUpperCase()}${workspaceType.substring(1)} workspace • $planLabel',
          ),
          trailing: isOffice
              ? Chip(
                  label: const Text('Office'),
                  backgroundColor: AppColors.lilac,
                )
              : null,
        ),
      );
    }).toList();
  }

  List<Widget> _notificationCards(List<dynamic> notifications) {
    if (notifications.isEmpty) {
      return const [
        Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Text('You are all caught up.'),
          ),
        ),
      ];
    }
    return notifications.take(3).map((item) {
      final notification = item as Map<String, dynamic>;
      return Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: const Icon(Icons.notifications_none),
          title: Text('${notification['verb'] ?? 'New update'}'),
          subtitle: Text('${notification['created_at'] ?? ''}'),
        ),
      );
    }).toList();
  }
}
