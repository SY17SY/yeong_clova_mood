import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/constants.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';
import 'package:yeong_clova_mood/models/f_post_model.dart';
import 'package:yeong_clova_mood/repos/b_auth_repo.dart';
import 'package:yeong_clova_mood/utils.dart';
import 'package:yeong_clova_mood/view_models/e_my_vm.dart';
import 'package:yeong_clova_mood/view_models/h_settings_vm.dart';
import 'package:yeong_clova_mood/views/e_my/eg_detail_screen.dart';
import 'package:yeong_clova_mood/views/e_my/widgets/my_post_menu.dart';
import 'package:yeong_clova_mood/views/g_your/widgets/your_post_menu.dart';

class MyPost extends ConsumerStatefulWidget {
  final PostModel post;

  const MyPost({super.key, required this.post});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyPostState();
}

class _MyPostState extends ConsumerState<MyPost> {
  late final hour = widget.post.createdAt!.toDate().hour;
  late final minute = widget.post.createdAt!.toDate().minute;

  void _onClovaTap() {
    ref.read(myProvider.notifier).toggleClovaPost(widget.post.id);
  }

  void _onPostTap() {
    context.pushNamed(
      DetailScreen.routeName,
      params: {
        "tab": "mine",
        "postId": widget.post.id,
      },
      extra: widget.post,
    );
  }

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
      builder: (context) => YourPostMenu(post: widget.post),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(settingsProvider.notifier).isDark(context);
    final isMyPost = ref.watch(authRepository).user!.uid == widget.post.uid;
    return GestureDetector(
      onTap: _onPostTap,
      child: Container(
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
                Hero(
                  tag: "mine_${widget.post.id}",
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Sizes.d8),
                        image: DecorationImage(
                          image:
                              NetworkImage(toImageUrl(widget.post.thumbUrl!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
              Gaps.v10,
              Consumer(
                builder: (context, ref, child) {
                  return FutureBuilder<bool>(
                    future: ref
                        .watch(myProvider.notifier)
                        .givenClova(widget.post.id),
                    builder: (context, snapshot) {
                      final givenClova = snapshot.data ?? false;
                      return Row(
                        spacing: Sizes.d18,
                        children: [
                          GestureDetector(
                            onTap: _onClovaTap,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  "assets/images/mini_clova.svg",
                                  width: Sizes.d24,
                                  height: Sizes.d24,
                                  colorFilter: ColorFilter.mode(
                                    givenClova
                                        ? isDark
                                            ? AppColors.primaryLight
                                            : AppColors.primaryDark
                                        : isDark
                                            ? AppColors.neutral200
                                            : AppColors.neutral800,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Gaps.h4,
                                TbodySmall14(
                                  widget.post.clovas.toString(),
                                  color: givenClova
                                      ? isDark
                                          ? AppColors.primaryLight
                                          : AppColors.primaryDark
                                      : null,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/images/comment.svg",
                                width: Sizes.d24,
                                height: Sizes.d24,
                                colorFilter: ColorFilter.mode(
                                  isDark
                                      ? AppColors.neutral200
                                      : AppColors.neutral800,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Gaps.h4,
                              TbodySmall14(widget.post.comments.toString()),
                            ],
                          ),
                        ],
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
