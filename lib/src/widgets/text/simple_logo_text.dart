import 'package:flutter/material.dart';

class SimpleLogoText extends StatelessWidget {
  final TextStyle? textStyle;
  final MainAxisAlignment? alignment;

  const SimpleLogoText({super.key, this.alignment, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Text('Maya',
        style: textStyle ??
            Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ));
  }
}
