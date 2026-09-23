import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const coral = Color(0xFFF2645A);
const navy = Color(0xFF1E2233);
const softPink = Color(0xFFFFE8E6);
const softBlue = Color(0xFFE8F0FE);

void main() => runApp(const HearteliApp());

class HearteliApp extends StatelessWidget {
  const HearteliApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Hearteli', debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true, fontFamily: 'Nunito', scaffoldBackgroundColor: const Color(0xFFFAFCFF),
      colorScheme: ColorScheme.fromSeed(seedColor: coral, primary: coral),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFFAFCFF), foregroundColor: navy, centerTitle: false),
      filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(backgroundColor: coral, foregroundColor: Colors.white, minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))))),
    home: const HearteliHome(),
  );
}

class Api {
  // Supply your deployed HTTPS origin at build time; never embed credentials.
  static const origin = String.fromEnvironment('HEARTELI_API_URL', defaultValue: 'http://localhost:8000');
  static String? token;
  static Future<dynamic> request(String path, {String method = 'GET', Map<String, dynamic>? body}) async {
    final response = await http.Request(method, Uri.parse('$origin$path'));
    response.headers['Content-Type'] = 'application/json';
    if (token != null) response.headers['Authorization'] = 'Token $token';
    if (body != null) response.body = jsonEncode(body);
    final streamed = await response.send();
    final content = await http.Response.fromStream(streamed);
    final data = content.body.isEmpty ? null : jsonDecode(content.body);
    if (content.statusCode >= 400) throw Exception(data is Map ? data.values.join(' ') : 'Request failed');
    return data;
  }
}

class HearteliHome extends StatefulWidget {
  const HearteliHome({super.key});
  @override
  State<HearteliHome> createState() => _HearteliHomeState();
}
class _HearteliHomeState extends State<HearteliHome> {
  int page = 0;
  bool ready = false;
  @override
  void initState() { super.initState(); SharedPreferences.getInstance().then((p) { if (mounted) setState(() { Api.token = p.getString('token'); ready = true; }); }); }
  @override
  Widget build(BuildContext context) {
    if (!ready) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (Api.token == null) return LoginPage(onLogin: () => setState(() {}));
    const titles = ['Home', 'Your Circle', 'Check-In', 'Insights', 'More'];
    return Scaffold(
      appBar: AppBar(title: Text(titles[page], style: const TextStyle(fontWeight: FontWeight.bold))),
      body: SafeArea(child: IndexedStack(index: page, children: [
        HomePage(go: (i) => setState(() => page = i)), const CirclePage(), CheckInPage(go: (i) => setState(() => page = i)), const InsightsPage(), MorePage(logout: () async { final p = await SharedPreferences.getInstance(); await p.remove('token'); setState(() => Api.token = null); }),
      ])),
      bottomNavigationBar: NavigationBar(selectedIndex: page, onDestinationSelected: (i) => setState(() => page = i), destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.people_outline), label: 'Circle'),
        NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Check-In'),
        NavigationDestination(icon: Icon(Icons.insights_outlined), label: 'Insights'),
        NavigationDestination(icon: Icon(Icons.more_horiz), label: 'More'),
      ]),
    );
  }
}

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;
  const LoginPage({super.key, required this.onLogin});
  @override State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController(), password = TextEditingController();
  bool loading = false, signup = false;
  String? error;
  @override void dispose() { email.dispose(); password.dispose(); super.dispose(); }
  Future<void> submit() async {
    setState(() { loading = true; error = null; });
    try {
      if (signup) { setState(() => error = 'Account creation is available through the existing signup API. Please sign in after registering.'); return; }
      final result = await Api.request('/api/login/', method: 'POST', body: {'email': email.text.trim(), 'password': password.text});
      Api.token = result['token'] as String;
      (await SharedPreferences.getInstance()).setString('token', Api.token!);
      widget.onLogin();
    } catch (e) { setState(() => error = e.toString()); }
    finally { if (mounted) setState(() => loading = false); }
  }
  @override Widget build(BuildContext context) => Scaffold(body: SafeArea(child: ListView(padding: const EdgeInsets.all(28), children: [
    const SizedBox(height: 60), Image.asset('assets/brand/hearteli_master_logo_transparent.png', height: 90), const SizedBox(height: 42),
    const Text('Know when to be there.', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: navy)),
    const SizedBox(height: 10), const Text('A kinder way to check in, show you care, and support when it matters.'), const SizedBox(height: 32),
    TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email address', border: OutlineInputBorder())),
    const SizedBox(height: 14), TextField(controller: password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
    if (error != null) Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(error!, style: const TextStyle(color: Colors.red))),
    const SizedBox(height: 22), FilledButton(onPressed: loading ? null : submit, child: Text(loading ? 'Please wait…' : 'Sign in')),
    const SizedBox(height: 24), const Text('Your feelings stay private until you choose to share.', textAlign: TextAlign.center),
  ])));
}

