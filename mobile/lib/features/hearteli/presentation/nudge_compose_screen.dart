import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import 'circle_screen.dart';
import 'components.dart';

class NudgeComposeScreen extends StatefulWidget {
  const NudgeComposeScreen({
    super.key,
    required this.apiClient,
    required this.sessionStore,
    this.fromImmediateSupport = false,
  });

  final ApiClient apiClient;
  final SessionStore sessionStore;
  final bool fromImmediateSupport;

  @override
  State<NudgeComposeScreen> createState() => _NudgeComposeScreenState();
}

class _NudgeComposeScreenState extends State<NudgeComposeScreen> {
  List<dynamic> recipients = [];
  bool loading = true;
  bool failed = false;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      failed = false;
    });
    try {
      final data = await widget.apiClient.get(
        '/api/tracking/hearteli/circle/',
        query: {'nudge_eligible': 'true'},
      );
      if (mounted) setState(() => recipients = items(data));
    } catch (_) {
      if (mounted) setState(() => failed = true);
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> invite() async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Your Circle')),
          body: SafeArea(
            child: CircleScreen(
              apiClient: widget.apiClient,
              sessionStore: widget.sessionStore,
            ),
          ),
        ),
      ),
    );
    if (mounted) load();
  }

  Future<void> confirm(int recipientId, String name) async {
    final sent = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (confirmationContext) => Scaffold(
          appBar: AppBar(
      title: Text(widget.fromImmediateSupport ? 'Your Circle' : 'Empathy Nudge'),
    ),
          body: SafeArea(
            child: ListView(
              padding: screenPadding,
              children: [
                PageIntro(
                  title: 'A little nudge can go a long way',
                  subtitle:
                      'Would you like $name to know that some support might help today?',
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () async {
                    final sent = await Navigator.push<bool>(
                      confirmationContext,
                      MaterialPageRoute(
                        builder: (_) => _NudgePreview(
                          apiClient: widget.apiClient,
                          recipientId: recipientId,
                          name: name,
                          fromImmediateSupport: widget.fromImmediateSupport,
                        ),
                      ),
                    );
                    if (sent == true && confirmationContext.mounted) {
                      Navigator.pop(confirmationContext, true);
                    }
                  },
                  child: const Text('Continue'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(confirmationContext),
                  child: const Text('Not now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (!mounted) return;
    if (sent == true) {
      Navigator.pop(context, true);
    } else {
      load();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Empathy Nudge')),
    body: SafeArea(
      child: ListView(
        padding: screenPadding,
        children: [
          PageIntro(
            title: widget.fromImmediateSupport
                ? 'Contact someone in your Circle'
                : 'Who would you like to nudge?',
            subtitle: 'Choose someone in your Circle who accepts nudges.',
          ),
          if (widget.fromImmediateSupport) ...[
            const SizedBox(height: 14),
            const StatusPanel(
              message: 'A Nudge may not be seen right away. If you need help now, call someone you trust directly or go back to Immediate Support for local options.',
            ),
          ],
          const SizedBox(height: 20),
          if (loading)
            const Center(
              child: CircularProgressIndicator(
                semanticsLabel: 'Loading Circle recipients',
              ),
            )
          else if (failed)
            Semantics(
              liveRegion: true,
              child: StatusPanel(
                message: 'Could not load your Circle recipients.',
                action: 'Try again',
                onAction: load,
              ),
            )
          else if (recipients.isEmpty)
            Semantics(
              liveRegion: true,
              child: StatusPanel(
                message: widget.fromImmediateSupport
                    ? 'No trusted Circle contact can receive a Nudge right now.'
                    : 'No Circle members can receive nudges yet.',
                action: widget.fromImmediateSupport
                    ? 'Back to Immediate Support'
                    : 'Invite someone',
                onAction: widget.fromImmediateSupport
                    ? () => Navigator.pop(context)
                    : invite,
              ),
            )
          else
            for (final raw in recipients)
              LabelRow(
                icon: Icons.person_outline,
                title: raw['recipient_name'] as String,
                subtitle: raw['relationship'] as String?,
                onTap: () => confirm(
                  raw['recipient'] as int,
                  raw['recipient_name'] as String,
                ),
              ),
        ],
      ),
    ),
  );
}

class _NudgePreview extends StatefulWidget {
  const _NudgePreview({
    required this.apiClient,
    required this.recipientId,
    required this.name,
    required this.fromImmediateSupport,
  });

  final ApiClient apiClient;
  final int recipientId;
  final String name;
  final bool fromImmediateSupport;

  @override
  State<_NudgePreview> createState() => _NudgePreviewState();
}

class _NudgePreviewState extends State<_NudgePreview> {
  static const _defaultMessage =
      'A quick check-in would mean a lot. Would you have a moment?';
  final message = TextEditingController(text: _defaultMessage);
  late final String retryKey = _newRetryKey();
  bool sending = false;
  String? error;

  static String _newRetryKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 15) | 64;
    bytes[8] = (bytes[8] & 63) | 128;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  Future<void> send() async {
    final content = message.text.trim();
    if (sending || content.isEmpty) return;
    setState(() {
      sending = true;
      error = null;
    });
    try {
      await widget.apiClient.post(
        '/api/tracking/hearteli/nudges/',
        body: {
          'recipient': widget.recipientId,
          'message': content,
          'idempotency_key': retryKey,
          if (widget.fromImmediateSupport) 'support_context': 'safety',
        },
      );
      if (!mounted) return;
      showCalmMessage(context, 'Nudge submitted.');
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.statusCode == 400
            ? 'This nudge could not be sent. Go back to check the recipient and message.'
            : 'Could not confirm the send. Please try again.';
      });
    } catch (_) {
      if (mounted) {
        setState(() => error = 'Could not confirm the send. Please try again.');
      }
    } finally {
      if (mounted) setState(() => sending = false);
    }
  }

  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !sending,
    child: Scaffold(
      appBar: AppBar(title: const Text('Preview nudge')),
      body: SafeArea(
        child: ListView(
          padding: screenPadding,
          children: [
            PageIntro(
              title: 'Ready to reach out?',
              subtitle:
                  'Only ${widget.name} will see this message in Hearteli. No check-in or mood is shared.',
            ),
            const SizedBox(height: 20),
            TextField(
              controller: message,
              enabled: !sending,
              maxLength: 500,
              maxLines: 4,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                labelText: 'Message they’ll see in Hearteli',
              ),
            ),
            const SizedBox(height: 16),
            const HearteliCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Lock-screen notification preview'),
                  SizedBox(height: 8),
                  Text('A little nudge from Hearteli ❤️'),
                  Text(
                    'Someone in your Circle would appreciate some kindness today.',
                  ),
                ],
              ),
            ),
            if (error != null) ...[
              const SizedBox(height: 12),
              Semantics(liveRegion: true, child: StatusPanel(message: error!)),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: sending || message.text.trim().isEmpty ? null : send,
              child: Text(sending ? 'Sending…' : 'Send an Empathy Nudge'),
            ),
            TextButton(
              onPressed: sending ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    ),
  );
}
