import '../../core/config/app_config.dart';

class UserModel {
  final int id;
  final String email;
  final String role;
  final String? username;
  final String? phone;
  final String? customerName;
  final String? location;
  final String? photoProfile;
  final int? departmentId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.username,
    this.phone,
    this.customerName,
    this.location,
    this.photoProfile,
    this.departmentId,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
      username: json['username'] as String?,
      phone: json['phone'] as String?,
      customerName: json['customer_name'] as String?,
      location: json['location'] as String?,
      photoProfile: json['photo_profile'] as String?,
      departmentId: json['department_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'username': username,
      'phone': phone,
      'customer_name': customerName,
      'location': location,
      'photo_profile': photoProfile,
      'department_id': departmentId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get display name - prioritas username, lalu email
  String get displayName => username ?? email.split('@')[0];
  
  /// Get avatar URL or return default placeholder
  String get avatarUrl {
    if (photoProfile != null && photoProfile!.isNotEmpty) {
      // Use AppConfig helper to build full URL
      return AppConfig.getProfilePhotoUrl(photoProfile) ?? 
             'https://ui-avatars.com/api/?name=${Uri.encodeComponent(displayName)}&background=003AE6&color=fff&size=200';
    }
    // Return default avatar placeholder
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(displayName)}&background=003AE6&color=fff&size=200';
  }
}
