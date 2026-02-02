import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
          child: Text(
            'Welcome',
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.2,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Center(
          child: RichText(
            text: const TextSpan(
              text: 'To ',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.2,
                letterSpacing: -0.5,
              ),
              children: [
                TextSpan(
                  text: 'Talenta Attendance',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        const Center(
          child: Text(
            'Hello There, Login to continue',
            style: TextStyle(
              fontSize: 15,
              color: Color(0xFF9E9E9E),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
