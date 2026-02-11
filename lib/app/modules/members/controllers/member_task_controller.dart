import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/services/task_service.dart';
import '../../../routes/app_pages.dart';

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
            final taskDetail = await _taskService.getTaskWithAssignments(task.id);
            
            if (taskDetail != null) {
              // Check if user is assigned to this task
              final isAssigned = taskDetail.assignments.any((assignment) => 
                assignment.userId == user.id
              );
              
              if (isAssigned) {
                // Find the user's assignment to get status and other info
                final userAssignment = taskDetail.assignments.firstWhere(
                  (assignment) => assignment.userId == user.id
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
  
  /// Navigate to task detail
  void openTaskDetail(TaskModel task) {
    // Navigate to employee detail view with proper arguments
    // Using Routes constant to ensure binding is applied
    Get.toNamed(
      Routes.EMPLOYEE_DETAIL,
      arguments: {
        'employeeName': user.displayName,
        'taskSubject': task.taskSubject,
        'submissionDate': task.isSubmitted ? task.updatedAt : null,
        'assignmentStatus': task.status, // Use assignmentStatus key
        'status': task.status, // Keep for backward compatibility
        'assignmentId': task.id,
        'taskId': task.taskId ?? task.id,
      },
    );
  }
  
  /// Format due date
  String formatDueDate(DateTime? date) {
    if (date == null) return 'No due date';
    
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
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
