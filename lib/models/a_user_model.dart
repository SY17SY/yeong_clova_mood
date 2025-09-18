import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String email;
  final int followings;
  final int followers;
  final Timestamp createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.followings,
    required this.followers,
    required this.createdAt,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : uid = json['uid'],
        name = json['name'],
        email = json['email'],
        followings = json['followings'],
        followers = json['followers'],
        createdAt = json['createdAt'] as Timestamp;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'followings': followings,
      'followers': followers,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
