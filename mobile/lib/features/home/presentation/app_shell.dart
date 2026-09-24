import 'package:flutter/material.dart';

import '../../../core/notifications/firebase_service.dart';
import '../../../core/network/api_client.dart';
import '../../../core/session/session_store.dart';
import '../../../core/theme/app_theme.dart';
import '../../appointments/presentation/appointments_screen.dart';
import '../../gratitude/presentation/gratitude_screen.dart';
import '../../mood/presentation/mood_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../therapist/presentation/therapist_dashboard_screen.dart';
import '../../therapists/presentation/therapists_screen.dart';
import 'dashboard_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.sessionStore, required this.apiClient});

  final SessionStore sessionStore;
  final ApiClient apiClient;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    FirebaseService(widget.apiClient).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.sessionStore.isTherapist ? [
      TherapistDashboardScreen(apiClient: widget.apiClient),
      AppointmentsScreen(apiClient: widget.apiClient),
      GratitudeScreen(apiClient: widget.apiClient),
      ProfileScreen(sessionStore: widget.sessionStore, apiClient: widget.apiClient),
    ] : [
      DashboardScreen(sessionStore: widget.sessionStore, apiClient: widget.apiClient),
      MoodScreen(apiClient: widget.apiClient),
      TherapistsScreen(apiClient: widget.apiClient),
      AppointmentsScreen(apiClient: widget.apiClient),
      ProfileScreen(sessionStore: widget.sessionStore, apiClient: widget.apiClient),
    ];
    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        backgroundColor: Colors.white,
        indicatorColor: AppColors.lilac,
        destinations: widget.sessionStore.isTherapist ? const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: 'Practice'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Sessions'),
          NavigationDestination(icon: Icon(Icons.auto_awesome_outlined), selectedIcon: Icon(Icons.auto_awesome), label: 'Gratitude'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ] : const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.mood_outlined), selectedIcon: Icon(Icons.mood), label: 'Mood'),
          NavigationDestination(icon: Icon(Icons.people_outline), selectedIcon: Icon(Icons.people), label: 'Therapists'),
          NavigationDestination(icon: Icon(Icons.calendar_month_outlined), selectedIcon: Icon(Icons.calendar_month), label: 'Sessions'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
