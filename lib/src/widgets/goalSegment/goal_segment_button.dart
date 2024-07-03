import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/config/goal_segment.dart';
import 'package:morpheus/src/providers/goal_segment_provider.dart';

class GoalSegmentButton extends ConsumerWidget {
  const GoalSegmentButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoalSegment? selected = ref.watch(goalSegmentProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: GoalSegment.values.map((segment) {
        // Capitalize the first letter of the button text
        String buttonText = segment.toString().split('.').last;
        buttonText = buttonText[0].toUpperCase() + buttonText.substring(1);

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ButtonStyle(
              // Define the shape for square with rounded edges
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (selected == segment) {
                    return Theme.of(context)
                        .colorScheme
                        .primary; // Selected color
                  }
                  return Theme.of(context)
                      .colorScheme
                      .surfaceDim; // Unselected color
                },
              ),
              foregroundColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
                  if (selected == segment) {
                    return Theme.of(context)
                        .colorScheme
                        .onPrimary; // Selected text color
                  }
                  return Theme.of(context)
                      .colorScheme
                      .primary; // Unselected text color
                },
              ),
              minimumSize: WidgetStateProperty.all<Size>(
                const Size(100, 70),
              ),
            ),
            onPressed: () =>
                ref.read(goalSegmentProvider.notifier).state = segment,
            child: Text(buttonText),
          ),
        );
      }).toList(),
    );
  }
}
