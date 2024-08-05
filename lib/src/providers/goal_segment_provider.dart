import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maya/src/config/goal_segment.dart';

final StateProvider<GoalSegment> goalSegmentProvider =
    StateProvider<GoalSegment>((ref) => GoalSegment.five);
