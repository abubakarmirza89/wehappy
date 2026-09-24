import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/validation/validators.dart';
import '../../../shared/utils/toast.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/section_title.dart';
import '../../chat/presentation/chat_screen.dart';

class TherapistsScreen extends StatefulWidget {
  const TherapistsScreen({super.key, required this.apiClient});
  final ApiClient apiClient;
  @override
  State<TherapistsScreen> createState() => _TherapistsScreenState();
}

class _TherapistsScreenState extends State<TherapistsScreen> {
  late Future<List<dynamic>> _future;
  @override
  void initState() { super.initState(); _future = _load(); }
  Future<List<dynamic>> _load() async { final data = await widget.apiClient.get('/api/users/therapists/'); return data is List ? data : const []; }

  @override
  Widget build(BuildContext context) => SafeArea(child: FutureBuilder<List<dynamic>>(future: _future, builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView(message: 'Finding care professionals...');
    if (snapshot.hasError) return ErrorView(message: '${snapshot.error}', onRetry: () => setState(() => _future = _load()));
    final therapists = snapshot.data!;
    return ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 32), children: [
      Text('Find your support', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.ink)),
      const SizedBox(height: 8), const Text('Connect with a professional when you need a little more support.'), const SizedBox(height: 24),
      SectionTitle(title: '${therapists.length} therapists available'), const SizedBox(height: 12),
      if (therapists.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(20), child: Text('No therapists are available right now.'))),
      ...therapists.map((item) {
        final therapist = item as Map<String, dynamic>;
        final name = '${therapist['name'] ?? 'Therapist'}';
        final therapistId = (therapist['id'] as num?)?.toInt();
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(14),
            leading: CircleAvatar(backgroundColor: AppColors.mint, child: Text(name.isEmpty ? 'T' : name[0])),
            title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(therapist['email']?.toString() ?? 'Available for sessions'),
            trailing: Wrap(
              spacing: 4,
              children: [
                IconButton(
                  tooltip: 'Message therapist',
                  onPressed: therapistId == null ? null : () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(apiClient: widget.apiClient, therapistId: therapistId))),
                  icon: const Icon(Icons.chat_bubble_outline),
                ),
                FilledButton(onPressed: () => _showBooking(context, therapist), child: const Text('Book')),
              ],
            ),
          ),
        );
      }),
    ]);
  }));

  void _showBooking(BuildContext context, Map<String, dynamic> therapist) {
    final formKey = GlobalKey<FormState>();
    final date = TextEditingController();
    final time = TextEditingController();
    final location = TextEditingController(text: 'Online');
    final reason = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.fromLTRB(24, 8, 24, MediaQuery.of(sheetContext).viewInsets.bottom + 24),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Book ${therapist['name'] ?? 'therapist'}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                AppTextField(controller: date, label: 'Date (YYYY-MM-DD)', validator: (value) => Validators.required(value, label: 'Date')),
                const SizedBox(height: 10),
                AppTextField(controller: time, label: 'Time (HH:MM)', validator: (value) => Validators.required(value, label: 'Time')),
                const SizedBox(height: 10),
                AppTextField(controller: location, label: 'Location', validator: (value) => Validators.required(value, label: 'Location')),
                const SizedBox(height: 10),
                AppTextField(controller: reason, label: 'What would you like support with?', maxLines: 3, validator: (value) => Validators.minLength(value, label: 'Reason', length: 5)),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      try {
                        await widget.apiClient.post('/api/users/create-appointment/${therapist['id']}/', body: {'date': date.text.trim(), 'time': time.text.trim(), 'location': location.text.trim(), 'reason': reason.text.trim()});
                        if (sheetContext.mounted) {
                          Navigator.pop(sheetContext);
                          AppToast.success(context, 'Appointment request created.');
                        }
                      } catch (error) {
                        if (sheetContext.mounted) AppToast.error(sheetContext, '$error');
                      }
                    },
                    child: const Text('Confirm appointment'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
