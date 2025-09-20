import 'package:yeong_clova_mood/constants/colors.dart';

const weekdays = ["일", "월", "화", "수", "목", "금", "토"];

enum Mood { happy, excited, calm, sad, angry, anxious, lucky }

const moods = [
  Mood.happy,
  Mood.excited,
  Mood.calm,
  Mood.sad,
  Mood.angry,
  Mood.anxious,
  Mood.lucky,
];

const moodsStr = {
  Mood.happy: "happy",
  Mood.excited: "excited",
  Mood.calm: "calm",
  Mood.sad: "sad",
  Mood.angry: "angry",
  Mood.anxious: "anxious",
  Mood.lucky: "lucky",
};

const moodsMood = {
  "happy": Mood.happy,
  "excited": Mood.excited,
  "calm": Mood.calm,
  "sad": Mood.sad,
  "angry": Mood.angry,
  "anxious": Mood.anxious,
  "lucky": Mood.lucky,
};

const moodImgs = {
  Mood.happy: "assets/images/happy.png",
  Mood.excited: "assets/images/excited.png",
  Mood.calm: "assets/images/calm.png",
  Mood.sad: "assets/images/sad.png",
  Mood.angry: "assets/images/angry.png",
  Mood.anxious: "assets/images/anxious.png",
  Mood.lucky: "assets/images/clover.png",
};

var moodColors = {
  Mood.happy: AppColors.happy,
  Mood.excited: AppColors.excited,
  Mood.calm: AppColors.calm,
  Mood.sad: AppColors.sad,
  Mood.angry: AppColors.angry,
  Mood.anxious: AppColors.anxious,
  Mood.lucky: AppColors.lucky,
};

var moodColorsDark = {
  Mood.happy: AppColors.happyDark,
  Mood.excited: AppColors.excitedDark,
  Mood.calm: AppColors.calmDark,
  Mood.sad: AppColors.sadDark,
  Mood.angry: AppColors.angryDark,
  Mood.anxious: AppColors.anxiousDark,
  Mood.lucky: AppColors.luckyDark,
};
