# API Integration Guide

This document describes the API integration structure for all features following the workflow in `flow_connect_api.dm`.

## ✅ Completed Features

### 1. Auth Feature
- **Models**: `LoginRequest`, `ForgotPasswordRequest`, `LoginResponse`, `UserModel`
- **Repository**: `AuthRepository`
- **Cubit**: `AuthCubit` with `AuthState` (using freezed)
- **Endpoints**: Login, Logout, Forgot Password

### 2. Products Feature
- **Models**: `CreateProductRequest`, `UpdateProductRequest`, `ProductResponse`, `ProductsListResponse`
- **Repository**: `ProductsRepository`
- **Cubit**: `ProductsCubit` with `ProductsState` (using freezed)
- **Endpoints**: Get All, Get By ID, Create, Update, Delete

### 3. Orders Feature
- **Models**: `CreateOrderRequest`, `OrderItemRequest`, `UpdateOrderStatusRequest`, `OrderResponse`, `OrderItemResponse`, `OrdersListResponse`
- **Repository**: `OrdersRepository`
- **Cubit**: `OrdersCubit` with `OrdersState` (using freezed)
- **Endpoints**: Get All, Get By ID, Create, Update Status, Update Payment Status, Update Shipping Status

### 4. Customers Feature
- **Models**: `CustomerResponse`, `CustomersListResponse`
- **Repository**: `CustomersRepository`
- **Cubit**: `CustomersCubit` with `CustomersState` (using freezed)
- **Endpoints**: Get All, Get By ID

### 5. Dashboard Feature
- **Models**: `DashboardStatsResponse`
- **Repository**: `DashboardRepository`
- **Cubit**: `DashboardCubit` with `DashboardState` (using freezed)
- **Endpoints**: Get Stats, Get Sales, Get Top Products, Get Traffic Sources, Get Recent Activities

## 📁 File Structure

Each feature follows this structure:
```
features/
  {feature_name}/
    data/
      models/
        request/     # Request models
        response/    # Response models
      repositories/  # Repository using ApiService
    logic/
      cubit/        # Cubit using repository
      states/       # States using freezed
    presentation/   # UI (existing)
```

## 🔧 Usage Example

### Using Cubit in UI

```dart
// Get cubit from dependency injection
final authCubit = context.read<AuthCubit>();

// Listen to state changes
BlocBuilder<AuthCubit, AuthState>(
  builder: (context, state) {
    return state.when(
      initial: () => LoginForm(),
      loading: () => CircularProgressIndicator(),
      authenticated: (loginResponse) => HomePage(),
      unauthenticated: () => LoginForm(),
      error: (message) => ErrorWidget(message),
    );
  },
);

// Call cubit methods
authCubit.login(
  username: 'admin',
  password: 'password',
  website: 'https://demo1.anmka.com',
);
```

### Using Repository Directly (if needed)

```dart
final repository = getIt<AuthRepository>();
final result = await repository.login(request);
result.when(
  success: (data) => print('Success: $data'),
  failure: (error) => print('Error: ${error.errorMessage}'),
);
```

## 🚀 Next Steps

1. **Run code generation**:
   ```bash
   flutter pub get
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Update UI pages** to use cubits:
   - Replace `AuthController` with `AuthCubit` in login page
   - Add `BlocProvider` for each feature where needed
   - Use `BlocBuilder` or `BlocConsumer` to listen to state changes

3. **Example: Update Login Page**
   ```dart
   // Replace Provider with BlocProvider
   BlocBuilder<AuthCubit, AuthState>(
     builder: (context, state) {
       state.when(
         initial: () => LoginForm(),
         loading: () => CircularProgressIndicator(),
         authenticated: (response) {
           // Navigate to home
           WidgetsBinding.instance.addPostFrameCallback((_) {
             Navigator.of(context).pushReplacement(...);
           });
           return LoginForm();
         },
         error: (message) => ErrorSnackBar(message),
       );
     },
   )
   ```

## 📝 Notes

- All repositories use `ApiResult<T>` for type-safe error handling
- All states use `freezed` for immutable state management
- Token is automatically managed by `DioFactory`
- Error messages are in Arabic by default
- All endpoints from Postman collection are available in `ApiService`

## 🔄 Remaining Features

The following features still need full implementation (models, repository, cubit):
- Coupons
- Shipping
- Notifications
- Settings

These can be implemented following the same pattern as the completed features.

