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
import 'package:yeong_clova_mood/view_models/e_my_vm.dart';
import 'package:yeong_clova_mood/view_models/h_settings_vm.dart';
import 'package:yeong_clova_mood/views/e_my/widgets/my_post_menu.dart';
import 'package:yeong_clova_mood/views/g_your/widgets/your_post_menu.dart';

class DetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "detail";
  static const String routeUrl = ":postId";

  final String tab;
  final String postId;
  final PostModel post;

  const DetailScreen({
    super.key,
    required this.tab,
    required this.postId,
    required this.post,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  late final hour = widget.post.createdAt!.toDate().hour;
  late final minute = widget.post.createdAt!.toDate().minute;
  late final Future<bool> _givenClovaFuture;

  @override
  void initState() {
    super.initState();
    _givenClovaFuture =
        ref.read(myProvider.notifier).givenClova(widget.post.id);
  }

  void _onClovaTap() {
    ref.read(myProvider.notifier).toggleClovaPost(widget.post.id);
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
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0.5,
            floating: true,
            snap: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  moodImgs[moodsMood[widget.post.mood]]!,
                  width: Sizes.d24,
                  height: Sizes.d24,
                ),
                Gaps.h8,
                TtitleSmall16(widget.post.title),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: Sizes.d20,
                horizontal: Sizes.d16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.post.content != null &&
                      widget.post.content!.isNotEmpty)
                    TbodyMedium16(widget.post.content!),
                  if (widget.post.thumbUrl != null &&
                      widget.post.thumbUrl!.isNotEmpty) ...[
                    Gaps.v16,
                    Hero(
                      tag: "${widget.tab}_${widget.post.id}",
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                toImageUrl(widget.post.thumbUrl!),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (widget.post.imgUrls != null &&
                      widget.post.imgUrls!.isNotEmpty) ...[
                    for (var imgUrl in widget.post.imgUrls!) ...[
                      Gaps.v16,
                      AspectRatio(
                        aspectRatio: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(toImageUrl(imgUrl)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                  Gaps.v10,
                  Consumer(
                    builder: (context, ref, child) {
                      return FutureBuilder<bool>(
                        future: _givenClovaFuture,
                        builder: (context, snapshot) {
                          final givenClova = snapshot.data ?? false;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                spacing: Sizes.d18,
                                children: [
                                  GestureDetector(
                                    onTap: _onClovaTap,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/images/mini_clova.svg",
                                          width: Sizes.d32,
                                          height: Sizes.d32,
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
                                        width: Sizes.d32,
                                        height: Sizes.d32,
                                        colorFilter: ColorFilter.mode(
                                          isDark
                                              ? AppColors.neutral200
                                              : AppColors.neutral800,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      Gaps.h4,
                                      TbodySmall14(
                                          widget.post.comments.toString()),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TbodySmall14(
                                    "$hour시 $minute분",
                                    color: AppColors.neutral500,
                                  ),
                                  IconButton(
                                    onPressed: isMyPost
                                        ? _onMyMenuTap
                                        : _onYourMenuTap,
                                    icon: FaIcon(
                                      FontAwesomeIcons.ellipsis,
                                    ),
                                    color: AppColors.neutral500,
                                    iconSize: Sizes.d20,
                                  )
                                ],
                              )
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
