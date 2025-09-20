import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';

class BottomAuth extends ConsumerWidget {
  final String title;
  final String buttonTitle;
  final VoidCallback onTap;

  const BottomAuth({
    super.key,
    required this.title,
    required this.buttonTitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomAppBar(
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Sizes.d32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TbodyMedium16(
              title,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            Gaps.h4,
            GestureDetector(
              onTap: onTap,
              child: TtitleSmall16(buttonTitle, color: AppColors.primary),
            )
          ],
        ),
      ),
    );
  }
}
