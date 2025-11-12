import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_card.dart';
import '../controllers/auth_controller.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _websiteController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _showPassword = false;
  bool _rememberMe = false;
  String? _errorMessage;

  @override
  void dispose() {
    _websiteController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
      _errorMessage = null;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      setState(() {
        _errorMessage = 'يرجى تصحيح الحقول المظللة.';
      });
      return;
    }

    await _handleLogin();
  }

  Future<void> _handleLogin() async {
    final auth = context.read<AuthController>();
    setState(() => _errorMessage = null);

    final success = await auth.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      website: _websiteController.text.trim(),
    );

    if (!mounted) return;

    if (!success) {
      setState(() {
        _errorMessage = 'بيانات تسجيل الدخول غير صحيحة. يرجى المحاولة مرة أخرى.';
      });
    } else {
      FocusScope.of(context).unfocus();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم تسجيل الدخول بنجاح.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openForgotPassword() {
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const Directionality(
          textDirection: TextDirection.rtl,
          child: ForgotPasswordPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildBrand(),
                      const SizedBox(height: AppSpacing.xl),
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: _autovalidateMode,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تسجيل الدخول',
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                'ادخل بياناتك للوصول إلى لوحة التحكم',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(color: AppColors.mutedForeground),
                              ),
                              const SizedBox(height: AppSpacing.xl),
                              if (_errorMessage != null)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(AppSpacing.md),
                                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                                  decoration: BoxDecoration(
                                    color: AppColors.danger.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(AppRadius.md),
                                    border: Border.all(color: AppColors.danger.withOpacity(0.2)),
                                  ),
                                  child: Text(
                                    _errorMessage!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: AppColors.danger,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              _buildInputField(
                                controller: _websiteController,
                                label: 'رابط الموقع',
                                hint: 'https://mystore.com',
                                icon: Icons.public,
                                enabled: !auth.isLoading,
                                autofillHints: const [AutofillHints.url],
                                validator: (value) {
                                  final trimmed = value?.trim() ?? '';
                                  if (trimmed.isEmpty) {
                                    return 'يرجى إدخال رابط المتجر.';
                                  }
                                  final uri = Uri.tryParse(trimmed);
                                  if (uri == null || (!uri.isScheme('https') && !uri.isScheme('http'))) {
                                    return 'يرجى إدخال رابط صحيح يبدأ بـ https://';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              _buildInputField(
                                controller: _usernameController,
                                label: 'اسم المستخدم',
                                hint: 'أدخل اسم المستخدم',
                                icon: Icons.person_outline,
                                enabled: !auth.isLoading,
                                autofillHints: const [AutofillHints.username],
                                validator: (value) {
                                  final trimmed = value?.trim() ?? '';
                                  if (trimmed.isEmpty) {
                                    return 'اسم المستخدم مطلوب.';
                                  }
                                  if (trimmed.length < 3) {
                                    return 'يجب أن يحتوي اسم المستخدم على 3 أحرف على الأقل.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              _buildInputField(
                                controller: _passwordController,
                                label: 'كلمة المرور',
                                hint: 'أدخل كلمة المرور',
                                icon: Icons.lock_outline,
                                enabled: !auth.isLoading,
                                obscureText: !_showPassword,
                                textInputAction: TextInputAction.done,
                                enableSuggestions: false,
                                autofillHints: const [AutofillHints.password],
                                onFieldSubmitted: (_) => _submitLogin(),
                                suffix: IconButton(
                                  onPressed: () => setState(() => _showPassword = !_showPassword),
                                  icon: Icon(
                                    _showPassword ? Icons.visibility_off : Icons.visibility,
                                    color: Colors.white54,
                                  ),
                                ),
                                validator: (value) {
                                  final trimmed = value ?? '';
                                  if (trimmed.isEmpty) {
                                    return 'كلمة المرور مطلوبة.';
                                  }
                                  if (trimmed.length < 6) {
                                    return 'يجب أن تحتوي كلمة المرور على 6 أحرف على الأقل.';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: AppSpacing.md),
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    activeColor: AppColors.primary,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    onChanged: auth.isLoading
                                        ? null
                                        : (value) {
                                            setState(() => _rememberMe = value ?? false);
                                          },
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  const Text('تذكرني'),
                                  const Spacer(),
                                  Flexible(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(0, 0),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        onPressed: auth.isLoading ? null : _openForgotPassword,
                                        child: const Text('نسيت كلمة المرور؟'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: auth.isLoading ? null : _submitLogin,
                                  child: auth.isLoading
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Text('تسجيل الدخول'),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.lg),
                              Divider(color: AppColors.border.withOpacity(0.6)),
                              const SizedBox(height: AppSpacing.md),
                              _buildSecurityNotice(context),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _buildFooter(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF1D4ED8),
                Color(0xFF4338CA),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: const Icon(
            Icons.storefront,
            color: Colors.white,
            size: 36,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const Text(
          'انمكا',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'إدارة المتجر الإلكتروني',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    bool enabled = true,
    Widget? suffix,
    String? Function(String?)? validator,
    TextInputAction textInputAction = TextInputAction.next,
    Iterable<String>? autofillHints,
    bool enableSuggestions = true,
    void Function(String)? onFieldSubmitted,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          enabled: enabled,
          textInputAction: textInputAction,
          autofillHints: autofillHints,
          enableSuggestions: enableSuggestions,
          onFieldSubmitted: onFieldSubmitted,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.white54),
            suffixIcon: suffix,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildSecurityNotice(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.success),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              'جميع البيانات محمية بتشفير SSL. لن نشارك معلوماتك مع أي طرف ثالث.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white54,
        );

    return Column(
      children: [
        Text('© 2024 انمكا. جميع الحقوق محفوظة.', style: textStyle),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: AppSpacing.md,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text('الشروط والأحكام'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('سياسة الخصوصية'),
            ),
          ],
        ),
      ],
    );
  }
}

