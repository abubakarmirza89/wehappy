import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/data/auth_repository.dart';
import '../../auth/presentation/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.sessionStore, required this.apiClient});
  final SessionStore sessionStore;
  final ApiClient apiClient;

  Future<void> _logout(BuildContext context) async {
    await AuthRepository(apiClient, sessionStore).logout();
    if (context.mounted) Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => LoginScreen(sessionStore: sessionStore, apiClient: apiClient)), (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final name = sessionStore.userName ?? 'MindMenta member';
    return SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 32), children: [
      Text('Your profile', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.ink)),
      const SizedBox(height: 20),
      Card(child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [const CircleAvatar(radius: 30, backgroundColor: AppColors.lilac, child: Icon(Icons.person, size: 30)), const SizedBox(width: 16), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)), const SizedBox(height: 4), Text(sessionStore.userId == null ? 'Your wellbeing journey' : 'Member #${sessionStore.userId}')])]))),
      const SizedBox(height: 20),
      Card(child: Column(children: [ListTile(leading: const Icon(Icons.notifications_none), title: const Text('Notifications'), trailing: const Icon(Icons.chevron_right), onTap: () {}), const Divider(height: 1), ListTile(leading: const Icon(Icons.lock_outline), title: const Text('Privacy and security'), trailing: const Icon(Icons.chevron_right), onTap: () {}), const Divider(height: 1), ListTile(leading: const Icon(Icons.info_outline), title: const Text('About MindMenta'), trailing: const Icon(Icons.chevron_right), onTap: () {})])),
      const SizedBox(height: 20),
      OutlinedButton.icon(onPressed: () => _logout(context), icon: const Icon(Icons.logout), label: const Text('Sign out')),
    ]));
  }
}
