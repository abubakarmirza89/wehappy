import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import 'components.dart';
import 'safety_screen.dart';
import 'sponsor_placement.dart';

class SupportInboxScreen extends StatefulWidget {
  const SupportInboxScreen({
    super.key,
    required this.apiClient,
    required this.sessionStore,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
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
        appBar: AppBar(),
        body: RefreshIndicator(
          onRefresh: load,
          child: ListView(
            padding: screenPadding,
            children: [
              const PageIntro(
                title: 'Your updates',
                subtitle: 'Support updates from your Circle, all in one place.',
              ),
              const SizedBox(height: 20),
              if (loading)
                const Center(child: CircularProgressIndicator())
              else if (error != null)
                StatusPanel(
                    message: error!, action: 'Try again', onAction: load)
              else if (nudges.isEmpty)
                const StatusPanel(
                  message:
                      'No support updates yet. When someone in your Circle reaches out, you will find it here.',
                  icon: Icons.favorite_outline,
                )
              else
                for (final raw in nudges)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: HearteliCard(
                      child: LabelRow(
                        icon: Icons.favorite_border,
                        title:
                            '${raw['sender_name']} → ${raw['recipient_name']}',
                        subtitle:
                            '${raw['status']} · ${raw['delivery_status']} · ${raw['created_at']?.toString().substring(0, 10) ?? ''}',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => NudgeDetail(
                              apiClient: widget.apiClient,
                              sessionStore: widget.sessionStore,
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
  const NudgeDetail({
    super.key,
    required this.apiClient,
    required this.sessionStore,
    required this.id,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
  final int id;
  @override
  State<NudgeDetail> createState() => _NudgeDetailState();
}

class _NudgeDetailState extends State<NudgeDetail> {
  Map<String, dynamic>? nudge;
  Map<String, dynamic>? sponsor;
  String? error;
  bool busy = false;
  bool showWaysToHelp = false;
  bool showAcknowledgement = false;
  String get senderName {
    final name = '${nudge?['sender_name'] ?? ''}'.trim();
    return name.isEmpty ? 'Someone in your Circle' : name;
  }
  String get supportPreferenceText {
    final raw = '${nudge?['support_preference'] ?? ''}'.trim();
    if (raw.isEmpty) return '';
    final preferences = raw.split(',').map((value) => value.trim()).toList();
    final text = preferences.map((value) {
      return switch (value) {
        'Check in with me' => 'a quick check-in text',
        'Call me' || 'Call me when free' => 'a call',
        'Practical help' => 'practical help',
        'Give me space' => 'some space',
        'Just know' => 'knowing you are there',
        'Not sure' || 'Not sure yet' => "they're not sure what would help yet",
        _ => value,
      };
    }).join(', ');
    if (preferences.length == 1 && preferences.single.startsWith('Not sure')) {
      return "They aren't sure what would help yet.";
    }
    return preferences.length == 1
        ? 'They said $text could help.'
        : 'They said these could help: $text.';
  }
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
      if (nudge?['viewer_is_recipient'] == true) {
        try {
          final ad = await widget.apiClient.get(
            '/api/users/nudges/${widget.id}/sponsor/',
          );
          if (mounted && ad is Map)
            setState(() => sponsor = Map<String, dynamic>.from(ad));
        } catch (_) {}
      }
    } catch (e) {
      if (mounted)
        setState(() => error = 'This update is no longer available.');
    }
  }

  Future<void> respond(String choice) async {
    setState(() => busy = true);
    try {
      final data = await widget.apiClient.post(
        '/api/tracking/hearteli/nudges/${widget.id}/respond/',
        body: {'choice': choice},
      );
      if (mounted && data is Map) {
        setState(() => nudge = Map<String, dynamic>.from(data));
      }
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> openExternal(Uri uri, String fallback) async {
    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!opened) {
        if (mounted) showCalmMessage(context, fallback);
        return;
      }
      if (mounted) setState(() => showAcknowledgement = true);
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: ListView(
          padding: screenPadding,
          children: [
            if (error != null)
              StatusPanel(message: error!, icon: Icons.lock_outline)
            else if (nudge == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              if (nudge!['viewer_is_recipient'] == true) ...[
                if (nudge!['status'] != 'sent') ...[
                  const Icon(
                    Icons.favorite_outline,
                    color: AppColors.coral,
                    size: 55,
                  ),
                  const SizedBox(height: 14),
                  PageIntro(
                    title: nudge!['recipient_choice'] == 'cannot_help'
                        ? "That's okay"
                        : "Thanks for being there for $senderName.",
                    subtitle: nudge!['recipient_choice'] == 'cannot_help'
                        ? "Thanks for letting $senderName know. Looking after yourself matters too."
                        : 'Small moments like this matter.',
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Done'),
                  ),
                ] else ...[
                  const Icon(
                    Icons.favorite_outline,
                    color: AppColors.coral,
                    size: 55,
                  ),
                  const SizedBox(height: 14),
                  PageIntro(
                    title: '$senderName reached out',
                    subtitle:
                        "You don't need to fix anything. A simple message or call may be enough.",
                  ),
                  const SizedBox(height: 22),
                  HearteliCard(
                    color: AppColors.blush,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (supportPreferenceText.isNotEmpty) ...[
                          Text(
                            supportPreferenceText,
                            style: const TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 10),
                        ],
                        Text(
                          '“${nudge!['message']}”',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (!showWaysToHelp) ...[
                    FilledButton(
                      onPressed: () => setState(() => showWaysToHelp = true),
                      child: const Text('See ways to help'),
                    ),
                    OutlinedButton(
                      onPressed: busy ? null : () => respond('will_give_space'),
                      child: const Text("I'll give space"),
                    ),
                    OutlinedButton(
                      onPressed: busy ? null : () => respond('cannot_help'),
                      child: const Text("I can't right now"),
                    ),
                    TextButton(
                      onPressed: () =>
                          setState(() => showAcknowledgement = true),
                      child: const Text('Acknowledge'),
                    ),
                  ] else if (!showAcknowledgement) ...[
                    const PageIntro(
                      title: 'Small gestures. Meaningful connections.',
                      subtitle:
                          "A thoughtful message, a listening ear or simply checking in can make someone feel less alone.\n\nYou don't need to fix anything. Just showing that you care can matter.",
                    ),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () => openExternal(
                        Uri(
                          scheme: 'sms',
                          queryParameters: {
                            'body': 'Hey, thinking of you. Up for a chat?',
                          },
                        ),
                        'Could not open your messaging app. You can message them in the app you both use.',
                      ),
                      icon: const Icon(Icons.chat_bubble_outline),
                      label: const Text('Send a message'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => openExternal(
                        Uri(scheme: 'tel'),
                        'Could not open your phone app. You can call them when it works for you.',
                      ),
                      icon: const Icon(Icons.phone_outlined),
                      label: const Text("Call when you're free"),
                    ),
                    OutlinedButton.icon(
                      onPressed: () =>
                          setState(() => showAcknowledgement = true),
                      icon: const Icon(Icons.volunteer_activism_outlined),
                      label: const Text('Offer practical help'),
                    ),
                    const HearteliCard(
                      child: Text(
                        'Ask what would make today a little easier, without making assumptions.',
                      ),
                    ),
                  ] else ...[
                    PageIntro(
                      title: "Let $senderName know where things stand",
                      subtitle:
                          "Choose what fits. $senderName will only see your choice, not your phone or message activity.",
                    ),
                    const SizedBox(height: 12),
                    for (final response in const {
                      'recipient_reported_reached_out': "I've reached out",
                      'will_check_in_later': "I'll check in later",
                      'will_give_space': "I'll give space",
                      'cannot_help': "I can't right now",
                    }.entries)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: response.key == 'cannot_help'
                            ? OutlinedButton(
                                onPressed:
                                    busy ? null : () => respond(response.key),
                                child: Text(response.value),
                              )
                            : FilledButton(
                                onPressed:
                                    busy ? null : () => respond(response.key),
                                child: Text(response.value),
                              ),
                      ),
                  ],
                ],
              ] else ...[
                const Icon(
                  Icons.favorite_outline,
                  color: AppColors.coral,
                  size: 55,
                ),
                const SizedBox(height: 14),
                PageIntro(
                  title: '$senderName reached out',
                  subtitle: nudge!['status'] == 'sent'
                      ? 'You are waiting for a response.'
                      : 'Someone from your Circle responded. You do not need to do anything right now.',
                ),
                const SizedBox(height: 22),
                HearteliCard(
                  color: AppColors.blush,
                  child: Text('“${nudge!['message']}”'),
                ),
                if (nudge!['status'] == 'acknowledged') ...[
                  const SizedBox(height: 12),
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
                    child: const Text('How did that support feel?'),
                  ),
                ],
              ],
              TextButton.icon(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SafetyScreen(
                      apiClient: widget.apiClient,
                      sessionStore: widget.sessionStore,
                    ),
                  ),
                ),
                icon: const Icon(Icons.health_and_safety_outlined),
                label: const Text('Need immediate support? View help'),
              ),
              if (sponsor != null)
                SponsorPlacement(
                    apiClient: widget.apiClient, payload: sponsor!),
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
        appBar: AppBar(),
        body: ListView(
          padding: screenPadding,
          children: [
            const PageIntro(
              title: 'How did that support feel?',
              subtitle:
                  'This reflection is private. The other person and your workplace cannot see it.',
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
