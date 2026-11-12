import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/appointments/appointment_time.dart';
import '../../../core/theme/app_theme.dart';
import 'components.dart';
import 'sponsor_placement.dart';

class TherapyScreen extends StatefulWidget {
  const TherapyScreen({super.key, required this.apiClient});
  final ApiClient apiClient;
  @override
  State<TherapyScreen> createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> {
  List<dynamic> professionals = [];
  List<String> specialties = [];
  List<int> durations = [];
  final query = TextEditingController();
  final maxFee = TextEditingController();
  Set<String> selectedSpecialties = {};
  int? duration;
  Map<String, dynamic> applied = {};
  bool loading = true, loadingMore = false;
  String? error, feeError, pageError;
  int? nextAfter;
  int resultCount = 0;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    query.dispose();
    maxFee.dispose();
    super.dispose();
  }

  Future<void> load() async {
    setState(() {
      loading = true;
      error = null;
      pageError = null;
      nextAfter = null;
    });
    try {
      final data = await widget.apiClient.get(
        '/api/users/marketplace/search/',
        query: {'include_facets': 'true', ...applied},
      );
      if (!mounted) return;
      setState(() {
        professionals = [...items(data['sponsored']), ...items(data['organic'])];
        resultCount = (data['count'] as int?) ?? professionals.length;
        nextAfter = data['next_after'] as int?;
        specialties = items(data['specialties']).whereType<String>().toList();
        durations = items(data['durations']).whereType<int>().toList();
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        error = 'Could not load therapists. Please try again.';
        loading = false;
      });
    }
  }

  Future<void> loadMore() async {
    final after = nextAfter;
    if (after == null || loading || loadingMore) return;
    setState(() {
      loadingMore = true;
      pageError = null;
    });
    try {
      final data = await widget.apiClient.get(
        '/api/users/marketplace/search/',
        query: {'include_facets': 'true', ...applied, 'after': after},
      );
      if (!mounted) return;
      setState(() {
        final seen = professionals.map((p) => p['id']).toSet();
        professionals.addAll(items(data['organic']).where((p) => seen.add(p['id'])));
        nextAfter = data['next_after'] as int?;
      });
    } catch (_) {
      if (mounted) setState(() => pageError = 'Could not load more therapists.');
    } finally {
      if (mounted) setState(() => loadingMore = false);
    }
  }

  void apply() {
    FocusScope.of(context).unfocus();
    final fee = maxFee.text.trim();
    final name = query.text.trim();
    if (fee.isNotEmpty && !RegExp(r'^\d{1,8}(\.\d{1,2})?$').hasMatch(fee)) {
      setState(() => feeError = 'Enter a non-negative fee with up to two decimals.');
      return;
    }
    feeError = null;
    applied = {
      if (name.isNotEmpty) 'q': name,
      if (selectedSpecialties.isNotEmpty)
        'specialties': selectedSpecialties.join(','),
      if (fee.isNotEmpty) 'max_fee': fee,
      if (duration != null) 'duration': duration,
    };
    load();
  }

  void clear() {
    query.clear();
    maxFee.clear();
    selectedSpecialties = {};
    duration = null;
    apply();
  }

  void removeFilter(String key, [String? specialty]) {
    final next = Map<String, dynamic>.from(applied);
    if (specialty != null) {
      final values = (next[key] as String).split(',')..remove(specialty);
      selectedSpecialties.remove(specialty);
      if (values.isEmpty) {
        next.remove(key);
      } else {
        next[key] = values.join(',');
      }
    } else {
      next.remove(key);
      if (key == 'q') query.clear();
      if (key == 'max_fee') {
        maxFee.clear();
        feeError = null;
      }
      if (key == 'duration') duration = null;
    }
    applied = next;
    load();
  }

