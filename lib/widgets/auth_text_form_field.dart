import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/view_models/b_sign_up_vm.dart';
import 'package:yeong_clova_mood/view_models/c_login_vm.dart';
import 'package:yeong_clova_mood/view_models/h_settings_vm.dart';
import 'package:yeong_clova_mood/widgets/input_clear_button.dart';

enum AuthFormType { login, signUp }

class AuthTextFormField extends ConsumerStatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final String fieldKey;
  final AuthFormType formType;

  const AuthTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.validator,
    required this.fieldKey,
    required this.formType,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthTextFormFieldState();
}

class _AuthTextFormFieldState extends ConsumerState<AuthTextFormField> {
  String text = "";
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    if (widget.fieldKey == "password" || widget.fieldKey == "check") {
      _obscureText = true;
    }
    widget.controller.addListener(_onTextChanged);
  }

  void _toggleObscure() {
    setState(() {
      if (widget.fieldKey == "password" || widget.fieldKey == "check") {
        _obscureText = !_obscureText;
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    text = widget.controller.text;

    switch (widget.formType) {
      case AuthFormType.login:
        ref.read(loginFormProvider.notifier).updateField(widget.fieldKey, text);
        break;
      case AuthFormType.signUp:
        ref
            .read(signUpFormProvider.notifier)
            .updateField(widget.fieldKey, text);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(settingsProvider.notifier).isDark(context);
    return TextFormField(
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: isDark ? AppColors.neutral500 : AppColors.neutral400,
            ),
        errorStyle: Theme.of(context)
            .textTheme
            .titleMedium!
            .copyWith(color: AppColors.error),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? AppColors.neutral700 : AppColors.neutral300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.error,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.error,
          ),
        ),
        suffix: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (text.isNotEmpty)
              InputClearButton(
                controller: widget.controller,
              ),
            if (widget.fieldKey == "password" ||
                widget.fieldKey == "check") ...[
              Gaps.h16,
              GestureDetector(
                onTap: _toggleObscure,
                child: FaIcon(
                  _obscureText
                      ? FontAwesomeIcons.eye
                      : FontAwesomeIcons.eyeSlash,
                  color: AppColors.neutral400,
                  size: Sizes.d20,
                ),
              ),
            ],
            Gaps.h8,
          ],
        ),
      ),
      style: Theme.of(context).textTheme.titleMedium,
      controller: widget.controller,
      autocorrect: false,
      obscureText: _obscureText,
      textInputAction: TextInputAction.next,
      validator: widget.validator,
      onSaved: (newValue) {
        if (newValue != null) {
          switch (widget.formType) {
            case AuthFormType.login:
              ref
                  .read(loginFormProvider.notifier)
                  .updateField(widget.fieldKey, newValue);
              break;
            case AuthFormType.signUp:
              ref
                  .read(signUpFormProvider.notifier)
                  .updateField(widget.fieldKey, newValue);
              break;
          }
        } else {
          switch (widget.formType) {
            case AuthFormType.login:
              ref.read(loginFormProvider.notifier).resetField(widget.fieldKey);
              break;
            case AuthFormType.signUp:
              ref.read(signUpFormProvider.notifier).resetField(widget.fieldKey);
              break;
          }
        }
      },
    );
  }
}
