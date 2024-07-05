import 'package:flutter/material.dart';

class LogoText extends StatelessWidget {
  final TextStyle? textStyle;
  final MainAxisAlignment? alignment;
  const LogoText({super.key, this.textStyle, this.alignment});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment ?? MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Text('MA',
                style: (textStyle ?? Theme.of(context).textTheme.headlineSmall)
                    ?.copyWith(
                        fontWeight: FontWeight.w700,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Theme.of(context).colorScheme.secondary)),
            Text(
              'MA',
              style: (textStyle ?? Theme.of(context).textTheme.headlineSmall)
                  ?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Stack(
          children: [
            Text('YA',
                style: (textStyle ?? Theme.of(context).textTheme.headlineSmall)
                    ?.copyWith(
                        fontWeight: FontWeight.w700,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Theme.of(context).colorScheme.primary)),
            Text(
              'YA',
              style: (textStyle ?? Theme.of(context).textTheme.headlineSmall)
                  ?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
