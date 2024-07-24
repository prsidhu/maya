import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
        Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: Icon(
            FontAwesomeIcons.music,
            size: 10.0,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        Text(mediaName,
            style: textStyle ??
                Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Theme.of(context).colorScheme.tertiary))
      ],
    );
  }
}
