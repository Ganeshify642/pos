import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';
import '../providers/menu_provider.dart';
import '../utils/app_colors.dart';
import '../utils/constants.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scaleAnim = Tween<double>(begin: 0.7, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;

    // Load settings and menu
    final settings = context.read<SettingsProvider>();
    final menu = context.read<MenuProvider>();
    await settings.loadSettings();
    await menu.loadAll();

    await Future.delayed(const Duration(milliseconds: 800));

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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (ctx, child) => Opacity(
            opacity: _fadeAnim.value,
            child: Transform.scale(
              scale: _scaleAnim.value,
              child: child,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],  
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white,
                  size: 52,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppConstants.appName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Offline Billing & Inventory',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 60),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
