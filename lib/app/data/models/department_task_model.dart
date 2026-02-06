class DepartmentTaskModel {
  final int id;
  final int taskId;
  final int userId;
  final String status;
  final bool isSubmitted;
  final String createdAt;
  final String updatedAt;
  final String taskSubject;
  final String taskDescription;
  final String dueDate;
  final String location;
  final String customerName;
  final String userEmail;
  final String username;
  final int departmentId;
  final String departmentsName;

  DepartmentTaskModel({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.status,
    required this.isSubmitted,
    required this.createdAt,
    required this.updatedAt,
    required this.taskSubject,
    required this.taskDescription,
    required this.dueDate,
    required this.location,
    required this.customerName,
    required this.userEmail,
    required this.username,
    required this.departmentId,
    required this.departmentsName,
  });

  factory DepartmentTaskModel.fromJson(Map<String, dynamic> json) {
    return DepartmentTaskModel(
      id: json['id'] as int? ?? 0,
      taskId: json['task_id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      status: json['status'] as String? ?? '',
      isSubmitted: json['is_submitted'] == 1 || json['is_submitted'] == true,
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      taskSubject: json['task_subject'] as String? ?? '',
      taskDescription: json['task_description'] as String? ?? '',
      dueDate: json['due_date'] as String? ?? '',
      location: json['location'] as String? ?? '',
      customerName: json['customer_name'] as String? ?? '',
      userEmail: json['user_email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      departmentId: json['department_id'] as int? ?? 0,
      departmentsName: json['departments_name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'user_id': userId,
      'status': status,
      'is_submitted': isSubmitted,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'task_subject': taskSubject,
      'task_description': taskDescription,
      'due_date': dueDate,
      'location': location,
      'customer_name': customerName,
      'user_email': userEmail,
      'username': username,
      'department_id': departmentId,
      'departments_name': departmentsName,
    };
  }
}
