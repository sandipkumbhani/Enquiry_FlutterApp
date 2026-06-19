# 🚀 Quick Start Guide - Real Estate CRM Flutter App

## 5-Minute Setup

### 1. Clone/Create Project
```bash
flutter create real_estate_crm
cd real_estate_crm
```

### 2. Add Dependencies
Copy this to `pubspec.yaml` under `dependencies`:
```yaml
get: ^4.6.6
get_storage: ^2.1.1
dio: ^5.3.1
connectivity_plus: ^5.0.1
shared_preferences: ^2.2.2
intl: ^0.19.0
```

Run:
```bash
flutter pub get
```

### 3. Set Your API URL
Open `lib/config/app_config.dart` and update:
```dart
static const String baseUrl = 'https://YOUR_API_URL.com';
```

### 4. Run the App
```bash
flutter run
```

---

## 📱 Default Login Credentials (for testing)
```
Email: test@example.com
Password: password123
```

---

## 🔑 Key Features Ready to Use

### 1. **Login**
- Auto-saves token
- Auto-saves Project ID globally
- Remember me option
- Error handling

### 2. **Dashboard**
- Shows analytics
- Lists recent enquiries
- Displays global project ID
- Refresh functionality

### 3. **Menu Navigation**
- Drawer menu
- Auto-logout
- Menu from API

### 4. **Global API Configuration**
- Centralized URLs
- Auto token injection
- Global error handling
- Auto-logout on 401

### 5. **Local Storage**
- Token persistence
- Project ID persistence
- User data storage
- Remember me

---

## 🎯 Important Files to Modify

### 1. Update API Base URL
**File:** `lib/config/app_config.dart`
```dart
static const String baseUrl = 'https://your-api.com';
static const String loginEndpoint = '/api/v1/auth/login';
static const String dashboardEndpoint = '/api/v1/dashboard';
```

### 2. Customize Colors
**File:** `lib/main.dart`
```dart
theme: ThemeData(
  primaryColor: Color(0xff1E3A8A),
  // Change colors here
),
```

### 3. Modify Login Screen
**File:** `lib/screens/login_screen.dart`
- Add your logo
- Update text
- Change colors

### 4. Customize Dashboard
**File:** `lib/screens/dashboard_screen.dart`
- Add your widgets
- Modify layout
- Update styling

---

## 📊 API Response Format Expected

### Login Response
```json
{
  "success": true,
  "data": {
    "token": "your-jwt-token",
    "projectId": "proj_123",
    "user": {
      "id": "user_1",
      "name": "John Doe",
      "email": "john@example.com",
      "phone": "9876543210",
      "role": "admin"
    }
  }
}
```

### Dashboard Response
```json
{
  "success": true,
  "data": {
    "totalEnquiries": 150,
    "openEnquiries": 45,
    "closedEnquiries": 105,
    "conversionRate": 70.0,
    "recentEnquiries": [...],
    "stats": [...]
  }
}
```

---

## 🛠️ Common Development Tasks

### Add New Screen

1. Create screen file in `lib/screens/`:
```dart
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Screen')),
      body: Container(),
    );
  }
}
```

2. Add route in `lib/config/app_pages.dart`:
```dart
GetPage(
  name: '/myscreen',
  page: () => MyScreen(),
),
```

3. Navigate from anywhere:
```dart
Get.toNamed('/myscreen');
```

### Use Global Data

```dart
// Get Project ID
String projectId = StorageService.getProjectId() ?? '';

// Get Token
String? token = StorageService.getToken();

// Get User Name
String userName = StorageService.getUserFullName() ?? 'User';
```

### Make API Call with Project ID

```dart
final apiService = Get.find<ApiService>();

final response = await apiService.get(
  '/api/v1/enquiries',
  queryParameters: {'projectId': StorageService.getProjectId()},
);

if (response['success']) {
  print('Data: ${response['data']}');
}
```

### Show Error/Success Messages

```dart
// Error (automatic)
Get.snackbar('Error', 'Something went wrong',
  backgroundColor: Colors.red,
);

// Success
Get.snackbar('Success', 'Operation completed',
  backgroundColor: Colors.green,
);
```

---

## 🔐 Login Flow Example

```
1. User clicks Login
2. App sends: email + password to /api/v1/auth/login
3. API returns: token + projectId + user data
4. App saves:
   - Token → StorageService
   - ProjectId → StorageService (globally accessible)
   - UserData → StorageService
5. Navigate to Dashboard
6. Dashboard auto-calls /api/v1/dashboard with projectId
```

---

## 📦 Project Structure at a Glance

```
lib/
├── main.dart                 ← App entry point
├── config/
│   ├── app_config.dart      ← API URLs & constants
│   └── app_pages.dart       ← Routes & navigation
├── services/
│   ├── api_service.dart     ← HTTP client
│   └── storage_service.dart ← Local storage
├── controllers/
│   ├── auth_controller.dart        ← Login/Logout
│   ├── dashboard_controller.dart   ← Dashboard logic
│   └── menu_controller.dart        ← Menu logic
├── models/
│   ├── auth_models.dart     ← User models
│   └── dashboard_models.dart ← Dashboard models
├── screens/
│   ├── login_screen.dart    ← Login UI
│   └── dashboard_screen.dart ← Dashboard UI
├── widgets/                 ← Reusable UI components
├── bindings/
│   └── app_binding.dart     ← Dependency injection
└── utils/                   ← Utilities & helpers
```

---

## ✅ Checklist Before Deployment

- [ ] Update API base URL in `app_config.dart`
- [ ] Add app logo in `assets/images/`
- [ ] Test login with real API
- [ ] Test dashboard API calls
- [ ] Update app name in `pubspec.yaml`
- [ ] Add app icon for Android & iOS
- [ ] Test on real device
- [ ] Add privacy policy
- [ ] Generate signed APK/AAB for Play Store
- [ ] Generate IPA for App Store

---

## 🎓 Next Learning Steps

1. **Explore Controllers** - Understand state management in `lib/controllers/`
2. **Customize API Endpoints** - Modify `lib/config/app_config.dart`
3. **Add New Screens** - Follow screen creation pattern
4. **Implement Enquiry Management** - Create enquiry screens
5. **Add Offline Support** - Cache API responses locally
6. **Implement Push Notifications** - Add Firebase Cloud Messaging

---

## 🆘 Troubleshooting

### **Issue:** App crashes on startup
**Solution:** Make sure all dependencies are installed:
```bash
flutter clean
flutter pub get
flutter run
```

### **Issue:** Login fails
**Solution:** Check API URL in `app_config.dart` and ensure server is running

### **Issue:** Project ID not saving
**Solution:** Check API response includes `projectId` field

### **Issue:** Navigation not working
**Solution:** Verify route names in `app_pages.dart` match GetX.toNamed() calls

---

## 📞 Resources

- **Flutter Docs:** https://flutter.dev
- **GetX Docs:** https://github.com/jonataslaw/getx
- **Dio Docs:** https://github.com/flutterchina/dio
- **Architecture Guide:** See `ARCHITECTURE_GUIDE.md`

---

**Ready to develop? Let's go! 🎯**
