import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/constants.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';
import 'package:yeong_clova_mood/models/f_post_model.dart';
import 'package:yeong_clova_mood/repos/b_auth_repo.dart';
import 'package:yeong_clova_mood/utils.dart';
import 'package:yeong_clova_mood/view_models/g_settings_vm.dart';
import 'package:yeong_clova_mood/widgets/my_post_menu.dart';

class Post extends ConsumerStatefulWidget {
  final PostModel post;

  const Post({super.key, required this.post});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostState();
}

class _PostState extends ConsumerState<Post> {
  late final hour = widget.post.createdAt!.toDate().hour;
  late final minute = widget.post.createdAt!.toDate().minute;

  void _onMyMenuTap() async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => MyPostMenu(post: widget.post),
    );
  }

  void _onYourMenuTap() async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => MyPostMenu(post: widget.post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(settingsProvider.notifier).isDark(context);
    final isMyPost = ref.watch(authRepository).user!.uid == widget.post.uid;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: Sizes.d5,
                color: isDark
                    ? moodColorsDark[moodsMood[widget.post.mood]]!
                    : moodColors[moodsMood[widget.post.mood]]!,
              ),
            ),
          ),
          margin: EdgeInsets.only(left: Sizes.d8),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: Sizes.d2,
              horizontal: Sizes.d16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: TtitleSmall16(widget.post.title)),
                    Gaps.h8,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TlabelSmall12(
                          "$hour시 $minute분",
                          color: AppColors.neutral500,
                        ),
                        IconButton(
                          onPressed: isMyPost ? _onMyMenuTap : _onYourMenuTap,
                          icon: FaIcon(
                            FontAwesomeIcons.ellipsis,
                          ),
                          color: AppColors.neutral500,
                          iconSize: Sizes.d20,
                        )
                      ],
                    )
                  ],
                ),
                if (widget.post.content != null &&
                    widget.post.content!.isNotEmpty)
                  TbodySmall14(widget.post.content!, maxLines: 3),
                if (widget.post.thumbUrl != null &&
                    widget.post.thumbUrl!.isNotEmpty) ...[
                  Gaps.v16,
                  Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Sizes.d8),
                      image: DecorationImage(
                        image: NetworkImage(toImageUrl(widget.post.thumbUrl!)),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
                Gaps.v6,
                Row(
                  spacing: Sizes.d4,
                  children: [
                    SvgPicture.asset(
                      "assets/images/mini_clova.svg",
                      width: Sizes.d24,
                      height: Sizes.d24,
                      colorFilter: ColorFilter.mode(
                        isDark ? AppColors.neutral200 : AppColors.neutral800,
                        BlendMode.srcIn,
                      ),
                    ),
                    TbodySmall14(widget.post.clovas.toString()),
                    Gaps.h10,
                    SvgPicture.asset(
                      "assets/images/comment.svg",
                      width: Sizes.d24,
                      height: Sizes.d24,
                      colorFilter: ColorFilter.mode(
                        isDark ? AppColors.neutral200 : AppColors.neutral800,
                        BlendMode.srcIn,
                      ),
                    ),
                    TbodySmall14(widget.post.comments.toString()),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
