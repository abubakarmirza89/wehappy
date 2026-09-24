import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/utils/toast.dart';
import '../../../shared/widgets/loading_view.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.apiClient, this.therapistId});
  final ApiClient apiClient;
  final int? therapistId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _message = TextEditingController();
  late Future<List<dynamic>> _future;
  int? _conversationId;
  List<dynamic> _messages = [];

  @override
  void initState() { super.initState(); _future = _load(); }
  @override
  void dispose() { _message.dispose(); super.dispose(); }

  Future<List<dynamic>> _load() async {
    final data = await widget.apiClient.get('/api/tracking/chat-conversations/');
    final conversations = data is List ? data : const [];
    if (conversations.isNotEmpty) {
      final conversation = conversations.first as Map<String, dynamic>;
      _conversationId = (conversation['id'] as num).toInt();
      _messages = (conversation['messages'] as List?) ?? [];
    }
    return _messages;
  }

  Future<void> _send() async {
    final text = _message.text.trim();
    if (text.isEmpty) { AppToast.error(context, 'Write a message first.'); return; }
    try {
      if (_conversationId == null) {
        final created = await widget.apiClient.post('/api/tracking/chat-conversations/', body: {if (widget.therapistId != null) 'therapist': widget.therapistId});
        _conversationId = (created['id'] as num).toInt();
      }
      final updated = await widget.apiClient.post('/api/tracking/chat-conversations/$_conversationId/send_message/', body: {'message': text});
      setState(() { _messages = (updated['messages'] as List?) ?? [..._messages, {'sender': 'user', 'message_text': text}]; _message.clear(); });
    } catch (error) { if (mounted) AppToast.error(context, '$error'); }
  }

  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Messages')), body: FutureBuilder<List<dynamic>>(future: _future, builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) return const LoadingView(message: 'Opening messages...');
    return Column(children: [Expanded(child: ListView.builder(padding: const EdgeInsets.all(16), itemCount: _messages.length, itemBuilder: (context, index) { final item = _messages[index] as Map<String, dynamic>; final mine = item['sender'] == 'user'; return Align(alignment: mine ? Alignment.centerRight : Alignment.centerLeft, child: Container(margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(13), constraints: const BoxConstraints(maxWidth: 300), decoration: BoxDecoration(color: mine ? AppColors.lilac : Colors.white, borderRadius: BorderRadius.circular(18)), child: Text('${item['message_text'] ?? ''}'))); })), SafeArea(child: Padding(padding: const EdgeInsets.fromLTRB(14, 8, 14, 12), child: Row(children: [Expanded(child: TextField(controller: _message, textInputAction: TextInputAction.send, onSubmitted: (_) => _send(), decoration: const InputDecoration(labelText: 'Write a message'))), const SizedBox(width: 8), IconButton.filled(onPressed: _send, icon: const Icon(Icons.send))])))]);
  }));
}
