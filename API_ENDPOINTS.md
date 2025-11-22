# نقاط النهاية المطلوبة لتطبيق انمكا ستور

## 🔐 المصادقة (Authentication)

### 1. تسجيل الدخول
- **Method:** `POST`
- **Endpoint:** `/api/auth/login`
- **Body:**
  ```json
  {
    "username": "string",
    "password": "string",
    "website": "string"
  }
  ```
- **Response:**
  ```json
  {
    "token": "string",
    "user": {
      "id": "string",
      "name": "string",
      "email": "string",
      "website": "string"
    }
  }
  ```

### 2. استعادة كلمة المرور
- **Method:** `POST`
- **Endpoint:** `/api/auth/forgot-password`
- **Body:**
  ```json
  {
    "email": "string"
  }
  ```

### 3. تسجيل الخروج
- **Method:** `POST`
- **Endpoint:** `/api/auth/logout`
- **Headers:** `Authorization: Bearer {token}`

---

## 📦 المنتجات (Products)

### 1. الحصول على جميع المنتجات
- **Method:** `GET`
- **Endpoint:** `/api/products`
- **Query Parameters:**
  - `search` (optional): البحث في اسم المنتج
  - `category` (optional): تصفية حسب الفئة
  - `status` (optional): تصفية حسب الحالة (available, lowStock, outOfStock)
  - `page` (optional): رقم الصفحة
  - `limit` (optional): عدد النتائج في الصفحة
- **Response:**
  ```json
  {
    "products": [
      {
        "id": "number",
        "name": "string",
        "category": "string",
        "price": "number",
        "stock": "number",
        "status": "string",
        "image": "string",
        "sku": "string",
        "sales": "number",
        "description": "string"
      }
    ],
    "total": "number",
    "page": "number",
    "limit": "number"
  }
  ```

### 2. الحصول على منتج محدد
- **Method:** `GET`
- **Endpoint:** `/api/products/{id}`
- **Response:**
  ```json
  {
    "id": "number",
    "name": "string",
    "category": "string",
    "price": "number",
    "stock": "number",
    "status": "string",
    "image": "string",
    "sku": "string",
    "sales": "number",
    "description": "string"
  }
  ```

### 3. إنشاء منتج جديد
- **Method:** `POST`
- **Endpoint:** `/api/products`
- **Headers:** `Authorization: Bearer {token}`
- **Body:**
  ```json
  {
    "name": "string",
    "category": "string",
    "price": "number",
    "stock": "number",
    "sku": "string",
    "description": "string",
    "image": "string"
  }
  ```

### 4. تحديث منتج
- **Method:** `PUT` أو `PATCH`
- **Endpoint:** `/api/products/{id}`
- **Headers:** `Authorization: Bearer {token}`
- **Body:**
  ```json
  {
    "name": "string",
    "category": "string",
    "price": "number",
    "stock": "number",
    "sku": "string",
    "description": "string",
    "image": "string"
  }
  ```

### 5. حذف منتج
- **Method:** `DELETE`
- **Endpoint:** `/api/products/{id}`
- **Headers:** `Authorization: Bearer {token}`

---

## 🛒 الطلبات (Orders)

### 1. الحصول على جميع الطلبات
- **Method:** `GET`
- **Endpoint:** `/api/orders`
- **Query Parameters:**
  - `status` (optional): تصفية حسب الحالة (newOrder, inProgress, completed, cancelled)
  - `paymentStatus` (optional): تصفية حسب حالة الدفع (pending, paid, refunded)
  - `shippingStatus` (optional): تصفية حسب حالة الشحن (preparing, inTransit, delivered)
  - `page` (optional): رقم الصفحة
  - `limit` (optional): عدد النتائج في الصفحة
