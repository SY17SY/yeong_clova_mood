import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';
import 'package:yeong_clova_mood/repos/b_auth_repo.dart';
import 'package:yeong_clova_mood/view_models/h_settings_vm.dart';
import 'package:yeong_clova_mood/views/abc_authentication/b0_sign_up_screen.dart';

class SettingScreen extends ConsumerStatefulWidget {
  static const routeName = "setting";
  static const routeUrl = "/setting";

  const SettingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingScreenState();
}

class _SettingScreenState extends ConsumerState<SettingScreen> {
  Future<void> _onLogoutTap() async {
    await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("로그아웃"),
        content: Text("정말 로그아웃하시겠습니까?"),
        actions: [
          CupertinoDialogAction(
            onPressed: () => context.pop(),
            child: Text("아니오"),
          ),
          CupertinoDialogAction(
            onPressed: () async {
              await ref.read(authRepository).logOut();
              if (mounted && context.mounted) {
                context.pop();
                context.go(SignUpScreen.routeUrl);
              }
            },
            isDestructiveAction: true,
            child: Text("로그아웃"),
          ),
        ],
      ),
    );
  }

  void _onThemeChanged(ThemeMode? mode) {
    if (mode == null) return;

    switch (mode) {
      case ThemeMode.system:
        ref.read(settingsProvider.notifier).setThemeMode(
              followSystem: true,
              darkMode: false,
            );
        break;
      case ThemeMode.light:
        ref.read(settingsProvider.notifier).setThemeMode(
              followSystem: false,
              darkMode: false,
            );
        break;
      case ThemeMode.dark:
        ref.read(settingsProvider.notifier).setThemeMode(
              followSystem: false,
              darkMode: true,
            );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final currentThemeMode = settings.followSystem
        ? ThemeMode.system
        : (settings.darkMode ? ThemeMode.dark : ThemeMode.light);
    return Scaffold(
      appBar: AppBar(
        title: TtitleMedium18("설정"),
        elevation: 0.5,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            size: Sizes.d20,
          ),
        ),
      ),
      body: ListView(
        children: [
          Gaps.v24,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.d24),
            child: TtitleSmall16(
              "테마",
              color: AppColors.neutral600,
            ),
          ),
          Gaps.v12,
          Container(
            margin: EdgeInsets.symmetric(horizontal: Sizes.d16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Sizes.d12),
              border: Border.all(
                color: AppColors.neutral200,
                width: 0.5,
              ),
            ),
            child: Column(
              children: [
                RadioGroup<ThemeMode>(
                  groupValue: currentThemeMode,
                  onChanged: _onThemeChanged,
                  child: Column(
                    children: [
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.system,
                        title: TbodyMedium16("시스템 설정"),
                        subtitle: TbodySmall14(
                          "기기의 테마 설정을 따릅니다",
                          color: AppColors.neutral500,
                        ),
                        activeColor: AppColors.primary,
                      ),
                      Divider(
                        height: 1,
                        color: AppColors.neutral200,
                        indent: Sizes.d16,
                        endIndent: Sizes.d16,
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.light,
                        title: TbodyMedium16("라이트 모드"),
                        subtitle: TbodySmall14(
                          "밝은 테마를 사용합니다",
                          color: AppColors.neutral500,
                        ),
                        activeColor: AppColors.primary,
                      ),
                      Divider(
                        height: 1,
                        color: AppColors.neutral200,
                        indent: Sizes.d16,
                        endIndent: Sizes.d16,
                      ),
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.dark,
                        title: TbodyMedium16("다크 모드"),
                        subtitle: TbodySmall14(
                          "어두운 테마를 사용합니다",
                          color: AppColors.neutral500,
                        ),
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gaps.v32,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.d24),
            child: TtitleSmall16(
              "계정",
              color: AppColors.neutral600,
            ),
          ),
          Gaps.v12,
          Container(
            margin: EdgeInsets.symmetric(horizontal: Sizes.d16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Sizes.d12),
              border: Border.all(
                color: AppColors.neutral200,
                width: 0.5,
              ),
            ),
            child: ListTile(
              onTap: _onLogoutTap,
              leading: Container(
                padding: EdgeInsets.all(Sizes.d8),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(Sizes.d8),
                ),
                child: FaIcon(
                  FontAwesomeIcons.rightFromBracket,
                  color: AppColors.error,
                  size: Sizes.d20,
                ),
              ),
              title: TbodyMedium16(
                "로그아웃",
                color: AppColors.error,
              ),
              trailing: FaIcon(
                FontAwesomeIcons.chevronRight,
                color: AppColors.neutral400,
                size: Sizes.d16,
              ),
            ),
          ),
          Gaps.v24,
        ],
      ),
    );
  }
}
