import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/login_controller.dart';
import '../../../../core/theme/app_theme.dart';
import 'login_header.dart';
import 'email_input_field.dart';
import 'password_input_field.dart';
import 'login_button.dart';

class LoginCard extends GetView<LoginController> {
  const LoginCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double cardHorizontalPadding = screenWidth * 0.06;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 45),
            padding: EdgeInsets.fromLTRB(
              cardHorizontalPadding,
              55,
              cardHorizontalPadding,
              32,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const LoginHeader(),
                  SizedBox(height: screenSize.height * 0.028),
                  const EmailInputField(),
                  SizedBox(height: screenSize.height * 0.022),
                  const PasswordInputField(),
                  const SizedBox(height: 10),
                  _buildForgotPassword(),
                  SizedBox(height: screenSize.height * 0.02),
                  const LoginButton(),
                ],
              ),
            ),
          ),
          _buildLogo(),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return const Positioned(
      top: 0,
      child: _LogoWidget(),
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: controller.goToForgotPassword,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'Forget password?',
          style: TextStyle(
            color: AppTheme.errorColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  const _LogoWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Image.asset(
        'assets/logo.png',
        fit: BoxFit.contain,
      ),
    );
  }
}