  Future<void> chooseSpecialties() async {
    final pending = {...selectedSpecialties};
    var search = '';
    final result = await showDialog<Set<String>>(
      context: context,
      builder: (dialog) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          scrollable: true,
          title: const Text('Specialties'),
          content: SizedBox(
            width: 360,
            height: 300,
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Search specialties'),
                  onChanged: (value) => update(() => search = value.toLowerCase()),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      for (final item in specialties)
                        if (item.toLowerCase().contains(search))
                          CheckboxListTile(
                            title: Text(item),
                            value: pending.contains(item),
                            onChanged: (checked) => update(() {
                              if (checked == true) {
                                pending.add(item);
                              } else {
                                pending.remove(item);
                              }
                            }),
                          ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(dialog), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(dialog, pending), child: const Text('Done')),
          ],
        ),
      ),
    );
    if (mounted && result != null) setState(() => selectedSpecialties = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Professional support')),
      body: ListView(
        padding: screenPadding,
        children: [
          const PageIntro(
            title: 'Find a therapist',
            subtitle: 'Professional support is here if you want it.',
          ),
          const SizedBox(height: 18),
          TextField(
            controller: query,
            maxLength: 100,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: 'Search by name',
              counterText: '',
            ),
            onSubmitted: (_) { if (!loading && !loadingMore) apply(); },
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: loading || specialties.isEmpty ? null : chooseSpecialties,
            child: Text(selectedSpecialties.isEmpty
                ? 'Any specialty'
                : '${selectedSpecialties.length} specialties selected'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: maxFee,
            decoration: InputDecoration(
              labelText: 'Maximum fee (USD)',
              hintText: 'Any price',
              errorText: feeError,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 12),
          DropdownButton<int>(
            value: duration,
            hint: const Text('Any session duration'),
            isExpanded: true,
            items: [
              const DropdownMenuItem(value: null, child: Text('Any session duration')),
              for (final value in {...durations, if (duration != null) duration!})
                DropdownMenuItem(value: value, child: Text('$value minutes')),
            ],
            onChanged: loading ? null : (value) => setState(() => duration = value),
          ),
          Wrap(
            spacing: 8,
            children: [
              OutlinedButton(onPressed: loading || loadingMore ? null : apply, child: const Text('Apply filters')),
              TextButton(onPressed: loading || loadingMore ? null : clear, child: const Text('Clear all')),
            ],
          ),
          Wrap(
            spacing: 8,
            children: [
              for (final entry in applied.entries)
                if (entry.key == 'specialties')
                  for (final value in (entry.value as String).split(','))
                    InputChip(label: Text(value), onDeleted: loading || loadingMore ? null : () => removeFilter(entry.key, value))
                else
                  InputChip(
                    label: Text(switch (entry.key) {
                      'max_fee' => 'Up to USD ${entry.value}',
                      'duration' => '${entry.value} minutes',
                      _ => '${entry.value}',
                    }),
                    onDeleted: loading || loadingMore ? null : () => removeFilter(entry.key),
                  ),
            ],
          ),
          const SizedBox(height: 16),
          if (loading)
            const Center(child: CircularProgressIndicator(semanticsLabel: 'Loading therapists'))
          else if (error != null)
            Semantics(liveRegion: true, child: StatusPanel(message: error!, action: 'Retry', onAction: load))
          else if (professionals.isEmpty)
            Semantics(
              liveRegion: true,
              child: StatusPanel(
                message: applied.isEmpty
                    ? 'No eligible therapists are available in the directory right now.'
                    : 'No therapists match your filters.',
                action: applied.isEmpty ? null : 'View all therapists',
                onAction: applied.isEmpty ? null : clear,
              ),
            )
          else ...[
            Semantics(liveRegion: true, child: Text(
              resultCount == professionals.length
                  ? '$resultCount therapists found'
                  : 'Showing ${professionals.length} of $resultCount therapists',
            )),
            for (final raw in professionals)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: HearteliCard(
                  child:
                      raw['sponsor'] != null
                          ? SponsorPlacement(
                            apiClient: widget.apiClient,
                            payload: Map<String, dynamic>.from(raw['sponsor']),
                            child: LabelRow(
                              icon: Icons.psychology_outlined,
                              title:
                                  '${raw['name']} ${raw['verified'] == true ? '✓ Verified' : ''}',
                              subtitle:
                                  '${items(raw['offerings']).length} approved session options',
                              onTap: () async {
                                try {
                                  await widget.apiClient.post(
                                    '/api/users/sponsor-events/',
                                    body: {
                                      'event_id': raw['sponsor']['event_id'],
                                      'event_type': 'click',
                                    },
                                  );
                                } catch (_) {}
                                if (!context.mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => TherapistDetail(
                                          apiClient: widget.apiClient,
                                          therapist: Map<String, dynamic>.from(
                                            raw as Map,
                                          ),
                                        ),
                                  ),
                                );
                              },
                            ),
                          )
                          : LabelRow(
                            icon: Icons.psychology_outlined,
                            title:
                                '${raw['name']} ${raw['verified'] == true ? '✓ Verified' : ''}',
                            subtitle:
                                '${items(raw['offerings']).length} approved session options',
                            onTap:
                                () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => TherapistDetail(
                                          apiClient: widget.apiClient,
                                          therapist: Map<String, dynamic>.from(
                                            raw as Map,
                                          ),
                                        ),
                                  ),
                                ),
                          ),
                ),
              ),
            if (nextAfter != null)
              OutlinedButton(
                onPressed: loadingMore ? null : loadMore,
                child: Text(loadingMore ? 'Loading…' : 'Load more therapists'),
              ),
            if (pageError != null)
              Semantics(liveRegion: true, child: Text(pageError!)),
          ],
          const SizedBox(height: 12),
          const Text(
            'Hearteli is not emergency care. For urgent safety concerns, use Immediate support.',
            style: TextStyle(color: AppColors.neutralGrey),
          ),
        ],
      ),
    );
  }
}

