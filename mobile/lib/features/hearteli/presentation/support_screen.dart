import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/app_theme.dart';
import 'components.dart';
import 'nudge_conversation_screen.dart';

class SupportInboxScreen extends StatefulWidget {
  const SupportInboxScreen({super.key, required this.apiClient});
  final ApiClient apiClient;
  @override
  State<SupportInboxScreen> createState() => _SupportInboxScreenState();
}

class _SupportInboxScreenState extends State<SupportInboxScreen> {
  List<dynamic> nudges = [];
  bool loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() => loading = true);
    try {
      final data = await widget.apiClient.get('/api/tracking/hearteli/nudges/');
      if (mounted)
        setState(() {
          nudges = items(data);
          error = null;
        });
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Support history')),
    body: RefreshIndicator(
      onRefresh: load,
      child: ListView(
        padding: screenPadding,
        children: [
          const PageIntro(
            title: 'Being there, together',
            subtitle: 'Only messages you sent or received appear here.',
          ),
          const SizedBox(height: 20),
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (error != null)
            StatusPanel(message: error!, action: 'Try again', onAction: load)
          else if (nudges.isEmpty)
            const StatusPanel(
              message: 'No nudges yet. A small check-in can be a meaningful first step.',
              icon: Icons.favorite_outline,
            )
          else
            for (final raw in nudges)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: HearteliCard(
                  child: LabelRow(
                    icon: Icons.favorite_border,
                    title: '${raw['sender_name']} → ${raw['recipient_name']}',
                    subtitle:
                        '${raw['status']} · ${raw['delivery_status']} · ${raw['created_at']?.toString().substring(0, 10) ?? ''}',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NudgeDetail(
                          apiClient: widget.apiClient,
                          id: raw['id'] as int,
                        ),
                      ),
                    ).then((_) => load()),
                  ),
                ),
              ),
        ],
      ),
    ),
  );
}

class NudgeDetail extends StatefulWidget {
  const NudgeDetail({super.key, required this.apiClient, required this.id});
  final ApiClient apiClient;
  final int id;
  @override
  State<NudgeDetail> createState() => _NudgeDetailState();
}

