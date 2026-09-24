import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import 'components.dart';
import 'feel_better_screen.dart';

class NudgeConversationScreen extends StatefulWidget {
  const NudgeConversationScreen({super.key, required this.apiClient, required this.nudgeId, required this.otherName});
  final ApiClient apiClient;
  final int nudgeId;
  final String otherName;
  @override State<NudgeConversationScreen> createState() => _NudgeConversationScreenState();
}
class _NudgeConversationScreenState extends State<NudgeConversationScreen> {
  final message = TextEditingController();
  List<dynamic> messages = [];
  bool busy = false;
  String? error;
  @override void initState() { super.initState(); load(); }
  @override void dispose() { message.dispose(); super.dispose(); }
  Future<void> load() async {
    try {
      final data = await widget.apiClient.get('/api/tracking/hearteli/nudges/${widget.nudgeId}/messages/');
      if (mounted) setState(() { messages = items(data); error = null; });
    } catch (_) { if (mounted) setState(() => error = 'This conversation is no longer available.'); }
  }
  Future<void> send() async {
    final body = message.text.trim();
    if (body.isEmpty || busy) return;
    setState(() => busy = true);
    try {
      await widget.apiClient.post('/api/tracking/hearteli/nudges/${widget.nudgeId}/messages/', body: {'body': body});
      message.clear(); await load();
    } catch (e) { if (mounted) showCalmMessage(context, '$e'); }
    finally { if (mounted) setState(() => busy = false); }
  }
  @override Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.otherName)),
    body: SafeArea(child: Column(children: [
      Expanded(child: RefreshIndicator(onRefresh: load, child: ListView(padding: screenPadding, children: [
        const StatusPanel(message: 'Only the two people in this nudge can read this conversation while Circle permission remains active.'),
        const SizedBox(height: 16),
        if (error != null) StatusPanel(message: error!, icon: Icons.lock_outline),
        if (messages.isEmpty && error == null) const Text('Reach out in your own words. A small message can help.'),
        for (final raw in messages) Align(
          alignment: raw['is_mine'] == true ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(constraints: const BoxConstraints(maxWidth: 300),
            margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: raw['is_mine'] == true ? AppColors.blush : AppColors.softBlue,
              borderRadius: BorderRadius.circular(18)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('${raw['body']}', style: const TextStyle(fontSize: 15)),
              Text('${raw['author_name']}', style: const TextStyle(color: AppColors.neutralGrey, fontSize: 11)),
            ]))),
        if (messages.isNotEmpty) TextButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(
            builder: (_) => FeelBetterScreen(apiClient: widget.apiClient,
              onDone: () => Navigator.popUntil(context, (route) => route.isFirst)))),
          child: const Text('See your progress')),
      ]))),
      if (error == null) Padding(padding: screenPadding, child: Row(children: [
        Expanded(child: TextField(controller: message, maxLength: 1000, minLines: 1, maxLines: 3,
          decoration: const InputDecoration(hintText: 'Type a message…', counterText: ''))),
        const SizedBox(width: 8),
        IconButton.filled(onPressed: busy ? null : send, icon: const Icon(Icons.send), tooltip: 'Send message'),
      ])),
    ])),
  );
}
