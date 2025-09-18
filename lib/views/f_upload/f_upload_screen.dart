import 'dart:io';

import 'package:flutter/cupertino.dart';
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
import 'package:yeong_clova_mood/views/f_upload/f_camera_screen.dart';
import 'package:yeong_clova_mood/widgets/bottom_modal_datetime.dart';
import 'package:yeong_clova_mood/widgets/mood_buttons.dart';

class UploadScreen extends ConsumerStatefulWidget {
  static const routeName = "upload";
  static const routeUrl = "/upload";

  const UploadScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadScreenState();
}

class _UploadScreenState extends ConsumerState<UploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final PageController _pageController = PageController();

  String? _title;
  String? _content;
  bool _isPrivate = true;
  List<File> currentFiles = [];

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() {
      setState(() {
        _title = _titleController.text;
      });
    });
    _contentController.addListener(() {
      setState(() {
        _content = _contentController.text;
      });
    });
  }

  void _onCancelTap() async {
    await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("이 화면을 나가시겠습니까?"),
        content: Text("작성된 내용이 저장되지 않습니다."),
        actions: [
          CupertinoDialogAction(
            onPressed: () => context.pop(),
            isDestructiveAction: true,
            child: Text("아니오"),
          ),
          CupertinoDialogAction(
            onPressed: () {
              ref.read(postUploadProvider.notifier).resetAll();
              context.pop();
              context.pop();
            },
            child: Text("예"),
          )
        ],
      ),
    );
  }

  void _onDeletePressed(File img) {
    ref.read(postUploadProvider.notifier).removeFiles(img);
    currentFiles = ref.read(postUploadProvider).files;
  }

  void _togglePrivate() {
    setState(() {
      _isPrivate = !_isPrivate;
    });
  }

  Future<void> _onTimePickerPressed() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const BottomModalDatetime(),
    );
  }

  Future<void> _onCameraPressed() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
    );

    if (result == null) return;

    ref.read(postUploadProvider.notifier).addFiles(File(result.path));
    currentFiles = ref.read(postUploadProvider).files;
    if (currentFiles.length > 1) {
      _pageController.jumpToPage(currentFiles.length - 1);
    }
  }

  Future<void> _onSubmitTap() async {
    final uploadState = ref.read(postUploadProvider);
    if (_title == null || uploadState.mood == null) {
      return;
    }
    final data = {
      "title": _title,
      "content": _content,
      "isPrivate": _isPrivate,
    };
    await ref.read(postProvider.notifier).uploadPost(
          context: context,
          data: data,
          files: currentFiles,
        );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer(
            builder: (context, ref, child) {
              final createdAt = ref.watch(postUploadProvider).createdAt;
              return TtitleMedium18(
                "${createdAt.month}월 ${createdAt.day}일 ${weekdays[createdAt.weekday]}요일",
              );
            },
          ),
          elevation: 0.5,
          leading: TextButton(
            onPressed: _onCancelTap,
            child: TbodyMedium16("Cancel", color: AppColors.neutral500),
          ),
          leadingWidth: Sizes.d100,
          actions: [
            IconButton(
              onPressed: _onSubmitTap,
              icon: FaIcon(
                FontAwesomeIcons.check,
                color: AppColors.neutral500,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: EdgeInsets.all(Sizes.d16),
                          child: MoodButtons(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          Sizes.d32,
                          Sizes.d10,
                          Sizes.d32,
                          Sizes.d20,
                        ),
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                hintText: "제목",
                              ),
                              style: Theme.of(context).textTheme.titleMedium,
                              controller: _titleController,
                            ),
                            Divider(color: AppColors.neutral500),
                            Gaps.v10,
                            TextField(
                              decoration: InputDecoration(
                                hintText: "내용",
                              ),
                              style: Theme.of(context).textTheme.titleMedium,
                              maxLines: null,
                              controller: _contentController,
                            ),
                          ],
                        ),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          final files = ref.watch(postUploadProvider).files;
                          if (files.isEmpty) return const SizedBox();
                          return Container(
                            height: 200,
                            margin: EdgeInsets.symmetric(horizontal: Sizes.d16),
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: files.length,
                              itemBuilder: (context, index) {
                                final file = files[index];
                                return Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.all(Sizes.d8),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(Sizes.d12),
                                        image: DecorationImage(
                                          image: FileImage(File(file.path)),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: Sizes.d16,
                                      right: Sizes.d16,
                                      child: GestureDetector(
                                        onTap: () => _onDeletePressed(file),
                                        child: Container(
                                          padding: EdgeInsets.all(Sizes.d8),
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withValues(alpha: 0.6),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: Sizes.d20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          padding: EdgeInsets.fromLTRB(Sizes.d24, Sizes.d6, Sizes.d24, 0),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _togglePrivate,
                    child: TlabelLarge14(_isPrivate ? "비공개" : "공개"),
                  ),
                  IconButton(
                    onPressed: _onCameraPressed,
                    icon: FaIcon(FontAwesomeIcons.camera),
                  ),
                ],
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Consumer(
                  builder: (context, ref, child) {
                    final createdAt = ref.watch(postUploadProvider).createdAt;
                    return Center(
                      child: TextButton(
                        onPressed: _onTimePickerPressed,
                        child: TtitleSmall16(
                          createdAt.minute == 0
                              ? "${createdAt.hour}시"
                              : "${createdAt.hour}시 ${createdAt.minute}분",
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
