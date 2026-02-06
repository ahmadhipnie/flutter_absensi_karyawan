class TaskModel {
  final int id;
  final int taskId;
  final int userId;
  final String status;
  final bool isSubmitted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String taskSubject;
  final String taskDescription;
  final DateTime dueDate;
  final String location;

  TaskModel({
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
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as int,
      taskId: json['task_id'] as int,
      userId: json['user_id'] as int,
      status: json['status'] as String,
      isSubmitted: json['is_submitted'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      taskSubject: json['task_subject'] as String,
      taskDescription: json['task_description'] as String,
      dueDate: DateTime.parse(json['due_date'] as String),
      location: json['location'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'task_id': taskId,
      'user_id': userId,
      'status': status,
      'is_submitted': isSubmitted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'task_subject': taskSubject,
      'task_description': taskDescription,
      'due_date': dueDate.toIso8601String(),
      'location': location,
    };
  }
}

class TaskResponseModel {
  final bool success;
  final List<TaskModel> data;

  TaskResponseModel({
    required this.success,
    required this.data,
  });

  factory TaskResponseModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return TaskResponseModel(
      success: json['success'] as bool? ?? false,
      data: dataList
          .map((item) => TaskModel.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
