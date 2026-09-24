import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/section_title.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key, required this.apiClient});

  final ApiClient apiClient;

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  late Future<List<dynamic>> _future;
  final Set<int> _selected = {};
  final _notes = TextEditingController();
  bool _saving = false;
  String? _message;

  @override
  void initState() { super.initState(); _future = _loadMoods(); }
  @override
  void dispose() { _notes.dispose(); super.dispose(); }

  Future<List<dynamic>> _loadMoods() async {
    final data = await widget.apiClient.get('/api/tracking/moods/');
    return data is List ? data : const [];
  }

  Future<void> _save() async {
    if (_selected.isEmpty) { setState(() => _message = 'Choose at least one mood first.'); return; }
    setState(() { _saving = true; _message = null; });
    try {
      await widget.apiClient.post('/api/tracking/mood-check-ins/today_check_in/', body: {'mood_ids': _selected.toList(), 'notes': _notes.text.trim()});
      if (mounted) setState(() => _message = 'Your check-in was saved. Thank you for checking in.');
    } catch (error) { if (mounted) setState(() => _message = '$error'); } finally { if (mounted) setState(() => _saving = false); }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: FutureBuilder<List<dynamic>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView(message: 'Finding your moods...');
        if (snapshot.hasError) return ErrorView(message: '${snapshot.error}', onRetry: () => setState(() => _future = _loadMoods()));
        final moods = snapshot.data!;
        return ListView(padding: const EdgeInsets.fromLTRB(20, 18, 20, 32), children: [
          Text('Your mood space', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: AppColors.ink)),
          const SizedBox(height: 8),
          const Text('Name what is present. There is no right answer.'),
          const SizedBox(height: 24),
          SectionTitle(title: 'How are you feeling?'),
          const SizedBox(height: 12),
          GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: moods.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 1), itemBuilder: (context, index) {
            final mood = moods[index] as Map<String, dynamic>;
            final id = (mood['id'] as num).toInt();
            final selected = _selected.contains(id);
            return InkWell(onTap: () => setState(() => selected ? _selected.remove(id) : _selected.add(id)), borderRadius: BorderRadius.circular(20), child: Card(color: selected ? AppColors.lilac : Colors.white, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(width: 42, height: 42, child: mood['img_emoji'] == null ? const Center(child: Text('😊', style: TextStyle(fontSize: 28))) : Image.network('${mood['img_emoji']}', fit: BoxFit.contain, errorBuilder: (_, __, ___) => const Center(child: Text('😊', style: TextStyle(fontSize: 28))))), const SizedBox(height: 6), Text('${mood['name'] ?? 'Mood'}', textAlign: TextAlign.center)])));
          }),
          const SizedBox(height: 20),
          TextField(controller: _notes, maxLines: 3, decoration: const InputDecoration(labelText: 'Anything else you want to note?', alignLabelWithHint: true)),
          const SizedBox(height: 16),
          FilledButton.icon(onPressed: _saving ? null : _save, icon: _saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.check_rounded), label: const Text('Save check-in')),
          if (_message != null) ...[const SizedBox(height: 14), Text(_message!, style: TextStyle(color: _message!.startsWith('Your') ? Colors.green : Colors.redAccent))],
        ]);
      },
    ));
  }
}
