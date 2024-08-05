import 'package:flutter/material.dart';

class OnboardingText extends StatelessWidget {
  const OnboardingText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '(best with earphones)',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            )),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
              'Once you start, please turn your phone and hold the camera flash 8 to 12 inches in front of your face.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Then, close your eyes and experience the magic!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary.withAlpha(200),
                  fontWeight: FontWeight.w600),
            )),
      ],
    ));
  }
}