class _NudgeDetailState extends State<NudgeDetail> {
  Map<String, dynamic>? nudge;
  String? error;
  bool busy = false;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data = await widget.apiClient.get(
        '/api/tracking/hearteli/nudges/${widget.id}/',
      );
      if (mounted)
        setState(() {
          nudge = Map<String, dynamic>.from(data as Map);
          error = null;
        });
    } catch (e) {
      if (mounted)
        setState(() => error = 'This update is no longer available.');
    }
  }

  Future<void> respond(String choice) async {
    setState(() => busy = true);
    try {
      await widget.apiClient.post(
        '/api/tracking/hearteli/nudges/${widget.id}/respond/',
        body: {'status': choice},
      );
      await load();
      if (mounted)
        showCalmMessage(
          context,
          choice == 'cannot_help'
              ? 'Thanks for being honest.'
              : 'Your response was saved.',
        );
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Empathy Nudge')),
    body: ListView(
      padding: screenPadding,
      children: [
        if (error != null)
          StatusPanel(message: error!, icon: Icons.lock_outline)
        else if (nudge == null)
          const Center(child: CircularProgressIndicator())
        else ...[
          const Icon(Icons.favorite_outline, color: AppColors.coral, size: 55),
          const SizedBox(height: 14),
          PageIntro(
            title: '${nudge!['sender_name']} could use a check-in',
            subtitle:
                'You don’t need to fix anything. A kind next step can help.',
          ),
          const SizedBox(height: 22),
          HearteliCard(
            color: AppColors.blush,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Their message',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(
                  '“${nudge!['message']}”',
                  style: const TextStyle(fontSize: 18),
                ),
                if ('${nudge!['support_preference'] ?? ''}'.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text('What would help: ${nudge!['support_preference']}'),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'A gentle next step',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const HearteliCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabelRow(
                  icon: Icons.chat_bubble_outline,
                  title: 'Send a kind message',
                  subtitle: '“I’m here if you’d like to talk.”',
                ),
                LabelRow(
                  icon: Icons.phone_outlined,
                  title: 'Call when you can',
                  subtitle: 'Ask first if a call would help.',
                ),
                LabelRow(
                  icon: Icons.spa_outlined,
                  title: 'Give space',
                  subtitle: 'Acknowledge without pressing for details.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          if (nudge!['viewer_is_recipient'] == true &&
              nudge!['status'] == 'sent') ...[
            FilledButton(
              onPressed: busy ? null : () => respond('acknowledged'),
              child: const Text('I’ll check in'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: busy ? null : () => respond('cannot_help'),
              child: const Text('I can’t right now'),
            ),
          ] else if (nudge!['viewer_is_recipient'] == true)
            StatusPanel(
              message:
                  'Your response: ${nudge!['status'] == 'acknowledged' ? 'I’ll check in' : 'I can’t right now'}',
            ),
          if (nudge!['viewer_is_recipient'] != true) ...[
            StatusPanel(
              message:
                  'Recipient response: ${nudge!['status']}. Delivery: ${nudge!['delivery_status']}.',
            ),
            const SizedBox(height: 12),
            if (nudge!['status'] == 'acknowledged')
              OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SupportOutcomeScreen(
                      apiClient: widget.apiClient,
                      nudgeId: widget.id,
                    ),
                  ),
                ),
                child: const Text('Reflect on support received'),
              ),
          ],
          const SizedBox(height: 12),
          if (nudge!['viewer_is_recipient'] == true)
            OutlinedButton.icon(
              onPressed: () async {
                await Clipboard.setData(
                  const ClipboardData(
                    text: 'I’m here if you’d like to talk. No pressure to reply right away.',
                  ),
                );
                if (context.mounted)
                  showCalmMessage(
                    context,
                    'Opening message copied. Send it through the channel you both use.',
                  );
              },
              icon: const Icon(Icons.copy_outlined),
              label: const Text('Copy a kind opening message'),
            ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => NudgeConversationScreen(apiClient: widget.apiClient,
                nudgeId: widget.id, otherName: nudge!['viewer_is_recipient'] == true
                  ? '${nudge!['sender_name']}' : '${nudge!['recipient_name']}'),
            )),
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Open support conversation'),
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${nudge!['delivery_status']}. An acknowledgement does not mean support has happened.',
            style: const TextStyle(color: AppColors.neutralGrey),
          ),
        ],
      ],
    ),
  );
}

class SupportOutcomeScreen extends StatefulWidget {
  const SupportOutcomeScreen({
    super.key,
    required this.apiClient,
    required this.nudgeId,
  });
  final ApiClient apiClient;
  final int nudgeId;
  @override
  State<SupportOutcomeScreen> createState() => _SupportOutcomeScreenState();
}

class _SupportOutcomeScreenState extends State<SupportOutcomeScreen> {
  String? choice;
  final note = TextEditingController();
  bool busy = false;
  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('How did it feel?')),
    body: ListView(
      padding: screenPadding,
      children: [
        const PageIntro(
          title: 'Did you feel supported?',
          subtitle: 'This is for you. The other person and your workplace cannot see your answer.',
        ),
        const SizedBox(height: 22),
        for (final e in const {
          'yes': 'Yes',
          'a_little': 'A little',
          'not_yet': 'Not yet',
          'prefer_not': 'Prefer not to say',
        }.entries)
          RadioListTile<String>(
            title: Text(e.value),
            value: e.key,
            groupValue: choice,
            onChanged: (v) => setState(() => choice = v),
          ),
        const SizedBox(height: 14),
        TextField(
          controller: note,
          maxLines: 3,
          maxLength: 500,
          decoration: const InputDecoration(
            labelText: 'Private note (optional)',
          ),
        ),
        const SizedBox(height: 18),
        FilledButton(
          onPressed: choice == null || busy
              ? null
              : () async {
                  setState(() => busy = true);
                  try {
                    await widget.apiClient.post(
                      '/api/tracking/hearteli/outcomes/',
                      body: {
                        'nudge': widget.nudgeId,
                        'result': choice,
                        'private_note': note.text.trim(),
                      },
                    );
                    if (context.mounted) Navigator.pop(context);
                  } catch (e) {
                    if (context.mounted) showCalmMessage(context, '$e');
                  } finally {
                    if (mounted) setState(() => busy = false);
                  }
                },
          child: const Text('Save privately'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Skip'),
        ),
      ],
    ),
  );
}
