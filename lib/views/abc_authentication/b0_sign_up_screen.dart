import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';
import 'package:yeong_clova_mood/views/abc_authentication/b1_email_sign_up_screen.dart';
import 'package:yeong_clova_mood/views/abc_authentication/c_login_screen.dart';
import 'package:yeong_clova_mood/views/abc_authentication/widgets/auth_button.dart';
import 'package:yeong_clova_mood/views/abc_authentication/widgets/bottom_auth.dart';

class SignUpScreen extends ConsumerWidget {
  static const routeName = "sign-up";
  static const routeUrl = "/sign-up";

  const SignUpScreen({super.key});

  void _onEmailTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmailSignUpScreen()),
    );
  }

  void _onLoginTap(BuildContext context) {
    context.push(LoginScreen.routeUrl);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.d32,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 2, child: SizedBox()),
              Expanded(
                flex: 2,
                child: Image.asset("assets/images/clover.png"),
              ),
              Expanded(flex: 1, child: SizedBox()),
              Expanded(
                flex: 30,
                child: Column(
                  children: [
                    TtitleLarge20("Sign up", fontSize: Sizes.d24),
                    Gaps.v20,
                    TbodyLarge18(
                      "당신의 일상을 클로바로 채워요",
                      color: AppColors.neutral600,
                    ),
                    Gaps.v40,
                    GestureDetector(
                      onTap: () => _onEmailTap(context),
                      child: AuthButton(
                        icon: FontAwesomeIcons.user,
                        text: "이메일 / 비밀번호",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAuth(
        title: "이미 가입하셨나요?",
        buttonTitle: "로그인",
        onTap: () => _onLoginTap(context),
      ),
    );
  }
}
