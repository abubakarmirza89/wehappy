import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/network/api_client.dart';
import '../../../core/validation/form_feedback.dart';
import '../../../core/validation/validators.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import 'components.dart';

class CircleScreen extends StatefulWidget {
  const CircleScreen({
    super.key,
    required this.apiClient,
    required this.sessionStore,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
  @override
  State<CircleScreen> createState() => _CircleScreenState();
}

class _CircleScreenState extends State<CircleScreen> {
  List<dynamic> connections = [];
  bool loading = true;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final data = await widget.apiClient.get('/api/tracking/hearteli/circle/');
      if (mounted) setState(() => connections = items(data));
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> add() async {
    final choice = await showDialog<String>(
      context: context,
      builder:
          (dialog) => AlertDialog(
            title: const Text("Who's in your corner?"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create a private, one-time invite, or use someone else’s QR code or invite code.',
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.qr_code_2),
                  title: const Text('Show my QR invite'),
                  subtitle: const Text('Expires after 10 minutes'),
                  onTap: () => Navigator.pop(dialog, 'create'),
                ),
                ListTile(
                  leading: const Icon(Icons.qr_code_scanner),
                  title: const Text('Scan QR or enter a code'),
                  onTap: () => Navigator.pop(dialog, 'redeem'),
                ),
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('Invite by email'),
                  onTap: () => Navigator.pop(dialog, 'email'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialog),
                child: const Text('Cancel'),
              ),
            ],
          ),
    );
    if (!mounted) return;
    if (choice == 'create') {
      await _createCircleInvite();
    } else if (choice == 'redeem') {
      await _redeemCircleInvite();
    } else if (choice == 'email') {
      await _inviteByEmail();
    }
  }

  Future<void> _inviteByEmail() async {
    final email = TextEditingController();
    String relationship = 'Friend';
    String? inviteError;
    bool sending = false;
    bool showSignupInvite = false;
    await showDialog<void>(
      context: context,
      builder:
          (dialog) => StatefulBuilder(
            builder:
                (dialog, update) => AlertDialog(
                  title: const Text('Invite by email'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email address',
                          error: inlineFieldError(inviteError),
                        ),
                        onChanged: (_) {
                          update(() {
                            inviteError = null;
                            showSignupInvite = false;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: relationship,
                        decoration: const InputDecoration(
                          labelText: 'Relationship',
                        ),
                        items:
                            [
                                  'Partner',
                                  'Parent',
                                  'Family',
                                  'Friend',
                                  'Colleague',
                                  'Other',
                                ]
                                .map(
                                  (value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  ),
                                )
                                .toList(),
                        onChanged:
                            (value) => update(
                              () => relationship = value ?? relationship,
                            ),
                      ),
                      if (showSignupInvite) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed:
                                sending
                                    ? null
                                    : () async {
                                      final recipientEmail = email.text.trim();
                                      update(() {
                                        sending = true;
                                        inviteError = null;
                                      });
                                      try {
                                        await widget.apiClient.post(
                                          '/api/tracking/hearteli/circle/invite-signup/',
                                          body: {
                                            'email': recipientEmail,
                                            'relationship': relationship,
                                          },
                                        );
                                        if (!dialog.mounted) return;
                                        Navigator.pop(dialog);
                                        if (mounted) {
                                          showCalmMessage(
                                            context,
                                            'Signup invitation sent to $recipientEmail.',
                                          );
                                        }
                                      } catch (e) {
                                        if (dialog.mounted) {
                                          update(() => inviteError = formRequestError(e, invalid: 'Check the invitation details or ask for a new code.'));
                                        }
                                      } finally {
                                        if (dialog.mounted) {
                                          update(() => sending = false);
                                        }
                                      }
                                    },
                            icon: const Icon(Icons.person_add_alt_1),
                            label: const Text('Invite to Hearteli'),
                          ),
                        ),
                      ],
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: sending ? null : () => Navigator.pop(dialog),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed:
                          sending
                              ? null
                              : () async {
                                final recipientEmail = email.text.trim();
                                final validation = Validators.email(recipientEmail);
                                if (validation != null) {
                                  update(
                                    () =>
                                        inviteError =
                                            validation,
                                  );
                                  return;
                                }
                                update(() {
                                  sending = true;
                                  inviteError = null;
                                });
                                try {
                                  await widget.apiClient.post(
                                    '/api/tracking/hearteli/circle/',
                                    body: {
                                      'recipient_email_input': recipientEmail,
                                      'relationship': relationship,
                                    },
                                  );
                                  if (!dialog.mounted) return;
                                  Navigator.pop(dialog);
                                  await load();
                                  if (mounted) {
                                    showCalmMessage(
                                      context,
                                      'Email invitation sent.',
                                    );
                                  }
                                } catch (e) {
                                  if (dialog.mounted) {
                                    update(() {
                                      inviteError = formRequestError(e,
                                          invalid: 'Check your invitation details and try again.',
                                          missing: 'No Hearteli account was found. You can send a signup invitation.');
                                      showSignupInvite =
                                          e is ApiException &&
                                          e.statusCode == 404;
                                    });
                                  }
                                } finally {
                                  if (dialog.mounted) {
                                    update(() => sending = false);
                                  }
                                }
                              },
                      child:
                          sending
                              ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Send invitation'),
                    ),
                  ],
                ),
          ),
    );
    email.dispose();
  }

  Future<void> _createCircleInvite() async {
    try {
      final response = await widget.apiClient.post(
        '/api/tracking/hearteli/circle/invite-code/',
      );
      if (response is! Map || response['code'] is! String) {
        throw const FormatException(
          'The server returned an invalid invite code.',
        );
      }
      final code = response['code'] as String;
      final expiry = DateTime.tryParse('${response['expires_at']}')?.toLocal();
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder:
            (dialog) => AlertDialog(
              title: const Text('Your Circle invite'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Ask them to scan this QR or enter the code in Hearteli. It works once and expires in 10 minutes.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  QrImageView(
                    data: code,
                    size: 220,
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 12),
                  SelectableText(
                    _formatInviteCode(code),
                    textAlign: TextAlign.center,
                    style: Theme.of(dialog).textTheme.titleLarge?.copyWith(
                      letterSpacing: 2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (expiry != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Expires at ${TimeOfDay.fromDateTime(expiry).format(dialog)}',
                    ),
                  ],
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: code));
                      if (dialog.mounted) {
                        showCalmMessage(dialog, 'Invite code copied.');
                      }
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy code'),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialog),
                  child: const Text('Done'),
                ),
              ],
            ),
      );
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    }
  }

  Future<void> _redeemCircleInvite() async {
    final code = TextEditingController();
    String? inviteError;
    bool redeeming = false;
    await showDialog<void>(
      context: context,
      builder:
          (dialog) => StatefulBuilder(
            builder:
                (dialog, update) => AlertDialog(
                  title: const Text('Join their Circle'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Scan their QR code or enter the 20-character invite code. You must be signed in to join.',
                      ),
                      const SizedBox(height: 14),
                      TextField(
                        controller: code,
                        textCapitalization: TextCapitalization.characters,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: 'Invite code',
                          hintText: 'Enter code',
                          error: inlineFieldError(inviteError),
                        ),
                        onChanged: (_) {
                          if (inviteError != null)
                            update(() => inviteError = null);
                        },
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed:
                              redeeming
                                  ? null
                                  : () async {
                                    final scanned = await Navigator.of(
                                      dialog,
                                    ).push<String>(
                                      MaterialPageRoute(
                                        builder:
                                            (_) =>
                                                const CircleInviteScannerScreen(),
                                      ),
                                    );
                                    if (scanned != null && dialog.mounted) {
                                      update(() {
                                        code.text = scanned;
                                        inviteError = null;
                                      });
                                    }
                                  },
                          icon: const Icon(Icons.qr_code_scanner),
                          label: const Text('Scan QR'),
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: redeeming ? null : () => Navigator.pop(dialog),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed:
                          redeeming
                              ? null
                              : () async {
                                if (code.text.trim().isEmpty) {
                                  update(() => inviteError = 'Enter the Circle invite code.');
                                  return;
                                }
                                update(() {
                                  redeeming = true;
                                  inviteError = null;
                                });
                                try {
                                  final response = await widget.apiClient.post(
                                    '/api/tracking/hearteli/circle/redeem-invite/',
                                    body: {'code': code.text},
                                  );
                                  if (!dialog.mounted) return;
                                  final ownerName =
                                      response is Map
                                          ? '${response['owner_name'] ?? 'your friend'}'
                                          : 'your friend';
                                  Navigator.pop(dialog);
                                  await load();
                                  if (mounted) {
                                    showCalmMessage(
                                      context,
                                      'You joined $ownerName’s Circle.',
                                    );
                                  }
                                } catch (e) {
                                  if (dialog.mounted)
                                    update(() => inviteError = formRequestError(e, invalid: 'Check the invitation details or ask for a new code.'));
                                } finally {
                                  if (dialog.mounted) {
                                    update(() => redeeming = false);
                                  }
                                }
                              },
                      child:
                          redeeming
                              ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Join Circle'),
                    ),
                  ],
                ),
          ),
    );
    code.dispose();
  }

  String _formatInviteCode(String code) => [
    for (var start = 0; start < code.length; start += 4)
      code.substring(start, start + 4 < code.length ? start + 4 : code.length),
  ].join(' ');

  Future<void> updateConnection(int id, Map<String, dynamic> payload) async {
    try {
      await widget.apiClient.patch(
        '/api/tracking/hearteli/circle/$id/',
        body: payload,
      );
      await load();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remove(Map<String, dynamic> person) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialog) => AlertDialog(
            title: const Text('Remove this person?'),
            content: const Text(
              'They will no longer be able to receive new Empathy Nudges from you.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialog, false),
                child: const Text('Keep in Circle'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialog, true),
                child: const Text('Remove'),
              ),
            ],
          ),
    );
    if (confirmed != true) return;
    try {
      await widget.apiClient.delete(
        '/api/tracking/hearteli/circle/${person['id']}/',
      );
      await load();
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    }
  }

  void open(Map<String, dynamic> person) => Navigator.push(
    context,
    MaterialPageRoute(
      builder:
          (_) => CircleDetail(
            person: person,
            isOwner: '${person['owner']}' == widget.sessionStore.userId,
            onUpdate: (data) => updateConnection(person['id'] as int, data),
            onRemove: () => remove(person),
          ),
    ),
  ).then((_) => load());
  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: load,
    child: ListView(
      padding: screenPadding,
      children: [
        const SizedBox(height: 6),
        const PageIntro(
          title: 'Your Circle',
          subtitle: 'The people you choose to keep close.',
        ),
        const SizedBox(height: 14),
        if (loading)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(),
            ),
          )
        else if (error != null)
          StatusPanel(message: error!, action: 'Retry', onAction: load)
        else if (connections.isEmpty)
          const StatusPanel(
            message:
                'Your Circle is yours to build. Your check-ins remain private whether or not you add someone.',
            icon: Icons.people_outline,
          )
        else
          for (final raw in connections)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: HearteliCard(
                child: LabelRow(
                  icon: Icons.person_outline,
                  title:
                      '${raw['owner']}' == widget.sessionStore.userId
                          ? '${raw['recipient_name']}'
                          : '${raw['owner_name']}',
                  subtitle:
                      '${raw['relationship']} · ${raw['declined_at'] != null
                          ? 'Invitation no longer available'
                          : raw['accepted_at'] == null
                          ? 'Pending'
                          : raw['may_receive_nudges'] == true
                          ? 'Nudges enabled'
                          : 'Paused'}',
                  onTap: () => open(Map<String, dynamic>.from(raw as Map)),
                ),
              ),
            ),
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: add,
          icon: const Icon(Icons.add),
          label: const Text('Add someone'),
        ),
        const SizedBox(height: 10),
        const Text(
          'No one sees a private check-in simply by joining your Circle.',
          style: TextStyle(color: AppColors.neutralGrey),
        ),
      ],
    ),
  );
}

