import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class AttendanceLogView extends StatelessWidget {
  const AttendanceLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Attendance Report',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month Selector
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    'February 2026',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey[600]),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            // Stats Row
            Row(
              children: [
                Expanded(child: _buildStatCard('Absent', '19')),
                SizedBox(width: 12),
                Expanded(child: _buildStatCard('Clock In', '10')),
                SizedBox(width: 12),
                Expanded(child: _buildStatCard('Late Clock In', '20')),
              ],
            ),
            
            SizedBox(height: 24),
            
            // List
            _buildLogItem('17 Feb 2026', '08:00'),
            Divider(height: 1, color: Colors.grey[100]),
            _buildLogItem('18 Feb 2026', '08:05'),
            Divider(height: 1, color: Colors.grey[100]),
            _buildLogItem('19 Feb 2026', '07:58'),
            Divider(height: 1, color: Colors.grey[100]),
            _buildLogItem('20 Feb 2026', '08:00'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String count) {
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
            label,
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

  Widget _buildLogItem(String date, String time) {
    return InkWell(
      onTap: () => Get.toNamed(
        Routes.ATTENDANCE_HISTORY_DETAIL,
        arguments: {
          'date': date,
          'checkInTime': time,
          'photoUrl': '',
          'notes': 'Work from office',
          'location': 'Jl. Orchard Boulevard, Belian, Kec. Batam Kota',
        },
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.chevron_right, size: 20, color: Colors.grey[600]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
