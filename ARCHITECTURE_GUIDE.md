# Flutter Real Estate CRM - Project Architecture Guide

## 📋 Table of Contents
1. [Project Overview](#project-overview)
2. [Architecture Pattern](#architecture-pattern)
3. [Folder Structure](#folder-structure)
4. [Setup Instructions](#setup-instructions)
5. [Global Configuration](#global-configuration)
6. [State Management](#state-management)
7. [API Integration](#api-integration)
8. [Screens & Navigation](#screens--navigation)
9. [Deployment Guide](#deployment-guide)
10. [Best Practices](#best-practices)

---

## 📱 Project Overview

**Real Estate CRM Mobile Application** - An enquiry management system for the real estate industry.

**Key Features:**
- User Authentication (Login/Logout)
- Global API configuration
- Global Project ID storage after login
- Dashboard with analytics
- Menu navigation
- Enquiry management
- Production-ready architecture

**Target Platforms:** iOS (App Store) & Android (Play Store)

---

## 🏗️ Architecture Pattern

### MVVM + GetX + Clean Architecture

**Why this architecture?**
- ✅ Beginner-friendly with GetX's built-in features
- ✅ Scalable for enterprise apps
- ✅ Easy state management
- ✅ Excellent for production apps

### Architecture Layers:

```
┌─────────────────────────────────────┐
│        UI LAYER (Screens)           │
│  - LoginScreen                      │
│  - DashboardScreen                  │
│  - MenuScreen                       │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│   CONTROLLER LAYER (GetX)           │
│  - AuthController                   │
│  - DashboardController              │
│  - MenuController                   │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│    SERVICE LAYER (Business Logic)   │
│  - ApiService (Dio + Interceptors)  │
│  - StorageService                   │
│  - AuthService                      │
└────────────────┬────────────────────┘
                 │
┌────────────────▼────────────────────┐
│      DATA LAYER (API/Local DB)      │
│  - API Endpoints                    │
│  - Local Storage (GetStorage)       │
│  - Models                           │
└─────────────────────────────────────┘
```

---

## 📂 Folder Structure

```
lib/
├── main.dart                    # Entry point
├── config/
│   ├── app_config.dart         # Global API URLs & Constants
│   └── app_pages.dart          # Routes & Navigation
├── services/
│   ├── api_service.dart        # Dio HTTP client with interceptors
│   └── storage_service.dart    # Local storage management
├── controllers/
│   ├── auth_controller.dart    # Authentication logic
│   ├── dashboard_controller.dart # Dashboard logic
│   └── menu_controller.dart    # Menu logic
├── models/
│   ├── auth_models.dart        # Auth request/response models
│   └── dashboard_models.dart   # Dashboard models
├── screens/
│   ├── login_screen.dart       # Login UI
│   └── dashboard_screen.dart   # Dashboard UI
├── widgets/
│   └── common_widgets.dart     # Reusable widgets
├── bindings/
│   └── app_binding.dart        # Dependency injection
└── utils/
    ├── constants.dart
    └── validators.dart
```

---

## 🚀 Setup Instructions

### Step 1: Prerequisites
```bash
Flutter SDK >= 3.2.0
Dart SDK >= 3.2.0
Android Studio / Xcode (for emulator)
```

### Step 2: Create Flutter Project
```bash
flutter create real_estate_crm
cd real_estate_crm
```

### Step 3: Add Dependencies
Update `pubspec.yaml` with:
```yaml
dependencies:
  get: ^4.6.6              # State Management & Routing
  get_storage: ^2.1.1      # Local Storage
  dio: ^5.3.1              # HTTP Client
  connectivity_plus: ^5.0.1 # Network detection
```

### Step 4: Get Dependencies
```bash
flutter pub get
```

### Step 5: Generate Project Structure
Create folders as per folder structure above.

### Step 6: Copy Files
Copy all files from this guide into their respective locations.

### Step 7: Run App
```bash
flutter run
```

---

## ⚙️ Global Configuration

### API Configuration
**File:** `lib/config/app_config.dart`

```dart
class AppConfig {
  // Change this to your actual API URL
  static const String baseUrl = 'https://api.example.com';
  
  // API Endpoints
  static const String loginEndpoint = '/api/v1/auth/login';
  static const String dashboardEndpoint = '/api/v1/dashboard';
}
```

### Update for Different Environments
```dart
enum AppEnvironment { development, staging, production }

class EnvironmentConfig {
  static const AppEnvironment environment = AppEnvironment.production;
  
  static String getBaseUrl() {
    switch (environment) {
      case AppEnvironment.development:
        return 'https://dev-api.example.com';
      case AppEnvironment.staging:
        return 'https://staging-api.example.com';
      case AppEnvironment.production:
        return 'https://api.example.com';
    }
  }
}
```

---

## 🔐 Global Storage

### Storing Project ID After Login
The Project ID is automatically stored globally after login.

**In AuthController:**
```dart
// This is called after successful login
await StorageService.setProjectId(authData.projectId);
```

### Accessing Project ID Anywhere
```dart
// Get project ID
String? projectId = StorageService.getProjectId();

// Or from AuthController
String? projectId = Get.find<AuthController>().getProjectId();
```

### Accessing Token Anywhere
```dart
String? token = StorageService.getToken();
```

### User Data Access
```dart
// Get user full name
String? fullName = StorageService.getUserFullName();

// Get user email
String? email = StorageService.getUserEmail();

// Get all user data
Map<String, dynamic>? userData = StorageService.getUserData();
```

---

## 🎛️ State Management (GetX)

### AuthController - Authentication Management

**File:** `lib/controllers/auth_controller.dart`

**Features:**
- Login with email/password
- Automatic token saving
- Project ID storage
- Logout functionality

**Usage:**
```dart
// In any screen
final authController = Get.find<AuthController>();

// Login
await authController.login(
  email: 'user@example.com',
  password: 'password123',
  rememberMe: true,
);

// Get current user
String? userName = authController.getUserName();

// Get project ID
String? projectId = authController.getProjectId();

// Logout
await authController.logout();

// Observe login state
Obx(() {
  if (authController.isLoggedIn.value) {
    // User is logged in
  }
}),
```

### DashboardController - Dashboard Management

**File:** `lib/controllers/dashboard_controller.dart`

**Features:**
- Fetch dashboard data with global project ID
- Refresh data
- Analytics data

**Usage:**
```dart
final dashboardController = Get.find<DashboardController>();

// Fetch data (auto-called on init)
await dashboardController.fetchDashboardData();

// Refresh
await dashboardController.refreshDashboard();

// Get data
int total = dashboardController.getTotalEnquiries();
int open = dashboardController.getOpenEnquiries();

// Observe data
Obx(() {
  if (dashboardController.isLoading.value) {
    // Loading...
  }
}),
```

### MenuController - Navigation Management

**File:** `lib/controllers/menu_controller.dart`

**Features:**
- Load menu items from API
- Navigate between screens
- Fallback default menu

**Usage:**
```dart
final menuController = Get.find<MenuController>();

// Load menu
await menuController.loadMenuItems();

// Navigate
menuController.navigateToMenuItem(menuItem);

// Get menu items
List<MenuItem>? items = menuController.menuItems.value;
```

---

## 🌐 API Integration

### API Service with Interceptors

**File:** `lib/services/api_service.dart`

**Features:**
- Automatic token inclusion in headers
- Global error handling
- Timeout management
- Auto logout on 401 (Unauthorized)

### Making API Calls

```dart
final apiService = Get.find<ApiService>();

// GET Request
final response = await apiService.get('/endpoint');

// POST Request
final response = await apiService.post(
  '/endpoint',
  data: {'key': 'value'},
);

// PUT Request
final response = await apiService.put(
  '/endpoint',
  data: {'key': 'value'},
);

// DELETE Request
final response = await apiService.delete('/endpoint');
```

### Response Handling

```dart
final response = await apiService.get('/endpoint');

if (response['success']) {
  final data = response['data'];
  // Handle success
} else {
  final error = response['message'];
  // Handle error
}
```

### Custom Error Messages

```dart
// Show error (default)
await apiService.get('/endpoint');

// Hide error
await apiService.get('/endpoint', showError: false);
```

---

## 🗺️ Screens & Navigation

### Navigation Using GetX

```dart
// Navigate to screen
Get.toNamed('/dashboard');

// Navigate and replace (no back button)
Get.offNamed('/login');

// Navigate and remove all previous routes
Get.offAllNamed('/dashboard');

// Navigate with arguments
Get.toNamed('/details', arguments: {'id': '123'});
```

### Available Routes
- `/splash` - Splash Screen
- `/login` - Login Screen
- `/dashboard` - Dashboard Screen
- `/menu` - Menu Screen
- `/enquiries` - Enquiries Screen
- `/projects` - Projects Screen
- `/reports` - Reports Screen
- `/settings` - Settings Screen

### Creating New Screens

1. Create screen in `lib/screens/`:
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
  name: AppRoutes.myRoute,
  page: () => MyScreen(),
  binding: MyBinding(),
),
```

3. Create binding in `lib/bindings/`:
```dart
class MyBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MyController());
  }
}
```

---

## 📦 API Response Models

### Login Response Example

**API Call:**
```dart
POST /api/v1/auth/login
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIs...",
    "projectId": "proj_123456",
    "user": {
      "id": "user_123",
      "name": "John Doe",
      "email": "user@example.com",
      "phone": "9876543210",
      "profileImage": "https://...",
      "role": "admin"
    }
  }
}
```

### Dashboard Response Example

**API Call:**
```dart
GET /api/v1/dashboard?projectId=proj_123456
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
        "clientName": "Raj Kumar",
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

## 🔐 Authentication Flow

### Login Flow

```
1. User enters email & password
   ↓
2. LoginScreen calls authController.login()
   ↓
3. AuthController makes POST request to /auth/login
   ↓
4. API returns token, projectId, and user data
   ↓
5. Token saved to StorageService
6. ProjectId saved globally
7. User data saved
   ↓
8. Navigate to Dashboard
   ↓
9. DashboardController loads data using global projectId
```

### Post-Login Data Access

```
// In any screen after login:

// Get token automatically added to requests
// Get project ID
String projectId = StorageService.getProjectId();

// Make API call - token included automatically
final response = await apiService.get(
  '/enquiries',
  queryParameters: {'projectId': projectId},
);
```

### Automatic Logout on Token Expiry

If API returns 401 (Unauthorized):
1. ApiInterceptor catches 401 error
2. Calls `_handleUnauthorized()`
3. Clears all stored data
4. Redirects to login screen
5. User needs to login again

---

## 🎨 UI Customization

### Color Scheme
Primary color: `#1E3A8A` (Dark Blue)
Accent color: `#3B82F6` (Light Blue)

Modify in `main.dart`:
```dart
theme: ThemeData(
  primaryColor: Color(0xff1E3A8A),
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xff1E3A8A),
  ),
),
```

### Typography
Font: Roboto (configured in `pubspec.yaml`)

Apply custom fonts:
```dart
Text(
  'Hello',
  style: TextStyle(
    fontFamily: 'Roboto',
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
)
```

---

## 🚀 Deployment Guide

### For Android (Play Store)

1. **Generate Signing Key:**
```bash
keytool -genkey -v -keystore ~/real_estate_key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias real-estate-key
```

2. **Update Build Configuration:**
Edit `android/app/build.gradle`:
```gradle
signingConfigs {
    release {
        keyAlias "real-estate-key"
        keyPassword "your_password"
        storeFile file("/path/to/real_estate_key.jks")
        storePassword "your_password"
    }
}
```

3. **Build Release APK:**
```bash
flutter build apk --release
```

4. **Build AAB (Recommended):**
```bash
flutter build appbundle --release
```

5. **Upload to Play Store:**
- Go to Google Play Console
- Create new app
- Upload AAB file
- Add screenshots, description, etc.

### For iOS (App Store)

1. **Update App Info:**
Edit `ios/Runner/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>Real Estate CRM</string>
<key>CFBundleVersion</key>
<string>1</string>
```

2. **Build Release IPA:**
```bash
flutter build ios --release
```

3. **Archive in Xcode:**
```bash
cd ios
xcodebuild -workspace Runner.xcworkspace -scheme Runner \
  -configuration Release -archivePath build/Runner.xcarchive \
  archive
```

4. **Upload to App Store:**
- Use Application Loader
- Or use Xcode > Organizer > Upload

---

## ✅ Best Practices

### 1. Error Handling
```dart
try {
  final response = await apiService.post('/endpoint', data: data);
  if (response['success']) {
    // Success
  } else {
    print('Error: ${response['message']}');
  }
} catch (e) {
  print('Exception: $e');
}
```

### 2. Loading States
```dart
Obx(() {
  if (controller.isLoading.value) {
    return LoadingWidget();
  }
  if (controller.errorMessage.value != null) {
    return ErrorWidget(message: controller.errorMessage.value);
  }
  return ContentWidget();
}),
```

### 3. Token Management
- Always use `StorageService.getToken()` to get current token
- Never hardcode tokens
- Clear token on logout
- Handle token refresh

### 4. Project ID Usage
- Always include projectId in API requests
- Use globally stored projectId from `StorageService`
- Pass as query parameter or request body

### 5. API Security
- Always use HTTPS
- Validate SSL certificates
- Don't log sensitive data
- Implement rate limiting
- Use API key for additional security

### 6. State Management
- Use Obx() for reactive updates
- Don't overuse GetX - use for global state only
- Initialize controllers in Bindings
- Use .value property to update observables

### 7. Code Organization
- Keep controllers lean - put logic in services
- One model per file
- Group related screens in subfolders
- Use meaningful naming conventions

### 8. Testing
```dart
// Unit test example
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

## 📝 Common Issues & Solutions

### Issue: Token not included in API requests
**Solution:** Check if token is saved in StorageService after login
```dart
String? token = StorageService.getToken();
print('Token: $token');
```

### Issue: Project ID is null
**Solution:** Ensure API response includes projectId
```json
{
  "data": {
    "projectId": "proj_123"
  }
}
```

### Issue: Pages not found error
**Solution:** Check route names in `app_pages.dart` match usage
```dart
// Correct
Get.toNamed('/dashboard');

// Wrong
Get.toNamed('dashboard'); // Missing /
```

### Issue: Controller not found
**Solution:** Ensure binding is initialized
```dart
GetPage(
  name: '/page',
  page: () => MyPage(),
  binding: MyBinding(), // Don't forget!
),
```

---

## 🎓 Next Steps

1. **Customize Login Screen** - Add company logo, colors
2. **Create Enquiries Screen** - List and manage enquiries
3. **Add Search Functionality** - Search enquiries
4. **Implement Reports** - Analytics and reports
5. **Add Offline Support** - Cache API responses
6. **Push Notifications** - Firebase Cloud Messaging
7. **Image Upload** - Profile pictures, documents
8. **Dark Mode** - Theme switching

---

## 📞 Support

For more information:
- [Flutter Documentation](https://flutter.dev/docs)
- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Dio Documentation](https://github.com/flutterchina/dio)

---

**Happy Coding! 🚀**
