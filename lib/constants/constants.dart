import 'package:yeong_clova_mood/constants/colors.dart';

const weekdays = ["일", "월", "화", "수", "목", "금", "토"];

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
