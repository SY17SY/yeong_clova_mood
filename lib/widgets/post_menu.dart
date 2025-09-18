import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';
import 'package:yeong_clova_mood/models/f_post_model.dart';
import 'package:yeong_clova_mood/view_models/f_post_vm.dart';

class PostMenu extends ConsumerWidget {
  final PostModel post;

  const PostMenu({super.key, required this.post});

  void _onDeleteTap(BuildContext context, WidgetRef ref) async {
    await showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text("이 글을 삭제하시겠습니까?"),
        content: Text("삭제 후 되돌릴 수 없습니다."),
        actions: [
          CupertinoDialogAction(
            child: Text("아니오"),
            onPressed: () => context.pop(),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              context.pop();
              context.pop();
              await ref.read(postProvider.notifier).deletePost(post.id);
            },
            child: Text("예"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(Sizes.d10)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          Sizes.d24,
          Sizes.d8,
          Sizes.d24,
          Sizes.d48,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Sizes.d20,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(Sizes.d16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: () => _onDeleteTap(context, ref),
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(Sizes.d24),
                      child: TtitleSmall16("Delete", color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
