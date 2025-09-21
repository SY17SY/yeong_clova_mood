import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/models/eg_comment_model.dart';
import 'package:yeong_clova_mood/models/f_post_model.dart';

class PostRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  String generatePostId() {
    return _db.collection("posts").doc().id;
  }

  Future<PostModel> createPost(PostModel post) async {
    await _db.collection("posts").doc(post.id).set(post.toJson());
    return post;
  }

  Future<String> uploadPost({
    required File file,
    required String uid,
    required String postId,
  }) async {
    final fileName =
        "/posts/$uid/$postId/${DateTime.now().millisecondsSinceEpoch}";
    final ref = _storage.ref().child(fileName);
    await ref.putFile(file);
    return fileName;
  }

  Stream<List<PostModel>> getUserPosts(String uid) {
    return _db
        .collection("users")
        .doc(uid)
        .collection("posts")
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map(
              (doc) => PostModel.fromJson(doc.data(), postId: doc.id),
            )
            .toList());
  }

  Future<CommentModel> createComment(CommentModel comment) async {
    final commentId = "${comment.postUid}_${comment.uid}_${comment.createdAt}";
    await _db
        .collection("posts")
        .doc(comment.postId)
        .collection("comments")
        .doc(commentId)
        .set(comment.toJson());
    return comment;
  }

  Stream<List<CommentModel>> getPostComments(String postId) {
    return _db
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => CommentModel.fromJson(
                  doc.data(),
                  commentId: doc.id,
                ))
            .toList());
  }
}

final postRepository = Provider((ref) => PostRepository());
