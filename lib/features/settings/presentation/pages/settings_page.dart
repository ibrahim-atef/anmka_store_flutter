import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/request/invite_team_member_request.dart';
import '../../data/models/request/update_notification_settings_request.dart';
import '../../data/models/request/update_store_settings_request.dart';
import '../../data/models/response/team_member_response.dart';
import '../../logic/cubit/settings_cubit.dart';
import '../../logic/states/settings_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _storeNameController = TextEditingController();
  final _storeCategoryController = TextEditingController();
  final _storeUrlController = TextEditingController();

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeCategoryController.dispose();
    _storeUrlController.dispose();
    super.dispose();
  }

  Future<void> _showInviteDialog(
      BuildContext context, SettingsCubit cubit) async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedRole = 'manager';
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: const Text('دعوة عضو جديد'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'اسم العضو'),
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'الاسم مطلوب'
                        : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: emailController,
                    decoration:
                        const InputDecoration(labelText: 'البريد الإلكتروني'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      final trimmed = value?.trim() ?? '';
                      if (trimmed.isEmpty) return 'البريد مطلوب';
                      final emailRegex =
                          RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                      return emailRegex.hasMatch(trimmed)
                          ? null
                          : 'صيغة البريد غير صحيحة';
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: selectedRole,
                    decoration: const InputDecoration(labelText: 'الدور'),
                    items: const [
                      DropdownMenuItem(value: 'manager', child: Text('مدير')),
                      DropdownMenuItem(
                          value: 'support', child: Text('دعم العملاء')),
                      DropdownMenuItem(value: 'staff', child: Text('موظف')),
                    ],
                    onChanged: (value) => selectedRole = value ?? 'manager',
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('إلغاء'),
              ),
              FilledButton(
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    Navigator.of(ctx).pop(true);
                  }
                },
                child: const Text('إرسال الدعوة'),
              ),
            ],
          ),
        );
      },
    );

    if (result == true) {
      if (!mounted) return;
      final request = InviteTeamMemberRequest(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        role: selectedRole,
      );
      cubit.inviteTeamMember(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        state.whenOrNull(
          loaded: (storeSettings, notificationSettings, team) {
            // Update controllers when data is loaded
            if (_storeNameController.text.isEmpty) {
              _storeNameController.text = storeSettings.storeName;
              _storeCategoryController.text = storeSettings.storeCategory ?? '';
              _storeUrlController.text = storeSettings.storeUrl ?? '';
            }
          },
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
              const SectionHeader(
                title: 'الإعدادات',
                subtitle: 'إدارة إعدادات المتجر والحساب',
              ),
              const SizedBox(height: AppSpacing.lg),
              state.when(
                initial: () => const Center(child: CircularProgressIndicator()),
                loading: () => const Center(child: CircularProgressIndicator()),
                loaded: (storeSettings, notificationSettings, team) {
                  return Column(
                    children: [
                      // Store Settings
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionHeader(
                              title: 'إعدادات المتجر',
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextFormField(
                              controller: _storeNameController,
                              decoration: const InputDecoration(
                                  labelText: 'اسم المتجر'),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextFormField(
                              controller: _storeCategoryController,
                              decoration: const InputDecoration(
                                  labelText: 'مجال المتجر'),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextFormField(
                              controller: _storeUrlController,
                              decoration: const InputDecoration(
                                  labelText: 'رابط المتجر'),
                              keyboardType: TextInputType.url,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            FilledButton(
                              onPressed: () {
                                final request = UpdateStoreSettingsRequest(
                                  storeName: _storeNameController.text.trim(),
                                  storeCategory:
                                      _storeCategoryController.text.trim(),
                                  storeUrl: _storeUrlController.text.trim(),
                                );
                                context
                                    .read<SettingsCubit>()
                                    .updateStoreSettings(request);
                              },
                              child: const Text('حفظ التعديلات'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Notification Settings
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionHeader(title: 'إعدادات التنبيهات'),
                            SwitchListTile(
                              value: notificationSettings.notificationsEnabled,
                              onChanged: (value) {
                                context
                                    .read<SettingsCubit>()
                                    .updateNotificationSettings(
                                      UpdateNotificationSettingsRequest(
                                        notificationsEnabled: value,
                                      ),
                                    );
                              },
                              activeThumbColor: AppColors.primary,
                              title: const Text('تفعيل التنبيهات'),
                              subtitle: const Text(
                                  'الحصول على إشعارات حول الطلبات والمخزون'),
                            ),
                            SwitchListTile(
                              value: notificationSettings.twoFactorEnabled,
                              onChanged: (value) {
                                context
                                    .read<SettingsCubit>()
                                    .updateNotificationSettings(
                                      UpdateNotificationSettingsRequest(
                                        twoFactorEnabled: value,
                                      ),
                                    );
                              },
                              activeThumbColor: AppColors.primary,
                              title: const Text('تفعيل التحقق بخطوتين'),
                              subtitle: const Text(
                                  'زيادة أمان الحساب عبر رسالة نصية'),
                            ),
                            SwitchListTile(
                              value: notificationSettings.autoSyncEnabled,
                              onChanged: (value) {
                                context
                                    .read<SettingsCubit>()
                                    .updateNotificationSettings(
                                      UpdateNotificationSettingsRequest(
                                        autoSyncEnabled: value,
                                      ),
                                    );
                              },
                              activeThumbColor: AppColors.primary,
                              title: const Text('مزامنة المخزون تلقائياً'),
                              subtitle:
                                  const Text('تحديث كميات المخزون كل ساعة'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      // Team Management
                      AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionHeader(title: 'إدارة الفريق'),
                            const SizedBox(height: AppSpacing.md),
                            if (team.members.isEmpty)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(AppSpacing.xl),
                                  child: Text(
                                    'لا يوجد أعضاء في الفريق',
                                    style: TextStyle(
                                      color: AppColors.mutedForeground,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              )
                            else
                              for (final member in team.members) ...[
                                _TeamMemberTile(
                                  member: member,
                                  onResetPassword: () {
                                    context
                                        .read<SettingsCubit>()
                                        .resetTeamPassword(
                                            int.parse(member.id));
                                  },
                                ),
                                if (member != team.members.last)
                                  Divider(
                                      color: AppColors.border.withOpacity(0.7)),
                              ],
                            const SizedBox(height: AppSpacing.md),
                            OutlinedButton.icon(
                              onPressed: () => _showInviteDialog(
                                context,
                                context.read<SettingsCubit>(),
                              ),
                              icon: const Icon(Icons.person_add_alt),
                              label: const Text('دعوة عضو جديد'),
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _TeamMemberTile extends StatelessWidget {
  const _TeamMemberTile({
    required this.member,
    required this.onResetPassword,
  });

  final TeamMemberResponse member;
  final VoidCallback onResetPassword;

  IconData _getAvatarIcon(String role) {
    return switch (role.toLowerCase()) {
      'manager' || 'مدير' => Icons.manage_accounts,
      'support' || 'دعم' => Icons.headset_mic_outlined,
      _ => Icons.person_outline,
    };
  }

  String _getRoleLabel(String role) {
    return switch (role.toLowerCase()) {
      'manager' => 'مدير المتجر',
      'support' => 'دعم العملاء',
      'staff' => 'موظف',
      _ => role,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.surfaceSecondary,
        child: Icon(_getAvatarIcon(member.role), color: Colors.white),
      ),
      title: Text(member.name,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getRoleLabel(member.role),
            style:
                const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
          ),
          Text(
            member.email,
            style:
                const TextStyle(color: AppColors.mutedForeground, fontSize: 12),
          ),
        ],
      ),
      trailing: IconButton(
        onPressed: onResetPassword,
        tooltip: 'إعادة تعيين كلمة المرور',
        icon: const Icon(Icons.refresh_outlined),
      ),
    );
  }
}
