import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TaskController extends GetxController {
  // Observable states
  final selectedFilter = 'All'.obs;
  final scrollController = ScrollController();

  // Filter options
  final List<String> filters = [
    'All',
    'Department A',
    'Department B',
    'Department C',
  ];

  // Sample tasks data grouped by month
  final Map<String, List<TaskModel>> groupedTasks = {
    'February 2026': [
      TaskModel(
        title: 'Site Inspection Report Submission',
        dueDate: DateTime(2026, 2, 17, 23, 59),
        department: 'Department A',
      ),
      TaskModel(
        title: 'Site Inspection Report Submission',
        dueDate: DateTime(2026, 2, 17, 23, 59),
        department: 'Department B',
      ),
      TaskModel(
        title: 'Site Inspection Report Submission',
        dueDate: DateTime(2026, 2, 17, 23, 59),
        department: 'Department A',
      ),
      TaskModel(
        title: 'Site Inspection Report Submission',
        dueDate: DateTime(2026, 2, 17, 23, 59),
        department: 'Department C',
      ),
    ],
    'January 2026': [
      TaskModel(
        title: 'Site Inspection Report Submission',
        dueDate: DateTime(2026, 1, 22, 23, 59),
        department: 'Department A',
      ),
      TaskModel(
        title: 'Site Inspection Report Submission',
        dueDate: DateTime(2026, 1, 17, 23, 59),
        department: 'Department B',
      ),
      TaskModel(
        title: 'Site Inspection Report Submission',
        dueDate: DateTime(2026, 1, 22, 23, 59),
        department: 'Department C',
      ),
      TaskModel(
        title: 'Site Inspection Report Submission',
        dueDate: DateTime(2026, 1, 22, 23, 59),
        department: 'Department C',
      ),
      TaskModel(
        title: 'Site Inspection Report Submission',
        dueDate: DateTime(2026, 1, 22, 23, 59),
        department: 'Department C',
      ),
      TaskModel(
        title: 'Site Inspection Report Submission',
        dueDate: DateTime(2026, 1, 22, 23, 59),
        department: 'Department C',
      ),
      TaskModel(
        title: 'Site Inspection Report Submission',
        dueDate: DateTime(2026, 1, 22, 23, 59),
        department: 'Department C',
      ),
      TaskModel(
        title: 'Site Inspection Report Submission',
        dueDate: DateTime(2026, 1, 22, 23, 59),
        department: 'Department C',
      ),
    ],
  };

  /// Get filtered tasks based on selected department
  Map<String, List<TaskModel>> get filteredTasks {
    if (selectedFilter.value == 'All') {
      return groupedTasks;
    }

    final filtered = <String, List<TaskModel>>{};
    groupedTasks.forEach((month, tasks) {
      final filteredList = tasks
          .where((task) => task.department == selectedFilter.value)
          .toList();
      if (filteredList.isNotEmpty) {
        filtered[month] = filteredList;
      }
    });
    return filtered;
  }

  /// Select filter
  void selectFilter(String filter) {
    selectedFilter.value = filter;
  }

  /// Format date to display format
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
    final month = months[date.month - 1];
    final day = date.day;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return 'Due $day $month ${date.year}, $hour $minute PM';
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}

/// Task Model
class TaskModel {
  final String title;
  final DateTime dueDate;
  final String department;
  final bool isCompleted;

  TaskModel({
    required this.title,
    required this.dueDate,
    required this.department,
    this.isCompleted = false,
  });
}
