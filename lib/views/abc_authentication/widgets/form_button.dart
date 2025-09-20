import 'package:flutter/material.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';

class FormButton extends StatelessWidget {
  final String? title;
  final bool disabled;
  final VoidCallback onTap;

  const FormButton({
    super.key,
    this.title = "Next",
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FractionallySizedBox(
        widthFactor: 1,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(vertical: Sizes.d16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Sizes.d5),
            color: disabled
                ? AppColors.neutral200
                : Theme.of(context).primaryColor,
          ),
          child: AnimatedDefaultTextStyle(
            duration: Duration(milliseconds: 300),
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: disabled ? AppColors.neutral400 : Colors.white,
                ),
            child: Text(title!, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
