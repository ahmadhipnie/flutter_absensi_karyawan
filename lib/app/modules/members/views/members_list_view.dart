import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/members_controller.dart';
import 'widgets/member_list_item.dart';
import '../../../core/theme/app_theme.dart';

class MembersListView extends GetView<MembersController> {
  const MembersListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Members',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            
            const SizedBox(height: 8),

            // Add Members Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: InkWell(
                onTap: controller.goToCreateProfile,
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.person_add, color: Colors.white, size: 24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Add Members',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const Divider(height: 24, thickness: 1, color: Color(0xFFF5F5F5)),

            // Members List
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Trigger rebuild when dependencies change
                // ignore: unused_local_variable
                final dep = controller.selectedDepartment.value;
                // ignore: unused_local_variable
                final query = controller.searchQuery.value;

                final members = controller.getFilteredMembers();

                if (members.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: controller.refresh,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'No members found',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.refresh,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: members.length,
                    separatorBuilder: (context, index) => Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade100,
                      indent: 80,
                      endIndent: 20,
                    ),
                    itemBuilder: (context, index) {
                      return MemberListItem(member: members[index]);
                    },
                  ),
                
                final users = controller.getFilteredUsers();
                
                if (users.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'No members found',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: users.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey.shade100,
                    indent: 80, 
                    endIndent: 20,
                  ),
                  itemBuilder: (context, index) {
                    return MemberListItem(user: users[index]);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSearchBar() {
  //   return Container(
  //     margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
  //     height: 44,
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF5F5F5),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: TextField(
  //       controller: controller.searchController,
  //       onChanged: controller.onSearchChanged,
  //       style: const TextStyle(fontSize: 14, color: Colors.black),
  //       decoration: const InputDecoration(
  //         prefixIcon: Icon(
  //           Icons.search,
  //           color: AppTheme.primaryColor,
  //           size: 22,
  //         ),
  //         hintText: 'Search Members',
  //         hintStyle: TextStyle(
  //           color: Color(0xFF9E9E9E),
  //           fontSize: 14,
  //           fontWeight: FontWeight.w400,
  //         ),
  //         border: InputBorder.none,
  //         enabledBorder: InputBorder.none,
  //         focusedBorder: InputBorder.none,
  //         contentPadding: EdgeInsets.symmetric(
  //           horizontal: 16,
  //           vertical: 12,
  //         ),
  //         isDense: true,
  //       ),
  //     ),
  //   );
  // }
}