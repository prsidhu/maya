import 'package:flutter/material.dart';
import 'package:morpheus/src/widgets/goalSegment/goal_segment_button.dart';

class GoalSegmentWidget extends StatelessWidget {
  const GoalSegmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              'Choose your goal',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          const GoalSegmentButton()
        ]);
  }
}
