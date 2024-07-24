import 'package:flutter/material.dart';

class PrimaryTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const PrimaryTitle({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ??
          Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
    );
  }
}
