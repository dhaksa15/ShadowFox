import 'package:flutter/material.dart';
import '../core/design_system.dart';
import '../widgets/logout_button.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final notifications = [
      {
        'title': 'New Pet Available! 🐶',
        'message': 'Max, a Golden Retriever, is looking for a home',
        'time': '5 min ago',
        'icon': Icons.pets,
        'color': AppColors.primary,
      },
      {
        'title': 'Adoption Request Update',
        'message': 'Your request for Luna has been approved!',
        'time': '1 hour ago',
        'icon': Icons.check_circle,
        'color': AppColors.success,
      },
      {
        'title': 'Shelter Visit Reminder 📅',
        'message': 'Don\'t forget your visit tomorrow at 2 PM',
        'time': '3 hours ago',
        'icon': Icons.event,
        'color': AppColors.warning,
      },
      {
        'title': 'New Message',
        'message': 'Happy Paws Shelter sent you a message',
        'time': '1 day ago',
        'icon': Icons.message,
        'color': AppColors.info,
      },
    ];

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [Text('🔔 '), Text('Notifications')],
        ),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.white,
        actions: [
          TextButton(onPressed: () {}, child: const Text('Mark all read')),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: LogoutButton(
              backgroundColor: Colors.transparent,
              iconColor: isDark ? AppColors.white : AppColors.primary,
            ),
          ),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🔕', style: TextStyle(fontSize: 60)),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications',
                    style: AppTextStyles.h5.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'re all caught up!',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.white,
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                    boxShadow: AppShadows.small,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (notification['color'] as Color).withValues(
                          alpha: 0.15,
                        ),
                        borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                      ),
                      child: Icon(
                        notification['icon'] as IconData,
                        color: notification['color'] as Color,
                      ),
                    ),
                    title: Text(
                      notification['title'] as String,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          notification['message'] as String,
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification['time'] as String,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
