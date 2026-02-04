import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/member_model.dart';
import '../../../common/widgets/app_back_button.dart';
import '../../../core/theme/app_theme.dart';
import './widgets/member_profile_header.dart';
import './widgets/member_attendance_log_section.dart';
import './widgets/member_task_section.dart';
import './widgets/member_more_menu.dart';

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
        leading: const AppBackButton(),
        actions: [
          MemberMoreMenu(member: member),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MemberProfileHeader(member: member),
            const SizedBox(height: 24),
            const Divider(height: 1, color: Color(0xFFE5E5E5)),
            const SizedBox(height: 16),
            const MemberAttendanceLogSection(),
            Container(
              height: 8,
              color: const Color(0xFFFAFAFA),
              margin: const EdgeInsets.symmetric(vertical: 24),
            ),
            const MemberTaskSection(),
          ],
        ),
      ),
    );
  }
}
