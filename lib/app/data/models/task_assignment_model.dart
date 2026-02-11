class TaskAssignmentModel {
  final int id;
  final int taskId;
  final int userId;
  final String status;
  final bool isSubmitted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userEmail;
  final String username;
  final String? photoProfile;

  TaskAssignmentModel({
    required this.id,
    required this.taskId,
    required this.userId,
    required this.status,
    required this.isSubmitted,
    required this.createdAt,
    required this.updatedAt,
    required this.userEmail,
    required this.username,
    this.photoProfile,
  });

  factory TaskAssignmentModel.fromJson(Map<String, dynamic> json) {
    return TaskAssignmentModel(
      id: json['id'] as int,
      taskId: json['task_id'] as int,
      userId: json['user_id'] as int,
      status: json['status'] as String,
      isSubmitted: json['is_submitted'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      userEmail: json['user_email'] as String,
      username: json['username'] as String,
      photoProfile: json['photo_profile'] as String?,
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
      'user_email': userEmail,
      'username': username,
      'photo_profile': photoProfile,
    };
  }
}

class TaskWithAssignmentsModel {
  final int id;
  final String subject;
  final String description;
  final String? customerName;
  final DateTime dueDate;
  final String location;
  final int creatorId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? creatorEmail;
  final String? creatorName;
  final List<TaskAssignmentModel> assignments;

  TaskWithAssignmentsModel({
    required this.id,
    required this.subject,
    required this.description,
    this.customerName,
    required this.dueDate,
    required this.location,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
    this.creatorEmail,
    this.creatorName,
    required this.assignments,
  });

  factory TaskWithAssignmentsModel.fromJson(Map<String, dynamic> json) {
    return TaskWithAssignmentsModel(
      id: json['id'] as int,
      subject: json['subject'] as String,
      description: json['description'] as String? ?? '',
      customerName: json['customer_name'] as String?,
      dueDate: DateTime.parse(json['due_date'] as String),
      location: json['location'] as String? ?? '',
      creatorId: json['creator_id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      creatorEmail: json['creator_email'] as String?,
      creatorName: json['creator_name'] as String?,
      assignments: (json['assignments'] as List?)
              ?.map((item) => TaskAssignmentModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'description': description,
      'customer_name': customerName,
      'due_date': dueDate.toIso8601String(),
      'location': location,
      'creator_id': creatorId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'creator_email': creatorEmail,
      'creator_name': creatorName,
      'assignments': assignments.map((a) => a.toJson()).toList(),
    };
  }
}
