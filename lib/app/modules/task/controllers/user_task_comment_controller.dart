import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
}

class UserTaskCommentController extends GetxController {
  // Text controller for comment input
  final commentController = TextEditingController();

  // Comments list
  final comments = <CommentModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyComments();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  /// Load dummy comments for UI demonstration
  void _loadDummyComments() {
    comments.value = [
      CommentModel(
        id: '1',
        name: 'Alexander Deron',
        avatarUrl: null,
        time: '14:09',
        message: 'Test Comment',
      ),
      CommentModel(
        id: '2',
        name: 'Queen Alsaa',
        avatarUrl: null,
        time: '14:15',
        message: 'Great!',
      ),
    ];
  }

  /// Send a new comment
  void sendComment() {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'You',
      avatarUrl: null,
      time: _getCurrentTime(),
      message: text,
    );

    comments.add(newComment);
    commentController.clear();
  }

  /// Get current time in HH:MM format
  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
