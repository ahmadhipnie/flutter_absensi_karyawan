import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  final currentIndex = 0.obs;

  final List<Widget> pages = [];

  @override
  void onInit() {
    super.onInit();
    // Check if there's an initial index passed via arguments
    final args = Get.arguments;
    if (args != null && args['initialIndex'] != null) {
      currentIndex.value = args['initialIndex'];
    }
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  // Method to navigate to specific page from anywhere
  static void navigateToPage(int index) {
    Get.offAllNamed('/main', arguments: {'initialIndex': index});
  }

  // Helper methods for specific pages
  static void navigateToDashboard() => navigateToPage(0);
  static void navigateToTask() => navigateToPage(1);
  static void navigateToCommunity() => navigateToPage(2);
}
