import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/conversation_model.dart';
import '../models/chat_message_model.dart';
import '../models/user_model.dart';
import '../providers/api_provider.dart';

class ChatService extends GetxService {
  late final ApiProvider _apiProvider;

  @override
  void onInit() {
    super.onInit();
    _apiProvider = Get.find<ApiProvider>();
  }

  /// Create a new conversation
  /// POST /conversations
  Future<CreateConversationResponse?> createConversation({
    required String type,
    String? title,
    required List<int> participantIds,
  }) async {
    try {
      final request = CreateConversationRequest(
        type: type,
        title: title,
        participantIds: participantIds,
      );

      final response = await _apiProvider.post(
        '/conversations',
        data: request.toJson(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateConversationResponse.fromJson(response.data);
      }

      return null;
    } on DioException catch (e) {
      String errorMessage = 'Failed to create conversation';

      if (e.response != null) {
        final data = e.response!.data;
        if (data is Map && data['message'] != null) {
          errorMessage = data['message'];
        }
      }

      throw errorMessage;
    } catch (e) {
      throw 'An error occurred: ${e.toString()}';
    }
  }

  /// Create a private conversation with a user
  Future<CreateConversationResponse?> createPrivateConversation({
    required int userId,
    String? title,
  }) async {
    return createConversation(
      type: 'private',
      title: title,
      participantIds: [userId],
    );
  }

  /// Create a group conversation
  Future<CreateConversationResponse?> createGroupConversation({
    required String title,
    required List<int> participantIds,
  }) async {
    return createConversation(
      type: 'group',
      title: title,
      participantIds: participantIds,
    );
  }

  /// Get conversation list
  /// GET /conversations
  Future<List<ConversationModel>> getConversations() async {
    try {
      final response = await _apiProvider.get('/conversations');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List)
              .map((item) => ConversationModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get messages for a conversation
  /// GET /conversations/{conversationId}/messages
  Future<List<ChatMessage>> getMessages(int conversationId) async {
    try {
      final response = await _apiProvider.get('/conversations/$conversationId/messages');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] is Map) {
          final messagesData = data['data']['messages'] as List? ?? [];
          return messagesData
              .map((item) => ChatMessage.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  /// Send a message to a conversation
  /// POST /conversations/{conversationId}/messages
  Future<ChatMessage?> sendMessage({
    required int conversationId,
    required String message,
  }) async {
    try {
      final response = await _apiProvider.post(
        '/conversations/$conversationId/messages',
        data: {'message': message},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['success'] == true && data['data'] != null) {
          return ChatMessage.fromJson(data['data'] as Map<String, dynamic>);
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Get list of users/members for starting new chat
  /// GET /users
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await _apiProvider.get('/users');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['success'] == true && data['data'] is List) {
          return (data['data'] as List)
              .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }
}
