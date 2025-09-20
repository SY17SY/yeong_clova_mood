import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/models/f_post_model.dart';
import 'package:yeong_clova_mood/repos/g_your_repo.dart';

class YourViewModel extends StreamNotifier<List<PostModel>> {
  @override
  Stream<List<PostModel>> build() {
    final repository = ref.read(yourRepository);
    final date = ref.watch(selectedDateProvider).selectedDate;
    return repository.getPosts(date);
  }
}

class SelectedDateState {
  final DateTime selectedDate;

  SelectedDateState({required this.selectedDate});
}

class SelectedDateViewModel extends StateNotifier<SelectedDateState> {
  SelectedDateViewModel()
      : super(
          SelectedDateState(selectedDate: DateTime.now()),
        );

  void updateSelectedDate(DateTime newDate) {
    state = SelectedDateState(selectedDate: newDate);
  }

  bool isSelected(DateTime date) {
    final currentDate = state.selectedDate;
    return currentDate.year == date.year &&
        currentDate.month == date.month &&
        currentDate.day == date.day;
  }
}

final yourProvider = StreamNotifierProvider<YourViewModel, List<PostModel>>(
  () => YourViewModel(),
);

final selectedDateProvider =
    StateNotifierProvider<SelectedDateViewModel, SelectedDateState>(
  (ref) => SelectedDateViewModel(),
);
