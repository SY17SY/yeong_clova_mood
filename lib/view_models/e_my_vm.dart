import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/models/f_post_model.dart';
import 'package:yeong_clova_mood/repos/b_auth_repo.dart';
import 'package:yeong_clova_mood/repos/e_my_repo.dart';

class MyViewModel extends StreamNotifier<List<PostModel>> {
  @override
  Stream<List<PostModel>> build() {
    final repository = ref.read(myRepository);
    final date = ref.watch(mySelectedDateProvider).selectedDate;
    return repository.getMyPosts(date);
  }

  Stream<bool> givenClova(String postId) {
    final repository = ref.read(myRepository);
    final uid = ref.read(authRepository).user!.uid;
    return repository.givenClova(postId: postId, uid: uid);
  }

  Future<void> toggleClovaPost({
    required String postUid,
    required String postId,
  }) async {
    final repository = ref.read(myRepository);
    final uid = ref.read(authRepository).user!.uid;
    await repository.toggleClovaPost(
      postUid: postUid,
      postId: postId,
      uid: uid,
    );
  }

  Future<void> deletePost(String postId) async {
    final uid = ref.read(authRepository).user!.uid;
    final repository = ref.read(myRepository);
    await repository.deletePost(postId);
    await repository.deletePostFiles(uid: uid, postId: postId);
  }
}

class MySelectedDateState {
  final DateTime selectedDate;

  MySelectedDateState({required this.selectedDate});
}

class MySelectedDateViewModel extends StateNotifier<MySelectedDateState> {
  MySelectedDateViewModel()
      : super(
          MySelectedDateState(selectedDate: DateTime.now()),
        );

  void updateSelectedDate(DateTime newDate) {
    state = MySelectedDateState(selectedDate: newDate);
  }

  bool isSelected(DateTime date) {
    final currentDate = state.selectedDate;
    return currentDate.year == date.year &&
        currentDate.month == date.month &&
        currentDate.day == date.day;
  }
}

final myProvider = StreamNotifierProvider<MyViewModel, List<PostModel>>(
  () => MyViewModel(),
);

final mySelectedDateProvider =
    StateNotifierProvider<MySelectedDateViewModel, MySelectedDateState>(
  (ref) => MySelectedDateViewModel(),
);

final givenClovaProvider = StreamProvider.family<bool, String>((ref, postId) {
  final repository = ref.read(myRepository);
  final uid = ref.read(authRepository).user!.uid;
  return repository.givenClova(postId: postId, uid: uid);
});
