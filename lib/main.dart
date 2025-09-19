import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/firebase_options.dart';
import 'package:yeong_clova_mood/repos/g_settings_repo.dart';
import 'package:yeong_clova_mood/router.dart';
import 'package:yeong_clova_mood/view_models/g_settings_vm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final preferences = await SharedPreferences.getInstance();
  final repository = SettingsRepository(preferences);

  runApp(
    ProviderScope(
      overrides: [
        settingsProvider.overrideWith((ref) => SettingsViewModel(repository))
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return MaterialApp.router(
      title: 'Yeong Mood Tracker',
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
      themeMode: settingsNotifier.themeMode,
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.neutral100,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.textPrimaryLight,
          onError: Colors.white,
        ),
        splashColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimaryLight,
          elevation: 0,
        ),
        bottomAppBarTheme: BottomAppBarThemeData(
          color: AppColors.neutral100,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColors.neutral400),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        tabBarTheme: TabBarThemeData(
          labelStyle: Theme.of(context).textTheme.titleSmall,
          unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
          unselectedLabelColor: AppColors.neutral500,
          labelColor: Colors.white,
          indicatorColor: Colors.transparent,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontFamily: "PretendardSemibold",
            fontSize: Sizes.d20,
            letterSpacing: -0.025,
          ),
          titleMedium: TextStyle(
            fontFamily: "PretendardSemibold",
            fontSize: Sizes.d18,
            letterSpacing: -0.025,
          ),
          titleSmall: TextStyle(
            fontFamily: "PretendardSemibold",
            fontSize: Sizes.d16,
            letterSpacing: -0.025,
          ),
          bodyLarge: TextStyle(
            fontFamily: "PretendardMedium",
            fontSize: Sizes.d18,
            letterSpacing: -0.025,
          ),
          bodyMedium: TextStyle(
            fontFamily: "PretendardMedium",
            fontSize: Sizes.d16,
            letterSpacing: -0.025,
          ),
          bodySmall: TextStyle(
            fontFamily: "PretendardMedium",
            fontSize: Sizes.d14,
            letterSpacing: -0.025,
          ),
          labelLarge: TextStyle(
            fontFamily: "PretendardSemibold",
            fontSize: Sizes.d14,
            letterSpacing: -0.025,
          ),
          labelSmall: TextStyle(
            fontFamily: "PretendardMedium",
            fontSize: Sizes.d12,
            letterSpacing: -0.025,
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: false,
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.neutral900,
          error: AppColors.error,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: AppColors.textPrimaryDark,
          onError: Colors.white,
        ),
        splashColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: AppColors.textPrimaryDark,
          elevation: 0,
        ),
        bottomAppBarTheme: BottomAppBarThemeData(
          color: AppColors.neutral800,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: AppColors.neutral500),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        tabBarTheme: TabBarThemeData(
          labelStyle: Theme.of(context).textTheme.titleSmall,
          unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
          unselectedLabelColor: AppColors.neutral500,
          labelColor: Colors.white,
          indicatorColor: Colors.transparent,
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(
            fontFamily: "PretendardSemibold",
            fontSize: Sizes.d20,
            letterSpacing: -0.025,
            color: AppColors.textPrimaryDark,
          ),
          titleMedium: TextStyle(
            fontFamily: "PretendardSemibold",
            fontSize: Sizes.d18,
            letterSpacing: -0.025,
            color: AppColors.textPrimaryDark,
          ),
          titleSmall: TextStyle(
            fontFamily: "PretendardSemibold",
            fontSize: Sizes.d16,
            letterSpacing: -0.025,
            color: AppColors.textPrimaryDark,
          ),
          bodyLarge: TextStyle(
            fontFamily: "PretendardMedium",
            fontSize: Sizes.d18,
            letterSpacing: -0.025,
            color: AppColors.textPrimaryDark,
          ),
          bodyMedium: TextStyle(
            fontFamily: "PretendardMedium",
            fontSize: Sizes.d16,
            letterSpacing: -0.025,
            color: AppColors.textPrimaryDark,
          ),
          bodySmall: TextStyle(
            fontFamily: "PretendardMedium",
            fontSize: Sizes.d14,
            letterSpacing: -0.025,
            color: AppColors.textPrimaryDark,
          ),
          labelLarge: TextStyle(
            fontFamily: "PretendardSemibold",
            fontSize: Sizes.d14,
            letterSpacing: -0.025,
            color: AppColors.textPrimaryDark,
          ),
          labelSmall: TextStyle(
            fontFamily: "PretendardMedium",
            fontSize: Sizes.d12,
            letterSpacing: -0.025,
            color: AppColors.textPrimaryDark,
          ),
        ),
      ),
    );
  }
}
