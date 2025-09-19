import 'package:flutter/material.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/constants.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';

class VerticalDate extends StatefulWidget {
  const VerticalDate({super.key});

  @override
  State<VerticalDate> createState() => _VerticalDateState();
}

class _VerticalDateState extends State<VerticalDate> {
  DateTime? _selectedDate;

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
