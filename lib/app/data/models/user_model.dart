class UserModel {
  final int id;
  final String email;
  final String role;
  final String? username;
  final String? customerName;
  final String? location;
  final int? departmentId;

  UserModel({
    required this.id,
    required this.email,
    required this.role,
    this.username,
    this.customerName,
    this.location,
    this.departmentId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      role: json['role'] as String,
      username: json['username'] as String?,
      customerName: json['customer_name'] as String?,
      location: json['location'] as String?,
      departmentId: json['department_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
      'username': username,
      'customer_name': customerName,
      'location': location,
      'department_id': departmentId,
    };
  }

  /// Get display name -优先使用 username, 其次 email
  String get displayName => username ?? email.split('@')[0];
}
