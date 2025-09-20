import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';
import 'package:yeong_clova_mood/view_models/h_settings_vm.dart';

class NavTab extends ConsumerWidget {
  final String svgPath;
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const NavTab({
    super.key,
    required this.svgPath,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(settingsProvider.notifier).isDark(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: AnimatedOpacity(
          opacity: isSelected ? 1 : 0.4,
          duration: Duration(milliseconds: 200),
          child: Padding(
            padding: EdgeInsets.only(
              top: Sizes.d6,
              bottom: Sizes.d14,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  svgPath,
                  width: Sizes.d40,
                  height: Sizes.d40,
                  colorFilter: ColorFilter.mode(
                    isDark ? Colors.white : Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
                Gaps.v2,
                TlabelLarge14(text),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
