# 📁 Project Structure Overview

## Complete File Tree

```
real_estate_crm/
│
├── lib/
│   ├── main.dart                          🔴 APP ENTRY POINT
│   │
│   ├── config/
│   │   ├── app_config.dart                ⚙️ Global API URLs & Constants
│   │   └── app_pages.dart                 🗺️ Routes & Navigation
│   │
│   ├── services/
│   │   ├── api_service.dart               🌐 Dio HTTP Client + Interceptors
│   │   └── storage_service.dart           💾 Local Storage Management
│   │
│   ├── controllers/
│   │   ├── auth_controller.dart           🔐 Authentication Logic
│   │   ├── dashboard_controller.dart      📊 Dashboard Logic
│   │   └── menu_controller.dart           📋 Menu Navigation Logic
│   │
│   ├── models/
│   │   ├── auth_models.dart               👤 Login, User Models
│   │   └── dashboard_models.dart          📈 Dashboard, Enquiry Models
│   │
│   ├── screens/
│   │   ├── login_screen.dart              🔐 Login UI
│   │   └── dashboard_screen.dart          📊 Dashboard UI
│   │
│   ├── widgets/
│   │   └── (create reusable UI components here)
│   │
│   ├── bindings/
│   │   └── app_binding.dart               🔗 Dependency Injection
│   │
│   └── utils/
│       ├── constants.dart                 ⚡ App Constants
│       └── validators.dart                ✅ Form Validators
│
├── android/
│   ├── app/
│   │   └── build.gradle                   🤖 Android Build Config
│   └── ...
│
├── ios/
│   └── ...                                 🍎 iOS Configuration
│
├── assets/
│   ├── images/                            🖼️ App Images
│   └── fonts/                             🔤 Custom Fonts
│
├── pubspec.yaml                           📦 Dependencies
│
├── README.md                              📖 Project Overview
├── ARCHITECTURE_GUIDE.md                  🏗️ Detailed Architecture
├── QUICK_START.md                         🚀 Quick Setup
├── IMPLEMENTATION_GUIDE.md                ✅ Next Steps
└── PROJECT_STRUCTURE.md                   📁 This File
```

---

## 🔴 Core Files Explained

### 1. **main.dart** - Entry Point
- ✅ Initialize storage
- ✅ Setup themes
- ✅ Configure routes
- ✅ Initialize bindings

### 2. **app_config.dart** - Global Configuration
```dart
// Update this with your API URL
static const String baseUrl = 'https://your-api.com';
```

### 3. **api_service.dart** - API Client
- ✅ Automatic token injection
- ✅ Global error handling
- ✅ Request/Response logging
- ✅ Auto logout on 401

### 4. **storage_service.dart** - Local Storage
- ✅ Save/Get token
- ✅ Save/Get project ID (global)
- ✅ Save/Get user data
- ✅ Clear all on logout

### 5. **auth_controller.dart** - Authentication
- ✅ Handle login
- ✅ Save token globally
- ✅ Save project ID globally
- ✅ Handle logout

### 6. **dashboard_controller.dart** - Dashboard
- ✅ Fetch dashboard data
- ✅ Use global project ID
- ✅ Manage dashboard state

### 7. **menu_controller.dart** - Navigation
- ✅ Load menu items
- ✅ Handle navigation
- ✅ Default menu fallback

---

## 🔐 Global Data Flow

### After Login

```
┌─────────────────────────────────────────────────┐
│           LOGIN SUCCESSFUL                      │
└────────────────┬────────────────────────────────┘
                 │
      ┌──────────┴──────────┐
      │                     │
      ▼                     ▼
   SAVE TOKEN           SAVE PROJECT_ID
   (StorageService)    (StorageService)
      │                     │
      └──────────┬──────────┘
                 │
      ┌──────────▼──────────────┐
      │   NAVIGATE TO           │
      │   DASHBOARD SCREEN      │
      └──────────┬──────────────┘
                 │
      ┌──────────▼────────────────────────┐
      │   DASHBOARD LOADS DATA            │
      │   Using global PROJECT_ID         │
      │   With auto-injected TOKEN        │
      └────────────────────────────────────┘
```

### Using Global Data

```dart
// In any screen, controller, or service:

// Get Project ID
String? projectId = StorageService.getProjectId();

// Get Token (auto-included in API calls)
String? token = StorageService.getToken();

// Get User Name
String? userName = StorageService.getUserFullName();

// In API requests
final response = await apiService.get(
  '/endpoint',
  queryParameters: {'projectId': projectId}, // Global ID
);
// Token automatically included in header ✅
```

---

## 🌐 API Request/Response Flow

### Example: Login Request

