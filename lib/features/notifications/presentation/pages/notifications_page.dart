import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/badge_chip.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/response/notification_response.dart';
import '../../logic/cubit/notifications_cubit.dart';
import '../../logic/states/notifications_state.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  BadgeTone _getToneFromString(String? tone) {
    if (tone == null) return BadgeTone.info;
    return switch (tone.toLowerCase()) {
      'success' => BadgeTone.success,
      'warning' => BadgeTone.warning,
      'danger' => BadgeTone.danger,
      _ => BadgeTone.info,
    };
  }

  String _formatTime(String timeString) {
    try {
      final date = DateTime.parse(timeString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inMinutes < 1) {
        return 'الآن';
      } else if (difference.inMinutes < 60) {
        return 'منذ ${difference.inMinutes} دقيقة';
      } else if (difference.inHours < 24) {
        return 'منذ ${difference.inHours} ساعة';
      } else if (difference.inDays < 7) {
        return 'منذ ${difference.inDays} يوم';
      } else {
        return intl.DateFormat('d MMMM yyyy', 'ar').format(date);
      }
    } catch (e) {
      return timeString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listener: (context, state) {
        state.whenOrNull(
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
        );
      },
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              SectionHeader(
                title: 'مركز الإشعارات',
                subtitle: 'تابع كل التحديثات المهمة في متجرك',
                trailing: state.maybeWhen(
                  loaded: (notificationsList) {
                    if (notificationsList.unreadCount > 0) {
                      return TextButton.icon(
                        onPressed: () {
                          context
                              .read<NotificationsCubit>()
                              .markAllNotificationsAsRead();
                        },
                        icon: const Icon(Icons.done_all),
                        label: const Text('تعليم الكل كمقروء'),
                      );
                    }
                    return null;
                  },
                  orElse: () => null,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              state.when(
                initial: () => const Center(child: CircularProgressIndicator()),
                loading: () => const Center(child: CircularProgressIndicator()),
                loaded: (notificationsList) {
                  if (notificationsList.notifications.isEmpty) {
                    return const AppCard(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.xl),
                          child: Text(
                            'لا توجد إشعارات',
                            style: TextStyle(
                              color: AppColors.mutedForeground,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  return AppCard(
                    child: Column(
                      children: [
                        for (final notification
                            in notificationsList.notifications) ...[
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notification.title,
                                    style: TextStyle(
                                      fontWeight: notification.isRead
                                          ? FontWeight.normal
                                          : FontWeight.w700,
                                    ),
                                  ),
                                ),
                                BadgeChip(
                                  label: notification.category,
                                  tone: _getToneFromString(notification.tone),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  notification.description,
                                  style: TextStyle(
                                    color: AppColors.mutedForeground,
                                    fontWeight: notification.isRead
                                        ? FontWeight.normal
                                        : FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  _formatTime(notification.time),
                                  style: const TextStyle(
                                    color: AppColors.mutedForeground,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              onPressed: notification.isRead
                                  ? null
                                  : () {
                                      context
                                          .read<NotificationsCubit>()
                                          .markNotificationAsRead(
                                              int.parse(notification.id));
                                    },
                              icon: Icon(
                                notification.isRead
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                color: notification.isRead
                                    ? AppColors.primary
                                    : AppColors.mutedForeground,
                              ),
                            ),
                          ),
                          if (notification !=
                              notificationsList.notifications.last)
                            Divider(color: AppColors.border.withOpacity(0.7)),
                        ],
                      ],
                    ),
                  );
                },
                error: (message) => AppCard(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: AppColors.danger),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            message,
                            style: const TextStyle(color: AppColors.danger),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
