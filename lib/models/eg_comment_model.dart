import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String id;
  final String postId;
  final String postUid;
  final String uid;
  final String name;
  final String content;
  final Timestamp? createdAt;

  CommentModel({
    this.id = "",
    required this.postId,
    required this.postUid,
    required this.uid,
    required this.name,
    required this.content,
    this.createdAt,
  });

  CommentModel.fromJson(Map<String, dynamic> json, {required String commentId})
      : id = commentId,
        postId = json["postId"],
        postUid = json["postUid"],
        uid = json["uid"],
        name = json["name"],
        content = json["content"],
        createdAt = json["createdAt"] as Timestamp;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'postUid': postUid,
      'uid': uid,
      'name': name,
      'content': content,
      'createdAt': createdAt,
    };
  }
}
