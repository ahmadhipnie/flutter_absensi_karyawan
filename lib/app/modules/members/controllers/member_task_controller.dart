import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/services/task_service.dart';
import '../../../core/theme/app_theme.dart';

class MemberTaskController extends GetxController {
  final TaskService _taskService = Get.find<TaskService>();

  // User whose tasks we're viewing
  final UserModel user;

  MemberTaskController(this.user);

  // Observable lists
  final isLoading = false.obs;
  final memberTasks = <TaskModel>[].obs;

  // Task statistics
  final assignedCount = 0.obs;
  final onTimeCount = 0.obs;
  final approvedCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadMemberTasks();
  }

  /// Load tasks assigned to this member
  Future<void> _loadMemberTasks() async {
    try {
      isLoading.value = true;

      // Get all tasks (supervisor endpoint)
      final taskResponse = await _taskService.getAllTasks();

      if (taskResponse != null && taskResponse.success) {
        // For each task, we need to check if this user is assigned
        // Since /tasks doesn't return assignment info, we need to fetch each task detail
        final List<TaskModel> userTasks = [];

        for (final task in taskResponse.data) {
          try {
            // Get task with assignments
            final taskDetail = await _taskService.getTaskWithAssignments(
              task.id,
            );

            if (taskDetail != null) {
              // Check if user is assigned to this task
              final isAssigned = taskDetail.assignments.any(
                (assignment) => assignment.userId == user.id,
              );

              if (isAssigned) {
                // Find the user's assignment to get status and other info
                final userAssignment = taskDetail.assignments.firstWhere(
                  (assignment) => assignment.userId == user.id,
                );

                // Create TaskModel with assignment info
                final taskWithAssignment = TaskModel(
                  id: userAssignment.id, // Use assignment id
                  taskId: task.id,
                  userId: user.id,
                  status: userAssignment.status,
                  isSubmitted: userAssignment.isSubmitted,
                  createdAt: userAssignment.createdAt,
                  updatedAt: userAssignment.updatedAt,
                  taskSubject: task.taskSubject,
                  taskDescription: task.taskDescription,
                  dueDate: task.dueDate,
                  location: task.location,
                  customerName: task.customerName,
                  creatorId: task.creatorId,
                  creatorEmail: task.creatorEmail,
                  creatorName: task.creatorName,
                );

                userTasks.add(taskWithAssignment);
              }
            }
          } catch (e) {
            print('Error fetching task ${task.id} assignments: $e');
            // Continue to next task
          }
        }

        memberTasks.value = userTasks;

        // Calculate statistics
        _calculateStatistics(userTasks);
      }
    } catch (e) {
      print('Error loading member tasks: $e');
      memberTasks.clear();
      _resetStatistics();
    } finally {
      isLoading.value = false;
    }
  }

  /// Calculate task statistics
  void _calculateStatistics(List<TaskModel> tasks) {
    assignedCount.value = tasks.length;

    // Count on-time submissions (tasks submitted - checking updatedAt vs dueDate)
    onTimeCount.value = tasks.where((task) {
      if (!task.isSubmitted) return false;
      // Use updatedAt as submission time if submitted
      return task.updatedAt.isBefore(task.dueDate);
    }).length;

    // Count approved/completed tasks
    approvedCount.value = tasks.where((task) {
      final status = task.status.toLowerCase();
      return status == 'completed' || status == 'approved';
    }).length;
  }

  /// Reset statistics to zero
  void _resetStatistics() {
    assignedCount.value = 0;
    onTimeCount.value = 0;
    approvedCount.value = 0;
  }

  /// Refresh tasks
  Future<void> refreshTasks() async {
    await _loadMemberTasks();
  }

  /// Show task detail as read-only notification dialog
  void openTaskDetail(TaskModel task) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.assignment,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                task.taskSubject,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (task.taskDescription.isNotEmpty) ...[
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.taskDescription,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF374151),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              _buildInfoRow(
                Icons.calendar_today_outlined,
                'Due Date',
                formatDueDate(task.dueDate),
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.flag_outlined,
                'Status',
                task.status.toUpperCase(),
              ),
              if (task.location.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.location_on_outlined,
                  'Location',
                  task.location,
                ),
              ],
              if (task.customerName != null &&
                  task.customerName!.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildInfoRow(
                  Icons.person_outline,
                  'Customer',
                  task.customerName!,
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Close',
              style: TextStyle(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build info row for task detail dialog
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6B7280)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF374151),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Format due date
  String formatDueDate(DateTime? date) {
    if (date == null) return 'No due date';

    const months = [
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

    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return 'Due $day $month $year, $hour:$minute';
  }

  /// Get status color
  String getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'approved':
        return '0xFF4CAF50'; // Green
      case 'in_progress':
      case 'pending':
        return '0xFFFFA726'; // Orange
      case 'rejected':
      case 'cancelled':
        return '0xFFF44336'; // Red
      default:
        return '0xFF9E9E9E'; // Grey
    }
  }
}
