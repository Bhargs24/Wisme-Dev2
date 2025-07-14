import 'package:flutter/material.dart';
import '../../shared/shared.dart';

/// Settings Screen
/// User preferences, account management, app settings
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _offlineDownloads = false;
  bool _autoPlay = true;
  String _preferredCoach = 'Both';
  double _playbackSpeed = 1.0;
  String _audioQuality = 'High';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      backgroundColor: Colors.grey.shade50,
      body: ListView(
        children: [
          _buildAccountSection(),
          _buildAudioSection(),
          _buildLearningSection(),
          _buildNotificationSection(),
          _buildDataSection(),
          _buildAboutSection(),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      title: 'Account',
      children: [
        _buildListTile(
          icon: Icons.person,
          title: 'Edit Profile',
          subtitle: 'Update your personal information',
          onTap: () => _showComingSoon(),
        ),
        _buildListTile(
          icon: Icons.subscriptions,
          title: 'Subscription',
          subtitle: 'Manage your Wisme Pro subscription',
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'PRO',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          onTap: () => _showComingSoon(),
        ),
        _buildListTile(
          icon: Icons.credit_card,
          title: 'Payment Methods',
          subtitle: 'Manage billing and payment options',
          onTap: () => _showComingSoon(),
        ),
      ],
    );
  }

  Widget _buildAudioSection() {
    return _buildSection(
      title: 'Audio',
      children: [
        _buildDropdownTile(
          icon: Icons.person_2,
          title: 'Preferred Coach',
          subtitle: 'Default coach for new episodes',
          value: _preferredCoach,
          items: ['Kai', 'Vee', 'Both'],
          onChanged: (value) => setState(() => _preferredCoach = value!),
        ),
        _buildSliderTile(
          icon: Icons.speed,
          title: 'Default Playback Speed',
          subtitle: '${_playbackSpeed}x speed',
          value: _playbackSpeed,
          min: 0.5,
          max: 3.0,
          divisions: 10,
          onChanged: (value) => setState(() => _playbackSpeed = value),
        ),
        _buildDropdownTile(
          icon: Icons.high_quality,
          title: 'Audio Quality',
          subtitle: 'Higher quality uses more data',
          value: _audioQuality,
          items: ['Low', 'Medium', 'High', 'Lossless'],
          onChanged: (value) => setState(() => _audioQuality = value!),
        ),
        _buildSwitchTile(
          icon: Icons.play_arrow,
          title: 'Auto-play Next Episode',
          subtitle: 'Automatically start next episode in journey',
          value: _autoPlay,
          onChanged: (value) => setState(() => _autoPlay = value),
        ),
      ],
    );
  }

  Widget _buildLearningSection() {
    return _buildSection(
      title: 'Learning',
      children: [
        _buildListTile(
          icon: Icons.interests,
          title: 'Learning Interests',
          subtitle: 'Update your topic preferences',
          onTap: () => _showComingSoon(),
        ),
        _buildListTile(
          icon: Icons.schedule,
          title: 'Learning Schedule',
          subtitle: 'Set daily learning reminders',
          onTap: () => _showComingSoon(),
        ),
        _buildListTile(
          icon: Icons.trending_up,
          title: 'Learning Goals',
          subtitle: 'Set and track learning objectives',
          onTap: () => _showComingSoon(),
        ),
        _buildSwitchTile(
          icon: Icons.download,
          title: 'Offline Downloads',
          subtitle: 'Download episodes for offline listening',
          value: _offlineDownloads,
          onChanged: (value) => setState(() => _offlineDownloads = value),
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return _buildSection(
      title: 'Notifications',
      children: [
        _buildSwitchTile(
          icon: Icons.notifications,
          title: 'Push Notifications',
          subtitle: 'Get notified about new content and reminders',
          value: _notificationsEnabled,
          onChanged: (value) => setState(() => _notificationsEnabled = value),
        ),
        _buildListTile(
          icon: Icons.notification_important,
          title: 'Notification Preferences',
          subtitle: 'Customize what notifications you receive',
          onTap: () => _showComingSoon(),
        ),
      ],
    );
  }

  Widget _buildDataSection() {
    return _buildSection(
      title: 'Data & Storage',
      children: [
        _buildListTile(
          icon: Icons.storage,
          title: 'Storage Usage',
          subtitle: 'Manage downloaded content and cache',
          trailing: const Text('2.4 GB', style: TextStyle(color: Colors.grey)),
          onTap: () => _showStorageDialog(),
        ),
        _buildListTile(
          icon: Icons.sync,
          title: 'Sync Data',
          subtitle: 'Sync your learning progress across devices',
          onTap: () => _showComingSoon(),
        ),
        _buildListTile(
          icon: Icons.backup,
          title: 'Backup Settings',
          subtitle: 'Backup your preferences and progress',
          onTap: () => _showComingSoon(),
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return _buildSection(
      title: 'About',
      children: [
        _buildListTile(
          icon: Icons.help,
          title: 'Help & Support',
          subtitle: 'FAQs, tutorials, and contact support',
          onTap: () => _showComingSoon(),
        ),
        _buildListTile(
          icon: Icons.privacy_tip,
          title: 'Privacy Policy',
          subtitle: 'How we protect your data',
          onTap: () => _showComingSoon(),
        ),
        _buildListTile(
          icon: Icons.description,
          title: 'Terms of Service',
          subtitle: 'Legal terms and conditions',
          onTap: () => _showComingSoon(),
        ),
        _buildListTile(
          icon: Icons.info,
          title: 'About Wisme',
          subtitle: 'Version 1.0.0 • AI-Powered Learning',
          onTap: () => _showAboutDialog(),
        ),
        _buildListTile(
          icon: Icons.logout,
          title: 'Sign Out',
          subtitle: 'Sign out of your account',
          titleColor: Colors.red,
          onTap: () => _showSignOutDialog(),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
        ),
        ModernCard(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: titleColor,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF2196F3),
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle),
      trailing: DropdownButton<String>(
        value: value,
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item),
        )).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
      ),
    );
  }

  Widget _buildSliderTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required double value,
    required double min,
    required double max,
    int? divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey.shade600),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle: Text(subtitle),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
            activeColor: const Color(0xFF2196F3),
          ),
        ),
      ],
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showStorageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Usage'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Downloaded Episodes: 1.8 GB'),
            Text('Cache: 512 MB'),
            Text('User Data: 45 MB'),
            SizedBox(height: 16),
            Text('Total: 2.4 GB', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Clear Cache'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Wisme'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Wisme - AI-Powered Learning'),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text('Transform any topic into personalized audio learning experiences with our AI coaches Kai and Vee.'),
            SizedBox(height: 16),
            Text('© 2025 Wisme. All rights reserved.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle sign out
              Navigator.pop(context);
              _showComingSoon();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
