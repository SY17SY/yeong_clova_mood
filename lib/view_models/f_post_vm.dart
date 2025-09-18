import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/models/f_post_model.dart';
import 'package:yeong_clova_mood/repos/b_auth_repo.dart';
import 'package:yeong_clova_mood/repos/f_post_repo.dart';
import 'package:yeong_clova_mood/utils.dart';

class PostViewModel extends StreamNotifier<List<PostModel>> {
  late final PostRepository _repository;

  @override
  Stream<List<PostModel>> build() {
    _repository = ref.read(postRepository);

    return _repository.getPosts();
  }

  Future<void> uploadPost({
    required BuildContext context,
    required Map<String, dynamic> data,
    List<File>? files,
  }) async {
    state = AsyncValue.loading();

    final uid = ref.read(authRepository).user!.uid;
    final uploadState = ref.read(postUploadProvider);

    state = await AsyncValue.guard(() async {
      final postId = _repository.generatePostId();

      final thumbUrl = files != null && files.isNotEmpty
          ? await _repository.uploadPost(
              file: files[0],
              uid: uid,
              postId: postId,
            )
          : null;
      final imageUrls = files != null && files.length > 1
          ? await Future.wait(files.skip(1).map(
                (file) async => await _repository.uploadPost(
                  file: file,
                  uid: uid,
                  postId: postId,
                ),
              ))
          : null;

      var post = PostModel(
        id: postId,
        uid: uid,
        title: data["title"]!,
        mood: uploadState.mood!,
        content: data["content"],
        thumbUrl: thumbUrl,
        imgUrls: imageUrls,
        isPrivate: data["isPrivate"],
        createdAt: Timestamp.fromDate(uploadState.createdAt),
      );
      await _repository.createPost(post);

      return [post];
    });

    if (state.hasError) {
      showFirebaseErrorSnack(context, state.error);
    } else {
      ref.read(postUploadProvider.notifier).resetAll();
      context.pop();
    }
  }

  Future<void> deletePost(String postId) async {
    final uid = ref.read(authRepository).user!.uid;
    await _repository.deletePost(postId);
    await _repository.deletePostFiles(uid: uid, postId: postId);
  }
}

class PostUploadState {
  final String? mood;
  final List<File> files;
  final DateTime createdAt;

  PostUploadState({
    this.mood,
    required this.files,
    required this.createdAt,
  });

  PostUploadState copyWith({
    String? mood,
    List<File>? files,
    DateTime? createdAt,
  }) {
    return PostUploadState(
      mood: mood ?? this.mood,
      files: files ?? this.files,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PostUploadViewModel extends StateNotifier<PostUploadState> {
  PostUploadViewModel()
      : super(
          PostUploadState(
            mood: null,
            files: [],
            createdAt: DateTime.now().subtract(Duration(
              minutes: DateTime.now().minute % 10,
            )),
          ),
        );

  void updateMood(String? mood) {
    if (state.mood == mood) {
      state = PostUploadState(
        mood: null,
        files: state.files,
        createdAt: state.createdAt,
      );
      return;
    }
    state = state.copyWith(mood: mood);
  }

  void addFiles(File file) {
    if (state.files.contains(file)) return;

    state = state.copyWith(files: [...state.files, file]);
  }

  void removeFiles(File file) {
    final updatedFiles = List<File>.from(state.files)..remove(file);
    state = state.copyWith(files: updatedFiles);
  }

  void clearFiles() {
    state = state.copyWith(files: []);
  }

  void updateCreatedAt(DateTime dateTime) {
    final newDateTime = dateTime.subtract(Duration(
      minutes: dateTime.minute % 10,
    ));
    state = state.copyWith(createdAt: newDateTime);
  }

  void resetToNow() {
    final now = DateTime.now();
    final newNow = now.subtract(Duration(minutes: now.minute % 10));
    state = state.copyWith(createdAt: newNow);
  }

  void resetAll() {
    state = PostUploadState(
      mood: null,
      files: [],
      createdAt: DateTime.now().subtract(Duration(
        minutes: DateTime.now().minute % 10,
      )),
    );
  }
}

final postProvider = StreamNotifierProvider<PostViewModel, List<PostModel>>(
  () => PostViewModel(),
);

final postUploadProvider =
    StateNotifierProvider<PostUploadViewModel, PostUploadState>(
  (ref) => PostUploadViewModel(),
);
