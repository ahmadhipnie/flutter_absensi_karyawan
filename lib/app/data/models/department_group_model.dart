class DepartmentGroupModel {
  final int id;
  final String title;
  final String type;
  final int departmentId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String departmentsName;

  DepartmentGroupModel({
    required this.id,
    required this.title,
    required this.type,
    required this.departmentId,
    required this.createdAt,
    required this.updatedAt,
    required this.departmentsName,
  });

  factory DepartmentGroupModel.fromJson(Map<String, dynamic> json) {
    return DepartmentGroupModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      type: json['type'] as String? ?? 'group',
      departmentId: json['department_id'] as int? ?? 0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at'] as String) 
          : DateTime.now(),
      departmentsName: json['departments_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'department_id': departmentId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'departments_name': departmentsName,
    };
  }
}