- **Response:**
  ```json
  {
    "orders": [
      {
        "id": "string",
        "customerName": "string",
        "customerId": "string",
        "total": "number",
        "status": "string",
        "paymentStatus": "string",
        "shippingStatus": "string",
        "date": "string (ISO 8601)",
        "items": [
          {
            "productId": "number",
            "name": "string",
            "quantity": "number",
            "price": "number"
          }
        ]
      }
    ],
    "total": "number",
    "page": "number",
    "limit": "number"
  }
  ```

### 2. الحصول على طلب محدد
- **Method:** `GET`
- **Endpoint:** `/api/orders/{id}`
- **Response:**
  ```json
  {
    "id": "string",
    "customerName": "string",
    "customerId": "string",
    "customerEmail": "string",
    "customerPhone": "string",
    "total": "number",
    "status": "string",
    "paymentStatus": "string",
    "shippingStatus": "string",
    "date": "string (ISO 8601)",
    "items": [
      {
        "productId": "number",
        "name": "string",
        "quantity": "number",
        "price": "number"
      }
    ],
    "shippingAddress": "string",
    "notes": "string"
  }
  ```

### 3. إنشاء طلب جديد
- **Method:** `POST`
- **Endpoint:** `/api/orders`
- **Headers:** `Authorization: Bearer {token}`
- **Body:**
  ```json
  {
    "customerName": "string",
    "customerEmail": "string",
    "customerPhone": "string",
    "items": [
      {
        "productId": "number",
        "quantity": "number"
      }
    ],
    "shippingAddress": "string",
    "notes": "string"
  }
  ```

### 4. تحديث حالة الطلب
- **Method:** `PATCH`
- **Endpoint:** `/api/orders/{id}/status`
- **Headers:** `Authorization: Bearer {token}`
- **Body:**
  ```json
  {
    "status": "string" // newOrder, inProgress, completed, cancelled
  }
  ```

### 5. تحديث حالة الدفع
- **Method:** `PATCH`
- **Endpoint:** `/api/orders/{id}/payment-status`
- **Headers:** `Authorization: Bearer {token}`
- **Body:**
  ```json
  {
    "paymentStatus": "string" // pending, paid, refunded
  }
  ```

### 6. تحديث حالة الشحن
- **Method:** `PATCH`
- **Endpoint:** `/api/orders/{id}/shipping-status`
- **Headers:** `Authorization: Bearer {token}`
- **Body:**
  ```json
  {
    "shippingStatus": "string" // preparing, inTransit, delivered
  }
  ```

### 7. طباعة الفاتورة
- **Method:** `GET`
- **Endpoint:** `/api/orders/{id}/invoice`
- **Response:** PDF file أو JSON مع بيانات الفاتورة

---

## 👥 العملاء (Customers)

### 1. الحصول على جميع العملاء
- **Method:** `GET`
- **Endpoint:** `/api/customers`
- **Query Parameters:**
  - `tier` (optional): تصفية حسب المستوى (newCustomer, loyal, vip)
  - `search` (optional): البحث في الاسم أو البريد
  - `page` (optional): رقم الصفحة
  - `limit` (optional): عدد النتائج في الصفحة
- **Response:**
  ```json
  {
    "customers": [
      {
        "id": "string",
        "name": "string",
        "avatar": "string",
        "email": "string",
        "phone": "string",
        "tier": "string",
        "totalOrders": "number",
        "totalSpent": "number",
        "lastActive": "string (ISO 8601)",
        "tags": ["string"]
      }
    ],
    "total": "number",
    "page": "number",
    "limit": "number"
  }
  ```

### 2. الحصول على عميل محدد
- **Method:** `GET`
- **Endpoint:** `/api/customers/{id}`
- **Response:**
  ```json
  {
    "id": "string",
    "name": "string",
    "avatar": "string",
    "email": "string",
    "phone": "string",
    "tier": "string",
    "totalOrders": "number",
    "totalSpent": "number",
    "lastActive": "string (ISO 8601)",
    "tags": ["string"],
    "addresses": [
      {
        "id": "string",
        "address": "string",
        "city": "string",
        "isDefault": "boolean"
      }
    ],
    "orders": [
      {
        "id": "string",
        "date": "string",
        "total": "number",
        "status": "string"
      }
    ]
  }
  ```

