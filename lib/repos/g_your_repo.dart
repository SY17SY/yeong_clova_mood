import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/models/f_post_model.dart';

class YourRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  YourRepository();

  Stream<List<PostModel>> getPosts(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final query = _db
        .collection("posts")
        .where("createdAt",
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where("createdAt", isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy("createdAt", descending: true)
        .snapshots();
    return query.map((event) => event.docs
        .map((doc) => PostModel.fromJson(doc.data(), postId: doc.id))
        .toList());
  }
}

final yourRepository = Provider((ref) => YourRepository());
