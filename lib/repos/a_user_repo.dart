import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/models/a_user_model.dart';

class UserRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> createUser(UserModel user) async {
    await _db.collection("users").doc(user.uid).set(user.toJson());
  }

  Future<List<UserModel>> searchUsers(String uid, String keyword) async {
    final query = _db
        .collection("users")
        .where("name", isGreaterThanOrEqualTo: keyword)
        .where("name", isLessThanOrEqualTo: "$keyword\uf8ff");
    final QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();
    final List<UserModel> users =
        snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList();

    return users;
  }

  Future<void> deleteUserFiles(String uid) async {
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
      print('Error deleting user files: $e');
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await _db.collection("users").doc(uid).delete();
    } catch (e) {
      print(e);
    }
  }
}

final userRepository = Provider((ref) => UserRepository());
