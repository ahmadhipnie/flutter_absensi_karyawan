class TaskModel {
  final int id;
  final int? taskId;      // Nullable for compatibility
  final int? userId;      // Nullable for compatibility
  final String status;
  final bool isSubmitted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String taskSubject;
  final String taskDescription;
  final DateTime dueDate;
  final String location;
  final String? customerName;  // From direct task response
  final int? creatorId;        // From direct task response
  final String? creatorEmail;  // From direct task response
  final String? creatorName;   // From direct task response
  final List<int>? assignedTo; // From /api/tasks response - list of user IDs

  TaskModel({
    required this.id,
    this.taskId,
    this.userId,
    required this.status,
    required this.isSubmitted,
    required this.createdAt,
    required this.updatedAt,
    required this.taskSubject,
    required this.taskDescription,
    required this.dueDate,
    required this.location,
    this.customerName,
    this.creatorId,
    this.creatorEmail,
    this.creatorName,
    this.assignedTo,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    // Handle different response formats:
    // 1. Task assignment format (from /tasks/my-assigned)
    // 2. Direct task format (from /api/tasks) with assigned_to
    
    final bool isDirectTaskFormat = json.containsKey('subject');
    
    if (isDirectTaskFormat) {
      // Direct task format (from GET /api/tasks)
      final assignedTo = json['assigned_to'];
      return TaskModel(
        id: json['id'] as int,
        taskId: null,
        userId: null,
        status: json['status'] as String? ?? 'pending',
        isSubmitted: json['is_submitted'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        taskSubject: json['subject'] as String,
        taskDescription: json['description'] as String? ?? '',
        dueDate: DateTime.parse(json['due_date'] as String),
        location: json['location'] as String? ?? '',
        customerName: json['customer_name'] as String?,
        creatorId: json['creator_id'] as int?,
        creatorEmail: json['creator_email'] as String?,
        creatorName: json['creator_name'] as String?,
        assignedTo: assignedTo is List ? (assignedTo as List<int>).map((e) => e).toList() : null,
      );
    } else {
      // Task assignment format (from GET /tasks/my-assigned)
      return TaskModel(
        id: json['id'] as int,
        taskId: json['task_id'] as int?,
        userId: json['user_id'] as int?,
        status: json['status'] as String,
        isSubmitted: json['is_submitted'] as bool? ?? false,
        createdAt: DateTime.parse(json['created_at'] as String),
        updatedAt: DateTime.parse(json['updated_at'] as String),
        taskSubject: json['task_subject'] as String,
        taskDescription: json['task_description'] as String,
        dueDate: DateTime.parse(json['due_date'] as String),
        location: json['location'] as String? ?? '',
        customerName: json['customer_name'] as String?,
        creatorId: json['creator_id'] as int?,
        creatorEmail: json['creator_email'] as String?,
        creatorName: json['creator_name'] as String?,
        assignedTo: null,
      );
    }
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
      if (assignedTo != null) 'assigned_to': assignedTo,
    };
  }

  TaskModel copyWith({
    String? customerName,
    String? location,
  }) {
    return TaskModel(
      id: id,
      taskId: taskId,
      userId: userId,
      status: status,
      isSubmitted: isSubmitted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      taskSubject: taskSubject,
      taskDescription: taskDescription,
      dueDate: dueDate,
      location: location ?? this.location,
      customerName: customerName ?? this.customerName,
      creatorId: creatorId,
      creatorEmail: creatorEmail,
      creatorName: creatorName,
      assignedTo: assignedTo,
    );
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
