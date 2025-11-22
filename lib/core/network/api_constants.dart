class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://demo1.anmka.com';
  static const String apiBaseUrl = '$baseUrl/wp-json/anmka/v1';

  // Authentication endpoints
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';

  // Products endpoints
  static const String products = '/products';
  static String productById(int id) => '/products/$id';

  // Orders endpoints
  static const String orders = '/orders';
  static String orderById(int id) => '/orders/$id';
  static String orderStatus(int id) => '/orders/$id/status';
  static String orderPaymentStatus(int id) => '/orders/$id/payment-status';
  static String orderShippingStatus(int id) => '/orders/$id/shipping-status';
  static String orderInvoice(int id) => '/orders/$id/invoice';

  // Customers endpoints
  static const String customers = '/customers';
  static String customerById(int id) => '/customers/$id';

  // Dashboard endpoints
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardSales = '/dashboard/sales';
  static const String dashboardTopProducts = '/dashboard/top-products';
  static const String dashboardTrafficSources = '/dashboard/traffic-sources';
  static const String dashboardRecentActivities = '/dashboard/recent-activities';

  // Coupons endpoints
  static const String coupons = '/coupons';
  static String couponById(int id) => '/coupons/$id';

  // Shipping endpoints
  static const String shippingZones = '/shipping/zones';
  static String shippingZoneById(int id) => '/shipping/zones/$id';
  static const String shippingTrackingUpdates = '/shipping/tracking-updates';

  // Notifications endpoints
  static const String notifications = '/notifications';
  static String notificationRead(int id) => '/notifications/$id/read';
  static const String notificationsReadAll = '/notifications/read-all';

  // Settings endpoints
  static const String settingsStore = '/settings/store';
  static const String settingsNotifications = '/settings/notifications';
  static const String settingsTeam = '/settings/team';
  static const String settingsTeamInvite = '/settings/team/invite';
  static String settingsTeamResetPassword(int id) => '/settings/team/$id/reset-password';
}