class HomePage extends StatelessWidget {
  final ValueChanged<int> go;
  const HomePage({super.key, required this.go});
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(22), children: [
    Image.asset('assets/brand/hearteli_master_logo_transparent.png', height: 55, alignment: Alignment.centerLeft), const SizedBox(height: 30),
    const Text('How are you feeling today?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: navy)),
    const SizedBox(height: 8), const Text('It’s okay to have good days and tough days.'), const SizedBox(height: 24),
    _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Icon(Icons.favorite_outline, color: coral, size: 34), const SizedBox(height: 12), const Text('A small check-in can make a big difference.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), const SizedBox(height: 18), FilledButton(onPressed: () => go(2), child: const Text('Check in now'))])),
    const SizedBox(height: 16), OutlinedButton.icon(onPressed: () => go(1), icon: const Icon(Icons.people_outline), label: const Text('See your Circle')),
    const SizedBox(height: 22), const Text('You decide who can know. Every share requires your approval.', style: TextStyle(color: navy)),
  ]);
}
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(20), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(22), border: Border.all(color: softPink)), child: child);
}

class CheckInPage extends StatefulWidget {
  final ValueChanged<int> go;
  const CheckInPage({super.key, required this.go});
  @override State<CheckInPage> createState() => _CheckInPageState();
}
class _CheckInPageState extends State<CheckInPage> {
  List<dynamic> moods = [];
  int? moodId;
  int? lastCheckIn;
  bool busy = false;
  String? error;
  final note = TextEditingController();
  @override void initState() { super.initState(); load(); }
  @override void dispose() { note.dispose(); super.dispose(); }
  Future<void> load() async { try { final r = await Api.request('/api/tracking/moods/'); if (mounted) setState(() => moods = r is List ? r : (r['results'] ?? [])); } catch (e) { if (mounted) setState(() => error = e.toString()); } }
  Future<void> save() async {
    if (moodId == null) return;
    setState(() { busy = true; error = null; });
    try {
      final r = await Api.request('/api/tracking/mood-check-ins/', method: 'POST', body: {'mood_ids': [moodId], 'notes': note.text.trim()});
      if (mounted) setState(() => lastCheckIn = r['id'] as int);
    } catch (e) { if (mounted) setState(() => error = e.toString()); }
    finally { if (mounted) setState(() => busy = false); }
  }
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(22), children: [
    const Text('How are you feeling today?', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: navy)),
    const SizedBox(height: 8), const Text('Only you can see this check-in unless you choose to share.'), const SizedBox(height: 22),
    if (moods.isEmpty) const Text('No feelings are available yet. Ask your administrator to add mood options.'),
    Wrap(spacing: 10, runSpacing: 10, children: moods.map((m) => ChoiceChip(label: Text('${m['name']}'), selected: moodId == m['id'], onSelected: (_) => setState(() => moodId = m['id'] as int))).toList()),
    const SizedBox(height: 26), TextField(controller: note, maxLines: 3, maxLength: 500, decoration: const InputDecoration(labelText: 'Add context (optional)', border: OutlineInputBorder())),
    const SizedBox(height: 12), if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
    FilledButton(onPressed: moodId == null || busy ? null : save, child: const Text('Save privately')),
    if (lastCheckIn != null) ...[const SizedBox(height: 22), _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Your check-in is private.', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      const SizedBox(height: 8), const Text('Would it help to let a trusted person know? You choose the exact message.'),
      const SizedBox(height: 12), OutlinedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ComposeNudge(checkInId: lastCheckIn!))), child: const Text('Choose who can know')),
    ]))],
  ]);
}

