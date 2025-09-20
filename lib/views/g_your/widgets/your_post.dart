import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/constants/constants.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';
import 'package:yeong_clova_mood/models/f_post_model.dart';
import 'package:yeong_clova_mood/utils.dart';
import 'package:yeong_clova_mood/view_models/h_settings_vm.dart';

class YourPost extends ConsumerWidget {
  final PostModel post;

  const YourPost({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(settingsProvider.notifier).isDark(context);
    return Container(
      decoration: BoxDecoration(
        image: post.thumbUrl != null && post.thumbUrl!.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(
                  toImageUrl(post.thumbUrl!),
                ),
                fit: BoxFit.cover,
              )
            : null,
        color: post.thumbUrl == null || post.thumbUrl!.isEmpty
            ? isDark
                ? moodColorsDark[moodsMood[post.mood]]
                : moodColors[moodsMood[post.mood]]
            : null,
      ),
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.2),
                Colors.transparent,
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.center,
            ).createShader(bounds),
            blendMode: BlendMode.srcIn,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            bottom: Sizes.d8,
            left: Sizes.d8,
            right: Sizes.d8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TlabelLarge14(
                  post.title,
                  maxLines: 2,
                  color: Colors.white,
                ),
                if (post.content != null && post.content!.isNotEmpty) ...[
                  Gaps.v4,
                  Opacity(
                    opacity: 0.7,
                    child: TbodySmall14(
                      post.content!,
                      maxLines: 1,
                      color: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: Sizes.d12,
            right: Sizes.d12,
            child: Image.asset(
              moodImgs[moodsMood[post.mood]]!,
              width: Sizes.d32,
              height: Sizes.d32,
            ),
          )
        ],
      ),
    );
  }
}
