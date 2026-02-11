import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../common/widgets/app_back_button.dart';
import './widgets/member_profile_header.dart';
import './widgets/member_attendance_log_section.dart';
import './widgets/member_task_section.dart';
import './widgets/member_more_menu.dart';

class MemberDetailView extends StatelessWidget {
  const MemberDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final UserModel user = Get.arguments as UserModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const AppBackButton(),
        actions: [
          MemberMoreMenu(user: user),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MemberProfileHeader(user: user),
            const SizedBox(height: 24),
            const Divider(height: 1, color: Color(0xFFE5E5E5)),
            const SizedBox(height: 16),
            MemberAttendanceLogSection(user: user),
            Container(
              height: 8,
              color: const Color(0xFFFAFAFA),
              margin: const EdgeInsets.symmetric(vertical: 24),
            ),
            MemberTaskSection(user: user),
          ],
        ),
      ),
    );
  }
}
