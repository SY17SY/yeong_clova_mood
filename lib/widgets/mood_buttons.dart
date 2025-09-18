import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/view_models/f_post_vm.dart';

enum Mood { happy, excited, calm, sad, angry, anxious }

const moods = [
  Mood.happy,
  Mood.excited,
  Mood.calm,
  Mood.sad,
  Mood.angry,
  Mood.anxious,
];

const moodsStr = {
  Mood.happy: "happy",
  Mood.excited: "excited",
  Mood.calm: "calm",
  Mood.sad: "sad",
  Mood.angry: "angry",
  Mood.anxious: "anxious",
};

const moodImgs = {
  Mood.happy: "assets/images/happy.png",
  Mood.excited: "assets/images/excited.png",
  Mood.calm: "assets/images/calm.png",
  Mood.sad: "assets/images/sad.png",
  Mood.angry: "assets/images/angry.png",
  Mood.anxious: "assets/images/anxious.png",
};

var moodColors = {
  Mood.happy: AppColors.happy,
  Mood.excited: AppColors.excited,
  Mood.calm: AppColors.calm,
  Mood.sad: AppColors.sad,
  Mood.angry: AppColors.angry,
  Mood.anxious: AppColors.anxious,
};

class MoodButtons extends ConsumerStatefulWidget {
  const MoodButtons({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MoodButtonsState();
}

class _MoodButtonsState extends ConsumerState<MoodButtons> {
  void _onMoodTap(Mood newMood) {
    ref.read(postUploadProvider.notifier).updateMood(moodsStr[newMood]!);
  }

  @override
  Widget build(BuildContext context) {
    final selectedMood = ref.watch(postUploadProvider).mood;

    return Row(
      spacing: Sizes.d4,
      children: [
        for (var mood in moods)
          GestureDetector(
            onTap: () => _onMoodTap(mood),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(Sizes.d8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.d6),
                color: selectedMood == moodsStr[mood]
                    ? moodColors[mood]
                    : Colors.transparent,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    moodImgs[mood]!,
                    width: Sizes.d36,
                  ),
                  Gaps.v8,
                  SizedBox(
                    width: Sizes.d56,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      style:
                          Theme.of(context).textTheme.labelLarge!.copyWith(
                                color: selectedMood == moodsStr[mood]
                                    ? Colors.white
                                    : AppColors.neutral400,
                              ),
                      textAlign: TextAlign.center,
                      child: Text(moodsStr[mood]!),
                    ),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }
}
