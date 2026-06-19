# 🔗 API Integration Guide

## Backend API Requirements

Your backend server needs to provide these endpoints for the app to work properly.

---

## 1. Authentication Endpoints

### Login Endpoint

**Request:**
```
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "projectId": "proj_123456",
    "user": {
      "id": "user_001",
      "name": "John Doe",
      "email": "user@example.com",
      "phone": "+91-9876543210",
      "profileImage": "https://example.com/profile.jpg",
      "role": "admin"
    }
  }
}
```

**Error Response (401):**
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

**Key Fields:**
- `token` - JWT token to be included in all future requests
- `projectId` - Unique project identifier (stored globally)
- `user` - User information
- **Important:** Token is auto-saved and auto-included in all requests

---

### Logout Endpoint

**Request:**
```
POST /api/v1/auth/logout
Authorization: Bearer {token}
Content-Type: application/json
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

## 2. Dashboard Endpoints

### Get Dashboard Data

**Request:**
```
GET /api/v1/dashboard?projectId=proj_123456
Authorization: Bearer {token}
Content-Type: application/json
```

**Success Response (200):**
```json
{
  "success": true,
  "message": "Dashboard data retrieved",
  "data": {
    "totalEnquiries": 150,
    "openEnquiries": 45,
    "closedEnquiries": 105,
    "conversionRate": 70.0,
    "recentEnquiries": [
      {
        "id": "enq_001",
        "clientName": "Raj Kumar",
        "propertyType": "2BHK Apartment",
        "status": "open",
        "createdAt": "2024-01-15T10:30:00Z"
      },
      {
        "id": "enq_002",
        "clientName": "Priya Singh",
        "propertyType": "3BHK House",
        "status": "closed",
        "createdAt": "2024-01-14T14:20:00Z"
      },
      {
        "id": "enq_003",
        "clientName": "Amit Patel",
        "propertyType": "1BHK Studio",
        "status": "pending",
        "createdAt": "2024-01-13T09:15:00Z"
      }
    ],
    "stats": [
      {
        "label": "New Enquiries",
        "value": 25,
        "percentage": 16.7
      },
      {
        "label": "Follow-ups Pending",
        "value": 15,
        "percentage": 10.0
      },
      {
        "label": "This Week",
        "value": 32,
        "percentage": 21.3
      }
    ]
  }
}
```

**Error Response (401):**
```json
{
  "success": false,
  "message": "Unauthorized - Please login again"
}
```

---

### Get Menu Items

**Request:**
```
GET /api/v1/menu?projectId=proj_123456
Authorization: Bearer {token}
Content-Type: application/json
```

**Success Response (200):**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "1",
        "title": "Dashboard",
        "icon": "home",
        "route": "/dashboard"
      },
      {
        "id": "2",
        "title": "Enquiries",
        "icon": "mail",
        "route": "/enquiries"
      },
      {
        "id": "3",
        "title": "Projects",
        "icon": "folder",
        "route": "/projects"
      },
      {
        "id": "4",
        "title": "Reports",
        "icon": "bar_chart",
        "route": "/reports"
      },
      {
        "id": "5",
        "title": "Settings",
        "icon": "settings",
        "route": "/settings"
      }
    ]
  }
}
```

---

## 3. Enquiry Management Endpoints (Optional - to create)

### List All Enquiries

**Request:**
```
GET /api/v1/enquiries?projectId=proj_123456&status=open&page=1&limit=20
Authorization: Bearer {token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "enquiries": [
      {
        "id": "enq_001",
        "clientName": "Raj Kumar",
        "clientEmail": "raj@example.com",
        "clientPhone": "9876543210",
        "propertyType": "2BHK Apartment",
        "location": "Mumbai",
        "budget": 5000000,
        "status": "open",
        "createdAt": "2024-01-15T10:30:00Z",
        "notes": "Interested in south-facing apartments"
      }
    ],
    "total": 45,
    "page": 1
  }
}
```

### Create New Enquiry

**Request:**
```
POST /api/v1/enquiries
Authorization: Bearer {token}
Content-Type: application/json

{
  "projectId": "proj_123456",
  "clientName": "New Client",
  "clientEmail": "client@example.com",
  "clientPhone": "9876543210",
  "propertyType": "2BHK",
  "location": "Mumbai",
  "budget": 5000000,
  "notes": "Some notes"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Enquiry created successfully",
  "data": {
    "id": "enq_004",
    "clientName": "New Client",
    "...": "..."
  }
}
```

### Update Enquiry

**Request:**
```
PUT /api/v1/enquiries/enq_001
Authorization: Bearer {token}
Content-Type: application/json

{
  "status": "closed",
  "notes": "Updated notes"
}
```

### Delete Enquiry

**Request:**
```
DELETE /api/v1/enquiries/enq_001
Authorization: Bearer {token}
```

---

## 4. HTTP Headers

Every API request from the app will include these headers:

