import 'package:flutter/material.dart';

class LoginBackground extends StatelessWidget {
  final Widget child;

  const LoginBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double bgImageHeight = screenSize.height * 0.45;

    return Stack(
      children: [
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: bgImageHeight,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/bg-login.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 24,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: const Color(0xFF1A237E).withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: Container(color: Colors.white)),
          ],
        ),
        child,
      ],
    );
  }
}
