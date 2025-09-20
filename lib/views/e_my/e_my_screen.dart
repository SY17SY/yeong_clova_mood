import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/constants.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/view_models/e_my_vm.dart';
import 'package:yeong_clova_mood/view_models/h_settings_vm.dart';
import 'package:yeong_clova_mood/views/h_setting_screen.dart';
import 'package:yeong_clova_mood/widgets/my_horiz_date.dart';
import 'package:yeong_clova_mood/widgets/my_sliver_app_bar.dart';
import 'package:yeong_clova_mood/widgets/my_post.dart';

class MyScreen extends ConsumerStatefulWidget {
  static const routeName = "mine";
  static const routeUrl = "/mine";

  const MyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _postKeys = [];

  void _onSearchTap() {}

  void _onSettingTap() {
    context.push(SettingScreen.routeUrl);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToPost(int index) {
    if (index < _postKeys.length) {
      var context = _postKeys[index].currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        final appBarHeight = kToolbarHeight + Sizes.d100 + Sizes.d36;
        final estimatedPostHeight = 120.0;
        final dividerHeight = 1.0;
        final estimatedOffset =
            appBarHeight + (index * (estimatedPostHeight + dividerHeight));

        _scrollController.animateTo(
          estimatedOffset,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ref.watch(settingsProvider.notifier).isDark(context);
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        ref.watch(myProvider).when(
              loading: () => SliverMainAxisGroup(
                slivers: [
                  MySliverAppBar(),
                  SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                ],
              ),
              error: (error, stackTrace) => SliverMainAxisGroup(
                slivers: [
                  MySliverAppBar(),
                  SliverToBoxAdapter(
                    child: Center(
                      child: Text("error: ${error.toString()}"),
                    ),
                  ),
                ],
              ),
              data: (posts) {
                if (posts.isEmpty) {
                  return SliverMainAxisGroup(
                    slivers: [
                      MySliverAppBar(),
                      SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(Sizes.d40),
                            child: Text(
                              "선택한 날짜에 포스트가 없습니다",
                              style: TextStyle(
                                color: AppColors.neutral400,
                                fontSize: Sizes.d16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                _postKeys.clear();
                for (int i = 0; i < posts.length; i++) {
                  _postKeys.add(GlobalKey());
                }

                return SliverMainAxisGroup(
                  slivers: [
                    SliverAppBar(
                      elevation: 0.5,
                      floating: true,
                      snap: true,
                      actions: [
                        IconButton(
                          onPressed: _onSearchTap,
                          icon: FaIcon(FontAwesomeIcons.magnifyingGlass),
                          color: AppColors.neutral500,
                          iconSize: Sizes.d20,
                        ),
                        Gaps.h8,
                        IconButton(
                          onPressed: _onSettingTap,
                          icon: FaIcon(FontAwesomeIcons.gear),
                          color: AppColors.neutral500,
                          iconSize: Sizes.d20,
                        ),
                        Gaps.h16,
                      ],
                      bottom: PreferredSize(
                        preferredSize: Size(
                          MediaQuery.of(context).size.width,
                          Sizes.d100 + Sizes.d36,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            MyHorizDate(),
                            Container(
                              height: Sizes.d52,
                              margin: EdgeInsets.symmetric(vertical: Sizes.d10),
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                padding:
                                    EdgeInsets.symmetric(horizontal: Sizes.d24),
                                itemCount: posts.length,
                                separatorBuilder: (context, index) =>
                                    SizedBox(width: Sizes.d6),
                                itemBuilder: (context, index) {
                                  final post = posts[index];
                                  final moodEnum = moodsMood[post.mood];
                                  return GestureDetector(
                                    onTap: () => _scrollToPost(index),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Sizes.d6,
                                        vertical: Sizes.d8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? moodColorsDark[moodEnum]
                                            : moodColors[moodEnum],
                                        borderRadius:
                                            BorderRadius.circular(Sizes.d10),
                                      ),
                                      child: Image.asset(
                                        moodImgs[moodEnum]!,
                                        width: Sizes.d32,
                                        height: Sizes.d32,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverList.separated(
                      itemCount: posts.length,
                      itemBuilder: (context, index) => MyPost(
                        key: _postKeys[index],
                        post: posts[index],
                      ),
                      separatorBuilder: (context, index) => Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.d10,
                        ),
                        child: Divider(color: AppColors.neutral500),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Gaps.v40,
                    )
                  ],
                );
              },
            )
      ],
    );
  }
}
