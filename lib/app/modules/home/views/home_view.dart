import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Talenta Attendance'),
        centerTitle: true,
        backgroundColor: const Color(0xFF0046BE),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 200,
            ),
            const SizedBox(height: 32),
            const Text(
              'TALENTA ATTENDANCE',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0046BE),
              ),
            ),
            const SizedBox(height: 48),
            Obx(
              () => Text(
                'Counter: ${controller.count}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        backgroundColor: const Color(0xFF0046BE),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
