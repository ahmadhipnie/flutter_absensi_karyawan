import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeDetailController extends GetxController {
  final commentController = TextEditingController();

  // Employee work data
  final employeeName = 'Alsaa Cantikk'.obs;
  final taskSubject = 'Update Daily Work Progress for Project 1'.obs;
  final submissionDate = DateTime(2026, 2, 17).obs;
  final status = 'Tepat Waktu'.obs;
  final statusColor = const Color(0xFF4CAF50).obs;
  final approvalStatus = 'Approved'.obs;

  // Output files
  final RxList<Map<String, String>> outputFiles = <Map<String, String>>[
    {'name': 'Hasil Laporan Observasi A', 'type': 'pdf'},
  ].obs;

  // Comments
  final RxList<CommentModel> comments = <CommentModel>[
    CommentModel(
      id: '1',
      userName: 'Alsaa Cantikk',
      comment: 'Test Comment',
      time: '14:09',
    ),
  ].obs;

  // Approval status options
  final List<String> approvalOptions = ['Approved', 'Pending', 'Rejected'];

  /// Format date to display
  String formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final weekday = weekdays[date.weekday - 1];
    return '$weekday, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Change approval status
  void changeApprovalStatus(String? newStatus) {
    if (newStatus != null) {
      approvalStatus.value = newStatus;
      Get.snackbar('Status Changed', 'Approval status updated to $newStatus');
    }
  }

  /// Send private comment
  void sendPrivateComment() {
    if (commentController.text.trim().isEmpty) return;

    final newComment = CommentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: 'Me',
      comment: commentController.text.trim(),
      time:
          '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    );

    comments.add(newComment);
    commentController.clear();
  }

  /// Open output file
  void openOutputFile(String fileName) {
    Get.snackbar('Open File', fileName);
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}

class CommentModel {
  final String id;
  final String userName;
  final String comment;
  final String time;

  CommentModel({
    required this.id,
    required this.userName,
    required this.comment,
    required this.time,
  });
}