---

## 📊 لوحة التحكم (Dashboard)

### 1. الحصول على إحصائيات لوحة التحكم
- **Method:** `GET`
- **Endpoint:** `/api/dashboard/stats`
- **Response:**
  ```json
  {
    "totalSales": "number",
    "newOrders": "number",
    "newCustomers": "number",
    "outOfStockProducts": "number",
    "todayVisits": "number",
    "totalProducts": "number",
    "salesChange": "number",
    "ordersChange": "number",
    "customersChange": "number"
  }
  ```

### 2. الحصول على بيانات المبيعات
- **Method:** `GET`
- **Endpoint:** `/api/dashboard/sales`
- **Query Parameters:**
  - `period` (required): الفترة (daily, weekly, monthly)
  - `startDate` (optional): تاريخ البداية
  - `endDate` (optional): تاريخ النهاية
- **Response:**
  ```json
  {
    "data": [
      {
        "label": "string",
        "sales": "number",
        "orders": "number"
      }
    ]
  }
  ```

### 3. الحصول على أفضل المنتجات أداءً
- **Method:** `GET`
- **Endpoint:** `/api/dashboard/top-products`
- **Query Parameters:**
  - `limit` (optional): عدد المنتجات (افتراضي: 10)
  - `period` (optional): الفترة (week, month, year)
- **Response:**
  ```json
  {
    "products": [
      {
        "id": "number",
        "name": "string",
        "image": "string",
        "price": "number",
        "sales": "number"
      }
    ]
  }
  ```

### 4. الحصول على مصادر الزيارات
- **Method:** `GET`
- **Endpoint:** `/api/dashboard/traffic-sources`
- **Response:**
  ```json
  {
    "sources": [
      {
        "name": "string",
        "value": "number",
        "percentage": "number"
      }
    ]
  }
  ```

### 5. الحصول على النشاط الأخير
- **Method:** `GET`
- **Endpoint:** `/api/dashboard/recent-activities`
- **Query Parameters:**
  - `limit` (optional): عدد الأنشطة (افتراضي: 10)
- **Response:**
  ```json
  {
    "activities": [
      {
        "id": "string",
        "title": "string",
        "subtitle": "string",
        "tag": "string",
        "tagTone": "string",
        "date": "string (ISO 8601)"
      }
    ]
  }
  ```

---

## 🎫 الكوبونات (Coupons)

### 1. الحصول على جميع الكوبونات
- **Method:** `GET`
- **Endpoint:** `/api/coupons`
- **Response:**
  ```json
  {
    "coupons": [
      {
        "id": "string",
        "code": "string",
        "type": "string", // percent, fixed, freeShipping
        "discountValue": "number",
        "discountLabel": "string",
        "usage": "number",
        "maxUsage": "number",
        "validUntil": "string (ISO 8601)",
        "isActive": "boolean"
      }
    ]
  }
  ```

### 2. إنشاء كوبون جديد
- **Method:** `POST`
- **Endpoint:** `/api/coupons`
- **Headers:** `Authorization: Bearer {token}`
- **Body:**
  ```json
  {
    "code": "string",
    "type": "string", // percent, fixed, freeShipping
    "discountValue": "number",
    "discountLabel": "string",
    "maxUsage": "number",
    "validUntil": "string (ISO 8601)"
  }
  ```

### 3. تحديث كوبون
- **Method:** `PUT` أو `PATCH`
- **Endpoint:** `/api/coupons/{id}`
- **Headers:** `Authorization: Bearer {token}`
- **Body:**
  ```json
  {
    "code": "string",
    "type": "string",
    "discountValue": "number",
    "discountLabel": "string",
    "maxUsage": "number",
    "validUntil": "string (ISO 8601)",
    "isActive": "boolean"
  }
  ```

