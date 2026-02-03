class MemberModel {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String department;
  final String userType; // 'Supervisor' or 'Member'
  final DateTime? createdAt;

  MemberModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.department,
    required this.userType,
    this.createdAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatarUrl'],
      department: json['department'] ?? '',
      userType: json['userType'] ?? 'Member',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
      'department': department,
      'userType': userType,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
