import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../hearteli/presentation/checkin_screen.dart';
import '../../hearteli/presentation/circle_screen.dart';
import '../../hearteli/presentation/components.dart';
import '../../hearteli/presentation/insights_screen.dart';
import '../../hearteli/presentation/onboarding_screen.dart';
import '../../hearteli/presentation/settings_screen.dart';
import '../../hearteli/presentation/support_screen.dart';
import '../../hearteli/presentation/therapy_screen.dart';
import '../../hearteli/presentation/work_screen.dart';
import '../../hearteli/presentation/safety_screen.dart';
import '../../appointments/presentation/appointments_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.sessionStore,
    required this.apiClient,
  });
  final SessionStore sessionStore;
  final ApiClient apiClient;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0, refresh = 0;
  bool workContext = false;
  void complete() {
    setState(() {
      index = 0;
      refresh++;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.sessionStore.hasCompletedSetup)
      return FirstRunSetup(
        apiClient: widget.apiClient,
        onDone: () async {
          await widget.sessionStore.completeSetup();
          if (mounted) setState(() {});
        },
      );
    final pages = [
      HomeScreen(
        key: ValueKey(refresh),
        apiClient: widget.apiClient,
        sessionStore: widget.sessionStore,
        onCheckIn: () => setState(() => index = 2),
        onCircle: () => setState(() => index = 1),
      ),
      CircleScreen(
        apiClient: widget.apiClient,
        sessionStore: widget.sessionStore,
      ),
      CheckInScreen(
        key: ValueKey('checkin-$refresh'),
        apiClient: widget.apiClient,
        userId: widget.sessionStore.userId ?? '',
        onComplete: complete,
      ),
      workContext
          ? WorkScreen(
              apiClient: widget.apiClient,
              sessionStore: widget.sessionStore,
            )
          : InsightsScreen(
              key: ValueKey('insights-$refresh'),
              apiClient: widget.apiClient,
            ),
      MoreScreen(
        apiClient: widget.apiClient,
        sessionStore: widget.sessionStore,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const BrandLogo(height: 42),
        actions: [
          PopupMenuButton<bool>(
            tooltip: 'Switch personal or work context',
            icon: const Icon(Icons.account_circle_outlined),
            onSelected: (value) => setState(() {
              workContext = value;
              index = 0;
            }),
            itemBuilder: (_) => const [
              PopupMenuItem(value: false, child: Text('Personal')),
              PopupMenuItem(value: true, child: Text('For Work')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: IndexedStack(index: index, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => setState(() => index = i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Circle',
          ),
          const NavigationDestination(
            icon: Icon(Icons.add_circle_outline, color: AppColors.coral),
            selectedIcon: Icon(Icons.add_circle, color: AppColors.coral),
            label: 'Check-In',
          ),
          NavigationDestination(
            icon: Icon(
              workContext ? Icons.work_outline : Icons.insights_outlined,
            ),
            label: workContext ? 'Work' : 'Insights',
          ),
          const NavigationDestination(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.apiClient,
    required this.sessionStore,
    required this.onCheckIn,
    required this.onCircle,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
  final VoidCallback onCheckIn, onCircle;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> history = [], nudges = [];
  String? error;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final data = await Future.wait([
        widget.apiClient.get('/api/tracking/mood-check-ins/'),
        widget.apiClient.get('/api/tracking/hearteli/nudges/'),
      ]);
      if (mounted)
        setState(() {
          history = items(data[0]);
          nudges = items(data[1]);
          error = null;
        });
    } catch (e) {
      if (mounted) setState(() => error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final checkedIn = history.any((entry) => entry['date'] == today);
    final name = widget.sessionStore.userName?.split(' ').first ?? 'friend';
    return RefreshIndicator(
      onRefresh: load,
      child: ListView(
        padding: screenPadding,
        children: [
          const SizedBox(height: 6),
          Text(
            'Hello, $name',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 5),
          Text(
            checkedIn
                ? 'Thanks for checking in today.'
                : 'How are you feeling today?',
            style: const TextStyle(color: AppColors.neutralGrey, fontSize: 16),
          ),
          const SizedBox(height: 22),
          HearteliCard(
            color: AppColors.blush,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.favorite_outline,
                  color: AppColors.coral,
                  size: 38,
                ),
                const SizedBox(height: 15),
                const Text(
                  'Small check-ins make a big difference.',
                  style: TextStyle(
                    fontSize: 23,
                    height: 1.15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'A moment for yourself. Sharing is always your choice.',
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: widget.onCheckIn,
                  child: Text(checkedIn ? 'Check in again' : 'Check in now'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text('Quick actions', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19)),
          const SizedBox(height: 10),
          Row(children: [
            _QuickAction(icon: Icons.chat_bubble_outline, label: 'Message',
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => SupportInboxScreen(apiClient: widget.apiClient)))),
            _QuickAction(icon: Icons.send_outlined, label: 'Nudge', onTap: widget.onCheckIn),
            _QuickAction(icon: Icons.calendar_today_outlined, label: 'Book',
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => TherapyScreen(apiClient: widget.apiClient)))),
            _QuickAction(icon: Icons.bar_chart_outlined, label: 'Insights',
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => Scaffold(appBar: AppBar(title: const Text('Insights')),
                  body: InsightsScreen(apiClient: widget.apiClient))))),
          ]),
          const SizedBox(height: 22),
          const Text(
            'A kinder way to be there',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 19),
          ),
          const SizedBox(height: 10),
          HearteliCard(
            child: Column(
              children: [
                LabelRow(
                  icon: Icons.people_outline,
                  title: 'Your Circle',
                  subtitle: 'People who care about you',
                  onTap: widget.onCircle,
                ),
                LabelRow(
                  icon: Icons.send_outlined,
                  title: 'Empathy Nudges',
                  subtitle: 'See support sent and received',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          SupportInboxScreen(apiClient: widget.apiClient),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          if (error != null)
            StatusPanel(message: error!, action: 'Retry', onAction: load)
          else if (nudges.isNotEmpty)
            HearteliCard(
              color: AppColors.softBlue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recent support',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${nudges.first['sender_name']} → ${nudges.first['recipient_name']} · ${nudges.first['status']}',
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => NudgeDetail(
                          apiClient: widget.apiClient,
                          id: nudges.first['id'] as int,
                        ),
                      ),
                    ),
                    child: const Text('View update'),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          const Text(
            'Know when to be there.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.neutralGrey, letterSpacing: 2),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override Widget build(BuildContext context) => Expanded(child: InkWell(
    onTap: onTap, borderRadius: BorderRadius.circular(14),
    child: Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Column(children: [
      Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.blush,
        borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: AppColors.coral, size: 22)),
      const SizedBox(height: 6),
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
    ])),
  ));
}

class MoreScreen extends StatelessWidget {
  const MoreScreen({
    super.key,
    required this.apiClient,
    required this.sessionStore,
  });
  final ApiClient apiClient;
  final SessionStore sessionStore;
  @override
  Widget build(BuildContext context) => ListView(
    padding: screenPadding,
    children: [
      const PageIntro(
        title: 'More',
        subtitle: 'Support, privacy and your account.',
      ),
      const SizedBox(height: 22),
      HearteliCard(
        child: Column(
          children: [
            LabelRow(
              icon: Icons.favorite_outline,
              title: 'Support history',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SupportInboxScreen(apiClient: apiClient),
                ),
              ),
            ),
            LabelRow(
              icon: Icons.psychology_outlined,
              title: 'Find a therapist',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TherapyScreen(apiClient: apiClient),
                ),
              ),
            ),
            LabelRow(
              icon: Icons.calendar_month_outlined,
              title: 'Appointments',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: const Text('Appointments')),
                    body: AppointmentsScreen(apiClient: apiClient),
                  ),
                ),
              ),
            ),
            LabelRow(
              icon: Icons.work_outline,
              title: 'For Work',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: AppBar(title: const Text('For Work')),
                    body: WorkScreen(
                      apiClient: apiClient,
                      sessionStore: sessionStore,
                    ),
                  ),
                ),
              ),
            ),
            LabelRow(
              icon: Icons.health_and_safety_outlined,
              title: 'Immediate support',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SafetyScreen()),
              ),
            ),
            LabelRow(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SettingsScreen(
                    apiClient: apiClient,
                    sessionStore: sessionStore,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
