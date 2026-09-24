import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';

class WorkspaceDetailScreen extends StatefulWidget {
  const WorkspaceDetailScreen({
    super.key,
    required this.sessionStore,
    required this.apiClient,
    required this.workspace,
  });

  final SessionStore sessionStore;
  final ApiClient apiClient;
  final Map<String, dynamic> workspace;

  @override
  State<WorkspaceDetailScreen> createState() => _WorkspaceDetailScreenState();
}

class _WorkspaceDetailScreenState extends State<WorkspaceDetailScreen> {
  late Future<Map<String, dynamic>> _future;
  final TextEditingController _inviteController = TextEditingController();
  bool _isInviting = false;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Map<String, dynamic>> _load() async {
    final workspaceId = widget.workspace['id'];
    final workspaceType = (widget.workspace['workspace_type'] ?? 'family').toString();

    if (workspaceType == 'office') {
      final data = await widget.apiClient.get('/api/tracking/workspaces/$workspaceId/office_dashboard/');
      return data as Map<String, dynamic>;
    }

    return {
      'workspace_id': workspaceId,
      'workspace_type': workspaceType,
      'name': widget.workspace['name'] ?? 'Workspace',
      'subscription_plan': widget.workspace['subscription_plan'] ?? 'personal',
      'members': const [],
      'total_members': 1,
      'active_members_7d': 0,
      'average_mood_score': 0,
    };
  }

  Future<void> _inviteMembers() async {
    final rawValue = _inviteController.text.trim();
    if (rawValue.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter at least one email address.')),
      );
      return;
    }

