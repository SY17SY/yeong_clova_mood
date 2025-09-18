import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/repos/b_auth_repo.dart';
import 'package:yeong_clova_mood/views/abc_authentication/a_splash_screen.dart';
import 'package:yeong_clova_mood/views/abc_authentication/b0_sign_up_screen.dart';
import 'package:yeong_clova_mood/views/abc_authentication/c_login_screen.dart';
import 'package:yeong_clova_mood/views/d_common/d_main_navigation_screen.dart';
import 'package:yeong_clova_mood/views/f_upload/f_upload_screen.dart';

final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: SplashScreen.routeUrl,
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepository).isLoggedIn;
      if (!isLoggedIn) {
        if (state.subloc != SplashScreen.routeUrl &&
            state.subloc != SignUpScreen.routeUrl &&
            state.subloc != LoginScreen.routeUrl) {
          return SignUpScreen.routeUrl;
        }
      }
      return null;
    },
    routes: [
      GoRoute(
        name: SplashScreen.routeName,
        path: SplashScreen.routeUrl,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: SignUpScreen.routeName,
        path: SignUpScreen.routeUrl,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: SignUpScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: LoginScreen.routeName,
        path: LoginScreen.routeUrl,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: LoginScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: MainNavigationScreen.routeName,
        path: "/:tab(mine|yours)",
        pageBuilder: (context, state) {
          final tab = state.params["tab"]!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: MainNavigationScreen(tab),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          );
        },
      ),
      GoRoute(
        name: UploadScreen.routeName,
        path: UploadScreen.routeUrl,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: UploadScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              late final Animation<Offset> slideAnimation = Tween(
                begin: Offset(0, 1),
                end: Offset.zero,
              ).animate(animation);
              return SlideTransition(
                position: slideAnimation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
          );
        },
      ),
    ],
  ),
);