class CircleInviteScannerScreen extends StatefulWidget {
  const CircleInviteScannerScreen({super.key});

  @override
  State<CircleInviteScannerScreen> createState() =>
      _CircleInviteScannerScreenState();
}

class _CircleInviteScannerScreenState extends State<CircleInviteScannerScreen> {
  String? scanError;
  bool handled = false;

  void _onDetect(BarcodeCapture capture) {
    if (handled) return;
    final rawValue =
        capture.barcodes
            .map((barcode) => barcode.rawValue)
            .whereType<String>()
            .firstOrNull;
    if (rawValue == null) return;

    final code = rawValue.toUpperCase().replaceAll(RegExp(r'[\s-]'), '');
    if (code.length == 20 &&
        RegExp(r'^[ABCDEFGHJKLMNPQRSTUVWXYZ23456789]+$').hasMatch(code)) {
      handled = true;
      Navigator.pop(context, code);
    } else if (scanError == null) {
      setState(
        () => scanError = 'That QR code is not a Hearteli Circle invite.',
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Scan Circle invite')),
    body: Column(
      children: [
        Expanded(
          child: MobileScanner(
            onDetect: _onDetect,
            errorBuilder:
                (context, error) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Unable to open the camera. Check camera permission in your device settings and try again.\n$error',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            scanError ?? 'Point your camera at the other person’s QR code.',
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}

class CircleDetail extends StatefulWidget {
  const CircleDetail({
    super.key,
    required this.person,
    required this.isOwner,
    required this.onUpdate,
    required this.onRemove,
  });
  final Map<String, dynamic> person;
  final bool isOwner;
  final Future<void> Function(Map<String, dynamic>) onUpdate;
  final Future<void> Function() onRemove;
  @override
  State<CircleDetail> createState() => _CircleDetailState();
}

class _CircleDetailState extends State<CircleDetail> {
  late bool nudge = widget.person['may_receive_nudges'] == true;
  late bool preference = widget.person['may_receive_preference'] == true;
  late bool pattern = widget.person['ask_on_pattern'] == true;
  late bool declined = widget.person['declined_at'] != null;
  bool busy = false;
  Future<bool> change(Map<String, dynamic> value) async {
    setState(() => busy = true);
    try {
      await widget.onUpdate(value);
      if (mounted && value['accept'] == true) {
        Navigator.pop(context);
      } else if (mounted && value['accept'] == false) {
        setState(() => declined = true);
      }
      return true;
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
      return false;
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pending = widget.person['accepted_at'] == null && !declined;
    final personName =
        widget.isOwner
            ? '${widget.person['recipient_name']}'
            : '${widget.person['owner_name']}';
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: screenPadding,
        children: [
          const SizedBox(height: 12),
          CircleAvatar(
            radius: 34,
            backgroundColor: AppColors.blush,
            child: Text(
              personName.isEmpty
                  ? '?'
                  : personName.substring(0, 1).toUpperCase(),
              style: const TextStyle(fontSize: 30, color: AppColors.coral),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            personName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            '${widget.person['relationship']} · ${declined
                ? 'Invitation no longer available'
                : pending
                ? 'Invitation pending'
                : 'Connected'}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          if (declined) ...[
            StatusPanel(
              message:
                  widget.isOwner
                      ? 'Invitation no longer available.'
                      : 'No problem. We won’t notify the person who invited you. You can choose whether to connect in the future.',
            ),
            if (!widget.isOwner)
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            if (widget.isOwner)
              TextButton(
                onPressed:
                    busy
                        ? null
                        : () async {
                          await widget.onRemove();
                          if (context.mounted) Navigator.pop(context);
                        },
                child: const Text('Remove unavailable invitation'),
              ),
          ] else if (!widget.isOwner && pending) ...[
            const StatusPanel(
              message:
                  'Accepting does not share any history or private check-ins with you.',
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: busy ? null : () => change({'accept': true}),
              child: const Text('Accept invitation'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed:
                  busy
                      ? null
                      : () async {
                        await change({'accept': false});
                      },
              child: const Text('Decline'),
            ),
          ] else ...[
            HearteliCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Who can see what?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Private notes and full check-in history are never included.',
                  ),
                  if (widget.isOwner)
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Include support preference'),
                      subtitle: const Text(
                        'Only when you choose it in a nudge preview.',
                      ),
                      value: preference,
                      onChanged:
                          pending || busy
                              ? null
                              : (v) async {
                                final saved = await change({
                                  'may_receive_preference': v,
                                });
                                if (mounted && saved) {
                                  setState(() => preference = v);
                                }
                              },
                    )
                  else
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Receive nudges'),
                      subtitle: const Text('Pause or resume any time.'),
                      value: nudge,
                      onChanged:
                          busy
                              ? null
                              : (v) async {
                                final saved = await change({
                                  'may_receive_nudges': v,
                                });
                                if (mounted && saved) setState(() => nudge = v);
                              },
                    ),
                ],
              ),
            ),
            if (widget.isOwner)
              SwitchListTile(
                title: const Text('Ask me after repeated tough check-ins'),
                subtitle: const Text(
                  'Two tough check-ins within 48 hours can suggest this person. Nothing is sent automatically.',
                ),
                value: pattern,
                onChanged:
                    pending || busy
                        ? null
                        : (v) async {
                          final saved = await change({'ask_on_pattern': v});
                          if (mounted && saved) setState(() => pattern = v);
                        },
              ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed:
                  busy
                      ? null
                      : () async {
                        await widget.onRemove();
                        if (context.mounted) Navigator.pop(context);
                      },
              child: const Text('Remove and revoke future access'),
            ),
          ],
        ],
      ),
    );
  }
}
