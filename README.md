# 🏠 Real Estate CRM - Mobile Application

A production-ready Flutter mobile application for managing real estate enquiries. Built with modern architecture patterns and best practices.

![Flutter](https://img.shields.io/badge/Flutter-3.2%2B-blue)
![Dart](https://img.shields.io/badge/Dart-3.2%2B-blue)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📋 Features

✅ **Authentication System**
- Email/Password login
- Auto token storage
- Remember me functionality
- Secure logout

✅ **Global Configuration**
- Centralized API URL management
- Environment-based configuration (Dev/Staging/Production)
- Global Project ID storage after login
- Automatic token injection in all API requests

✅ **Dashboard**
- Real-time analytics
- Enquiry statistics
- Recent enquiries list
- Conversion rate tracking

✅ **Navigation**
- Drawer-based menu
- Easy route management
- Default fallback menu

✅ **API Integration**
- Dio HTTP client with interceptors
- Global error handling
- Automatic logout on token expiry (401)
- Request/Response logging

✅ **Local Storage**
- User authentication data
- Project ID persistence
- User preferences

---

## 🏗️ Architecture

### MVVM + GetX + Clean Architecture

```
UI Layer (Screens)
    ↓
Controller Layer (GetX - State Management)
    ↓
Service Layer (API, Storage)
    ↓
Data Layer (Models, API Endpoints)
```

**Why this architecture?**
- Scalable for large applications
- Easy to test and maintain
- Beginner-friendly with GetX
- Production-ready pattern

---

## 📂 Project Structure

```
lib/
├── main.dart                      # App entry point
├── config/
│   ├── app_config.dart           # Global API URLs & constants
│   └── app_pages.dart            # Routes & navigation
├── services/
│   ├── api_service.dart          # Dio HTTP client with interceptors
│   └── storage_service.dart      # Local storage management
├── controllers/
│   ├── auth_controller.dart      # Authentication logic
│   ├── dashboard_controller.dart # Dashboard logic
│   └── menu_controller.dart      # Menu navigation logic
├── models/
│   ├── auth_models.dart          # Auth models (Login, User)
│   └── dashboard_models.dart     # Dashboard models (Stats, Enquiries)
├── screens/
│   ├── login_screen.dart         # Login UI
│   ├── dashboard_screen.dart     # Dashboard UI
│   └── menu_screen.dart          # Menu UI (optional)
├── widgets/
│   └── common_widgets.dart       # Reusable UI components
├── bindings/
│   └── app_binding.dart          # Dependency injection
└── utils/
    ├── constants.dart            # App constants
    └── validators.dart           # Form validators
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.2.0 or higher
- Dart 3.2.0 or higher
- Android Studio / Xcode (for emulator)

### Installation

1. **Create Flutter Project**
   ```bash
   flutter create real_estate_crm
   cd real_estate_crm
   ```

2. **Add Dependencies**
   ```bash
   flutter pub add get get_storage dio connectivity_plus
   ```

3. **Copy Project Files**
   - Copy all files from this project into your Flutter project

4. **Update API Configuration**
   - Open `lib/config/app_config.dart`
   - Update `baseUrl` to your API server

   ```dart
   static const String baseUrl = 'https://your-api.com';
   ```

5. **Run the App**
   ```bash
   flutter run
   ```

---

## 📱 Login Workflow

```
1. User enters email & password
        ↓
2. App sends POST request to /api/v1/auth/login
        ↓
3. API returns: {token, projectId, userData}
        ↓
4. App saves:
   • Token → StorageService (used in all API requests)
   • ProjectId → StorageService (global access)
   • UserData → StorageService
        ↓
5. Navigate to Dashboard
        ↓
6. Dashboard fetches data using global projectId
```

---

## 🌐 API Integration

### Global API Configuration

**File:** `lib/config/app_config.dart`

```dart
class AppConfig {
  static const String baseUrl = 'https://api.example.com';
  static const String loginEndpoint = '$apiVersion/auth/login';
  static const String dashboardEndpoint = '$apiVersion/dashboard';
}
```

### API Interceptor

Automatically:
- ✅ Injects authentication token in all requests
- ✅ Handles response parsing
- ✅ Manages errors globally
- ✅ Auto-logs out on 401 (Unauthorized)

### Making API Calls

```dart
final apiService = Get.find<ApiService>();

// GET request
final response = await apiService.get('/endpoint');

// POST request
final response = await apiService.post(
  '/endpoint',
  data: {'key': 'value'},
);
```

---

## 🔐 Global State Management

### Accessing Global Data Anywhere

```dart
// Get Project ID
String projectId = StorageService.getProjectId();

// Get Authentication Token
String? token = StorageService.getToken();

// Get User Information
String? userName = StorageService.getUserFullName();
String? email = StorageService.getUserEmail();

// From AuthController
final authController = Get.find<AuthController>();
String? projectId = authController.getProjectId();
```

### Using Global Project ID in API Calls

```dart
// Automatically included with global storage
String? projectId = StorageService.getProjectId();

final response = await apiService.get(
  '/enquiries',
  queryParameters: {'projectId': projectId},
);
```

---

## 📊 Dashboard API Response Format

**Request:**
```
GET /api/v1/dashboard?projectId=proj_123
Header: Authorization: Bearer token_here
```

**Expected Response:**
```json
{
  "success": true,
  "data": {
    "totalEnquiries": 150,
    "openEnquiries": 45,
    "closedEnquiries": 105,
    "conversionRate": 70.0,
    "recentEnquiries": [
      {
        "id": "enq_1",
        "clientName": "John Doe",
        "propertyType": "2BHK Apartment",
        "status": "open",
        "createdAt": "2024-01-15"
      }
    ],
    "stats": [...]
  }
}
```

---

## 🎨 Customization

### Change App Colors

**File:** `lib/main.dart`

```dart
theme: ThemeData(
  primaryColor: Color(0xff1E3A8A),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xff1E3A8A),
  ),
),
```

### Update App Name

**File:** `pubspec.yaml`
```yaml
name: real_estate_crm
description: "Your app description"
```

### Add App Logo

1. Place logo in `assets/images/logo.png`
2. Update `pubspec.yaml`:
   ```yaml
   assets:
     - assets/images/logo.png
   ```
3. Use in screens:
   ```dart
   Image.asset('assets/images/logo.png')
   ```

---

## 📦 Deployment

### Android (Play Store)

1. **Generate Signing Key**
   ```bash
   keytool -genkey -v -keystore ~/real_estate_key.jks \
     -keyalg RSA -keysize 2048 -validity 10000 \
     -alias real-estate-key
   ```

2. **Update Build Configuration**
   Edit `android/app/build.gradle`

3. **Build AAB** (Recommended)
   ```bash
   flutter build appbundle --release
   ```

4. **Upload to Play Store**

### iOS (App Store)

1. **Build Release IPA**
   ```bash
   flutter build ios --release
   ```

2. **Archive and Upload**
   - Use Xcode Organizer
   - Upload to App Store

---

## 🧪 Testing

### Test Login (Example)
```dart
test('Login should save token', () async {
  final authController = AuthController();
  await authController.login(
    email: 'test@example.com',
    password: 'password',
    rememberMe: false,
  );
  expect(StorageService.getToken(), isNotNull);
});
```

---

## 📚 Documentation

- **[Architecture Guide](ARCHITECTURE_GUIDE.md)** - Detailed architecture explanation
- **[Quick Start Guide](QUICK_START.md)** - 5-minute setup guide

---

## 🔧 Troubleshooting

### App crashes on startup
```bash
flutter clean
flutter pub get
flutter run
```

### Login fails
- Check API URL in `app_config.dart`
- Ensure backend server is running
- Verify request format matches API

### Project ID not saving
- Check API response includes `projectId`
- Verify StorageService initialization

### Navigation errors
- Verify route names in `app_pages.dart`
- Check route names match GetX navigation calls

---

## 🤝 Contributing

Contributions welcome! Please follow these steps:
1. Fork the repository
2. Create feature branch
3. Make changes
4. Submit pull request

---

## 📄 License

This project is licensed under the MIT License - see LICENSE file for details.

---

## 👤 Support

For issues and questions:
- Open an issue on GitHub
- Check documentation in `ARCHITECTURE_GUIDE.md`
- Review `QUICK_START.md`

---

## 🎓 Resources

- [Flutter Documentation](https://flutter.dev)
- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Dio HTTP Client](https://github.com/flutterchina/dio)

---

## 🚀 Next Steps

After setup:
1. ✅ Update API base URL
2. ✅ Customize UI with your branding
3. ✅ Add enquiry management screens
4. ✅ Implement search functionality
5. ✅ Add image upload feature
6. ✅ Setup Firebase Cloud Messaging
7. ✅ Deploy to Play Store & App Store

---

**Happy coding! Build amazing real estate CRM apps with Flutter 🎯**
