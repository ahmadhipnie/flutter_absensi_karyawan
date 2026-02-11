class AnnouncementModel {
  final int id;
  final int senderId;
  final String subject;
  final String message;
  final bool isBroadcast;
  final DateTime createdAt;
  final String? senderEmail;
  final String? senderName;

  AnnouncementModel({
    required this.id,
    required this.senderId,
    required this.subject,
    required this.message,
    required this.isBroadcast,
    required this.createdAt,
    this.senderEmail,
    this.senderName,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as int,
      senderId: json['sender_id'] as int,
      subject: json['subject'] as String,
      message: json['message'] as String,
      isBroadcast: json['is_broadcast'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      senderEmail: json['sender_email'] as String?,
      senderName: json['sender_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_id': senderId,
      'subject': subject,
      'message': message,
      'is_broadcast': isBroadcast,
      'created_at': createdAt.toIso8601String(),
      'sender_email': senderEmail,
      'sender_name': senderName,
    };
  }
}

class AnnouncementResponseModel {
  final bool success;
  final List<AnnouncementModel> data;

  AnnouncementResponseModel({
    required this.success,
    required this.data,
  });

  factory AnnouncementResponseModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementResponseModel(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List? ?? [])
          .map((item) => AnnouncementModel.fromJson(item as Map<String, dynamic>))
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
