import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/views/h_setting_screen.dart';
import 'package:yeong_clova_mood/widgets/my_horiz_date.dart';

class MySliverAppBar extends StatelessWidget {
  const MySliverAppBar({super.key});

  void _onSearchTap() {}

  void _onSettingTap(BuildContext context) {
    context.push(SettingScreen.routeUrl);
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
          onPressed: () => _onSettingTap(context),
          icon: FaIcon(FontAwesomeIcons.gear),
          color: AppColors.neutral500,
          iconSize: Sizes.d20,
        ),
        Gaps.h16,
      ],
      bottom: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          Sizes.d64,
        ),
        child: MyHorizDate(),
      ),
    );
  }
}
