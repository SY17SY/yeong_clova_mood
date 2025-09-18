import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/repos/b_auth_repo.dart';
import 'package:yeong_clova_mood/utils.dart';
import 'package:yeong_clova_mood/views/e_my_screen.dart';

class LoginFormState {
  final Map<String, String> formData;

  LoginFormState({required this.formData});
}

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  LoginFormNotifier() : super(LoginFormState(formData: {}));

  void updateField(String key, String value) {
    final newFormData = Map<String, String>.from(state.formData);
    newFormData[key] = value;
    state = LoginFormState(formData: newFormData);
  }

  void resetField(String key) {
    final newFormData = Map<String, String>.from(state.formData);
    newFormData.remove(key);
    state = LoginFormState(formData: newFormData);
  }

  void clearForm() {
    state = LoginFormState(formData: {});
  }

  String? getField(String key) {
    return state.formData[key];
  }
}

class LoginViewModel extends AsyncNotifier<void> {
  late final AuthRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(authRepository);
  }

  Future<void> login(BuildContext context) async {
    state = AsyncValue.loading();
    final formData = ref.read(loginFormProvider).formData;
    state = await AsyncValue.guard(() async {
      final email = formData['email']!;
      final password = formData['password']!;
      await _repository.logIn(email, password);
    });

    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      ref.read(loginFormProvider.notifier).clearForm();
      context.go(MyScreen.routeUrl);
    }
  }
}

final loginProvider = AsyncNotifierProvider<LoginViewModel, void>(
  () => LoginViewModel(),
);

final loginFormProvider =
    StateNotifierProvider<LoginFormNotifier, LoginFormState>(
  (ref) => LoginFormNotifier(),
);
