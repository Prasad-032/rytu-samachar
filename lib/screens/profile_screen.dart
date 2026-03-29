import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../services/language_provider.dart';
import '../services/notification_service.dart';
import 'auth_screen.dart';
import 'schemes_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  bool _editingName = false;
  late TextEditingController _nameController;
  bool _notificationsOn = true;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: user?.displayName ?? 'Farmer');
    _notificationsOn =
        NotificationService().notificationsEnabled;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    await user?.updateDisplayName(_nameController.text.trim());
    setState(() => _editingName = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name updated successfully!'),
          backgroundColor: Color(0xFF2E7D32),
        ),
      );
    }
  }

  void _logout() {
    final lang = context.read<LanguageProvider>();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(lang.t('Logout', 'లాగ్అవుట్')),
        content: Text(lang.t(
          'Are you sure you want to logout?',
          'మీరు లాగ్అవుట్ చేయాలనుకుంటున్నారా?',
        )),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(lang.t('Cancel', 'రద్దు చేయి')),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const AuthScreen()),
                  (_) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(lang.t('Logout', 'లాగ్అవుట్')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();
    final displayName =
        user?.displayName ?? user?.email?.split('@')[0] ?? 'Farmer';
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'F';

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('👤 Profile', '👤 ప్రొఫైల్')),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_editingName)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: _nameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Colors.white38)),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.white),
                          onPressed: _saveName,
                        ),
                      ],
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () => setState(() => _editingName = true),
                          child: const Icon(Icons.edit,
                              color: Colors.white70, size: 18),
                        ),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      lang.t('✅ Verified Farmer', '✅ ధృవీకరించబడిన రైతు'),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Settings section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionTitle(lang.t('Settings', 'సెట్టింగులు')),
                  _SettingsTile(
                    icon: Icons.language,
                    title: lang.t('Language', 'భాష'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('EN',
                            style: TextStyle(
                                fontWeight: !lang.isTelugu
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: !lang.isTelugu
                                    ? const Color(0xFF2E7D32)
                                    : Colors.grey)),
                        const SizedBox(width: 6),
                        Switch(
                          value: lang.isTelugu,
                          onChanged: (_) => lang.toggleLanguage(),
                          activeColor: const Color(0xFF2E7D32),
                        ),
                        const SizedBox(width: 6),
                        Text('తె',
                            style: TextStyle(
                                fontWeight: lang.isTelugu
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: lang.isTelugu
                                    ? const Color(0xFF2E7D32)
                                    : Colors.grey)),
                      ],
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.notifications,
                    title: lang.t('Notifications', 'నోటిఫికేషన్లు'),
                    trailing: Switch(
                      value: _notificationsOn,
                      activeColor: const Color(0xFF2E7D32),
                      onChanged: (v) {
                        setState(() => _notificationsOn = v);
                        NotificationService().toggleNotifications(v);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.notifications_active),
                      label: Text(lang.t(
                          'Test Notification', 'టెస్ట్ నోటిఫికేషన్')),
                      onPressed: () {
                        NotificationService().showNotification(
                          'Test Notification 🔔',
                          'Rytu Samachar notifications are working!',
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF2E7D32),
                        side: const BorderSide(color: Color(0xFF2E7D32)),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _SectionTitle(lang.t('More', 'మరిన్ని')),
                  _SettingsTile(
                    icon: Icons.account_balance,
                    title:
                        lang.t('Government Schemes', 'ప్రభుత్వ పథకాలు'),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChangeNotifierProvider.value(
                                value: lang,
                                child: const SchemesScreen(),
                              )),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: Text(lang.t('Logout', 'లాగ్అవుట్')),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF2E7D32),
          fontWeight: FontWeight.bold,
          fontSize: 13,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2E7D32)),
        title: Text(title),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
