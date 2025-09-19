import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/models/a_user_model.dart';
import 'package:yeong_clova_mood/repos/a_user_repo.dart';
import 'package:yeong_clova_mood/repos/b_auth_repo.dart';

class UserViewModel extends AsyncNotifier<void> {
  late final UserRepository _repository;

  @override
  FutureOr<void> build() {
    _repository = ref.read(userRepository);
  }

  Future<void> createUser(
    UserCredential credential, {
    required String name,
  }) async {
    final user = UserModel(
      uid: credential.user!.uid,
      name: name,
      email: credential.user!.email ?? "example@gmail.com",
      followings: 0,
      followers: 0,
      createdAt: Timestamp.now(),
    );
    await _repository.createUser(user);
  }

  Future<List<UserModel>> searchUsers(String keyword) async {
    return _repository.searchUsers(keyword);
  }

  Future<void> deleteUser() async {
    final uid = ref.read(authRepository).user!.uid;
    await _repository.deleteUser(uid);
    await _repository.deleteUserFiles(uid);
  }
}

final userProvider = AsyncNotifierProvider<UserViewModel, void>(
  () => UserViewModel(),
);
