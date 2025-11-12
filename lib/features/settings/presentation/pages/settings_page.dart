import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/section_header.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _twoFactorEnabled = false;
  bool _autoSyncEnabled = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const SectionHeader(
            title: 'الإعدادات',
            subtitle: 'إدارة إعدادات المتجر والحساب',
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(
                  title: 'إعدادات المتجر',
                ),
                const SizedBox(height: AppSpacing.md),
                _buildTextField(label: 'اسم المتجر', initialValue: 'انمكا'),
                const SizedBox(height: AppSpacing.md),
                _buildTextField(label: 'مجال المتجر', initialValue: 'الملابس والأزياء'),
                const SizedBox(height: AppSpacing.md),
                _buildTextField(label: 'رابط المتجر', initialValue: 'https://store.anmka.com'),
                const SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حفظ إعدادات المتجر (محاكاة).')),
                    );
                  },
                  child: const Text('حفظ التعديلات'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'إعدادات التنبيهات'),
                SwitchListTile(
                  value: _notificationsEnabled,
                  onChanged: (value) => setState(() => _notificationsEnabled = value),
                  activeColor: AppColors.primary,
                  title: const Text('تفعيل التنبيهات'),
                  subtitle: const Text('الحصول على إشعارات حول الطلبات والمخزون'),
                ),
                SwitchListTile(
                  value: _twoFactorEnabled,
                  onChanged: (value) => setState(() => _twoFactorEnabled = value),
                  activeColor: AppColors.primary,
                  title: const Text('تفعيل التحقق بخطوتين'),
                  subtitle: const Text('زيادة أمان الحساب عبر رسالة نصية'),
                ),
                SwitchListTile(
                  value: _autoSyncEnabled,
                  onChanged: (value) => setState(() => _autoSyncEnabled = value),
                  activeColor: AppColors.primary,
                  title: const Text('مزامنة المخزون تلقائياً'),
                  subtitle: const Text('تحديث كميات المخزون كل ساعة'),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'إدارة الفريق'),
                const SizedBox(height: AppSpacing.md),
                const _TeamMemberTile(
                  name: 'أحمد محمود',
                  role: 'مدير المتجر',
                  email: 'ahmed@anmka.com',
                  avatar: Icons.manage_accounts,
                ),
                Divider(color: AppColors.border.withOpacity(0.7)),
                const _TeamMemberTile(
                  name: 'سارة علي',
                  role: 'دعم العملاء',
                  email: 'support@anmka.com',
                  avatar: Icons.headset_mic_outlined,
                ),
                const SizedBox(height: AppSpacing.md),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('دعوة عضو فريق جديدة قيد التطوير')),
                    );
                  },
                  icon: const Icon(Icons.person_add_alt),
                  label: const Text('دعوة عضو جديد'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({required String label, required String initialValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          initialValue: initialValue,
          decoration: const InputDecoration(),
        ),
      ],
    );
  }
}

class _TeamMemberTile extends StatelessWidget {
  const _TeamMemberTile({
    required this.name,
    required this.role,
    required this.email,
    required this.avatar,
  });

  final String name;
  final String role;
  final String email;
  final IconData avatar;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.surfaceSecondary,
        child: Icon(avatar, color: Colors.white),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(role, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
          Text(email, style: const TextStyle(color: AppColors.mutedForeground, fontSize: 12)),
        ],
      ),
      trailing: IconButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم إرسال إعادة تعيين كلمة المرور إلى $name (محاكاة).')),
          );
        },
        icon: const Icon(Icons.refresh_outlined),
      ),
    );
  }
}

