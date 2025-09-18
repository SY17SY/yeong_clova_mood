import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/repos/b_auth_repo.dart';
import 'package:yeong_clova_mood/views/e_my_screen.dart';
import 'package:yeong_clova_mood/views/f_upload/f_upload_screen.dart';
import 'package:yeong_clova_mood/views/f_your_screen.dart';
import 'package:yeong_clova_mood/widgets/nav_tab.dart';

class MainNavigationScreen extends ConsumerStatefulWidget {
  static const routeName = "main-navigation";
  static const routeUrl = "/";

  final String tab;
  const MainNavigationScreen(this.tab, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends ConsumerState<MainNavigationScreen> {
  final List<String> _tabs = ["mine", "upload", "yours"];

  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int index) async {
    if (index == 2) {
      ref.read(authRepository).logOut();
    }
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onUploadTap() async {
    context.push(UploadScreen.routeUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Offstage(offstage: _selectedIndex != 0, child: MyScreen()),
          Offstage(offstage: _selectedIndex != 2, child: YourScreen()),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.symmetric(horizontal: Sizes.d16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavTab(
              svgPath: "assets/images/my_clova.svg",
              text: "mine",
              isSelected: _selectedIndex == 0,
              onTap: () => _onTap(0),
            ),
            NavTab(
              svgPath: "assets/images/mini_clova.svg",
              text: "upload",
              isSelected: _selectedIndex == 1,
              onTap: _onUploadTap,
            ),
            NavTab(
              svgPath: "assets/images/your_clova.svg",
              text: "yours",
              isSelected: _selectedIndex == 2,
              onTap: () => _onTap(2),
            ),
          ],
        ),
      ),
    );
  }
}
