/// Login Request Model
class LoginRequest {
  final String email;
  final String password;

  LoginRequest({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
  };
}

/// Login Response Model
class LoginResponse {
  final bool success;
  final String message;
  final AuthData? data;
  final int? statusCode;
  final String? errorMessage;

  LoginResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
    this.errorMessage,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
      statusCode: json['statusCode'],
      errorMessage: json['errorMessage'],
    );
  }
}

/// Authentication Data Model
class AuthData {
  final String token;

  AuthData({
    required this.token,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
  };
}

/// User Model
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profileImage'] ?? json['profile_image'],
      role: json['role'] ?? 'user',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'profileImage': profileImage,
    'role': role,
  };
}
