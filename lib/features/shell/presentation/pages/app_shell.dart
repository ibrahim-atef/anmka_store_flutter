import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/routing/navigation_controller.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/network/dependency_injection.dart';
import '../../../auth/logic/cubit/auth_cubit.dart';
import '../../../auth/logic/states/auth_state.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../auth/presentation/widgets/welcome_overlay.dart';
import '../../../customers/logic/cubit/customers_cubit.dart';
import '../../../customers/presentation/pages/customers_page.dart';
import '../../../dashboard/logic/cubit/dashboard_cubit.dart';
import '../../../dashboard/presentation/pages/dashboard_page.dart';
import '../../../orders/logic/cubit/orders_cubit.dart';
import '../../../products/logic/cubit/products_cubit.dart';
import '../../../notifications/logic/cubit/notifications_cubit.dart';
import '../../../notifications/logic/states/notifications_state.dart';
import '../../../notifications/presentation/pages/notifications_page.dart';
import '../../../orders/presentation/pages/add_order_page.dart';
import '../../../orders/presentation/pages/orders_page.dart';
import '../../../products/presentation/pages/add_product_page.dart';
import '../../../products/presentation/pages/products_page.dart';
import '../../../settings/logic/cubit/settings_cubit.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import '../../../shipping/logic/cubit/shipping_cubit.dart';
import '../../../shipping/presentation/pages/shipping_page.dart';
import '../../../coupons/logic/cubit/coupons_cubit.dart';
import '../../../coupons/presentation/pages/coupons_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _hasSeenWelcome = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          authenticated: (loginResponse) {
            log('AppShell listener: User authenticated - ${loginResponse.user.name}');
          },
        );
      },
      builder: (context, state) {
        log('AppShell rebuild - State: ${state.runtimeType}');
        return state.when(
          initial: () {
            log('AppShell: Showing LoginPage (initial state)');
            return const Directionality(
              textDirection: TextDirection.rtl,
              child: LoginPage(),
            );
          },
          loading: () {
            log('AppShell: Showing loading indicator');
            return const Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          },
          authenticated: (loginResponse) {
            log('AppShell: Showing authenticated home for user: ${loginResponse.user.name}');
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                children: [
                  _AuthenticatedHome(userName: loginResponse.user.name),
                  if (!_hasSeenWelcome)
                    WelcomeOverlay(
                      userName: loginResponse.user.name,
                      onContinue: () => setState(() => _hasSeenWelcome = true),
                    ),
                ],
              ),
            );
          },
          unauthenticated: () {
            log('AppShell: Showing LoginPage (unauthenticated state)');
            return const Directionality(
              textDirection: TextDirection.rtl,
              child: LoginPage(),
            );
          },
          error: (message) {
            log('AppShell: Showing LoginPage (error state): $message');
            return const Directionality(
              textDirection: TextDirection.rtl,
              child: LoginPage(),
            );
          },
        );
      },
    );
  }
}

