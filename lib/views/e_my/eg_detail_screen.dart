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
import 'package:yeong_clova_mood/view_models/eg_detail_vm.dart';
import 'package:yeong_clova_mood/view_models/f_post_vm.dart';
import 'package:yeong_clova_mood/view_models/h_settings_vm.dart';
import 'package:yeong_clova_mood/views/e_my/widgets/my_post_menu.dart';
import 'package:yeong_clova_mood/views/e_my/widgets/persistent_tab_bar.dart';
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
  final _commentController = TextEditingController();
  late final hour = widget.post.createdAt!.toDate().hour;
  late final minute = widget.post.createdAt!.toDate().minute;

  String _comment = "";

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() {
      setState(() {
        _comment = _commentController.text;
      });
    });
  }

  void _onClovaTap() {
    ref.read(myProvider.notifier).toggleClovaPost(
          postUid: widget.post.uid,
          postId: widget.post.id,
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

  void _onSubmitCommentTap() async {
    if (_comment.isEmpty) return;

    final data = {
      "postId": widget.postId,
      "postUid": widget.post.uid,
      "content": _comment,
    };
    await ref.read(postProvider.notifier).uploadComment(
          context: context,
          data: data,
        );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(settingsProvider.notifier).isDark(context);
    final isMyPost = ref.read(authRepository).user!.uid == widget.post.uid;

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: GestureDetector(
        onTap: _onScaffoldTap,
        child: Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: TtitleSmall16(widget.post.name)),
                                  Gaps.h8,
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TbodySmall14(
                                        minute == 0
                                            ? "$hour시"
                                            : "$hour시 $minute분",
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
                              ),
                              if (widget.post.content != null &&
                                  widget.post.content!.isNotEmpty) ...[
                                Gaps.v12,
                                TbodyMedium16(widget.post.content!),
                              ],
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
                                          image:
                                              NetworkImage(toImageUrl(imgUrl)),
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
                                  final givenClova = ref
                                          .watch(givenClovaProvider(
                                              widget.post.id))
                                          .value ??
                                      false;
                                  return Row(
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
                                            widget.post.comments.toString(),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverPersistentHeader(delegate: PersistentTabBar()),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            child: Center(child: TtitleLarge20("page 1")),
                          ),
                        ],
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final commentsAsync =
                              ref.watch(commentsProvider(widget.post.id));
                          return commentsAsync.when(
                            data: (comments) => CustomScrollView(
                              slivers: [
                                SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final comment = comments[index];
                                      final hour =
                                          comment.createdAt!.toDate().hour;
                                      final minute =
                                          comment.createdAt!.toDate().minute;
                                      return ListTile(
                                        title: TtitleSmall16(comment.name),
                                        subtitle:
                                            TbodyMedium16(comment.content),
                                        trailing: TlabelLarge14(
                                          minute == 0
                                              ? "$hour시"
                                              : "$hour시 $minute분",
                                          color: AppColors.neutral500,
                                        ),
                                      );
                                    },
                                    childCount: comments.length,
                                  ),
                                ),
                              ],
                            ),
                            loading: () => CustomScrollView(
                              slivers: [
                                SliverFillRemaining(
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                ),
                              ],
                            ),
                            error: (error, stack) => CustomScrollView(
                              slivers: [
                                SliverFillRemaining(
                                  child: Center(child: Text('댓글을 불러올 수 없습니다.')),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      CustomScrollView(
                        slivers: [
                          SliverFillRemaining(
                            child: Center(child: TtitleLarge20("page 3")),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsetsGeometry.symmetric(
                      horizontal: Sizes.d16,
                      vertical: Sizes.d10,
                    ),
                    color: isDark ? Colors.black : Colors.white,
                    child: SizedBox(
                      height: Sizes.d56,
                      child: TextField(
                        controller: _commentController,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        textInputAction: TextInputAction.newline,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "댓글을 작성해주세요",
                          hintStyle: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: AppColors.neutral500),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: _onSubmitCommentTap,
                                child: FaIcon(
                                  FontAwesomeIcons.circleArrowUp,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.neutral900
                              : AppColors.neutral100,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: Sizes.d16),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