### 4. حذف كوبون
- **Method:** `DELETE`
- **Endpoint:** `/api/coupons/{id}`
- **Headers:** `Authorization: Bearer {token}`

---

## 🚚 الشحن (Shipping)

### 1. الحصول على مناطق الشحن
- **Method:** `GET`
- **Endpoint:** `/api/shipping/zones`
- **Response:**
  ```json
  {
    "zones": [
      {
        "id": "string",
        "name": "string",
        "deliveryTime": "string",
        "cost": "number",
        "coverage": "string"
      }
    ]
  }
  ```

### 2. إنشاء منطقة شحن جديدة
- **Method:** `POST`
- **Endpoint:** `/api/shipping/zones`
- **Headers:** `Authorization: Bearer {token}`
- **Body:**
  ```json
  {
    "name": "string",
    "deliveryTime": "string",
    "cost": "number",
    "coverage": "string"
  }
  ```

### 3. تحديث منطقة شحن
- **Method:** `PUT` أو `PATCH`
- **Endpoint:** `/api/shipping/zones/{id}`
- **Headers:** `Authorization: Bearer {token}`
- **Body:**
  ```json
  {
    "name": "string",
    "deliveryTime": "string",
    "cost": "number",
    "coverage": "string"
  }
  ```

### 4. حذف منطقة شحن
- **Method:** `DELETE`
- **Endpoint:** `/api/shipping/zones/{id}`
- **Headers:** `Authorization: Bearer {token}`

### 5. الحصول على تحديثات تتبع الشحنات
- **Method:** `GET`
- **Endpoint:** `/api/shipping/tracking-updates`
- **Query Parameters:**
  - `orderId` (optional): تصفية حسب رقم الطلب
  - `limit` (optional): عدد التحديثات
- **Response:**
  ```json
  {
    "updates": [
      {
        "id": "string",
        "orderId": "string",
        "status": "string",
        "time": "string (ISO 8601)",
        "location": "string",
        "notes": "string"
      }
    ]
  }
  ```

---

## 🔔 الإشعارات (Notifications)

### 1. الحصول على جميع الإشعارات
- **Method:** `GET`
- **Endpoint:** `/api/notifications`
- **Query Parameters:**
  - `category` (optional): تصفية حسب الفئة
  - `read` (optional): تصفية حسب الحالة (true, false)
  - `limit` (optional): عدد الإشعارات
- **Response:**
  ```json
  {
    "notifications": [
      {
        "id": "string",
        "title": "string",
        "description": "string",
        "category": "string",
        "time": "string (ISO 8601)",
        "isRead": "boolean",
        "tone": "string" // success, info, warning, danger
      }
    ],
    "unreadCount": "number"
  }
  ```

### 2. تعليم إشعار كمقروء
- **Method:** `PATCH`
- **Endpoint:** `/api/notifications/{id}/read`
- **Headers:** `Authorization: Bearer {token}`

### 3. تعليم جميع الإشعارات كمقروءة
- **Method:** `PATCH`
- **Endpoint:** `/api/notifications/read-all`
- **Headers:** `Authorization: Bearer {token}`

---

## ⚙️ الإعدادات (Settings)

### 1. الحصول على إعدادات المتجر
- **Method:** `GET`
- **Endpoint:** `/api/settings/store`
- **Headers:** `Authorization: Bearer {token}`
- **Response:**
  ```json
  {
    "storeName": "string",
    "storeDomain": "string",
    "storeCategory": "string",
    "storeUrl": "string"
  }
  ```

### 2. تحديث إعدادات المتجر
- **Method:** `PUT` أو `PATCH`
- **Endpoint:** `/api/settings/store`
- **Headers:** `Authorization: Bearer {token}`
- **Body:**
  ```json
  {
    "storeName": "string",
    "storeDomain": "string",
    "storeCategory": "string",
    "storeUrl": "string"
  }
  ```