class TherapistDetail extends StatelessWidget {
  const TherapistDetail({
    super.key,
    required this.apiClient,
    required this.therapist,
  });
  final ApiClient apiClient;
  final Map<String, dynamic> therapist;
  @override
  Widget build(BuildContext context) {
    final profile = therapist['therapist_profile'] as Map? ?? {};
    return Scaffold(
      appBar: AppBar(title: const Text('Therapist profile')),
      body: ListView(
        padding: screenPadding,
        children: [
          Text(
            therapist['review_count'] == 0 ||
                    therapist['average_rating'] == null
                ? 'No client reviews yet'
                : '${therapist['average_rating']} / 5 · ${therapist['review_count']} reviews',
          ),
          TextButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => TherapistReviewsScreen(
                          apiClient: apiClient,
                          id: therapist['id'] as int,
                        ),
                  ),
                ),
            child: const Text('Read client reviews'),
          ),
          Center(
            child: CircleAvatar(
              radius: 42,
              backgroundColor: AppColors.blush,
              child: const Icon(
                Icons.person_outline,
                color: AppColors.coral,
                size: 40,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '${therapist['name']} ${therapist['verified'] == true ? '✓ Verified' : '· Not verified'}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          HearteliCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Professional details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text('Credentials: ${profile['degrees'] ?? 'Not provided'}'),
                const SizedBox(height: 7),
                Text(
                  'Certifications: ${profile['certifications'] ?? 'Not provided'}',
                ),
                const SizedBox(height: 7),
                Text(
                  '${items(therapist['offerings']).length} approved session duration and fee options',
                ),
                const SizedBox(height: 7),
                Text(
                  'Availability: ${profile['is_available'] == true ? 'Ask for a time' : 'Not confirmed'}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BookTherapist(
                          apiClient: apiClient,
                          therapist: therapist,
                        ),
                  ),
                ),
            child: const Text('Request a session'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => ShareTherapyContext(
                          apiClient: apiClient,
                          therapist: therapist,
                        ),
                  ),
                ),
            child: const Text('Share selected context'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Sharing context is separate from booking and is always optional.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.neutralGrey),
          ),
        ],
      ),
    );
  }
}

class BookTherapist extends StatefulWidget {
  const BookTherapist({
    super.key,
    required this.apiClient,
    required this.therapist,
  });
  final ApiClient apiClient;
  final Map<String, dynamic> therapist;
  @override
  State<BookTherapist> createState() => _BookTherapistState();
}

class _BookTherapistState extends State<BookTherapist> {
  AppointmentClock? clock;
  bool loadingClock = true;
  DateTime? date;
  TimeOfDay? time;
  String format = 'Online';
  int? offeringId;
  Map<String, dynamic>? get selectedOffering {
    for (final o in items(widget.therapist['offerings'])) {
      if (o['id'] == offeringId) return Map<String, dynamic>.from(o);
    }
    return null;
  }

