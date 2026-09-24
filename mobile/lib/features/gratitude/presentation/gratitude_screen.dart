import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/utils/toast.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/loading_view.dart';

class GratitudeScreen extends StatefulWidget {
  const GratitudeScreen({super.key, required this.apiClient});
  final ApiClient apiClient;
  @override
  State<GratitudeScreen> createState() => _GratitudeScreenState();
}

class _GratitudeScreenState extends State<GratitudeScreen> {
  final _one = TextEditingController();
  final _two = TextEditingController();
  final _three = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  int? _entryId;

  @override
  void initState() { super.initState(); _load(); }
  @override
  void dispose() { _one.dispose(); _two.dispose(); _three.dispose(); super.dispose(); }

  Future<void> _load() async {
    try {
      final data = await widget.apiClient.get('/api/tracking/gratitude-entries/today/');
      if (data is Map && data['id'] != null) { _entryId = (data['id'] as num).toInt(); _one.text = '${data['gratitude_1'] ?? ''}'; _two.text = '${data['gratitude_2'] ?? ''}'; _three.text = '${data['gratitude_3'] ?? ''}'; }
    } catch (_) {} finally { if (mounted) setState(() => _loading = false); }
  }

  Future<void> _save() async {
    if ([_one, _two, _three].any((field) => field.text.trim().isEmpty)) { AppToast.error(context, 'Complete all three gratitude entries.'); return; }
    setState(() => _saving = true);
    try { final body = {'gratitude_1': _one.text.trim(), 'gratitude_2': _two.text.trim(), 'gratitude_3': _three.text.trim()}; if (_entryId == null) { final created = await widget.apiClient.post('/api/tracking/gratitude-entries/', body: body); if (created is Map && created['id'] != null) _entryId = (created['id'] as num).toInt(); } else { await widget.apiClient.patch('/api/tracking/gratitude-entries/$_entryId/', body: body); } if (mounted) AppToast.success(context, 'Your gratitude entry was saved.'); } catch (error) { if (mounted) AppToast.error(context, '$error'); } finally { if (mounted) setState(() => _saving = false); }
  }

  @override
  Widget build(BuildContext context) { if (_loading) return const LoadingView(message: 'Opening your gratitude journal...'); return SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 32), children: [Text('Gratitude journal', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.ink)), const SizedBox(height: 8), const Text('Three small things can change the shape of a day.'), const SizedBox(height: 24), Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [AppTextField(controller: _one, label: 'I am grateful for...', maxLines: 2), const SizedBox(height: 12), AppTextField(controller: _two, label: 'Something that brought me peace...', maxLines: 2), const SizedBox(height: 12), AppTextField(controller: _three, label: 'Someone or something I appreciate...', maxLines: 2), const SizedBox(height: 16), SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: _saving ? null : _save, icon: const Icon(Icons.bookmark_outline), label: Text(_saving ? 'Saving...' : 'Save today')))]))) ])); }
}
