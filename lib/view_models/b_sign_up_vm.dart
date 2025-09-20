import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/repos/b_auth_repo.dart';
import 'package:yeong_clova_mood/utils.dart';
import 'package:yeong_clova_mood/view_models/a_user_vm.dart';
import 'package:yeong_clova_mood/views/e_my/e_my_screen.dart';

class SignUpFormState {
  final Map<String, String> formData;

  SignUpFormState({required this.formData});
}

class SignUpFormNotifier extends StateNotifier<SignUpFormState> {
  SignUpFormNotifier() : super(SignUpFormState(formData: {}));

  void updateField(String key, String value) {
    final newFormData = Map<String, String>.from(state.formData);
    newFormData[key] = value;
    state = SignUpFormState(formData: newFormData);
  }

  void resetField(String key) {
    final newFormData = Map<String, String>.from(state.formData);
    newFormData.remove(key);
    state = SignUpFormState(formData: newFormData);
  }

  void clearForm() {
    state = SignUpFormState(formData: {});
  }

  String? getField(String key) {
    return state.formData[key];
  }
}

class SignUpViewModel extends AsyncNotifier<void> {
  late final AuthRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepository);
  }

  Future<void> emailSignUp(BuildContext context) async {
    final formData = ref.read(signUpFormProvider).formData;

    state = AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final name = formData['name']!;
      final email = formData['email']!;
      final password = formData['password']!;

      final credential = await _repository.emailSignUp(email, password);
      await ref.read(userProvider.notifier).createUser(credential, name: name);
    });

    if (!context.mounted) return;
    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      ref.read(signUpFormProvider.notifier).clearForm();
      context.go(MyScreen.routeUrl);
    }
  }
}

final signUpProvider = AsyncNotifierProvider<SignUpViewModel, void>(
  () => SignUpViewModel(),
);

final signUpFormProvider =
    StateNotifierProvider<SignUpFormNotifier, SignUpFormState>(
  (ref) => SignUpFormNotifier(),
);
