import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/task_service.dart';
import '../../../data/models/task_comment_model.dart';

class CommentModel {
  final String id;
  final String name;
  final String? avatarUrl;
  final String time;
  final String message;

  CommentModel({
    required this.id,
    required this.name,
    this.avatarUrl,
    required this.time,
    required this.message,
  });

  /// Create from TaskCommentModel
  factory CommentModel.fromTaskComment(TaskCommentModel comment) {
    return CommentModel(
      id: comment.id.toString(),
      name: comment.username,
      avatarUrl: comment.avatarUrl,
      time: comment.formattedTime,
      message: comment.commentText,
    );
  }
}

class UserTaskCommentController extends GetxController {
  final TaskService _taskService = Get.find<TaskService>();
  
  // Text controller for comment input
  final commentController = TextEditingController();

  // Comments list
  final comments = <CommentModel>[].obs;
  
  // Loading states
  final isLoading = false.obs;
  final isSending = false.obs;

  // Assignment ID from arguments
  int? get assignmentId => Get.arguments?['assignmentId'] as int?;

  @override
  void onInit() {
    super.onInit();
    if (assignmentId != null) {
      loadComments();
    }
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  /// Load comments from API
  Future<void> loadComments() async {
    if (assignmentId == null) return;

    try {
      isLoading.value = true;

      final taskComments = await _taskService.getAssignmentComments(
        assignmentId: assignmentId!,
      );

      // Convert to UI model
      comments.value = taskComments
          .map((comment) => CommentModel.fromTaskComment(comment))
          .toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Send a new comment
  Future<void> sendComment() async {
    if (assignmentId == null) return;
    
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    try {
      isSending.value = true;

      final newComment = await _taskService.postAssignmentComment(
        assignmentId: assignmentId!,
        commentText: text,
      );

      // Add to list
      comments.add(CommentModel.fromTaskComment(newComment));
      
      // Clear input
      commentController.clear();

      // Show success message
      Get.snackbar(
        'Success',
        'Comment posted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSending.value = false;
    }
  }
}
