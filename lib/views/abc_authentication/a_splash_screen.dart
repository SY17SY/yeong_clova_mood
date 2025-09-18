import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';
import 'package:yeong_clova_mood/views/e_my_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  static const routeName = "splash";
  static const routeUrl = "/splash";
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _brandController;
  late AnimationController _taglineController;

  late Animation<double> _logoAnimation;
  late Animation<double> _brandAnimation;
  late Animation<double> _taglineAnimation;

  late Animation<Offset> _logoSlideAnimation;
  late Animation<Offset> _brandSlideAnimation;
  late Animation<Offset> _taglineSlideAnimation;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _brandController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _logoAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    _brandAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _brandController,
      curve: Curves.easeOutCubic,
    ));

    _taglineAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeOutCubic,
    ));

    _logoSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOutBack,
    ));

    _brandSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _brandController,
      curve: Curves.easeOutCubic,
    ));

    _taglineSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _taglineController,
      curve: Curves.easeOutCubic,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _brandController.forward();

    await Future.delayed(const Duration(milliseconds: 300));
    _taglineController.forward();

    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      context.go(MyScreen.routeUrl);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _brandController.dispose();
    _taglineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _logoSlideAnimation,
              child: FadeTransition(
                opacity: _logoAnimation,
                child: ScaleTransition(
                  scale: _logoAnimation,
                  child: Image.asset(
                    "assets/images/clover.png",
                    width: Sizes.d80,
                    height: Sizes.d80,
                  ),
                ),
              ),
            ),
            Gaps.v32,
            SlideTransition(
              position: _brandSlideAnimation,
              child: FadeTransition(
                opacity: _brandAnimation,
                child: TtitleLarge20(
                  "CLOVA MOOD",
                  textAlign: TextAlign.center,
                  fontSize: Sizes.d28,
                ),
              ),
            ),
            Gaps.v52,
            SlideTransition(
              position: _taglineSlideAnimation,
              child: FadeTransition(
                opacity: _taglineAnimation,
                child: Column(
                  children: [
                    TbodyMedium16(
                      "오늘은 당신의 행복이 되고,",
                      textAlign: TextAlign.center,
                      color: AppColors.neutral600,
                    ),
                    Gaps.v10,
                    TbodyMedium16(
                      "내일은 당신의 행운이 되길.",
                      textAlign: TextAlign.center,
                      color: AppColors.neutral600,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
