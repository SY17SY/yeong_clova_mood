import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/view_models/e_my_vm.dart';
import 'package:yeong_clova_mood/views/g_setting_screen.dart';
import 'package:yeong_clova_mood/widgets/horiz_date.dart';
import 'package:yeong_clova_mood/widgets/post.dart';
import 'package:yeong_clova_mood/widgets/vertical_date.dart';

class MyScreen extends ConsumerStatefulWidget {
  static const routeName = "mine";
  static const routeUrl = "/mine";

  const MyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  void _onSearchTap() {}

  void _onSettingTap() {
    context.push(SettingScreen.routeUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          VerticalDate(),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  elevation: 0.5,
                  floating: true,
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
                      Sizes.d80,
                    ),
                    child: HorizDate(),
                  ),
                ),
                ref.watch(mySelectedDatePostsProvider).when(
                      loading: () => SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator.adaptive(),
                        ),
                      ),
                      error: (error, stackTrace) => SliverToBoxAdapter(
                        child: Center(
                          child: Text("error: ${error.toString()}"),
                        ),
                      ),
                      data: (posts) {
                        if (posts.isEmpty) {
                          return SliverToBoxAdapter(
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
                          );
                        }
                        return SliverList.separated(
                          itemCount: posts.length,
                          itemBuilder: (context, index) => Post(
                            key: ValueKey(posts[index].id),
                            post: posts[index],
                          ),
                          separatorBuilder: (context, index) => Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Sizes.d10,
                            ),
                            child: Divider(color: AppColors.neutral500),
                          ),
                        );
                      },
                    )
              ],
            ),
          )
        ],
      ),
    );
  }
}
