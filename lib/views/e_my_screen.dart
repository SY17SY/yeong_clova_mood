import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/constants.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';
import 'package:yeong_clova_mood/view_models/f_post_vm.dart';
import 'package:yeong_clova_mood/views/g_setting_screen.dart';
import 'package:yeong_clova_mood/widgets/post.dart';

class MyScreen extends ConsumerStatefulWidget {
  static const routeName = "mine";
  static const routeUrl = "/mine";

  const MyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  DateTime? _selectedDate;

  void _onSearchTap() {}

  void _onSettingTap() {
    context.push(SettingScreen.routeUrl);
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 80,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: AppColors.neutral300,
                  width: 0.5,
                ),
              ),
            ),
            child: ListView.builder(
              padding: EdgeInsets.only(
                top: Sizes.d72,
              ),
              itemCount: 30,
              itemBuilder: (context, index) {
                final date = DateTime.now().subtract(Duration(days: index));
                final isToday = index == 0;
                final isSelected = _selectedDate != null &&
                    _selectedDate!.year == date.year &&
                    _selectedDate!.month == date.month &&
                    _selectedDate!.day == date.day;
                return GestureDetector(
                  onTap: () => _onDateSelected(date),
                  child: Container(
                    height: 80,
                    margin: EdgeInsets.only(bottom: Sizes.d8),
                    decoration: BoxDecoration(
                      color: (isSelected || isToday)
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(Sizes.d8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TbodySmall14(
                          "${date.month}/${date.day}",
                          color: (isSelected || isToday)
                              ? AppColors.primary
                              : AppColors.neutral500,
                        ),
                        Gaps.v4,
                        TlabelSmall12(
                          weekdays[date.weekday % 7],
                          color: (isSelected || isToday)
                              ? AppColors.primary
                              : AppColors.neutral400,
                        ),
                        Gaps.v8,
                        Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: (isSelected || isToday)
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
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
                ),
                ref.watch(postProvider).when(
                      loading: () => SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      error: (error, stackTrace) => SliverToBoxAdapter(
                        child: Center(
                          child: Text("error: ${error.toString()}"),
                        ),
                      ),
                      data: (data) {
                        return SliverList.separated(
                          itemCount: data.length,
                          itemBuilder: (context, index) => Post(
                            key: ValueKey(data[index].id),
                            post: data[index],
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
