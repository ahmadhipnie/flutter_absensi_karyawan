import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  final selectedTabIndex = 0.obs;

  // Sample task data
  final taskTitle = 'Update Daily Work Progress for Project 1'.obs;
  final postedOn = DateTime(2026, 2, 17).obs;
  final dueDate = DateTime(2026, 2, 17).obs;
  final description =
      '''Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet'''
          .obs;
  final customerName = 'Alexandria Maria'.obs;
  final location = 'Orchard 1, Batam'.obs;

  // Employee work statistics
  final approvedCount = 10.obs;
  final lateSubmissionsCount = 20.obs;

  // Employee work data
  final List<EmployeeWorkModel> approvedEmployees = [
    EmployeeWorkModel(
      id: '1',
      name: 'Karina',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      status: EmployeeWorkStatus.onTime,
    ),
    EmployeeWorkModel(
      id: '2',
      name: 'Bambang',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      status: EmployeeWorkStatus.late,
    ),
  ];

  final List<EmployeeWorkModel> lateEmployees = [
    EmployeeWorkModel(
      id: '3',
      name: 'Jessylin',
      avatarUrl: 'https://i.pravatar.cc/150?img=5',
      status: EmployeeWorkStatus.late,
    ),
    EmployeeWorkModel(
      id: '4',
      name: 'Gerald',
      avatarUrl: 'https://i.pravatar.cc/150?img=14',
      status: EmployeeWorkStatus.late,
    ),
  ];

  final List<EmployeeWorkModel> assignedEmployees = [
    EmployeeWorkModel(
      id: '5',
      name: 'Jessica',
      avatarUrl: 'https://i.pravatar.cc/150?img=9',
      status: EmployeeWorkStatus.notSubmitted,
    ),
    EmployeeWorkModel(
      id: '6',
      name: 'Karolin',
      avatarUrl: 'https://i.pravatar.cc/150?img=10',
      status: EmployeeWorkStatus.notSubmitted,
    ),
    EmployeeWorkModel(
      id: '7',
      name: 'Karolin2',
      avatarUrl: 'https://i.pravatar.cc/150?img=10',
      status: EmployeeWorkStatus.notSubmitted,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      selectedTabIndex.value = tabController.index;
    });
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  /// Format date to display
  String formatDate(DateTime date) {
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  /// Edit task
  void editTask() {
    Get.snackbar('Edit Task', 'Edit functionality coming soon');
  }
}

enum EmployeeWorkStatus { onTime, late, notSubmitted }

class EmployeeWorkModel {
  final String id;
  final String name;
  final String avatarUrl;
  final EmployeeWorkStatus status;

  EmployeeWorkModel({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.status,
  });

  String get statusText {
    switch (status) {
      case EmployeeWorkStatus.onTime:
        return 'Tepat Waktu';
      case EmployeeWorkStatus.late:
        return 'Terlambat';
      case EmployeeWorkStatus.notSubmitted:
        return 'Tidak mengumpulkan';
    }
  }

  Color get statusColor {
    switch (status) {
      case EmployeeWorkStatus.onTime:
        return const Color(0xFF4CAF50);
      case EmployeeWorkStatus.late:
        return const Color(0xFFF44336);
      case EmployeeWorkStatus.notSubmitted:
        return const Color(0xFF9E9E9E);
    }
  }
}