class CirclePage extends StatefulWidget { const CirclePage({super.key}); @override State<CirclePage> createState() => _CirclePageState(); }
class _CirclePageState extends State<CirclePage> {
  List<dynamic> people = []; String? error;
  @override void initState() { super.initState(); load(); }
  Future<void> load() async { try { final r = await Api.request('/api/tracking/hearteli/circle/'); if (mounted) setState(() => people = r is List ? r : r['results'] ?? []); } catch (e) { if (mounted) setState(() => error = e.toString()); } }
  Future<void> invite() async {
    final email = TextEditingController();
    await showDialog(context: context, builder: (ctx) => AlertDialog(title: const Text('Add someone'), content: TextField(controller: email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Their Hearteli email')), actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')), TextButton(onPressed: () async { try { await Api.request('/api/tracking/hearteli/circle/', method: 'POST', body: {'recipient_email_input': email.text.trim()}); if (ctx.mounted) Navigator.pop(ctx); load(); } catch (e) { if (ctx.mounted) ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(e.toString()))); } }, child: const Text('Invite'))]));
    email.dispose();
  }
  Future<void> change(int id, Map<String, dynamic> data) async { try { await Api.request('/api/tracking/hearteli/circle/$id/', method: 'PATCH', body: data); load(); } catch (e) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()))); } }
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(22), children: [
    const Text('People who care about you.', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 12),
    if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
    for (final p in people) Padding(padding: const EdgeInsets.only(bottom: 10), child: _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('${p['recipient_name']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), Text('${p['relationship']} · ${p['accepted_at'] == null ? 'Pending invitation' : p['may_receive_nudges'] == true ? 'Nudges enabled' : 'Paused'}'),
      if (p['accepted_at'] == null) TextButton(onPressed: () => change(p['id'], {'accept': true, 'may_receive_nudges': true}), child: const Text('Accept if this invitation is for you')),
      if (p['accepted_at'] != null) SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Receive nudges'), value: p['may_receive_nudges'] == true, onChanged: (v) => change(p['id'], {'may_receive_nudges': v})),
    ]))),
    const SizedBox(height: 10), OutlinedButton.icon(onPressed: invite, icon: const Icon(Icons.person_add_alt), label: const Text('Add someone')),
    const Text('Both people must opt in before a nudge can be sent.'),
  ]);
}

