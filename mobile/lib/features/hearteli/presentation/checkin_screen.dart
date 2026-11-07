import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import 'components.dart';
import 'safety_screen.dart';
import 'feel_better_screen.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({
    super.key,
    required this.apiClient,
    required this.sessionStore,
    required this.userId,
    this.onComplete,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
  final String userId;
  final VoidCallback? onComplete;
  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  static const storage = FlutterSecureStorage();
  String get draftKey => 'hearteli_private_draft_${widget.userId}';
  static const labels = ['Great', 'Good', 'Okay', 'Not great', 'Struggling'];
  static const values = ['great', 'good', 'okay', 'not_great', 'struggling'];
  static const faces = ['☺', '🙂', '😌', '😕', '☹'];
  static const colors = [
    AppColors.mint,
    AppColors.warning,
    AppColors.calm,
    AppColors.coral,
    AppColors.error,
  ];
  bool ordinarySupport = false;
  int step = 0, feeling = -1;
  int? checkInId, recipient;
  final tags = <String>{}, preferences = <String>{};
  final note = TextEditingController(), message = TextEditingController();
  List<dynamic> connections = [];
  bool busy = false,
      hasDraft = false,
      patternSuggested = false,
      sharingDeclined = false;
  String? error;
  late final String retryKey = _newKey();
  static String _newKey() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 15) | 64;
    bytes[8] = (bytes[8] & 63) | 128;
    final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }

  @override
  void initState() {
    super.initState();
    _checkDraft();
  }

  @override
  void dispose() {
    note.dispose();
    message.dispose();
    super.dispose();
  }

  Future<void> _checkDraft() async {
    final value = await storage.read(key: draftKey);
    if (mounted) setState(() => hasDraft = value != null);
  }

  Future<void> _restoreDraft() async {
    final raw = await storage.read(key: draftKey);
    if (raw == null) return;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    setState(() {
      feeling = values.indexOf(data['feeling_category']);
      note.text = data['notes'] ?? '';
      tags.addAll((data['context_tags'] as List? ?? []).cast<String>());
      preferences.addAll(
        (data['support_preferences'] as List? ?? []).cast<String>(),
      );
      step = 1;
      hasDraft = false;
    });
  }

  Future<void> _draft() async {
    await storage.write(key: draftKey, value: jsonEncode(_payload()));
    if (mounted) {
      setState(() => hasDraft = true);
      showCalmMessage(
        context,
        'Saved securely on this device as a private draft. Nothing was shared.',
      );
    }
  }

  Map<String, dynamic> _payload() => {
    'feeling_category': values[feeling],
    'notes': note.text.trim(),
    'context_tags': tags.toList(),
    'support_preferences': preferences.toList(),
  };
  Future<void> _save() async {
    if (feeling < 0) return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      final data = await widget.apiClient.post(
        '/api/tracking/mood-check-ins/',
        body: _payload(),
      );
      await storage.delete(key: draftKey);
      if (!mounted) return;
      setState(() {
        checkInId = data['id'] as int;
        step = 3;
      });
      await _loadConnections();
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> _loadConnections() async {
    try {
      final data = await widget.apiClient.get('/api/tracking/hearteli/circle/');
      final prompt = await widget.apiClient.get(
        '/api/tracking/hearteli/circle/pattern_prompt/',
      );
      if (mounted)
        setState(() => patternSuggested = prompt['suggested'] == true);
      if (mounted)
        setState(
          () => connections = items(data)
              .where(
                (c) =>
                    c['accepted_at'] != null && c['may_receive_nudges'] == true,
              )
              .toList(),
        );
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    }
  }

  Map<String, dynamic>? get chosen {
    for (final raw in connections) {
      if (raw['recipient'] == recipient)
        return Map<String, dynamic>.from(raw as Map);
    }
    return null;
  }

  void _next() {
    if (step == 0 && feeling < 0) return;
    if (step == 2) {
      if (checkInId == null) {
        _save();
      } else {
        setState(() => step = 3);
      }
      return;
    }
    if (step < 4) setState(() => step++);
  }

  Future<void> _send() async {
    if (chosen == null || message.text.trim().isEmpty || checkInId == null)
      return;
    setState(() {
      busy = true;
      error = null;
    });
    try {
      await widget.apiClient.post(
        '/api/tracking/hearteli/nudges/',
        body: {
          'check_in': checkInId,
          'recipient': recipient,
          'message': message.text.trim(),
          'support_preference': chosen!['may_receive_preference'] == true
              ? _preferenceText()
              : '',
          'idempotency_key': retryKey,
          'support_context': ordinarySupport ? 'ordinary' : 'unknown',
        },
      );
      if (mounted) {
        _showProgress();
      }
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  void _showProgress() => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => FeelBetterScreen(
        onDone: () {
          Navigator.pop(context);
          widget.onComplete?.call();
        },
      ),
    ),
  );

  void _finishPrivateCheckIn() {
    if (widget.onComplete != null) {
      widget.onComplete!();
    } else {
      Navigator.pop(context);
    }
  }

  String _preferenceText() => preferences
      .map(
        (p) =>
            const {
              'check_in': 'Check in with me',
              'call': 'Call me',
              'practical_help': 'Practical help',
              'space': 'Give me space',
              'just_know': 'Just know',
              'not_sure': 'Not sure',
            }[p] ??
            p,
      )
      .join(', ');
  @override
  Widget build(BuildContext context) {
    const titles = [
      'How are you feeling today?',
      'Want to add a little more?',
      'What feels supportive to you?',
      'Would some support help?',
      'Ready to reach out?',
    ];
    final stepZeroTitle = feeling < 0
        ? titles[0]
        : feeling <= 1
        ? 'Glad to hear it!'
        : feeling == 2
        ? 'Every feeling belongs'
        : "We're glad you checked in";
    final stepZeroMessage = feeling < 0
        ? "There's no right or wrong answer. Just a moment to check in with yourself."
        : feeling <= 1
        ? "It's lovely to have moments that feel good. Enjoy this one."
        : feeling == 2
        ? "Not every day needs to be amazing. It's okay to simply be where you are."
        : "Some days are harder than others. You don't have to explain or change how you feel right now.";
    final stepThreeTitle = sharingDeclined
        ? "That's completely okay"
        : patternSuggested
        ? 'Want to let someone know?'
        : recipient != null
        ? 'A little nudge can go a long way'
        : feeling >= 3
        ? 'Would some support help?'
        : 'Thank you for checking in';
    final stepThreeMessage = sharingDeclined
        ? 'Your feelings are yours to share, whenever and with whoever you choose.'
        : patternSuggested
        ? 'You asked Hearteli to check with you after a couple of hard days. Would you like ${connections.isEmpty ? 'someone you trust' : connections.first['recipient_name']} to know?'
        : recipient != null
        ? 'Would you like ${chosen?['recipient_name']} to know that some support might help today?'
        : feeling >= 3
        ? 'You can let someone you trust know that a kind word might mean a lot today.'
        : 'Making space for how you feel is a meaningful step.';
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (step + 1) / 5,
              color: AppColors.coral,
              backgroundColor: AppColors.blush,
              minHeight: 4,
            ),
            Expanded(
              child: ListView(
                padding: screenPadding,
                children: [
                  if (step > 0)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => setState(() => step--),
                        tooltip: 'Previous step',
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                  Text(
                    'STEP ${step + 1} OF 5',
                    style: const TextStyle(
                      color: AppColors.coral,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  PageIntro(
                    title: step == 0
                        ? stepZeroTitle
                        : step == 1 || step == 2
                        ? titles[step]
                        : step == 3
                        ? stepThreeTitle
                        : titles[step],
                    subtitle: step == 0
                        ? stepZeroMessage
                        : step == 1
                        ? "You can write about what's on your mind, or simply leave today's check-in as it is."
                        : step == 2
                        ? 'A kind message, a quiet moment or someone simply listening? Let Hearteli know what helps.'
                        : step == 3
                        ? stepThreeMessage
                        : "Here's what ${chosen?['recipient_name'] ?? 'the person you choose'} will see. You can change or cancel this before sending.",
                  ),
                  const SizedBox(height: 22),
                  if (step == 0 && feeling >= 3)
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
                      label: const Text(
                        'Need to talk to someone now? View help',
                      ),
                    ),
                  if (step == 4)
                    CheckboxListTile(
                      value: ordinarySupport,
                      onChanged: (v) =>
                          setState(() => ordinarySupport = v ?? false),
                      title: const Text(
                        'This is an ordinary, non-urgent support update',
                      ),
                      subtitle: const Text(
                        'Optional. Safety or unclear contexts are never eligible for sponsorship.',
                      ),
                    ),
                  if (step == 0) ...[
                    if (hasDraft)
                      StatusPanel(
                        message: 'You have a private draft on this device.',
                        action: 'Resume draft',
                        onAction: _restoreDraft,
                      ),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 14,
                      children: List.generate(
                        5,
                        (i) => Semantics(
                          label: '${labels[i]} feeling',
                          selected: feeling == i,
                          button: true,
                          child: InkWell(
                            onTap: () => setState(() => feeling = i),
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              width: 95,
                              height: 104,
                              decoration: BoxDecoration(
                                color: feeling == i
                                    ? colors[i].withOpacity(.15)
                                    : Colors.white,
                                border: Border.all(
                                  color: feeling == i
                                      ? colors[i]
                                      : const Color(0xFFDCE5EE),
                                  width: feeling == i ? 2 : 1,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    faces[i],
                                    style: const TextStyle(fontSize: 32),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    labels[i],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (feeling == 4) ...[
                      const SizedBox(height: 18),
                      OutlinedButton.icon(
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
                        label: const Text('I need immediate support'),
                      ),
                    ],
                  ] else if (step == 1) ...[
                    Wrap(
                      spacing: 8,
                      children:
                          const {
                                'work': 'Work',
                                'family': 'Family',
                                'sleep': 'Sleep',
                                'overwhelmed': 'Overwhelmed',
                                'other': 'Other',
                              }.entries
                              .map(
                                (e) => FilterChip(
                                  label: Text(e.value),
                                  selected: tags.contains(e.key),
                                  onSelected: (v) => setState(
                                    () => v
                                        ? tags.add(e.key)
                                        : tags.remove(e.key),
                                  ),
                                ),
                              )
                              .toList(),
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: note,
                      maxLines: 4,
                      maxLength: 500,
                      decoration: const InputDecoration(
                        labelText: 'Private note (optional)',
                        hintText: 'Anything you want to remember?',
                      ),
                    ),
                    const StatusPanel(
                      message: 'Your note is private and will never appear in a nudge preview.',
                    ),
                  ] else if (step == 2) ...[
                    for (final e in const {
                      'check_in': 'Check in with me',
                      'call': 'Call me when free',
                      'practical_help': 'Practical help',
                      'space': 'Give me space',
                      'just_know': 'Just know',
                      'not_sure': 'Not sure yet',
                    }.entries)
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(e.value),
                        value: preferences.contains(e.key),
                        activeColor: AppColors.coral,
                        onChanged: (v) => setState(
                          () => v == true
                              ? preferences.add(e.key)
                              : preferences.remove(e.key),
                        ),
                      ),
                  ] else if (step == 3 &&
                      (feeling >= 3 || patternSuggested) &&
                      !sharingDeclined) ...[
                    HearteliCard(
                      color: AppColors.softBlue,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your feelings are yours to share',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Your check-in stays private unless you choose to send an Empathy Nudge.',
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (connections.isEmpty)
                      const StatusPanel(
                        message: 'No accepted Circle member has enabled nudges. Your check-in stays private. Add someone in Circle when you are ready.',
                      )
                    else ...[
                      const Text(
                        'You can let someone you trust know that a kind word might mean a lot today.',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 12),
                      for (final raw in connections)
                        RadioListTile<int>(
                          title: Text('${raw['recipient_name']}'),
                          subtitle: Text(
                            'Would you like ${raw['recipient_name'] ?? 'this person'} to know that some support might help today?',
                          ),
                          value: raw['recipient'] as int,
                          groupValue: recipient,
                          onChanged: (v) => setState(() {
                            recipient = v;
                            message.text =
                                'Someone in your Circle would appreciate some kindness today.';
                          }),
                        ),
                    ],
                  ] else if (step == 3) ...[
                    const SizedBox.shrink(),
                  ] else ...[
                    HearteliCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'To: ${chosen?['recipient_name'] ?? 'No one selected'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: message,
                            maxLines: 3,
                            maxLength: 500,
                            decoration: const InputDecoration(
                              labelText: 'Message they will see',
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'On their lock screen, this shows as: "Someone in your Circle would appreciate some kindness today."',
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Support preference: ${chosen?['may_receive_preference'] == true && preferences.isNotEmpty ? _preferenceText() : 'Not shared'}',
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Private note: excluded',
                            style: TextStyle(color: AppColors.neutralGrey),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Delivery: in-app inbox. No push delivery is guaranteed.',
                            style: TextStyle(color: AppColors.neutralGrey),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 14),
                    StatusPanel(
                      message: error!,
                      action: checkInId == null ? 'Save private draft' : null,
                      onAction: checkInId == null ? _draft : null,
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: screenPadding,
              child: Column(
                children: [
                  if (step < 3)
                    FilledButton(
                      onPressed: busy || (step == 0 && feeling < 0)
                          ? null
                          : _next,
                      child: Text(
                        busy
                            ? 'Saving…'
                            : step == 0
                            ? feeling < 0
                                  ? 'Check in'
                                  : 'Continue'
                            : step == 1
                            ? 'Add reflection'
                            : step == 2
                            ? 'Continue'
                            : 'Continue',
                      ),
                    ),
                  if (step == 3 && (feeling < 3 && !patternSuggested ||
                      sharingDeclined))
                    FilledButton(
                      onPressed: _finishPrivateCheckIn,
                      child: const Text('Done'),
                    ),
                  if (step == 3 && (feeling >= 3 || patternSuggested) &&
                      !sharingDeclined)
                    TextButton(
                      onPressed: () => setState(() => sharingDeclined = true),
                      child: const Text('Not right now'),
                    ),
                  if (step == 3 && recipient != null &&
                      !sharingDeclined)
                    FilledButton(
                      onPressed: busy ? null : _next,
                      child: const Text('Continue'),
                    ),
                  if (step == 4)
                    FilledButton(
                      onPressed: busy || message.text.trim().isEmpty
                          ? null
                          : _send,
                      child: Text(
                        busy ? 'Sending…' : 'Send an Empathy Nudge',
                      ),
                    ),
                  if (step == 1 || step == 2)
                    TextButton(
                      onPressed: _next,
                      child: const Text('Skip this step'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
