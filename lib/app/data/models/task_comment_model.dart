class TaskCommentModel {
  final int id;
  final int assignmentId;
  final int userId;
  final String commentText;
  final DateTime createdAt;
  final String userEmail;
  final String username;

  TaskCommentModel({
    required this.id,
    required this.assignmentId,
    required this.userId,
    required this.commentText,
    required this.createdAt,
    required this.userEmail,
    required this.username,
  });

  factory TaskCommentModel.fromJson(Map<String, dynamic> json) {
    return TaskCommentModel(
      id: json['id'] as int,
      assignmentId: json['assignment_id'] as int,
      userId: json['user_id'] as int,
      commentText: json['comment_text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      userEmail: json['user_email'] as String,
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignment_id': assignmentId,
      'user_id': userId,
      'comment_text': commentText,
      'created_at': createdAt.toIso8601String(),
      'user_email': userEmail,
      'username': username,
    };
  }

  /// Format time for display (HH:MM)
  String get formattedTime {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Get avatar URL for user
  String get avatarUrl {
    return 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(username)}&background=003AE6&color=fff&size=200';
  }
}

class TaskCommentResponseModel {
  final bool success;
  final String message;
  final List<TaskCommentModel> data;

  TaskCommentResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TaskCommentResponseModel.fromJson(Map<String, dynamic> json) {
    return TaskCommentResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List?)
              ?.map((item) => TaskCommentModel.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class TaskCommentCreateResponseModel {
  final bool success;
  final String message;
  final TaskCommentModel data;

  TaskCommentCreateResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TaskCommentCreateResponseModel.fromJson(Map<String, dynamic> json) {
    return TaskCommentCreateResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: TaskCommentModel.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
