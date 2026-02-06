class MemberModel {
  final int id;
  final String email;
  final String username;
  final String phone;
  final String role; // 'member' or 'supervisor'
  final String? location;
  final String? photoProfile;
  final int? departmentId;
  final DateTime createdAt;
  final DateTime updatedAt;

  MemberModel({
    required this.id,
    required this.email,
    required this.username,
    required this.phone,
    required this.role,
    this.location,
    this.photoProfile,
    this.departmentId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as int,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      role: json['role'] as String? ?? 'member',
      location: json['location'] as String?,
      photoProfile: json['photo_profile'] as String?,
      departmentId: json['department_id'] as int?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'phone': phone,
      'role': role,
      'location': location,
      'photo_profile': photoProfile,
      'department_id': departmentId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Get display name
  String get displayName => username;

  /// Get avatar URL
  String? get avatarUrl => photoProfile;

  /// Get user type for display (capitalize first letter)
  String get userType => role[0].toUpperCase() + role.substring(1);

  /// Get department (placeholder since API doesn't provide department name)
  String get department => location ?? 'Unknown';

  /// Check if this user is a supervisor
  bool get isSupervisor => role == 'supervisor';

  /// Check if this user is a member
  bool get isMember => role == 'member';
}
