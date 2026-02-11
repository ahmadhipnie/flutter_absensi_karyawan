import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/announcement_model.dart';
import '../../../utils/date_helper.dart';

class AnnouncementDetailView extends StatelessWidget {
  const AnnouncementDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final announcement = Get.arguments as AnnouncementModel?;

    if (announcement == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        body: const Center(
          child: Text('Announcement not found'),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
            onPressed: () => Get.back(),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: -30,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                            ],
                          ),
                          child: Icon(
                            announcement.isBroadcast ? Icons.campaign : Icons.description,
                            color: AppTheme.primaryColor,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                  ],
              ),
              const SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.black,
                          child: const Icon(Icons.person, color: Colors.white), 
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              announcement.senderName ?? 'Unknown',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateHelper.formatDateTimeWib(announcement.createdAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      announcement.subject,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      announcement.message,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
