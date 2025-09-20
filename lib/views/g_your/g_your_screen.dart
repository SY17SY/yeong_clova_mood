import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/view_models/g_your_vm.dart';
import 'package:yeong_clova_mood/views/g_your/widgets/your_post.dart';
import 'package:yeong_clova_mood/views/g_your/widgets/your_sliver_app_bar.dart';

class YourScreen extends ConsumerStatefulWidget {
  static const routeName = "yours";
  static const routeUrl = "/yours";

  const YourScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _YourScreenState();
}

class _YourScreenState extends ConsumerState<YourScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        ref.watch(yourProvider).when(
              loading: () => SliverMainAxisGroup(
                slivers: [
                  YourSliverAppBar(),
                  SliverToBoxAdapter(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                ],
              ),
              error: (error, stackTrace) => SliverMainAxisGroup(
                slivers: [
                  YourSliverAppBar(),
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
                      YourSliverAppBar(),
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
                return SliverMainAxisGroup(
                  slivers: [
                    YourSliverAppBar(),
                    SliverPadding(
                      padding: EdgeInsets.all(Sizes.d4),
                      sliver: SliverGrid.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: Sizes.d4,
                          mainAxisSpacing: Sizes.d4,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: posts.length,
                        itemBuilder: (context, index) => YourPost(
                          key: ValueKey(posts[index].id),
                          post: posts[index],
                        ),
                      ),
                    ),
                  ],
                );
              },
            )
      ],
    );
  }
}
