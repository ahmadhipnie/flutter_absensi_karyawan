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
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Members',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Add Members (compact header like design)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: InkWell(
              onTap: controller.goToCreateProfile,
              borderRadius: BorderRadius.circular(12),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(Icons.person_add, color: Colors.white, size: 28),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'Add Members',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 8),
          
          // Members List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              
              // Akses observable values untuk trigger rebuild ketika berubah
              // ignore: unused_local_variable
              final membersCount = controller.members.length;
              
              // Panggil getter METHOD (bukan getter property) setelah subscribe ke observables
              final members = controller.getFilteredMembers();
              
              if (members.isEmpty) {
                return Center(
                  child: Text(
                    'No members found',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 0),
                itemCount: members.length,
                separatorBuilder: (context, index) => Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.shade200,
                  indent: 76, // Align dengan text, skip avatar
                  endIndent: 16,
                ),
                itemBuilder: (context, index) {
                  return MemberListItem(member: members[index]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
