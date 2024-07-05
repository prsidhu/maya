import 'package:flutter/material.dart';

class MediaText extends StatelessWidget {
  final String mediaName;
  final TextStyle? textStyle;
  final EdgeInsets? padding;

  const MediaText(
      {super.key, required this.mediaName, this.textStyle, this.padding});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.music_note,
          size: 12.0,
          color: Theme.of(context).colorScheme.primary,
        ),
        Text(mediaName,
            style: textStyle ??
                Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.primary))
      ],
    );
  }
}