class _AuthenticatedHome extends StatelessWidget {
  const _AuthenticatedHome({required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavigationController>();

    Widget body;
    switch (nav.currentTab) {
      case AppTab.dashboard:
        body = BlocProvider(
          create: (context) => getIt<DashboardCubit>()..getStats(),
          child: DashboardPage(userName: userName),
        );
      case AppTab.products:
        body = BlocProvider(
          create: (context) => getIt<ProductsCubit>()..getProducts(),
          child: Builder(
            builder: (productsContext) => ProductsPage(
              onAddProduct: () {
                final cubit = productsContext.read<ProductsCubit>();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (routeContext) => BlocProvider.value(
                      value: cubit,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ProductFormPage(
                          onBack: () => Navigator.of(routeContext).pop(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      case AppTab.orders:
        body = BlocProvider(
          create: (context) => getIt<OrdersCubit>()..getOrders(),
          child: const OrdersPage(),
        );
      case AppTab.customers:
        body = BlocProvider(
          create: (context) => getIt<CustomersCubit>()..getCustomers(),
          child: const CustomersPage(),
        );
      case AppTab.settings:
        body = BlocProvider(
          create: (context) => getIt<SettingsCubit>()..loadSettings(),
          child: const SettingsPage(),
        );
    }

    return BlocProvider(
      create: (context) => getIt<NotificationsCubit>()..getNotifications(),
      child: Builder(
        builder: (providerContext) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  _Header(
                    onNavigateToNotifications: () => _openSheet(
                      providerContext,
                      const NotificationsPage(),
                    ),
                    onNavigateToShipping: () => _openSheet(
                      providerContext,
                      const ShippingPage(),
                    ),
                    onNavigateToCoupons: () => _openSheet(
                      providerContext,
                      const CouponsPage(),
                    ),
                    onLogout: () => context.read<AuthCubit>().logout(),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(child: body),
                ],
              ),
            ),
            bottomNavigationBar: _BottomNavigation(
              currentTab: nav.currentTab,
              onTabSelected: (tab) =>
                  context.read<NavigationController>().setTab(tab),
            ),
            // floatingActionButton: nav.currentTab == AppTab.orders
            //     ? FloatingActionButton.extended(
            //         onPressed: () {
            //           Navigator.of(context).push(
            //             MaterialPageRoute(
            //               builder: (routeContext) => Directionality(
            //                 textDirection: TextDirection.rtl,
            //                 child: AddOrderPage(
            //                   onBack: () => Navigator.of(routeContext).pop(),
            //                 ),
            //               ),
            //             ),
            //           );
            //         },
            //         icon: const Icon(Icons.add),
            //         label: const Text('طلب جديد'),
            //       )
            //     : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
          );
        },
      ),
    );
  }

  void _openSheet(BuildContext context, Widget child) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) {
        Widget wrappedChild = child;

        // Wrap with appropriate BlocProvider based on child type
        // Use sheetContext to access providers from the parent widget tree
        if (child is NotificationsPage) {
          // Try to get the existing NotificationsCubit from the parent context
          try {
            final notificationsCubit = context.read<NotificationsCubit>();
            wrappedChild = BlocProvider.value(
              value: notificationsCubit,
              child: child,
            );
          } catch (e) {
            // If not found in context, create a new one
            wrappedChild = BlocProvider(
              create: (context) =>
                  getIt<NotificationsCubit>()..getNotifications(),
              child: child,
            );
          }
        } else if (child is ShippingPage) {
          wrappedChild = BlocProvider(
            create: (context) => getIt<ShippingCubit>()..getShippingZones(),
            child: child,
          );
        } else if (child is CouponsPage) {
          wrappedChild = BlocProvider(
            create: (context) => getIt<CouponsCubit>()..getCoupons(),
            child: child,
          );
        }

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
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppRadius.lg)),
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
                      wrappedChild,
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
    final userName = context.select<AuthCubit, String>(
      (cubit) => cubit.state.maybeWhen(
        authenticated: (response) => response.user.name,
        orElse: () => 'مدير المتجر',
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: AppCard(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
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
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.appName,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    AppStrings.appSubtitle,
                    style: TextStyle(
                        color: AppColors.mutedForeground, fontSize: 12),
                  ),
                ],
              ),
            ),
            BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                final unreadCount = state.maybeWhen(
                  loaded: (notificationsList) => notificationsList.unreadCount,
                  orElse: () => 0,
                );

                return IconButton(
                  splashRadius: 22,
                  tooltip: 'الإشعارات',
                  onPressed: onNavigateToNotifications,
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.notifications_outlined),
                      if (unreadCount > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: CircleAvatar(
                            backgroundColor: Colors.redAccent,
                            radius: 8,
                            child: Text(
                              unreadCount > 99 ? '99+' : '$unreadCount',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(width: AppSpacing.sm),
            PopupMenuButton<_HeaderMenuAction>(
              tooltip: 'القائمة',
              offset: const Offset(0, 12),
              onSelected: (action) {
                switch (action) {
                  case _HeaderMenuAction.shipping:
                    onNavigateToShipping();
                    break;
                  case _HeaderMenuAction.coupons:
                    onNavigateToCoupons();
                    break;
                  case _HeaderMenuAction.logout:
                    onLogout();
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<_HeaderMenuAction>(
                  value: _HeaderMenuAction.shipping,
                  child: Row(
                    children: [
                      Icon(Icons.local_shipping_outlined, size: 18),
                      SizedBox(width: AppSpacing.sm),
                      Text('إدارة الشحن'),
                    ],
                  ),
                ),
                const PopupMenuItem<_HeaderMenuAction>(
                  value: _HeaderMenuAction.coupons,
                  child: Row(
                    children: [
                      Icon(Icons.local_activity_outlined, size: 18),
                      SizedBox(width: AppSpacing.sm),
                      Text('الكوبونات والعروض'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<_HeaderMenuAction>(
                  value: _HeaderMenuAction.logout,
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 18, color: AppColors.danger),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'تسجيل الخروج',
                        style: TextStyle(color: AppColors.danger),
                      ),
                    ],
                  ),
                ),
              ],
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage:
                        const AssetImage('assets/images/placeholder-user.jpg'),
                    child: Text(
                      userName.characters.firstOrNull ?? 'أ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _HeaderMenuAction { shipping, coupons, logout }

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
