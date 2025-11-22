import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'api_constants.dart';
import 'dio_factory.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService() => _ApiService(DioFactory.dio);

  // Authentication
  @POST(ApiConstants.login)
  Future<dynamic> login(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.logout)
  Future<dynamic> logout();

  @POST(ApiConstants.forgotPassword)
  Future<dynamic> forgotPassword(@Body() Map<String, dynamic> body);

  // Products
  @GET(ApiConstants.products)
  Future<dynamic> getProducts(@Queries() Map<String, dynamic>? queries);

  @GET('${ApiConstants.products}/{id}')
  Future<dynamic> getProductById(@Path('id') int id);

  @POST(ApiConstants.products)
  Future<dynamic> createProduct(@Body() Map<String, dynamic> body);

  @PUT('${ApiConstants.products}/{id}')
  Future<dynamic> updateProduct(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('${ApiConstants.products}/{id}')
  Future<dynamic> deleteProduct(@Path('id') int id);

  // Orders
  @GET(ApiConstants.orders)
  Future<dynamic> getOrders(@Queries() Map<String, dynamic>? queries);

  @GET('${ApiConstants.orders}/{id}')
  Future<dynamic> getOrderById(@Path('id') int id);

  @POST(ApiConstants.orders)
  Future<dynamic> createOrder(@Body() Map<String, dynamic> body);

  @PATCH('${ApiConstants.orders}/{id}/status')
  Future<dynamic> updateOrderStatus(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @PATCH('${ApiConstants.orders}/{id}/payment-status')
  Future<dynamic> updatePaymentStatus(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @PATCH('${ApiConstants.orders}/{id}/shipping-status')
  Future<dynamic> updateShippingStatus(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @GET('${ApiConstants.orders}/{id}/invoice')
  Future<dynamic> getInvoice(@Path('id') int id);

  // Customers
  @GET(ApiConstants.customers)
  Future<dynamic> getCustomers(@Queries() Map<String, dynamic>? queries);

  @GET('${ApiConstants.customers}/{id}')
  Future<dynamic> getCustomerById(@Path('id') int id);

  // Dashboard
  @GET(ApiConstants.dashboardStats)
  Future<dynamic> getDashboardStats();

  @GET(ApiConstants.dashboardSales)
  Future<dynamic> getDashboardSales(@Queries() Map<String, dynamic>? queries);

  @GET(ApiConstants.dashboardTopProducts)
  Future<dynamic> getTopProducts(@Queries() Map<String, dynamic>? queries);

  @GET(ApiConstants.dashboardTrafficSources)
  Future<dynamic> getTrafficSources();

  @GET(ApiConstants.dashboardRecentActivities)
  Future<dynamic> getRecentActivities(@Queries() Map<String, dynamic>? queries);

  // Coupons
  @GET(ApiConstants.coupons)
  Future<dynamic> getCoupons();

  @POST(ApiConstants.coupons)
  Future<dynamic> createCoupon(@Body() Map<String, dynamic> body);

  @PUT('${ApiConstants.coupons}/{id}')
  Future<dynamic> updateCoupon(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('${ApiConstants.coupons}/{id}')
  Future<dynamic> deleteCoupon(@Path('id') int id);

  // Shipping
  @GET(ApiConstants.shippingZones)
  Future<dynamic> getShippingZones();

  @POST(ApiConstants.shippingZones)
  Future<dynamic> createShippingZone(@Body() Map<String, dynamic> body);

  @PUT('${ApiConstants.shippingZones}/{id}')
  Future<dynamic> updateShippingZone(
    @Path('id') int id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('${ApiConstants.shippingZones}/{id}')
  Future<dynamic> deleteShippingZone(@Path('id') int id);

  @GET(ApiConstants.shippingTrackingUpdates)
  Future<dynamic> getTrackingUpdates(@Queries() Map<String, dynamic>? queries);

  // Notifications
  @GET(ApiConstants.notifications)
  Future<dynamic> getNotifications(@Queries() Map<String, dynamic>? queries);

  @PATCH('${ApiConstants.notifications}/{id}/read')
  Future<dynamic> markNotificationAsRead(@Path('id') int id);

  @PATCH(ApiConstants.notificationsReadAll)
  Future<dynamic> markAllNotificationsAsRead();

  // Settings
  @GET(ApiConstants.settingsStore)
  Future<dynamic> getStoreSettings();

  @PUT(ApiConstants.settingsStore)
  Future<dynamic> updateStoreSettings(@Body() Map<String, dynamic> body);

  @GET(ApiConstants.settingsNotifications)
  Future<dynamic> getNotificationSettings();

  @PUT(ApiConstants.settingsNotifications)
  Future<dynamic> updateNotificationSettings(@Body() Map<String, dynamic> body);

  @GET(ApiConstants.settingsTeam)
  Future<dynamic> getTeam();

  @POST(ApiConstants.settingsTeamInvite)
  Future<dynamic> inviteTeamMember(@Body() Map<String, dynamic> body);

  @POST('${ApiConstants.settingsTeam}/{id}/reset-password')
  Future<dynamic> resetTeamPassword(@Path('id') int id);
}
