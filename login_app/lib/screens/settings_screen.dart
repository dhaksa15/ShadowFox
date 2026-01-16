import 'package:flutter/material.dart';
import '../core/design_system.dart';
import '../widgets/logout_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _emailUpdates = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text('⚙️ '), Text('Settings')],
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: LogoutButton(
              backgroundColor: Colors.transparent,
              iconColor: isDark ? AppColors.white : AppColors.primary,
            ),
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          _buildSection('Preferences', [
            _buildSwitchTile(
              'Push Notifications',
              'Get alerts about new pets',
              _notificationsEnabled,
              (value) {
                setState(() => _notificationsEnabled = value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? '🔔 Notifications enabled!'
                          : '🔕 Notifications disabled',
                    ),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              Icons.notifications_outlined,
            ),
            _buildSwitchTile(
              'Email Updates',
              'Receive weekly pet updates',
              _emailUpdates,
              (value) {
                setState(() => _emailUpdates = value);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      value
                          ? '📧 Email updates enabled!'
                          : '📧 Email updates disabled',
                    ),
                    backgroundColor: AppColors.info,
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              Icons.email_outlined,
            ),
            _buildSwitchTile('Dark Mode', 'Use dark theme', _darkMode, (value) {
              setState(() => _darkMode = value);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    value ? '🌙 Dark mode enabled!' : '☀️ Light mode enabled',
                  ),
                  backgroundColor: AppColors.secondary,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            }, Icons.dark_mode_outlined),
          ]),
          const SizedBox(height: 24),
          _buildSection('Account', [
            _buildTile(
              'Change Password',
              'Update your password',
              Icons.lock_outline,
              () => _showPasswordDialog(context),
            ),
            _buildTile(
              'Privacy Settings',
              'Manage your privacy',
              Icons.privacy_tip_outlined,
              () => _showPrivacySettings(context),
            ),
          ]),
          const SizedBox(height: 24),
          _buildSection('About', [
            _buildTile(
              'Terms of Service',
              'Read our terms',
              Icons.description_outlined,
              () => _showTerms(context),
            ),
            _buildTile(
              'Privacy Policy',
              'How we protect your data',
              Icons.shield_outlined,
              () => _showPrivacyPolicy(context),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.grey500,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...children,
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        boxShadow: AppShadows.small,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTile(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        boxShadow: AppShadows.small,
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
          child: Icon(icon, color: AppColors.secondary),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          title: const Row(
            children: [Text('🔒'), SizedBox(width: 8), Text('Change Password')],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Current Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Text('✅'),
                        SizedBox(width: 8),
                        Expanded(child: Text('Password updated successfully!')),
                      ],
                    ),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacySettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.surfaceDark
                : AppColors.white,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppBorderRadius.xxl),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Text('🔐', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 12),
                  Text('Privacy Settings', style: AppTextStyles.h5),
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.visibility_off),
                title: const Text('Profile Visibility'),
                subtitle: const Text('Public'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.location_off),
                title: const Text('Location Sharing'),
                subtitle: const Text('Enabled'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text('Blocked Users'),
                subtitle: const Text('0 users'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showTerms(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          title: const Text('Terms of Service'),
          content: const SingleChildScrollView(
            child: Text(
              'Welcome to PawPal!\n\n'
              '1. By using PawPal, you agree to help pets find loving homes.\n\n'
              '2. All pet information is provided by verified shelters.\n\n'
              '3. Adoption processes follow local regulations.\n\n'
              '4. Users must be 18+ to adopt pets.\n\n'
              '5. PawPal connects adopters with shelters but does not handle transactions.\n\n'
              'Thank you for being part of our community! 🐾',
              style: AppTextStyles.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          ),
          title: const Text('Privacy Policy'),
          content: const SingleChildScrollView(
            child: Text(
              'Your Privacy Matters\n\n'
              '• We collect minimal personal information\n'
              '• Your data is encrypted and secure\n'
              '• We never sell your information\n'
              '• You can delete your account anytime\n'
              '• Shelter communications are private\n'
              '• Location data is optional\n\n'
              'We\'re committed to protecting your privacy while helping you find your perfect pet! 🔒',
              style: AppTextStyles.bodyMedium,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
