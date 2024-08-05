import 'package:flutter/material.dart';
import 'package:maya/src/widgets/goalSegment/goal_segment_button.dart';
import 'package:maya/src/widgets/text/primary_title.dart';

class GoalSegmentWidget extends StatelessWidget {
  const GoalSegmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: PrimaryTitle(
              text: 'Choose your duration',
            ),
          ),
          GoalSegmentButton()
        ]);
  }
}
