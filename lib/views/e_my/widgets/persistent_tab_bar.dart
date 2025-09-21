import 'package:flutter/material.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';

class PersistentTabBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: AppColors.neutral200, width: 1),
        ),
      ),
      child: TabBar(
        labelPadding: EdgeInsets.symmetric(vertical: Sizes.d20),
        indicatorColor: AppColors.neutral500,
        tabs: [
          TtitleSmall16("클로바", color: AppColors.neutral500),
          TtitleSmall16("댓글", color: AppColors.neutral500),
          TtitleSmall16("모아보기", color: AppColors.neutral500),
        ],
      ),
    );
  }

  @override
  double get maxExtent => Sizes.d80;

  @override
  double get minExtent => Sizes.d60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
