import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

class TaskDetailTabBar extends StatelessWidget {
  const TaskDetailTabBar({
    required this.controller,
    this.isReadOnly = false,
    super.key,
  });

  final TabController controller;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: AppTheme.gray200, width: 1)),
      ),
      child: TabBar(
        controller: controller,
        labelColor: Colors.black,
        unselectedLabelColor: AppTheme.gray500,
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: AppTheme.primaryColor,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: [
          const Tab(text: 'Instructions'),
          if (!isReadOnly) const Tab(text: 'Employee Work'),
        ],
      ),
    );
  }
}
