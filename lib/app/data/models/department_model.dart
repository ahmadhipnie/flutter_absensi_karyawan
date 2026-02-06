class DepartmentModel {
  final int id;
  final String name;
  final String description;
  final DateTime createdAt;
  final String? photo;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
    this.photo,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] as int,
      name: json['departments_name'] as String,
      description: json['description'] as String? ?? '',
      createdAt: DateTime.parse(json['created_at'] as String),
      photo: json['photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'departments_name': name,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      if (photo != null) 'photo': photo,
    };
  }

  /// Get photo URL or return default placeholder
  String get displayPhotoUrl {
    if (photo != null && photo!.isNotEmpty) {
      return photo!;
    }
    // Return default placeholder image
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}&background=003AE6&color=fff&size=200';
  }
}
