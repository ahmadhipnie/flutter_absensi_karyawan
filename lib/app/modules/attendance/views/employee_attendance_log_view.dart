import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmployeeAttendanceLogView extends StatelessWidget {
  const EmployeeAttendanceLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Attendance Log',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          _buildDateSection('18 Feb 2026', [
            {'name': 'Karina', 'time': '08:00'},
            {'name': 'Paijo Uchiha', 'time': '08:00'},
            {'name': 'Rahmat', 'time': '08:00'},
            {'name': 'Lestari', 'time': '08:00'},
          ]),
          const SizedBox(height: 10),
          _buildDateSection('17 Feb 2026', [
            {'name': 'Karina', 'time': '08:00'},
            {'name': 'Paijo Uchiha', 'time': '08:00'},
            {'name': 'Rahmat', 'time': '08:00'},
            {'name': 'Lestari', 'time': '08:00'},
          ]),
        ],
      ),
    );
  }

  Widget _buildDateSection(String date, List<Map<String, String>> employees) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ...employees.map((e) => _buildEmployeeItem(e)),
      ],
    );
  }

  Widget _buildEmployeeItem(Map<String, String> employee) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(
                  'https://ui-avatars.com/api/?name=${employee['name']}&background=random'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    employee['name']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Check in on ${employee['time']}',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Divider(color: Colors.grey.shade200, height: 1),
        const SizedBox(height: 16),
      ],
    );
  }
}
