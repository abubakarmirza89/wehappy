import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/validation/form_feedback.dart';
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
  final messageFocus = FocusNode();
  String? sendError;
  List<dynamic> messages = [];
  bool busy = false;
  String? error;
  @override void initState() { super.initState(); load(); }
  @override void dispose() { message.dispose(); messageFocus.dispose(); super.dispose(); }
  Future<void> load() async {
    try {
      final data = await widget.apiClient.get('/api/tracking/hearteli/nudges/${widget.nudgeId}/messages/');
      if (mounted) setState(() { messages = items(data); error = null; });
    } catch (_) { if (mounted) setState(() => error = 'This conversation is no longer available.'); }
  }
  Future<void> send() async {
    final body = message.text.trim();
    if (busy) return;
    if (body.isEmpty) {
      setState(() => sendError = 'Write a message before sending.');
      focusInvalidField(messageFocus);
      return;
    }
    setState(() { busy = true; sendError = null; });
    try {
      await widget.apiClient.post('/api/tracking/hearteli/nudges/${widget.nudgeId}/messages/', body: {'body': body});
      if (!mounted) return;
      message.clear(); await load();
    } catch (e) {
      if (mounted) {
        setState(() => sendError = formRequestError(e,
          invalid: 'Check your message and try again.',
          missing: 'This conversation is no longer available.'));
        focusInvalidField(messageFocus);
      }
    }
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
            builder: (_) => FeelBetterScreen(
              onDone: () => Navigator.popUntil(context, (route) => route.isFirst),
            ))),
          child: const Text('See your progress')),
      ]))),
      if (error == null) Padding(padding: screenPadding, child: Row(children: [
        Expanded(child: TextField(controller: message, maxLength: 1000, minLines: 1, maxLines: 3,
          focusNode: messageFocus, readOnly: busy,
          onChanged: (_) {
            if (sendError != null) setState(() => sendError = null);
          },
          decoration: InputDecoration(labelText: 'Message', counterText: '',
            error: inlineFieldError(sendError)))),
        const SizedBox(width: 8),
        IconButton.filled(onPressed: busy ? null : send, icon: busy ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send), tooltip: busy ? 'Sending message' : 'Send message'),
      ])),
    ])),
  );
}
