import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/section_title.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key, required this.apiClient});
  final ApiClient apiClient;
  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  late Future<List<dynamic>> _future;
  @override
  void initState() { super.initState(); _future = _load(); }
  Future<List<dynamic>> _load() async { final data = await widget.apiClient.get('/api/users/appointment/'); return data is List ? data : const []; }

  @override
  Widget build(BuildContext context) => SafeArea(child: FutureBuilder<List<dynamic>>(future: _future, builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView(message: 'Loading your sessions...');
    if (snapshot.hasError) return ErrorView(message: '${snapshot.error}', onRetry: () => setState(() => _future = _load()));
    final appointments = snapshot.data!;
    return ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 32), children: [
      Text('Your sessions', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.ink)),
      const SizedBox(height: 8), const Text('Keep your support appointments in one calm place.'), const SizedBox(height: 24), SectionTitle(title: '${appointments.length} appointments'), const SizedBox(height: 12),
      if (appointments.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(20), child: Text('No appointments yet. Explore therapists to book your first session.'))),
      ...appointments.map((item) { final appointment = item as Map<String, dynamic>; return Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(contentPadding: const EdgeInsets.all(16), leading: const CircleAvatar(backgroundColor: AppColors.blush, child: Icon(Icons.calendar_today_outlined)), title: Text('${appointment['therapist'] ?? 'Therapy session'}', style: const TextStyle(fontWeight: FontWeight.w700)), subtitle: Text('${appointment['date'] ?? ''}  ${appointment['time'] ?? ''}\n${appointment['location'] ?? 'Online'}'), isThreeLine: true, trailing: Text('${appointment['status'] ?? 'BOOKED'}'))); }),
    ]);
  }));
}
