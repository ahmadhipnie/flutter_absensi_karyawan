import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../controllers/department_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../core/config/app_config.dart';
import '../../members/controllers/members_controller.dart';
import '../../members/views/widgets/member_list_item.dart';
import '../../../data/services/user_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/department_task_model.dart';

class DepartmentDetailView extends GetView<DepartmentController> {
  const DepartmentDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Section with rounded bottom
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                top: 25,
                child: Obx(() {
                  final dept = controller.department.value;
                  final photoUrl = AppConfig.getDepartmentPhotoUrl(dept?.photo);

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 14,
                          spreadRadius: 1,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: photoUrl != null
                                  ? NetworkImage(photoUrl) as ImageProvider
                                  : const AssetImage('assets/bg-login.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      dept?.name ?? 'Department',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1F2937),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final result = await Get.toNamed(
                                        Routes.DEPARTMENT_INFO,
                                        arguments: dept,
                                      );
                                      // If department was edited or deleted, go back with result
                                      if (result == true) {
                                        Get.back(result: true);
                                      }
                                    },
                                    child: Icon(Icons.info_outline, size: 18, color: Colors.grey[400]),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Show member count for this department
                              if (!Get.isRegistered<MembersController>())
                                const Text(
                                  '0 members',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              else
                                Obx(() {
                                  final membersCtrl = Get.find<MembersController>();
                                  final memberCount = dept != null
                                      ? membersCtrl.members.where((m) => m.departmentId == dept.id).length
                                      : 0;

                                  return Text(
                                    '$memberCount member${memberCount == 1 ? '' : 's'}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  );
                                }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 50),
          // Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildTabs(),
            ),
          ),
          
          Container(
            height: 1,
            color: const Color(0xFFF3F4F6),
          ),

          // Announcement Card shown below tabs so it's visible across all tab pages
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: _buildAnnouncementCard(),
          ),
          
          // Tab View Content (Task/Discussion/Members)
          // Since TabBarView usually expands, we wrap in Expanded.
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _buildTaskTab(),
                const Center(child: Text('Discussion Content')),
                _buildMembersTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard() {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.CREATE_ANNOUNCEMENT),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.campaign,
                color: AppTheme.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Announce Something to your team',
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 36,
      child: TabBar(
        controller: controller.tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicator: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        labelColor: const Color(0xFF1F2937),
        unselectedLabelColor: const Color(0xFF9CA3AF),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        padding: EdgeInsets.zero,
        labelPadding: const EdgeInsets.only(right: 8),
        tabs: [
          _tabItem(Icons.assignment_outlined, 'Task'),
          _tabItem(Icons.chat_bubble_outline, 'Discussion'),
          _tabItem(Icons.people_outline, 'Members'),
        ],
      ),
    );
  }

  Widget _tabItem(IconData icon, String text) {
    return Tab(
      height: 36,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskTab() {
    return Obx(() {
      if (controller.isLoadingTasks.value) {
        return const Center(child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(),
        ));
      }

      if (controller.departmentTasks.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.assignment_outlined, size: 48, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Text(
                'No tasks assigned yet',
                style: TextStyle(color: Colors.grey.shade500),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchDepartmentTasks,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.departmentTasks.length,
          separatorBuilder: (c, i) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final task = controller.departmentTasks[index];
            return _buildTaskItem(task);
          },
        ),
      );
    });
  }

  Widget _buildTaskItem(DepartmentTaskModel task) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.assignment_outlined,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.taskSubject,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Assigned to: ${task.username}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(task.status),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade400),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(task.dueDate),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              if (task.location.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(
                      task.location,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bgColor;
    Color textColor;
    String label = status;

    switch (status.toLowerCase()) {
      case 'completed':
        bgColor = Colors.green.shade50;
        textColor = Colors.green.shade700;
        break;
      case 'pending':
        bgColor = Colors.orange.shade50;
        textColor = Colors.orange.shade700;
        break;
      case 'in_progress':
        bgColor = Colors.blue.shade50;
        textColor = Colors.blue.shade700;
        label = 'In Progress';
        break;
      default:
        bgColor = Colors.grey.shade100;
        textColor = Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.capitalizeFirst ?? label,
        style: TextStyle(
          color: textColor,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDate(String dateStr) {
    if (dateStr.isEmpty) return '-';
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  Widget _buildMembersTab() {
    final dept = controller.department.value;
    if (dept == null) {
      return const Center(child: Text('No department selected'));
    }

    // If MembersController is available, use it (reactive)
    if (Get.isRegistered<MembersController>()) {
      return GetBuilder<MembersController>(
        init: Get.find<MembersController>(),
        builder: (membersCtrl) {
          final members = membersCtrl.members.where((m) {
            // Match by departmentId OR by location (department name) to be robust
            final byId = m.departmentId != null && m.departmentId == dept.id;
            final byName = m.location != null && m.location == dept.name;
            // Also handle possible string-int mismatch
            final byIdString = m.departmentId != null && m.departmentId.toString() == dept.id.toString();
            return byId || byName || byIdString;
          }).toList();

          if (members.isEmpty) {
            return RefreshIndicator(
              onRefresh: membersCtrl.fetchMembers,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 300,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        Text('No members in this department', style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: membersCtrl.fetchMembers,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: members.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
              itemBuilder: (context, index) {
                return MemberListItem(user: members[index]);
              },
            ),
          );
        },
      );
    }

    // Fallback: fetch users directly via UserService
    return FutureBuilder<List<UserModel>>(
      future: UserService().getUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Failed to load members'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Get.offAndToNamed(Routes.MEMBERS_LIST),
                  child: const Text('Open Members List'),
                ),
              ],
            ),
          );
        }

        final users = snapshot.data ?? [];
        final members = users.where((u) {
          final byId = u.departmentId != null && u.departmentId == dept.id;
          final byName = u.location != null && u.location == dept.name;
          final byIdString = u.departmentId != null && u.departmentId.toString() == dept.id.toString();
          return byId || byName || byIdString;
        }).toList();

        if (members.isEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              // Try refreshing by navigating to members list
              await Get.toNamed(Routes.MEMBERS_LIST);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 300,
                child: Center(child: Text('No members in this department')),
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: members.length,
          separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
          itemBuilder: (context, index) => MemberListItem(user: members[index]),
        );
      },
    );
  }
}
