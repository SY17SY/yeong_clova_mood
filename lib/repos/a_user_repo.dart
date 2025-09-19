import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/models/a_user_model.dart';
import 'package:yeong_clova_mood/repos/b_auth_repo.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Ref _ref;

  UserRepository(this._ref);

  String? get _currentUserId => _ref.read(authRepository).user?.uid;

  Future<void> createUser(UserModel user) async {
    if (_currentUserId == null) {
      throw Exception("User not authenticated");
    }
    if (user.uid != _currentUserId) {
      throw Exception("Unauthorized: Cannot create user for another uid");
    }

    try {
      await _db.collection("users").doc(user.uid).set(user.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> searchUsers(String keyword) async {
    if (_currentUserId == null) {
      throw Exception("User not authenticated");
    }
    if (keyword.trim().isEmpty) {
      return [];
    }

    try {
      final query = _db
          .collection("users")
          .where("name", isGreaterThanOrEqualTo: keyword.trim())
          .where("name", isLessThanOrEqualTo: "${keyword.trim()}\uf8ff")
          .limit(50);

      final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
      final List<UserModel> users = snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .where((user) => user.uid != _currentUserId)
          .toList();

      return users;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUserFiles(String uid) async {
    if (_currentUserId == null) {
      throw Exception("User not authenticated");
    }
    if (uid != _currentUserId) {
      throw Exception("Unauthorized: Cannot delete another user's files");
    }

    try {
      final ref = _storage.ref().child("/posts/$uid/");
      final ListResult result = await ref.listAll();

      for (Reference dirRef in result.prefixes) {
        final ListResult dirResult = await dirRef.listAll();
        for (Reference fileRef in dirResult.items) {
          await fileRef.delete();
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteUser(String uid) async {
    if (_currentUserId == null) {
      throw Exception("User not authenticated");
    }
    if (uid != _currentUserId) {
      throw Exception("Unauthorized: Cannot delete another user's account");
    }

    try {
      await _db.collection("users").doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    if (_currentUserId == null) return null;

    try {
      final doc = await _db.collection("users").doc(_currentUserId).get();
      if (!doc.exists) return null;

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUserById(String uid) async {
    if (_currentUserId == null) {
      throw Exception("User not authenticated");
    }

    try {
      final doc = await _db.collection("users").doc(uid).get();
      if (!doc.exists) return null;

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      rethrow;
    }
  }
}

final userRepository = Provider((ref) => UserRepository(ref));
