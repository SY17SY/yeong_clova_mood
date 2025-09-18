import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String id;
  final String uid;
  final String title;
  final String mood;
  final String? content;
  final String? thumbUrl;
  final List<String>? imgUrls;
  final int clovas;
  final int comments;
  final bool isPrivate;
  final Timestamp? createdAt;

  PostModel({
    this.id = "",
    required this.uid,
    required this.title,
    required this.mood,
    this.content,
    this.thumbUrl,
    this.imgUrls,
    this.clovas = 0,
    this.comments = 0,
    required this.isPrivate,
    this.createdAt,
  });

  PostModel.fromJson(Map<String, dynamic> json, {required String postId})
      : id = postId,
        uid = json["uid"],
        title = json["title"],
        mood = json["mood"],
        content = json["content"],
        thumbUrl = json["thumbUrl"],
        imgUrls = json["imgUrls"],
        clovas = json["clovas"],
        comments = json["comments"],
        isPrivate = json["isPrivate"],
        createdAt = json["createdAt"] as Timestamp;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'title': title,
      'mood': mood,
      'content': content,
      'thumbUrl': thumbUrl,
      'imgUrls': imgUrls,
      'clovas': clovas,
      'comments': comments,
      'isPrivate': isPrivate,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
