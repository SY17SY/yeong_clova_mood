import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/models/eg_comment_model.dart';
import 'package:yeong_clova_mood/models/f_post_model.dart';
import 'package:yeong_clova_mood/repos/f_post_repo.dart';

class DetailViewModel extends FamilyStreamNotifier<List<PostModel>, String> {
  @override
  Stream<List<PostModel>> build(String uid) {
    final repository = ref.read(postRepository);
    return repository.getUserPosts(uid);
  }
}

final detailProvider =
    StreamNotifierProvider.family<DetailViewModel, List<PostModel>, String>(
  () => DetailViewModel(),
);

class CommentsViewModel
    extends FamilyStreamNotifier<List<CommentModel>, String> {
  @override
  Stream<List<CommentModel>> build(String postId) {
    final repository = ref.read(postRepository);
    return repository.getPostComments(postId);
  }
}

final commentsProvider = StreamNotifierProvider.family<CommentsViewModel,
    List<CommentModel>, String>(() => CommentsViewModel());