class ComposeNudge extends StatefulWidget { final int checkInId; const ComposeNudge({super.key, required this.checkInId}); @override State<ComposeNudge> createState() => _ComposeNudgeState(); }
class _ComposeNudgeState extends State<ComposeNudge> {
  List<dynamic> people = []; int? recipient; String? error; bool busy = false;
  final message = TextEditingController(), preference = TextEditingController();
  @override void initState() { super.initState(); load(); }
  @override void dispose() { message.dispose(); preference.dispose(); super.dispose(); }
  Future<void> load() async { try { final r = await Api.request('/api/tracking/hearteli/circle/'); if (mounted) setState(() => people = (r is List ? r : r['results'] as List).where((p) => p['accepted_at'] != null && p['may_receive_nudges'] == true).toList()); } catch (e) { if (mounted) setState(() => error = e.toString()); } }
  Future<void> send() async {
    if (recipient == null || message.text.trim().isEmpty) return;
    final yes = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(title: const Text('Who can see this?'), content: Text('Only ${people.firstWhere((p) => p['recipient'] == recipient)['recipient_name']} will receive:\n\n“${message.text.trim()}”\n\nSupport preference: ${preference.text.trim().isEmpty ? 'None shared' : preference.text.trim()}\n\nYour private notes are not shared.'), actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Edit')), FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Send nudge'))]));
    if (yes != true) return;
    setState(() => busy = true);
    try { await Api.request('/api/tracking/hearteli/nudges/', method: 'POST', body: {'check_in': widget.checkInId, 'recipient': recipient, 'message': message.text.trim(), 'support_preference': preference.text.trim()}); if (mounted) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nudge saved as sent. Delivery is not yet confirmed.'))); Navigator.pop(context); } } catch (e) { if (mounted) setState(() => error = e.toString()); } finally { if (mounted) setState(() => busy = false); }
  }
  @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Empathy Nudge')), body: ListView(padding: const EdgeInsets.all(22), children: [
    const Text('Let someone know how to be there.', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)), const SizedBox(height: 20),
    DropdownButtonFormField<int>(value: recipient, decoration: const InputDecoration(labelText: 'Trusted person', border: OutlineInputBorder()), items: people.map<DropdownMenuItem<int>>((p) => DropdownMenuItem(value: p['recipient'] as int, child: Text('${p['recipient_name']}'))).toList(), onChanged: (v) => setState(() => recipient = v)),
    if (people.isEmpty) const Padding(padding: EdgeInsets.all(12), child: Text('No accepted Circle member has enabled nudges yet.')),
    const SizedBox(height: 18), TextField(controller: message, maxLength: 500, maxLines: 3, decoration: const InputDecoration(labelText: 'What would you like them to know?', border: OutlineInputBorder())),
    TextField(controller: preference, maxLength: 120, decoration: const InputDecoration(labelText: 'What would help? (optional)', border: OutlineInputBorder())),
    const SizedBox(height: 14), if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
    FilledButton(onPressed: busy ? null : send, child: const Text('Preview who can see this')),
  ]));
}

class InsightsPage extends StatefulWidget { const InsightsPage({super.key}); @override State<InsightsPage> createState() => _InsightsPageState(); }
class _InsightsPageState extends State<InsightsPage> {
  List<dynamic> history = []; String? error;
  @override void initState() { super.initState(); load(); }
  Future<void> load() async { try { final r = await Api.request('/api/tracking/mood-check-ins/'); if (mounted) setState(() => history = r is List ? r : r['results'] ?? []); } catch (e) { if (mounted) setState(() => error = e.toString()); } }
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(22), children: [
    const Text('Your check-ins', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)), const SizedBox(height: 8), const Text('A gentle look at your days. Only you see this history.'), const SizedBox(height: 20),
    if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
    if (history.isEmpty) const Text('Your history will appear after your first check-in.'),
    for (final h in history) Padding(padding: const EdgeInsets.only(bottom: 10), child: _Card(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('${h['date']}', style: const TextStyle(fontWeight: FontWeight.bold)), Text((h['moods'] as List).map((m) => m['name']).join(', ')), if ((h['notes'] ?? '').toString().isNotEmpty) const Text('Private note saved')]))),
  ]);
}
class MorePage extends StatelessWidget { final VoidCallback logout; const MorePage({super.key, required this.logout});
  @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(22), children: [
    Image.asset('assets/brand/hearteli_master_logo_transparent.png', height: 70), const SizedBox(height: 25),
    const _Card(child: Text('Your privacy matters. Check-ins stay private unless you deliberately share a nudge with one accepted person.')),
    const SizedBox(height: 18), const Text('Need immediate help? Contact local emergency services or someone you trust. Hearteli does not monitor emergencies.'),
    const SizedBox(height: 22), OutlinedButton(onPressed: logout, child: const Text('Sign out')),
  ]);
}
