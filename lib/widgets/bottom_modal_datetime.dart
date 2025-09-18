import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';
import 'package:yeong_clova_mood/view_models/f_post_vm.dart';

class BottomModalDatetime extends ConsumerStatefulWidget {
  const BottomModalDatetime({super.key});

  @override
  ConsumerState<BottomModalDatetime> createState() =>
      _BottomModalDatetimeState();
}

class _BottomModalDatetimeState extends ConsumerState<BottomModalDatetime> {
  final now = DateTime.now();
  late DateTime _editingDT;

  @override
  void initState() {
    super.initState();
    _editingDT = ref.read(postUploadProvider).createdAt;
  }

  void _onDateTimeChanged(DateTime newDateTime) {
    _editingDT = newDateTime;
  }

  void _onDateTimeDone(BuildContext context, DateTime newDateTime) {
    ref.read(postUploadProvider.notifier).updateCreatedAt(newDateTime);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(Sizes.d20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: Sizes.d40,
            height: Sizes.d4,
            margin: EdgeInsets.symmetric(vertical: Sizes.d12),
            decoration: BoxDecoration(
              color: AppColors.neutral300,
              borderRadius: BorderRadius.circular(Sizes.d2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.d24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TtitleMedium18('날짜 / 시간 변경'),
                TextButton(
                  onPressed: () => _onDateTimeDone(context, _editingDT),
                  child: TtitleMedium18('완료', color: AppColors.primary),
                ),
              ],
            ),
          ),
          SizedBox(height: Sizes.d8),
          Expanded(
            child: CupertinoDatePicker(
              onDateTimeChanged: _onDateTimeChanged,
              initialDateTime: _editingDT,
              minimumDate: DateTime(
                now.year,
                now.month,
                now.day - 2,
              ),
              maximumDate: DateTime(
                now.year,
                now.month,
                now.day,
                23,
                50,
              ),
              minuteInterval: 10,
              mode: CupertinoDatePickerMode.dateAndTime,
            ),
          ),
        ],
      ),
    );
  }
}
