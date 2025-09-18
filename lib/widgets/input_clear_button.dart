import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';

class InputClearButton extends StatelessWidget {
  final TextEditingController controller;

  const InputClearButton({super.key, required this.controller});

  void _onClearTap(TextEditingController controller) {
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onClearTap(controller),
      child: FaIcon(
        FontAwesomeIcons.solidCircleXmark,
        color: AppColors.neutral400,
        size: Sizes.d20,
      ),
    );
  }
}
