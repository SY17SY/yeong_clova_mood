import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TtitleLarge20 extends ConsumerWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TtitleLarge20(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: color,
            fontSize: fontSize,
            height: maxLines == 1 ? 1.0 : 1.4,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class TtitleMedium18 extends ConsumerWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TtitleMedium18(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: color,
            fontSize: fontSize,
            height: maxLines == 1 ? 1.0 : 1.4,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class TtitleSmall16 extends ConsumerWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TtitleSmall16(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: color,
            fontSize: fontSize,
            height: maxLines == 1 ? 1.0 : 1.4,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class TbodyLarge18 extends ConsumerWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TbodyLarge18(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: color,
            fontSize: fontSize,
            height: maxLines == 1 ? 1.0 : 1.4,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class TbodyMedium16 extends ConsumerWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TbodyMedium16(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: color,
            fontSize: fontSize,
            height: maxLines == 1 ? 1.0 : 1.4,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class TbodySmall14 extends ConsumerWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TbodySmall14(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: color,
            fontSize: fontSize,
            height: maxLines == 1 ? 1.0 : 1.4,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class TlabelLarge14 extends ConsumerWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TlabelLarge14(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge!.copyWith(
            color: color,
            fontSize: fontSize,
            height: maxLines == 1 ? 1.0 : 1.4,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

class TlabelSmall12 extends ConsumerWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TlabelSmall12(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.textAlign = TextAlign.left,
    this.maxLines = 1,
    this.overflow = TextOverflow.ellipsis,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall!.copyWith(
            color: color,
            fontSize: fontSize,
            height: maxLines == 1 ? 1.0 : 1.4,
          ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
