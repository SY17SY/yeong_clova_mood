import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/constants.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';
import 'package:yeong_clova_mood/view_models/e_my_vm.dart';

class HorizDate extends ConsumerStatefulWidget {
  const HorizDate({super.key});

  @override
  HorizDateState createState() => HorizDateState();
}

class HorizDateState extends ConsumerState<HorizDate> {
  final PageController _pageController = PageController();

  void _onDateSelected(DateTime date) {
    ref.read(mySelectedDateProvider.notifier).updateSelectedDate(date);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(mySelectedDateProvider).selectedDate;
    return Container(
      height: Sizes.d80,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.neutral300,
            width: 0.5,
          ),
        ),
      ),
      child: PageView.builder(
        controller: _pageController,
        itemCount: 4,
        reverse: true,
        itemBuilder: (context, pageIndex) {
          final today = DateTime.now();
          final startOfWeek = today.subtract(Duration(days: 6 + pageIndex * 7));
          final weekDates = List.generate(
              7, (dayIndex) => startOfWeek.add(Duration(days: dayIndex)));

          return Row(
            children: weekDates.map((date) {
              final isSelected = selectedDate.year == date.year &&
                  selectedDate.month == date.month &&
                  selectedDate.day == date.day;

              return Expanded(
                child: GestureDetector(
                  onTap: () => _onDateSelected(date),
                  child: Container(
                    height: Sizes.d80,
                    margin: EdgeInsets.symmetric(horizontal: Sizes.d4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(Sizes.d8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TlabelSmall12(
                          weekdays[date.weekday % 7],
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.neutral400,
                        ),
                        Gaps.v4,
                        TbodySmall14(
                          "${date.day}",
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.neutral500,
                        ),
                        Gaps.v8,
                        Container(
                          width: 20,
                          height: 4,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
