import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../providers/menu_provider.dart';
import '../utils/app_colors.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _loadingController;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _slideAnim;
  late Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnim = Tween<double>(begin: 0.6, end: 1).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _slideAnim = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.3, 0.7, curve: Curves.easeOut),
      ),
    );

    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _fadeController.forward();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    // Load settings and menu
    final settings = context.read<SettingsProvider>();
    final menu = context.read<MenuProvider>();
    await settings.loadSettings();
    await menu.loadAll();

    await Future.delayed(const Duration(milliseconds: 1200));

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF7),
      body: Stack(
        children: [
          // Background food icons scattered
          ..._buildFoodIcons(size),

          // Bottom wave decoration
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomPaint(
              size: Size(size.width, size.height * 0.22),
              painter: _WavePainter(),
            ),
          ),

          // Main content
          Center(
            child: AnimatedBuilder(
              animation: _fadeController,
              builder: (ctx, child) => child!,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // Logo with scale animation
                  AnimatedBuilder(
                    animation: _fadeController,
                    builder: (ctx, child) => Opacity(
                      opacity: _fadeAnim.value,
                      child: Transform.scale(
                        scale: _scaleAnim.value,
                        child: child,
                      ),
                    ),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/gopal_logo.png',
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: const BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.storefront_rounded,
                              color: Colors.white,
                              size: 56,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Business name
                  AnimatedBuilder(
                    animation: _fadeController,
                    builder: (ctx, child) => Opacity(
                      opacity: _fadeAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnim.value),
                        child: child,
                      ),
                    ),
                    child: Text(
                      'ગોપાલ વડાપાંઉ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF1A1A2E),
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Decorative divider line + dot
                  AnimatedBuilder(
                    animation: _fadeController,
                    builder: (ctx, child) => Opacity(
                      opacity: _taglineFade.value,
                      child: child,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 40,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 40,
                          height: 3,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Tagline
                  AnimatedBuilder(
                    animation: _fadeController,
                    builder: (ctx, child) => Opacity(
                      opacity: _taglineFade.value,
                      child: child,
                    ),
                    child: Text(
                      'Smart POS for Your Business',
                      style: TextStyle(
                        color: const Color(0xFF475569),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const Spacer(flex: 4),

                  // Loading indicator
                  AnimatedBuilder(
                    animation: _fadeController,
                    builder: (ctx, child) => Opacity(
                      opacity: _taglineFade.value,
                      child: child,
                    ),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.primary),
                        backgroundColor:
                            AppColors.primary.withValues(alpha: 0.12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  AnimatedBuilder(
                    animation: _fadeController,
                    builder: (ctx, child) => Opacity(
                      opacity: _taglineFade.value,
                      child: child,
                    ),
                    child: Text(
                      'Loading...',
                      style: TextStyle(
                        color: const Color(0xFF94A3B8),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),

                  SizedBox(height: size.height * 0.06),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds scattered food icon decorations in the background
  List<Widget> _buildFoodIcons(Size size) {
    final iconData = [
      (Icons.lunch_dining, 0.08, 0.12, 36.0, -15.0),       // burger top-left
      (Icons.local_pizza_outlined, 0.85, 0.08, 30.0, 10.0), // pizza top-right
      (Icons.icecream_outlined, 0.92, 0.20, 28.0, 5.0),     // ice cream right
      (Icons.local_cafe_outlined, 0.05, 0.25, 26.0, -8.0),  // cup left
      (Icons.fastfood_outlined, 0.78, 0.35, 28.0, 12.0),    // fries right
      (Icons.bakery_dining_outlined, 0.12, 0.42, 24.0, -20.0), // bakery left
      (Icons.ramen_dining_outlined, 0.88, 0.50, 26.0, 8.0), // noodles right
      (Icons.local_drink_outlined, 0.08, 0.58, 28.0, -10.0), // drink left
      (Icons.kebab_dining_outlined, 0.82, 0.62, 24.0, 15.0), // kebab right
      (Icons.emoji_food_beverage_outlined, 0.15, 0.72, 26.0, -5.0), // beverage left
    ];

    return iconData.map((data) {
      return Positioned(
        left: size.width * data.$2,
        top: size.height * data.$3,
        child: AnimatedBuilder(
          animation: _fadeController,
          builder: (ctx, child) => Opacity(
            opacity: _fadeAnim.value * 0.12,
            child: Transform.rotate(
              angle: data.$5 * pi / 180,
              child: child,
            ),
          ),
          child: Icon(
            data.$1,
            size: data.$4,
            color: const Color(0xFFEA580C),
          ),
        ),
      );
    }).toList();
  }
}

/// Custom wave painter for the bottom decoration
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFEECD2).withValues(alpha: 0.6)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.45);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.35,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.5,
      size.width,
      size.height * 0.3,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // Second wave layer
    final paint2 = Paint()
      ..color = const Color(0xFFFEDCB0).withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height * 0.6);
    path2.quadraticBezierTo(
      size.width * 0.3,
      size.height * 0.4,
      size.width * 0.6,
      size.height * 0.55,
    );
    path2.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.68,
      size.width,
      size.height * 0.5,
    );
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