```
┌─────────────────────────────────────────┐
│ 1. LOGIN SCREEN                         │
│    email: user@example.com              │
│    password: ****                       │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ 2. AUTH CONTROLLER                      │
│    authController.login(...)            │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ 3. API SERVICE (Dio)                    │
│    POST /api/v1/auth/login              │
│    Body: {email, password}              │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ 4. API INTERCEPTOR                      │
│    Add: Content-Type header             │
│    (Token not added yet - no auth)      │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ 5. YOUR BACKEND SERVER                  │
│    Validate credentials                 │
│    Generate token                       │
│    Return: {token, projectId, user}    │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ 6. API INTERCEPTOR (Response)           │
│    Return 200 OK                        │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ 7. AUTH CONTROLLER                      │
│    Save token → StorageService          │
│    Save projectId → StorageService      │
│    Save userData → StorageService       │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ 8. NAVIGATE TO DASHBOARD                │
│    All global data ready ✅             │
└─────────────────────────────────────────┘
```

### Example: Dashboard Request (After Login)

```
┌─────────────────────────────────────────┐
│ 1. DASHBOARD SCREEN LOADS               │
│    DashboardController initializes      │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ 2. DASHBOARD CONTROLLER                 │
│    Get projectId from StorageService    │
│    projectId = "proj_123"               │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ 3. API SERVICE                          │
│    GET /api/v1/dashboard                │
│    QueryParam: projectId=proj_123       │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ 4. API INTERCEPTOR                      │
│    Get token from StorageService        │
│    Add: Authorization: Bearer token     │
│    Add: Content-Type header             │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ 5. YOUR BACKEND SERVER                  │
│    Validate token ✅                    │
│    Validate projectId ✅                │
│    Return dashboard data                │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ 6. DASHBOARD CONTROLLER                 │
│    Parse response                       │
│    Update UI with data                  │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│ 7. DASHBOARD SCREEN                     │
│    Display: Stats, Charts, Enquiries   │
└─────────────────────────────────────────┘
```

---

## 📊 Controller Lifecycle

### AuthController
```
App Start
   ↓
_checkLoginStatus() - Restore previous session if exists
   ↓
If token exists → isLoggedIn = true → Go to Dashboard
If token missing → isLoggedIn = false → Go to Login
   ↓
On Login → Save data → Navigate to Dashboard
   ↓
On Logout → Clear all → Navigate to Login
```

### DashboardController
```
Dashboard Screen Mounted
   ↓
onInit() → fetchDashboardData()
   ↓
Get projectId from StorageService
   ↓
Call API with projectId
   ↓
Parse response → Update UI
   ↓
User refreshes → refreshDashboard()
   ↓
Same flow repeats
```

---

## 🔄 State Management (GetX)

### Reactive Variables

```dart
// In any controller:

var isLoading = false.obs;              // Observable boolean
var projectId = Rx<String?>(null);      // Observable with generic
var items = Rx<List<Item>?>(null);      // Observable list

// In UI:
Obx(() => Text('Loading: ${isLoading.value}')),

// Update anywhere:
isLoading.value = true;
projectId.value = 'proj_123';
```

---

## ✅ Setup Checklist

Before running the app:

- [ ] Copy all files to lib folder
- [ ] Add dependencies to pubspec.yaml
- [ ] Update API URL in app_config.dart
- [ ] Create project directories
- [ ] Run: flutter pub get
- [ ] Run: flutter run

---

## 🚀 Quick Start Commands

```bash
# Create project
flutter create real_estate_crm

# Navigate
cd real_estate_crm

# Get dependencies
flutter pub get

# Run app
flutter run

# Run with logs
flutter run -v

# Build APK
flutter build apk --release

# Build AAB
flutter build appbundle --release

# Clean build
flutter clean
flutter pub get
flutter run
```

---

## 📞 File Locations Guide

```
Want to...                              File to Edit
────────────────────────────────────────────────────────────
Change API URL                    → lib/config/app_config.dart
Change app theme colors           → lib/main.dart
Modify login screen               → lib/screens/login_screen.dart
Modify dashboard screen           → lib/screens/dashboard_screen.dart
Add authentication logic          → lib/controllers/auth_controller.dart
Add dashboard logic               → lib/controllers/dashboard_controller.dart
Change local storage behavior     → lib/services/storage_service.dart
Add/modify API endpoints          → lib/models/
Create new screen                 → lib/screens/new_screen.dart
Add new controller                → lib/controllers/new_controller.dart
Configure routes                  → lib/config/app_pages.dart
Add dependencies                  → pubspec.yaml
```

---

## 📖 Documentation Files

| File | Purpose |
|------|---------|
| README.md | Project overview & setup |
| ARCHITECTURE_GUIDE.md | Detailed architecture explanation |
| QUICK_START.md | 5-minute quick setup |
| IMPLEMENTATION_GUIDE.md | Next steps & development guide |
| PROJECT_STRUCTURE.md | This file - project structure |

---

## 🎓 Learning Path

1. **Day 1:** Read README.md & QUICK_START.md
2. **Day 2:** Read ARCHITECTURE_GUIDE.md
3. **Day 3:** Update API URLs & test login
4. **Day 4:** Customize UI with your branding
5. **Day 5:** Create new screens (Enquiries, Projects, etc.)
6. **Day 6:** Implement additional features
7. **Day 7:** Test & Deploy

---

**Ready to build? Start with QUICK_START.md! 🚀**
