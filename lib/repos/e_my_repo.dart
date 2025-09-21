import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/models/f_post_model.dart';
import 'package:yeong_clova_mood/repos/b_auth_repo.dart';

class MyRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Ref _ref;

  MyRepository(this._ref);

  String? get _currentUserId => _ref.read(authRepository).user?.uid;

  Stream<List<PostModel>> getMyPosts(DateTime date) {
    if (_currentUserId == null) return Stream.value([]);

    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = _db
        .collection("posts")
        .where("uid", isEqualTo: _currentUserId)
        .where("createdAt",
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where("createdAt", isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy("createdAt", descending: true)
        .snapshots();
    return query.map((event) => event.docs
        .map((doc) => PostModel.fromJson(doc.data(), postId: doc.id))
        .toList());
  }

  Stream<bool> givenClova({required String postId, required String uid}) {
    return _db
        .collection("users")
        .doc(uid)
        .collection("clovas")
        .doc(postId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  Future<void> toggleClovaPost({
    required String postUid,
    required String postId,
    required String uid,
  }) async {
    final query = _db.collection("clovas").doc("${postUid}_${postId}_$uid");
    final clova = await query.get();

    if (!clova.exists) {
      await query.set({"createdAt": Timestamp.now()});
    } else {
      await query.delete();
    }
  }

  Future<void> deletePost(String postId) async {
    if (_currentUserId == null) throw Exception("User not authenticated");

    try {
      final postDoc = await _db.collection("posts").doc(postId).get();
      if (!postDoc.exists) {
        throw Exception("Post not found");
      }

      final postData = postDoc.data()!;
      if (postData["uid"] != _currentUserId) {
        throw Exception("Unauthorized: Cannot delete another user's post");
      }

      await _db.collection("posts").doc(postId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deletePostFiles({
    required String uid,
    required String postId,
  }) async {
    if (_currentUserId == null) throw Exception("User not authenticated");
    if (uid != _currentUserId) {
      throw Exception("Unauthorized: Cannot delete another user's files");
    }

    try {
      final ref = _storage.ref().child("/posts/$uid/$postId/");
      final ListResult result = await ref.listAll();
      for (Reference fileRef in result.items) {
        await fileRef.delete();
      }
    } catch (e) {
      rethrow;
    }
  }
}

final myRepository = Provider((ref) => MyRepository(ref));
