import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/utils/toast.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';

class TherapistDashboardScreen extends StatefulWidget {
  const TherapistDashboardScreen({super.key, required this.apiClient});
  final ApiClient apiClient;

  @override
  State<TherapistDashboardScreen> createState() => _TherapistDashboardScreenState();
}

class _TherapistDashboardScreenState extends State<TherapistDashboardScreen> {
  late Future<Map<String, dynamic>> _future;
  final _amount = TextEditingController();
  final _payout = TextEditingController();
  final _rate = TextEditingController();

  @override
  void initState() { super.initState(); _future = _load(); }
  @override
  void dispose() { _amount.dispose(); _payout.dispose(); _rate.dispose(); super.dispose(); }
  Future<Map<String, dynamic>> _load() async => Map<String, dynamic>.from(await widget.apiClient.get('/api/users/therapist/dashboard/'));

  Future<void> _updateRate() async {
    final rate = double.tryParse(_rate.text.trim());
    if (rate == null || rate < 0) { AppToast.error(context, 'Enter a valid hourly fee.'); return; }
    try { await widget.apiClient.patch('/api/users/therapist/settings/', body: {'hourly_rate': rate}); if (mounted) { AppToast.success(context, 'Hourly fee updated.'); setState(() => _future = _load()); } } catch (error) { if (mounted) AppToast.error(context, '$error'); }
  }

  Future<void> _withdraw() async {
    final amount = double.tryParse(_amount.text.trim());
    if (amount == null || amount <= 0 || _payout.text.trim().isEmpty) { AppToast.error(context, 'Enter a valid amount and payout account.'); return; }
    try { await widget.apiClient.post('/api/users/therapist/withdrawals/', body: {'amount': amount, 'payout_account': _payout.text.trim()}); if (mounted) { AppToast.success(context, 'Withdrawal request sent for admin review.'); setState(() => _future = _load()); } } catch (error) { if (mounted) AppToast.error(context, '$error'); }
  }

  @override
  Widget build(BuildContext context) => SafeArea(child: FutureBuilder<Map<String, dynamic>>(future: _future, builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView(message: 'Loading therapist workspace...');
    if (snapshot.hasError) return ErrorView(message: '${snapshot.error}', onRetry: () => setState(() => _future = _load()));
    final data = snapshot.data!;
    _rate.value = _rate.value.copyWith(text: '${data['hourly_rate'] ?? ''}');
    final appointments = (data['appointments'] as List? ?? const []);
    return ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 32), children: [
      Text('Therapist workspace', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.ink)),
      const SizedBox(height: 8), const Text('Manage your practice, appointments, and earnings.'), const SizedBox(height: 22),
      Row(children: [Expanded(child: _metric('Earned', '${data['total_earned'] ?? 0}')), const SizedBox(width: 10), Expanded(child: _metric('Rate', '${data['hourly_rate'] ?? 0}/hr'))]),
      const SizedBox(height: 10),
      Card(color: AppColors.mint, child: SwitchListTile(value: data['is_available'] == true, onChanged: (value) async { try { await widget.apiClient.patch('/api/users/therapist/settings/', body: {'is_available': value}); if (mounted) setState(() => _future = _load()); } catch (error) { if (mounted) AppToast.error(context, '$error'); } }, title: const Text('Available for new clients'), subtitle: const Text('Let clients know when you can accept appointments.'))),
      const SizedBox(height: 20), Text('Appointments', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)), const SizedBox(height: 10),
      if (appointments.isEmpty) const Card(child: Padding(padding: EdgeInsets.all(18), child: Text('No appointments yet.'))),
      ...appointments.map((item) => Card(margin: const EdgeInsets.only(bottom: 8), child: ListTile(leading: const CircleAvatar(backgroundColor: AppColors.mint, child: Icon(Icons.person)), title: Text('${item['user'] ?? 'Client'}'), subtitle: Text('${item['date'] ?? ''} ${item['time'] ?? ''}\n${item['reason'] ?? ''}'), trailing: Text('${item['status'] ?? ''}')))),
      const SizedBox(height: 18), Text('Request withdrawal', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)), const SizedBox(height: 10),
      Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [AppTextField(controller: _rate, label: 'Hourly fee', keyboardType: const TextInputType.numberWithOptions(decimal: true)), const SizedBox(height: 10), SizedBox(width: double.infinity, child: OutlinedButton(onPressed: _updateRate, child: const Text('Update fee'))), const Divider(height: 28), AppTextField(controller: _amount, label: 'Withdrawal amount', keyboardType: const TextInputType.numberWithOptions(decimal: true)), const SizedBox(height: 12), AppTextField(controller: _payout, label: 'Payout account / Stripe account'), const SizedBox(height: 14), SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _withdraw, icon: const Icon(Icons.payments_outlined), label: const Text('Request withdrawal')))]))),
    ]);
  }));

  Widget _metric(String label, String value) => Card(color: AppColors.mint, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label), const SizedBox(height: 6), Text(value, style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w800))])));
}
