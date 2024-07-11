import 'package:flutter/material.dart';
import 'package:maya/src/utils/stringUtils.dart';

class AuthorText extends StatelessWidget {
  final String author;
  final TextStyle? style;
  final EdgeInsets? padding;

  const AuthorText({super.key, required this.author, this.style, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8.0),
      child: Text('by ${capitalizeName(author)}',
          style:
              style?.copyWith(color: Theme.of(context).colorScheme.primary) ??
                  Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      )),
    );
  }
}
