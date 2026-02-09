class TaskSubmissionModel {
  final int id;
  final int assignmentId;
  final String submissionType;
  final String? contentUrl;
  final String? filePath;
  final String? fileName;
  final DateTime? submittedAt;

  TaskSubmissionModel({
    required this.id,
    required this.assignmentId,
    required this.submissionType,
    this.contentUrl,
    this.filePath,
    this.fileName,
    this.submittedAt,
  });

  factory TaskSubmissionModel.fromJson(Map<String, dynamic> json) {
    return TaskSubmissionModel(
      id: json['id'] as int,
      assignmentId: json['assignment_id'] as int,
      submissionType: json['submission_type'] as String,
      contentUrl: json['content_url'] as String?,
      filePath: json['file_path'] as String?,
      fileName: json['file_name'] as String?,
      submittedAt: json['submitted_at'] != null 
          ? DateTime.parse(json['submitted_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'assignment_id': assignmentId,
      'submission_type': submissionType,
      'content_url': contentUrl,
      'file_path': filePath,
      'file_name': fileName,
      'submitted_at': submittedAt?.toIso8601String(),
    };
  }
}

class TaskSubmissionResponseModel {
  final bool success;
  final String message;
  final TaskSubmissionModel? data;

  TaskSubmissionResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory TaskSubmissionResponseModel.fromJson(Map<String, dynamic> json) {
    return TaskSubmissionResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? TaskSubmissionModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}
