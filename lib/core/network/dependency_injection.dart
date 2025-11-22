import 'package:get_it/get_it.dart';
import 'api_service.dart';
import 'dio_factory.dart';

// Auth
import '../../features/auth/data/repositories/auth_repository.dart';
import '../../features/auth/logic/cubit/auth_cubit.dart';

// Products
import '../../features/products/data/repositories/products_repository.dart';
import '../../features/products/logic/cubit/products_cubit.dart';

// Orders
import '../../features/orders/data/repositories/orders_repository.dart';
import '../../features/orders/logic/cubit/orders_cubit.dart';

// Customers
import '../../features/customers/data/repositories/customers_repository.dart';
import '../../features/customers/logic/cubit/customers_cubit.dart';

// Dashboard
import '../../features/dashboard/data/repositories/dashboard_repository.dart';
import '../../features/dashboard/logic/cubit/dashboard_cubit.dart';

// Coupons
import '../../features/coupons/data/repositories/coupons_repository.dart';
import '../../features/coupons/logic/cubit/coupons_cubit.dart';

// Notifications
import '../../features/notifications/data/repositories/notifications_repository.dart';
import '../../features/notifications/logic/cubit/notifications_cubit.dart';

// Shipping
import '../../features/shipping/data/repositories/shipping_repository.dart';
import '../../features/shipping/logic/cubit/shipping_cubit.dart';

// Settings
import '../../features/settings/data/repositories/settings_repository.dart';
import '../../features/settings/logic/cubit/settings_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Initialize DioFactory and load token from storage
  await DioFactory.initialize();

  // Register Dio
  getIt.registerLazySingleton(() => DioFactory.dio);

  // Register ApiService
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  // Register Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ProductsRepository>(
    () => ProductsRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<OrdersRepository>(
    () => OrdersRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CustomersRepository>(
    () => CustomersRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<DashboardRepository>(
    () => DashboardRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CouponsRepository>(
    () => CouponsRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<ShippingRepository>(
    () => ShippingRepository(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<SettingsRepository>(
    () => SettingsRepository(getIt<ApiService>()),
  );

  // Register Cubits (Factory - new instance each time)
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt<AuthRepository>()),
  );
  getIt.registerFactory<ProductsCubit>(
    () => ProductsCubit(getIt<ProductsRepository>()),
  );
  getIt.registerFactory<OrdersCubit>(
    () => OrdersCubit(getIt<OrdersRepository>()),
  );
  getIt.registerFactory<CustomersCubit>(
    () => CustomersCubit(getIt<CustomersRepository>()),
  );
  getIt.registerFactory<DashboardCubit>(
    () => DashboardCubit(getIt<DashboardRepository>()),
  );
  getIt.registerFactory<CouponsCubit>(
    () => CouponsCubit(getIt<CouponsRepository>()),
  );
  getIt.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(getIt<NotificationsRepository>()),
  );
  getIt.registerFactory<ShippingCubit>(
    () => ShippingCubit(getIt<ShippingRepository>()),
  );
  getIt.registerFactory<SettingsCubit>(
    () => SettingsCubit(getIt<SettingsRepository>()),
  );
}