```
Authorization: Bearer {token}
Content-Type: application/json
Accept: application/json
```

**Example Full Request:**
```
GET /api/v1/dashboard?projectId=proj_123456 HTTP/1.1
Host: api.example.com
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
Accept: application/json
```

---

## 5. Error Handling

### 401 Unauthorized (Token Expired)

**Response:**
```json
{
  "statusCode": 401,
  "message": "Token expired or invalid"
}
```

**App Behavior:**
- ✅ Catches 401 automatically
- ✅ Clears all stored data
- ✅ Redirects to login screen
- ✅ Shows message to user

### 400 Bad Request

**Response:**
```json
{
  "success": false,
  "message": "Invalid request parameters"
}
```

### 500 Server Error

**Response:**
```json
{
  "success": false,
  "message": "Internal server error"
}
```

---

## 6. Global Project ID Usage

**Important:** After login, the app receives and stores a `projectId` globally.

This `projectId` must be:
1. ✅ Included in all subsequent API requests
2. ✅ Used to filter user-specific data
3. ✅ Validated on backend for security

**Example Usage in App:**
```dart
// Get global Project ID
String projectId = StorageService.getProjectId();

// Use in API requests
final response = await apiService.get(
  '/enquiries',
  queryParameters: {'projectId': projectId},
);
```

**Backend Validation:**
- ✅ Verify token belongs to the projectId
- ✅ Ensure user has access to this projectId
- ✅ Return only this project's data
- ✅ Prevent data leakage across projects

---

## 7. Token Format

The app expects a **JWT Token** (JSON Web Token).

**Example JWT Structure:**
```
Header:
{
  "alg": "HS256",
  "typ": "JWT"
}

Payload:
{
  "userId": "user_001",
  "projectId": "proj_123456",
  "email": "user@example.com",
  "iat": 1704067800,
  "exp": 1704154200
}

Signature:
HMACSHA256(base64UrlEncode(header) + "." + base64UrlEncode(payload), secret)
```

**Important:**
- ✅ Expires in a reasonable time (e.g., 24 hours)
- ✅ Includes userId for audit trail
- ✅ Includes projectId for validation
- ✅ Signed with secure secret

---

## 8. Response Format Standard

All API responses should follow this format:

```json
{
  "success": true/false,
  "message": "Human readable message",
  "data": {
    // Response specific data
  },
  "errors": [
    {
      "field": "email",
      "message": "Invalid email format"
    }
  ]
}
```

**Success Response:**
```json
{
  "success": true,
  "message": "Operation successful",
  "data": {}
}
```

**Error Response:**
```json
{
  "success": false,
  "message": "Operation failed",
  "errors": []
}
```

---

## 9. CORS Configuration

If backend is on different domain, enable CORS:

```
Access-Control-Allow-Origin: * (or specific domain)
Access-Control-Allow-Methods: GET, POST, PUT, DELETE
Access-Control-Allow-Headers: Content-Type, Authorization
```

---

## 10. Testing the API Integration

### Step 1: Test Login

```bash
curl -X POST https://api.example.com/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "password123"
  }'
```

### Step 2: Test Dashboard (Use token from login)

```bash
curl -X GET "https://api.example.com/api/v1/dashboard?projectId=proj_123456" \
  -H "Authorization: Bearer {your-token}" \
  -H "Content-Type: application/json"
```

---

## 11. Common Integration Issues

### Issue: 404 Not Found
- ✅ Check endpoint URL matches exactly
- ✅ Check method is GET/POST/PUT/DELETE
- ✅ Check app_config.dart has correct baseUrl

### Issue: 401 Unauthorized
- ✅ Check token is included in header
- ✅ Check token hasn't expired
- ✅ Check token belongs to this projectId

### Issue: 403 Forbidden
- ✅ Check user has permission
- ✅ Check projectId is correct
- ✅ Check token validity

### Issue: 500 Internal Server Error
- ✅ Check server logs
- ✅ Check database connectivity
- ✅ Check input validation

---

## 12. Sample Backend Implementation (Node.js/Express)

```javascript
// Login Endpoint
app.post('/api/v1/auth/login', (req, res) => {
  const { email, password } = req.body;
  
  // Validate credentials
  const user = validateUser(email, password);
  
  if (!user) {
    return res.status(401).json({
      success: false,
      message: 'Invalid credentials'
    });
  }
  
  // Generate token
  const token = jwt.sign(
    { userId: user.id, projectId: user.projectId },
    'secret_key',
    { expiresIn: '24h' }
  );
  
  return res.json({
    success: true,
    message: 'Login successful',
    data: {
      token: token,
      projectId: user.projectId,
      user: {
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        role: user.role
      }
    }
  });
});
```

---

## 📞 Support

For API integration questions:
- Check request/response format above
- Verify projectId is included in requests
- Ensure token is included in headers
- Review error responses for debugging

---

**Ready to build the backend? 🚀**
