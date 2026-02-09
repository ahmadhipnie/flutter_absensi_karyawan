/// Simple class to hold last message preview
class LastMessagePreview {
  final String text;
  final String senderName;
  final DateTime timestamp;
  final bool isFromMe;
  final String messageType; // 'text' or 'image'

  LastMessagePreview({
    required this.text,
    required this.senderName,
    required this.timestamp,
    this.isFromMe = false,
    this.messageType = 'text',
  });
}

class ParticipantModel {
  final int id;
  final int conversationId;
  final int userId;
  final String role;
  final DateTime joinedAt;
  final DateTime createdAt;
  final String email;
  final String username;

  ParticipantModel({
    required this.id,
    required this.conversationId,
    required this.userId,
    required this.role,
    required this.joinedAt,
    required this.createdAt,
    required this.email,
    required this.username,
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: json['id'] as int,
      conversationId: json['conversation_id'] as int,
      userId: json['user_id'] as int,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      email: json['email'] as String,
      username: json['username'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'user_id': userId,
      'role': role,
      'joined_at': joinedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'email': email,
      'username': username,
    };
  }

  /// Get display name (prioritize username, fallback to email)
  String get displayName => username.isNotEmpty ? username : email.split('@')[0];
}

class ConversationModel {
  final int id;
  final String? title;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int unreadCount;
  final List<ParticipantModel> participants;
  final LastMessagePreview? lastMessage;

  ConversationModel({
    required this.id,
    this.title,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.unreadCount,
    required this.participants,
    this.lastMessage,
  });

  /// Create a copy with last message updated
  ConversationModel copyWithLastMessage(LastMessagePreview? lastMessage) {
    return ConversationModel(
      id: id,
      title: title,
      type: type,
      createdAt: createdAt,
      updatedAt: updatedAt,
      unreadCount: unreadCount,
      participants: participants,
      lastMessage: lastMessage,
    );
  }

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    final participantsList = json['participants'] as List? ?? [];
    return ConversationModel(
      id: json['id'] as int,
      title: json['title'] as String?,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      unreadCount: json['unread_count'] as int? ?? 0,
      participants: participantsList
          .map((p) => ParticipantModel.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'unread_count': unreadCount,
      'participants': participants.map((p) => p.toJson()).toList(),
    };
  }

  /// Get display name for the conversation
  /// For private chat, use the other participant's name
  /// Note: Use displayNameWithId() for proper logic with current user context
  String get displayName {
    if (title != null && title!.isNotEmpty) {
      return title!;
    }

    if (type == 'private' && participants.isNotEmpty) {
      // For private chat, return the first participant's name
      // Note: Use displayNameWithId() for proper logic with current user
      final otherParticipant = participants.firstWhere(
        (p) => p.role != 'admin',
        orElse: () => participants.first,
      );
      return otherParticipant.displayName;
    }

    return 'Conversation';
  }

  /// Get display name for the conversation with current user context
  /// For private chat, use the OTHER participant's name (not current user)
  String displayNameWithId(String currentUserId) {
    if (type == 'private' && participants.isNotEmpty) {
      // For private chat, ALWAYS use the other participant's name (ignore title)
      final otherParticipant = participants.firstWhere(
        (p) => p.userId.toString() != currentUserId,
        orElse: () => participants.first,
      );
      return otherParticipant.displayName;
    }

    // For group chat or if no participants, use title
    if (title != null && title!.isNotEmpty) {
      return title!;
    }

    return 'Conversation';
  }

  /// Get subtitle for the conversation
  String get subtitle {
    if (type == 'private') {
      final participant = participants.firstWhere(
        (p) => p.role != 'admin',
        orElse: () => participants.first,
      );
      return participant.email;
    }
    return '${participants.length} members';
  }

  /// Get subtitle for the conversation with current user context
  String subtitleWithId(String currentUserId) {
    if (type == 'private') {
      final participant = participants.firstWhere(
        (p) => p.userId.toString() != currentUserId,
        orElse: () => participants.first,
      );
      return participant.email;
    }
    return '${participants.length} members';
  }
}

class CreateConversationResponse {
  final bool success;
  final String message;
  final ConversationModel? data;

  CreateConversationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory CreateConversationResponse.fromJson(Map<String, dynamic> json) {
    return CreateConversationResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: json['data'] != null
          ? ConversationModel.fromJson(json['data'] as Map<String, dynamic>)
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

/// Request model for creating a new conversation
class CreateConversationRequest {
  final String type;
  final String? title;
  final String? description;
  final List<int> participantIds;
  final int? departmentId; // Optional department ID

  CreateConversationRequest({
    required this.type,
    this.title,
    this.description,
    required this.participantIds,
    this.departmentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      'participant_ids': participantIds,
      if (departmentId != null) 'department_id': departmentId,
    };
  }

  /// Create a private conversation request
  factory CreateConversationRequest.private({
    required int participantId,
    String? title,
  }) {
    return CreateConversationRequest(
      type: 'private',
      title: title,
      participantIds: [participantId],
    );
  }
}
