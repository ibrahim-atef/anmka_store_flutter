import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/navigation_controller.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/widgets/welcome_overlay.dart';
import '../../../customers/presentation/pages/customers_page.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../orders/presentation/pages/add_order_page.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../../../products/presentation/pages/add_product_page.dart';
import '../../../products/presentation/pages/products_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../shipping/presentation/pages/shipping_page.dart';
import '../../../coupons/presentation/pages/coupons_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    if (auth.isLoading && !auth.isAuthenticated) {
      return const Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (!auth.isAuthenticated) {
      return const Directionality(
        textDirection: TextDirection.rtl,
        child: LoginPage(),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        children: [
          const _AuthenticatedHome(),
          if (!auth.hasSeenWelcome)
            WelcomeOverlay(
              userName: auth.displayName,
              onContinue: () => auth.markWelcomeSeen(),
            ),
        ],
      ),
    );
  }
}

class _AuthenticatedHome extends StatelessWidget {
  const _AuthenticatedHome();

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationController>();
    final auth = context.watch<AuthController>();

    Widget body;
    switch (nav.currentTab) {
      case AppTab.dashboard:
        body = DashboardPage(userName: auth.displayName);
      case AppTab.products:
        body = ProductsPage(
          onAddProduct: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (routeContext) => Directionality(
                  textDirection: TextDirection.rtl,
                  child: AddProductPage(
                    onBack: () => Navigator.of(routeContext).pop(),
                  ),
                ),
              ),
            );
          },
        );
      case AppTab.orders:
        body = const OrdersPage();
      case AppTab.customers:
        body = const CustomersPage();
      case AppTab.settings:
        body = const SettingsPage();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              onNavigateToNotifications: () => _openSheet(
                context,
                const NotificationsPage(),
              ),
              onNavigateToShipping: () => _openSheet(
                context,
                const ShippingPage(),
              ),
              onNavigateToCoupons: () => _openSheet(
                context,
                const CouponsPage(),
              ),
              onLogout: auth.logout,
            ),
            const SizedBox(height: AppSpacing.lg),
            Expanded(child: body),
          ],
        ),
      ),
      bottomNavigationBar: _BottomNavigation(
        currentTab: nav.currentTab,
        onTabSelected: (tab) => context.read<NavigationController>().setTab(tab),
      ),
      floatingActionButton: nav.currentTab == AppTab.orders
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (routeContext) => Directionality(
                      textDirection: TextDirection.rtl,
                      child: AddOrderPage(
                        onBack: () => Navigator.of(routeContext).pop(),
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('طلب جديد'),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _openSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.82,
            minChildSize: 0.5,
            builder: (_, controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                  child: ListView(
                    controller: controller,
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.sm),
                        child: Center(
                          child: Container(
                            width: 64,
                            height: 4,
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                      ),
                      child,
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.onNavigateToNotifications,
    required this.onNavigateToShipping,
    required this.onNavigateToCoupons,
    required this.onLogout,
  });

  final VoidCallback onNavigateToNotifications;
  final VoidCallback onNavigateToShipping;
  final VoidCallback onNavigateToCoupons;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(Icons.storefront, color: AppColors.primary),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    AppStrings.appName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    AppStrings.appSubtitle,
                    style: TextStyle(color: AppColors.mutedForeground, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Flexible(
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  IconButton(
                    splashRadius: 22,
                    onPressed: onNavigateToNotifications,
                    icon: const Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(Icons.notifications_outlined),
                        Positioned(
                          right: -2,
                          top: -2,
                          child: CircleAvatar(
                            backgroundColor: Colors.redAccent,
                            radius: 8,
                            child: Text(
                              '3',
                              style: TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    splashRadius: 22,
                    onPressed: onNavigateToShipping,
                    icon: const Icon(Icons.local_shipping_outlined),
                  ),
                  IconButton(
                    splashRadius: 22,
                    onPressed: onNavigateToCoupons,
                    icon: const Icon(Icons.local_activity_outlined),
                  ),
                  Wrap(
                    spacing: AppSpacing.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundImage: const AssetImage('assets/images/placeholder-user.jpg'),
                        child: Text(
                          auth.displayName.characters.firstOrNull ?? 'أ',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: onLogout,
                        child: const Text('تسجيل الخروج'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    required this.currentTab,
    required this.onTabSelected,
  });

  final AppTab currentTab;
  final ValueChanged<AppTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentTab.index,
      onTap: (index) => onTabSelected(AppTab.values[index]),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: AppStrings.dashboard,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_2_outlined),
          label: AppStrings.products,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined),
          label: AppStrings.orders,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_outlined),
          label: AppStrings.customers,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: AppStrings.settings,
        ),
      ],
    );
  }
}

