import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';
import 'package:yeong_clova_mood/view_models/b_sign_up_vm.dart';
import 'package:yeong_clova_mood/views/abc_authentication/widgets/auth_text_form_field.dart';
import 'package:yeong_clova_mood/views/abc_authentication/widgets/form_button.dart';

class EmailSignUpScreen extends ConsumerStatefulWidget {
  const EmailSignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailSignUpScreenState();
}

class _EmailSignUpScreenState extends ConsumerState<EmailSignUpScreen> {
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final TextEditingController _checkController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, String> formData = {};

  String? _isNameValid(String? input) {
    if (input == null || input.isEmpty) {
      return "닉네임을 작성해 주세요.";
    }
    return null;
  }

  String? _isEmailValid(String? input) {
    if (input == null || input.isEmpty) {
      return "이메일을 작성해 주세요.";
    }
    final regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (!regExp.hasMatch(input)) {
      return "이메일의 형식이 올바르지 않습니다.";
    }
    return null;
  }

  String? _isPasswordValid(String? input) {
    if (input == null || input.isEmpty) {
      return "비밀번호를 작성해 주세요.";
    }
    final baseRegExp = r"[A-Za-z0-9@$!%*#?&\^]";
    final regExpLen = r"{8,20}";
    final regExpChr = r"(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[@$!%*#?&\^])";

    final regExp1 = RegExp(r"^" + regExpChr + baseRegExp);
    if (!regExp1.hasMatch(input)) {
      return "비밀번호의 형식이 올바르지 않습니다.";
    }
    final regExp2 = RegExp(r"^" + baseRegExp + regExpLen);
    if (!regExp2.hasMatch(input)) {
      return "비밀번호는 8~20자로 작성해주세요.";
    }
    return null;
  }

  String? _checkPassword(String? input) {
    if (input == null || input.isEmpty) {
      return "비밀번호를 한 번 더 작성해 주세요.";
    }
    if (input != ref.read(signUpFormProvider).formData["password"]) {
      return "비밀번호가 일치하지 않습니다.";
    }
    return null;
  }

  void _onSubmitTap() {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        ref.read(signUpProvider.notifier).emailSignUp(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(title: TtitleMedium18("회원가입")),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Sizes.d20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Gaps.v28,
                  TtitleMedium18("닉네임", color: AppColors.neutral500),
                  Gaps.v8,
                  AuthTextFormField(
                    hintText: "name",
                    controller: _nameController,
                    validator: _isNameValid,
                    fieldKey: 'name',
                    formType: AuthFormType.signUp,
                  ),
                  Gaps.v28,
                  TtitleMedium18("이메일", color: AppColors.neutral500),
                  Gaps.v8,
                  AuthTextFormField(
                    hintText: "email@example.com",
                    controller: _emailController,
                    validator: _isEmailValid,
                    fieldKey: 'email',
                    formType: AuthFormType.signUp,
                  ),
                  Gaps.v28,
                  TtitleMedium18("비밀번호", color: AppColors.neutral500),
                  Gaps.v8,
                  AuthTextFormField(
                    hintText: "password",
                    controller: _passwordController,
                    validator: _isPasswordValid,
                    fieldKey: 'password',
                    formType: AuthFormType.signUp,
                  ),
                  Gaps.v28,
                  TtitleMedium18("비밀번호 확인", color: AppColors.neutral500),
                  Gaps.v8,
                  AuthTextFormField(
                    hintText: "password",
                    controller: _checkController,
                    validator: _checkPassword,
                    fieldKey: "check",
                    formType: AuthFormType.signUp,
                  ),
                  Gaps.v48,
                  FormButton(
                    title: "회원가입",
                    onTap: _onSubmitTap,
                    disabled: ref.watch(signUpProvider).isLoading,
                  ),
                  Gaps.v48,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
