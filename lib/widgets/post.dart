import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yeong_clova_mood/constants/colors.dart';
import 'package:yeong_clova_mood/constants/gaps.dart';
import 'package:yeong_clova_mood/constants/sizes.dart';
import 'package:yeong_clova_mood/constants/text.dart';
import 'package:yeong_clova_mood/models/f_post_model.dart';
import 'package:yeong_clova_mood/utils.dart';
import 'package:yeong_clova_mood/widgets/post_menu.dart';

class Post extends ConsumerStatefulWidget {
  final PostModel post;

  const Post({super.key, required this.post});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostState();
}

class _PostState extends ConsumerState<Post> {
  late final hour = widget.post.createdAt!.toDate().hour;
  late final minute = widget.post.createdAt!.toDate().minute;

  void _onMenuTap() async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) => PostMenu(post: widget.post),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Sizes.d2,
        horizontal: Sizes.d16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TtitleSmall16(widget.post.title),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TlabelSmall12("$hour시 $minute분", color: AppColors.neutral500),
                  IconButton(
                    onPressed: _onMenuTap,
                    icon: FaIcon(
                      FontAwesomeIcons.ellipsis,
                    ),
                    color: AppColors.neutral500,
                    iconSize: Sizes.d20,
                  )
                ],
              )
            ],
          ),
          if (widget.post.content != null)
            TbodySmall14(widget.post.content!, maxLines: 3),
          if (widget.post.thumbUrl != null) ...[
            Gaps.v16,
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Sizes.d8),
                image: DecorationImage(
                  image: NetworkImage(toImageUrl(widget.post.thumbUrl!)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          Gaps.v6,
          Row(
            spacing: Sizes.d4,
            children: [
              SvgPicture.asset(
                "assets/images/mini_clova.svg",
                width: Sizes.d40,
                height: Sizes.d40,
              ),
              TbodySmall14(widget.post.clovas.toString()),
              Gaps.h10,
            ],
          )
        ],
      ),
    );
  }
}
