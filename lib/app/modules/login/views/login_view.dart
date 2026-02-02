import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    // Get screen size for responsive calculations
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;

    // Background image height (higher to cover more area)
    final double bgImageHeight = screenHeight * 0.45;

    // Responsive sizes
    final double horizontalPadding = screenWidth * 0.05;
    final double cardHorizontalPadding = screenWidth * 0.06;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        bottomOpacity: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background structure
          Column(
            children: [
              // Background Image - Full width, higher coverage
              SizedBox(
                width: double.infinity,
                height: bgImageHeight,
                child: Stack(
                  children: [
                    // Background image only (no overlay on status bar area)
                    Positioned.fill(
                      child: Image.asset(
                        'assets/bg-login.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Dark overlay hanya di bawah status bar
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

              // Rest is white background
              Expanded(child: Container(color: Colors.white)),
            ],
          ),

          // Main Content - Centered Card with SafeArea
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 20,
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    // White Card
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
                            // Welcome Text
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

                            // To Talenta Attendance
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
                                        color: Color(0xFF0046BE),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Subtitle
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
                            SizedBox(height: screenHeight * 0.028),

                            // Email Label
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF9E9E9E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Email Input
                            TextFormField(
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: controller.validateEmail,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF9E9E9E),
                                  fontSize: 16,
                                ),
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.only(left: 16, right: 12),
                                  child: Icon(
                                    Icons.alternate_email,
                                    color: Color(0xFF9E9E9E),
                                    size: 24,
                                  ),
                                ),
                                prefixIconConstraints: const BoxConstraints(
                                  minWidth: 52,
                                  minHeight: 52,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE0E0E0),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF0046BE),
                                    width: 1.5,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.022),

                            // Password Label
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF9E9E9E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Password Input
                            Obx(
                              () => TextFormField(
                                controller: controller.passwordController,
                                obscureText: controller.obscurePassword.value,
                                validator: controller.validatePassword,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                decoration: InputDecoration(
                                  hintText: '• • • • • •',
                                  hintStyle: const TextStyle(
                                    color: Color(0xFF9E9E9E),
                                    fontSize: 14,
                                    letterSpacing: 4,
                                  ),
                                  prefixIcon: const Padding(
                                    padding: EdgeInsets.only(
                                      left: 16,
                                      right: 12,
                                    ),
                                    child: Icon(
                                      Icons.vpn_key_rounded,
                                      color: Color(0xFF9E9E9E),
                                      size: 22,
                                    ),
                                  ),
                                  prefixIconConstraints: const BoxConstraints(
                                    minWidth: 52,
                                    minHeight: 52,
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: IconButton(
                                      icon: Icon(
                                        controller.obscurePassword.value
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: const Color(0xFF757575),
                                        size: 24,
                                      ),
                                      onPressed:
                                          controller.togglePasswordVisibility,
                                    ),
                                  ),
                                  suffixIconConstraints: const BoxConstraints(
                                    minWidth: 48,
                                    minHeight: 48,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE0E0E0),
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFFE0E0E0),
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF0046BE),
                                      width: 1.5,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Forgot Password
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: controller.goToForgotPassword,
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: 4,
                                  ),
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Forget password?',
                                  style: TextStyle(
                                    color: Color(0xFFE53935),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            // Login Button
                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: controller.isLoading.value
                                      ? null
                                      : controller.login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF0046BE),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                    disabledBackgroundColor: const Color(
                                      0xFF0046BE,
                                    ).withOpacity(0.6),
                                  ),
                                  child: controller.isLoading.value
                                      ? const SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        )
                                      : const Text(
                                          'Login',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Logo - positioned to overlap with card
                    Positioned(
                      top: 0,
                      child: Container(
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