### 3. الحصول على إعدادات التنبيهات
- **Method:** `GET`
- **Endpoint:** `/api/settings/notifications`
- **Headers:** `Authorization: Bearer {token}`
- **Response:**
  ```json
  {
    "notificationsEnabled": "boolean",
    "twoFactorEnabled": "boolean",
    "autoSyncEnabled": "boolean"
  }
  ```

### 4. تحديث إعدادات التنبيهات
- **Method:** `PUT` أو `PATCH`
- **Endpoint:** `/api/settings/notifications`
- **Headers:** `Authorization: Bearer {token}`
- **Body:**
  ```json
  {
    "notificationsEnabled": "boolean",
    "twoFactorEnabled": "boolean",
    "autoSyncEnabled": "boolean"
  }
  ```

### 5. الحصول على أعضاء الفريق
- **Method:** `GET`
- **Endpoint:** `/api/settings/team`
- **Headers:** `Authorization: Bearer {token}`
- **Response:**
  ```json
  {
    "members": [
      {
        "id": "string",
        "name": "string",
        "email": "string",
        "role": "string",
        "avatar": "string"
      }
    ]
  }
  ```

### 6. دعوة عضو جديد للفريق
- **Method:** `POST`
- **Endpoint:** `/api/settings/team/invite`
- **Headers:** `Authorization: Bearer {token}`
- **Body:**
  ```json
  {
    "name": "string",
    "email": "string",
    "role": "string"
  }
  ```

### 7. إعادة تعيين كلمة مرور عضو
- **Method:** `POST`
- **Endpoint:** `/api/settings/team/{id}/reset-password`
- **Headers:** `Authorization: Bearer {token}`

---

## 📝 ملاحظات مهمة

### المصادقة (Authentication)
- جميع الـ endpoints التي تتطلب `Authorization: Bearer {token}` تحتاج إلى token صالح
- Token يتم الحصول عليه من endpoint تسجيل الدخول
- يجب إرسال Token في header `Authorization` بصيغة: `Bearer {token}`

### الأخطاء (Error Handling)
جميع الـ endpoints يجب أن ترجع أخطاء بصيغة موحدة:
```json
{
  "error": {
    "code": "string",
    "message": "string",
    "details": {}
  }
}
```

### أكواد الحالة (Status Codes)
- `200 OK`: نجحت العملية
- `201 Created`: تم إنشاء المورد بنجاح
- `400 Bad Request`: خطأ في البيانات المرسلة
- `401 Unauthorized`: غير مصرح (مشكلة في Token)
- `403 Forbidden`: غير مسموح بالوصول
- `404 Not Found`: المورد غير موجود
- `500 Internal Server Error`: خطأ في الخادم

### التصفح (Pagination)
الـ endpoints التي تدعم التصفح يجب أن ترجع:
```json
{
  "data": [],
  "pagination": {
    "page": "number",
    "limit": "number",
    "total": "number",
    "totalPages": "number"
  }
}
```

### التواريخ (Dates)
جميع التواريخ يجب أن تكون بصيغة ISO 8601:
- مثال: `2024-12-25T10:30:00Z`

---

## 📌 ملخص سريع

### إجمالي عدد الـ Endpoints: **47 endpoint**

#### حسب الفئة:
- **المصادقة:** 3 endpoints
- **المنتجات:** 5 endpoints
- **الطلبات:** 7 endpoints
- **العملاء:** 2 endpoints
- **لوحة التحكم:** 5 endpoints
- **الكوبونات:** 4 endpoints
- **الشحن:** 5 endpoints
- **الإشعارات:** 3 endpoints
- **الإعدادات:** 7 endpoints

---

تم إنشاء هذا الملف بناءً على تحليل كامل لتطبيق Flutter الخاص بمتجر انمكا.