  bool busy = false;
  final reason = TextEditingController();
  final referral = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadClock();
    final sponsor = widget.therapist['sponsor'];
    if (sponsor != null)
      widget.apiClient
          .post(
            '/api/users/sponsor-events/',
            body: {
              'event_id': sponsor['event_id'],
              'event_type': 'booking_start',
            },
          )
          .catchError((_) => <String, dynamic>{});
  }

  Future<void> loadClock() async {
    setState(() => loadingClock = true);
    try {
      final value = await AppointmentClock.load(widget.apiClient);
      if (mounted) setState(() => clock = value);
    } catch (_) {
      if (mounted) setState(() => clock = null);
    } finally {
      if (mounted) setState(() => loadingClock = false);
    }
  }

  @override
  void dispose() {
    reason.dispose();
    referral.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (date == null || time == null || selectedOffering == null) return;
    final selectedClock = clock;
    if (selectedClock == null) return;
    final local = selectedClock.resolve(date!, time!);
    if (local == null) {
      showCalmMessage(context, 'That time does not exist in your timezone. Choose another time.');
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialog) => AlertDialog(
            title: const Text('Review session request'),
            content: Text(
              '${widget.therapist['name']}\n${selectedClock.describe(local)}\n$format\nFee: USD ${selectedOffering?['fee']} · ${selectedOffering?['duration_minutes']} minutes\n\nThis request does not share your private check-ins.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialog, false),
                child: const Text('Edit'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialog, true),
                child: const Text('Confirm'),
              ),
            ],
          ),
    );
    if (!mounted || confirmed != true) return;
    setState(() => busy = true);
    try {
      await widget.apiClient.post(
        '/api/users/create-appointment/${widget.therapist['id']}/',
        body: {
          ...appointmentUtcPayload(local),
          'offering_id': offeringId,
          if (referral.text.trim().isNotEmpty)
            'referral_code': referral.text.trim(),
          if (widget.therapist['sponsor'] != null)
            'sponsor_event_id': widget.therapist['sponsor']['event_id'],
          'location': format,
          'reason':
              reason.text.trim().isEmpty
                  ? 'Support session'
                  : reason.text.trim(),
        },
      );
      if (mounted) {
        showCalmMessage(
          context,
          'Session request saved. Confirm availability with the provider.',
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) showCalmMessage(context, '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Request a session')),
    body: ListView(
      padding: screenPadding,
      children: [
        if (loadingClock)
          const LinearProgressIndicator()
        else if (clock == null)
          StatusPanel(message: 'Could not load your appointment timezone.', action: 'Retry', onAction: loadClock)
        else
          Text('Appointment timezone: ${clock!.label}'),
        PageIntro(
          title: 'Book ${widget.therapist['name']}',
          subtitle: 'Choose a time and review details before submitting.',
        ),
        DropdownButtonFormField<int>(
          value: offeringId,
          decoration: const InputDecoration(
            labelText: 'Approved session & fee',
          ),
          items:
              items(widget.therapist['offerings'])
                  .map(
                    (o) => DropdownMenuItem<int>(
                      value: o['id'] as int,
                      child: Text(
                        '${o['duration_minutes']} minutes · USD ${o['fee']}',
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (v) => setState(() => offeringId = v),
        ),
        const SizedBox(height: 18),
        OutlinedButton(
          onPressed: () async {
            final result = await showDatePicker(
              context: context,
              initialDate: (clock?.today ?? DateTime.now()).add(const Duration(days: 1)),
              firstDate: clock?.today ?? DateTime.now(),
              lastDate: (clock?.today ?? DateTime.now()).add(const Duration(days: 180)),
            );
            if (result != null) setState(() => date = result);
          },
          child: Text(
            date == null
                ? 'Select date'
                : date!.toIso8601String().substring(0, 10),
          ),
        ),
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: () async {
            final result = await showTimePicker(
              context: context,
              initialTime: const TimeOfDay(hour: 10, minute: 0),
            );
            if (result != null) setState(() => time = result);
          },
          child: Text(
            time == null
                ? 'Select time'
                : '${time!.format(context)} · ${clock?.label ?? 'Timezone unavailable'}',
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: format,
          decoration: const InputDecoration(labelText: 'Session format'),
          items:
              [
                'Online',
                'In person',
              ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => setState(() => format = v ?? format),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: reason,
          maxLength: 200,
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Reason (optional; shared with therapist)',
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: referral,
          decoration: const InputDecoration(
            labelText: 'Therapist referral code (optional)',
          ),
        ),
        const StatusPanel(
          message:
              'Booking does not grant access to your check-ins. You can share selected context separately.',
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: date == null || time == null || busy || loadingClock || clock == null
              ? null
              : submit,
          child: Text(busy ? 'Submitting…' : 'Review booking'),
        ),
      ],
    ),
  );
}

class ShareTherapyContext extends StatefulWidget {
  const ShareTherapyContext({
    super.key,
    required this.apiClient,
    required this.therapist,
  });
  final ApiClient apiClient;
  final Map<String, dynamic> therapist;
  @override
  State<ShareTherapyContext> createState() => _ShareTherapyContextState();
}

class _ShareTherapyContextState extends State<ShareTherapyContext> {
  List<dynamic> checkins = [];
  final selected = <int>{};
  bool notes = false, busy = false;
  int days = 7;
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data = await widget.apiClient.get('/api/tracking/mood-check-ins/');
      if (mounted) setState(() => checkins = items(data));
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    }
  }

  Future<void> share() async {
    if (selected.isEmpty) return;
    final yes = await showDialog<bool>(
      context: context,
      builder:
          (dialog) => AlertDialog(
            title: const Text('Who can see this?'),
            content: Text(
              '${widget.therapist['name']} can view ${selected.length} selected check-in(s)${notes ? ', including their private notes' : ', without notes'}, for $days days. You can revoke access earlier.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialog, false),
                child: const Text('Edit'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialog, true),
                child: const Text('Share selected'),
              ),
            ],
          ),
    );
    if (yes != true) return;
    setState(() => busy = true);
    try {
      await widget.apiClient.post(
        '/api/tracking/hearteli/therapy-context/',
        body: {
          'therapist': widget.therapist['id'],
          'check_in_ids': selected.toList(),
          'include_notes': notes,
          'expires_at':
              DateTime.now()
                  .toUtc()
                  .add(Duration(days: days))
                  .toIso8601String(),
        },
      );
      if (mounted) {
        showCalmMessage(
          context,
          'Selected context shared. Revoke it in Privacy & Consent.',
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Share context')),
    body: ListView(
      padding: screenPadding,
      children: [
        PageIntro(
          title: 'Choose what to share',
          subtitle: 'Nothing is preselected. Booking stays separate.',
        ),
        const SizedBox(height: 16),
        if (error != null) StatusPanel(message: error!),
        if (checkins.isEmpty)
          const StatusPanel(
            message: 'No check-ins available. You can skip context sharing.',
          ),
        for (final raw in checkins.take(20))
          CheckboxListTile(
            title: Text(
              '${raw['date']} · ${raw['feeling_category'] ?? 'Check-in'}',
            ),
            subtitle: const Text('Only selected details'),
            value: selected.contains(raw['id']),
            onChanged:
                (v) => setState(
                  () =>
                      v == true
                          ? selected.add(raw['id'] as int)
                          : selected.remove(raw['id']),
                ),
          ),
        SwitchListTile(
          title: const Text('Include private notes'),
          subtitle: const Text('Off by default'),
          value: notes,
          onChanged: (v) => setState(() => notes = v),
        ),
        DropdownButtonFormField<int>(
          value: days,
          decoration: const InputDecoration(labelText: 'Access expires in'),
          items:
              [1, 7, 30]
                  .map(
                    (v) => DropdownMenuItem(
                      value: v,
                      child: Text('$v day${v == 1 ? '' : 's'}'),
                    ),
                  )
                  .toList(),
          onChanged: (v) => setState(() => days = v ?? days),
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: selected.isEmpty || busy ? null : share,
          child: const Text('Preview selected context'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Skip'),
        ),
      ],
    ),
  );
}

class TherapistReviewsScreen extends StatelessWidget {
  const TherapistReviewsScreen({
    super.key,
    required this.apiClient,
    required this.id,
  });
  final ApiClient apiClient;
  final int id;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Client reviews')),
    body: FutureBuilder<dynamic>(
      future: apiClient.get('/api/users/therapists/$id/reviews/'),
      builder: (context, snapshot) {
        if (snapshot.hasError) return StatusPanel(message: '${snapshot.error}');
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final reviews = items(snapshot.data);
        return ListView(
          padding: screenPadding,
          children: [
            if (reviews.isEmpty) const Text('No client reviews yet.'),
            for (final r in reviews)
              HearteliCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${r['rating']} / 5 · Completed session'),
                    Text('${r['comment']}'),
                    TextButton(
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder:
                              (dialog) => AlertDialog(
                                title: const Text('Report this review?'),
                                content: const Text(
                                  'Send this review to the moderation team for assessment.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(dialog, false),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(dialog, true),
                                    child: const Text('Report'),
                                  ),
                                ],
                              ),
                        );
                        if (confirmed != true) return;
                        try {
                          await apiClient.post(
                            '/api/users/reviews/${r['id']}/report/',
                            body: {
                              'reason': 'Client requested moderation review',
                            },
                          );
                          if (context.mounted)
                            showCalmMessage(
                              context,
                              'Report sent for moderation.',
                            );
                        } catch (e) {
                          if (context.mounted) showCalmMessage(context, '$e');
                        }
                      },
                      child: const Text('Report review'),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    ),
  );
}
