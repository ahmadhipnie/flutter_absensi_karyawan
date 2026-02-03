import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/member_model.dart';
import '../../../core/theme/app_theme.dart';
import '../../../routes/app_pages.dart';

class MemberDetailView extends StatelessWidget {
  const MemberDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final MemberModel member = Get.arguments as MemberModel;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            child: PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.black),
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    Get.toNamed(Routes.EDIT_PROFILE, arguments: member);
                    break;
                  case 'password':
                    Get.toNamed(Routes.CHANGE_PASSWORD, arguments: member);
                    break;
                  case 'delete':
                    // TODO: Implement delete logic
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'edit',
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 20, color: Colors.grey[700]),
                      SizedBox(width: 8),
                      Text('Edit Profile', style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
                // smaller divider
                PopupMenuDivider(height: 8),
                PopupMenuItem(
                  value: 'password',
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: [
                      Icon(Icons.lock, size: 20, color: Colors.grey[700]),
                      SizedBox(width: 8),
                      Text('Change Password', style: TextStyle(color: Colors.grey[700])),
                    ],
                  ),
                ),
                PopupMenuDivider(height: 8),
                PopupMenuItem(
                  value: 'delete',
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: AppTheme.primaryColor),
                      SizedBox(width: 8),
                      Text('Delete Account', style: TextStyle(color: AppTheme.primaryColor)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: member.avatarUrl != null 
                        ? NetworkImage(member.avatarUrl!) 
                        : null,
                    child: member.avatarUrl == null
                        ? Icon(Icons.person, size: 40, color: Colors.grey)
                        : null,
                  ),
                  SizedBox(height: 16),
                  Text(
                    member.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    member.department, // Using department as role placeholder based on image
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),
            Divider(height: 1, color: Colors.grey[200]),
            SizedBox(height: 16),

            // Attendance Log Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Attendance Log',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View Log',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _buildAttendanceItem('17 Jan 2026', '08:00'),
                  Divider(height: 1, color: Colors.grey[100]),
                  _buildAttendanceItem('18 Jan 2026', '08:00'),
                  Divider(height: 1, color: Colors.grey[100]),
                  _buildAttendanceItem('19 Jan 2026', '08:00'),
                  Divider(height: 1, color: Colors.grey[100]),
                  _buildAttendanceItem('20 Jan 2026', '08:00'),
                ],
              ),
            ),

            Container(height: 8, color: Colors.grey[50], margin: EdgeInsets.symmetric(vertical: 24)),

            // Task Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTaskSummaryCard('Ditugaskan', '19')),
                      SizedBox(width: 12),
                      Expanded(child: _buildTaskSummaryCard('Tepat Waktu', '10')),
                      SizedBox(width: 12),
                      Expanded(child: _buildTaskSummaryCard('Approved', '20')),
                    ],
                  ),
                  SizedBox(height: 24),
                  _buildTaskItem(
                    'Site Inspection Report Submission',
                    'Due 17 Feb 2026, 11:59 PM',
                  ),
                  Divider(height: 32, color: Colors.grey[200]),
                  _buildTaskItem(
                    'Site Inspection Report Submission',
                    'Due 17 Feb 2026, 11:59 PM',
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceItem(String date, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            date,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Text(
                time,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, size: 20, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskSummaryCard(String title, String count) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFFEBF0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Icon(Icons.assignment, color: AppTheme.primaryColor, size: 24),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.more_vert, size: 20, color: Colors.grey[600]),
      ],
    );
  }
} // End of MemberDetailView class