    final emails = rawValue
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    if (emails.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No valid emails found.')),
      );
      return;
    }

    setState(() => _isInviting = true);

    try {
      final response = await widget.apiClient.post(
        '/api/tracking/workspaces/${widget.workspace['id']}/bulk_invite/',
        body: {'emails': emails},
      );

      final invitedCount = (response['invited_count'] as num?)?.toInt() ?? 0;
      final skipped = (response['skipped_emails'] as List?) ?? const [];
      final skippedText = skipped.isNotEmpty ? 'Skipped: ${skipped.join(', ')}' : 'All users were invited.';

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invited $invitedCount member(s). $skippedText')),
      );

      _inviteController.clear();
      setState(() {
        _future = _load();
        _isInviting = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _isInviting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invite failed: $error')),
      );
    }
  }

  @override
  void dispose() {
    _inviteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isOffice = (widget.workspace['workspace_type'] ?? 'family') == 'office';

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.workspace['name'] ?? 'Workspace'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }

          if (snapshot.hasError) {
            return ErrorView(
              message: '${snapshot.error}',
              onRetry: () => setState(() => _future = _load()),
            );
          }

          final data = snapshot.data ?? {};
          final members = (data['members'] as List?) ?? const [];
          final workspaceType = (data['workspace_type'] ?? 'family').toString();
          final subscriptionPlan = (data['subscription_plan'] ?? 'personal').toString();
          final totalMembers = (data['total_members'] as num?)?.toInt() ?? 0;
          final activeMembers = (data['active_members_7d'] as num?)?.toInt() ?? 0;
          final averageMoodScore = (data['average_mood_score'] as num?)?.toDouble() ?? 0;
          final environmentBreakdown = (data['environment_breakdown'] as Map?) ?? const {};
          final totalCheckIns = (environmentBreakdown['total_check_ins'] as num?)?.toInt() ?? 0;
          final positiveCount = (environmentBreakdown['positive'] as num?)?.toInt() ?? 0;
          final neutralCount = (environmentBreakdown['neutral'] as num?)?.toInt() ?? 0;
          final lowCount = (environmentBreakdown['low'] as num?)?.toInt() ?? 0;
          final environmentScore = (data['environment_score'] as num?)?.toDouble() ?? averageMoodScore;

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                Card(
                  color: AppColors.ink,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          workspaceType == 'office' ? 'Office workspace' : 'Workspace',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['name'] ?? widget.workspace['name'] ?? 'Workspace',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Chip(
                              label: Text(workspaceType),
                              backgroundColor: AppColors.lilac,
                            ),
                            const SizedBox(width: 8),
                            Chip(
                              label: Text(
                                subscriptionPlan == 'office_20' ? 'Office • \$20/month' : 'Personal plan',
                              ),
                              backgroundColor: AppColors.blush,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (isOffice) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 160,
                              child: _EnvironmentScoreChart(
                                score: environmentScore,
                                positive: positiveCount,
                                neutral: neutralCount,
                                low: lowCount,
                                totalCheckIns: totalCheckIns,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Workspace environment',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _LegendRow(
                                  label: 'Positive',
                                  value: positiveCount,
                                  color: AppColors.mint,
                                ),
                                const SizedBox(height: 8),
                                _LegendRow(
                                  label: 'Neutral',
                                  value: neutralCount,
                                  color: AppColors.lavender,
                                ),
                                const SizedBox(height: 8),
                                _LegendRow(
                                  label: 'Low',
                                  value: lowCount,
                                  color: const Color(0xFFFFB1B1),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  totalCheckIns > 0
                                      ? '$totalCheckIns check-ins in the last 7 days'
                                      : 'No mood check-ins yet',
                                  style: const TextStyle(color: AppColors.muted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _MetricCard(
                          label: 'Members',
                          value: '$totalMembers',
                          accentColor: AppColors.lilac,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _MetricCard(
                          label: 'Active 7d',
                          value: '$activeMembers',
                          accentColor: AppColors.blush,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _MetricCard(
                    label: 'Average mood score',
                    value: '${averageMoodScore.toStringAsFixed(0)}%',
                    accentColor: AppColors.ink,
                    fullWidth: true,
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Invite team members',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _inviteController,
                            minLines: 1,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              hintText: 'email1@example.com, email2@example.com',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _isInviting ? null : _inviteMembers,
                              icon: _isInviting
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                  : const Icon(Icons.group_add_outlined),
                              label: Text(_isInviting ? 'Inviting...' : 'Invite members'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Members',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  if (members.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('No members yet.'),
                      ),
                    )
                  else
                    ...members.map((member) {
                      final map = member as Map<String, dynamic>;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Text((map['name'] ?? 'U').toString().substring(0, 1).toUpperCase()),
                          ),
                          title: Text(map['name'] ?? 'Member'),
                          subtitle: Text(
                            '${map['designation'] ?? 'Employee'} • ${map['role'] ?? 'employee'}',
                          ),
                        ),
                      );
                    }),
                ] else ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'This workspace is not an office workspace. The office dashboard and bulk invite features are available only for office workspaces.',
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EnvironmentScoreChart extends StatelessWidget {
  const _EnvironmentScoreChart({
    required this.score,
    required this.positive,
    required this.neutral,
    required this.low,
    required this.totalCheckIns,
  });

  final double score;
  final int positive;
  final int neutral;
  final int low;
  final int totalCheckIns;

  @override
  Widget build(BuildContext context) {
    final total = positive + neutral + low;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: CustomPaint(
            painter: _EnvironmentPieChartPainter(
              positive: positive,
              neutral: neutral,
              low: low,
              total: total,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              totalCheckIns > 0 ? '${score.round()}%' : '0%',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const Text(
              'Environment',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EnvironmentPieChartPainter extends CustomPainter {
  _EnvironmentPieChartPainter({
    required this.positive,
    required this.neutral,
    required this.low,
    required this.total,
  });

  final int positive;
  final int neutral;
  final int low;
  final int total;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final backgroundPaint = Paint()..color = const Color(0xFFE9E5F5);
    canvas.drawCircle(center, radius, backgroundPaint);

    if (total == 0) {
      return;
    }

    double startAngle = -math.pi / 2;

    final slices = [
      _ChartSliceData(value: positive, color: AppColors.mint),
      _ChartSliceData(value: neutral, color: AppColors.lavender),
      _ChartSliceData(value: low, color: const Color(0xFFFFB1B1)),
    ];

    for (final slice in slices) {
      if (slice.value <= 0) continue;
      final sweepAngle = (slice.value / total) * math.pi * 2;
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        true,
        Paint()..color = slice.color,
      );
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _ChartSliceData {
  const _ChartSliceData({required this.value, required this.color});

  final int value;
  final Color color;
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '$label',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          '$value',
          style: const TextStyle(color: AppColors.muted),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.accentColor,
    this.fullWidth = false,
  });

  final String label;
  final String value;
  final Color accentColor;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: Card(
        color: accentColor,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: accentColor == AppColors.ink ? Colors.white70 : Colors.black54,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  color: accentColor == AppColors.ink ? Colors.white : AppColors.ink,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
