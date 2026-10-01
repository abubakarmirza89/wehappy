import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import 'components.dart';
import 'support_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key, required this.apiClient});
  final ApiClient apiClient;
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> notifications = [];
  bool loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data = await widget.apiClient.get('/api/users/notifications/');
      if (mounted)
        setState(() {
          notifications = items(data);
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

  Future<void> read(Map item) async {
    try {
      await widget.apiClient.post(
        '/api/users/notifications/${item['id']}/read/',
        body: {},
      );
      await load();
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Your updates')),
    body: RefreshIndicator(
      onRefresh: load,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: screenPadding,
        children: [
          const PageIntro(
            title: 'A little connection',
            subtitle: 'Account and support updates, in one place.',
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            icon: const Icon(Icons.favorite_outline),
            label: const Text('Open support nudges'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SupportInboxScreen(apiClient: widget.apiClient),
              ),
            ),
          ),
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (error != null)
            StatusPanel(message: error!, action: 'Try again', onAction: load)
          else if (notifications.isEmpty)
            const StatusPanel(message: 'No updates yet.')
          else
            for (final item in notifications)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: HearteliCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item['verb']}',
                        style: TextStyle(
                          fontWeight: item['read'] == true
                              ? FontWeight.w400
                              : FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text('${item['created_at']}'),
                      if (item['read'] != true)
                        TextButton(
                          onPressed: () => read(item as Map),
                          child: const Text('Mark as read'),
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
