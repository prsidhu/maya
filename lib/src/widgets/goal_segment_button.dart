import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GoalSegment { sleep, meditate, trance }

final goalSegmentProvider = StateProvider<GoalSegment?>((ref) => null);

class GoalSegmentWidget extends ConsumerWidget {
  const GoalSegmentWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GoalSegment? selected = ref.watch(goalSegmentProvider);
    return SegmentedButton<GoalSegment>(
      segments: const <ButtonSegment<GoalSegment>>[
        ButtonSegment<GoalSegment>(
          label: Text('Sleep'),
          value: GoalSegment.sleep,
        ),
        ButtonSegment<GoalSegment>(
          label: Text('Meditate'),
          value: GoalSegment.meditate,
        ),
        ButtonSegment<GoalSegment>(
          label: Text('Trance'),
          value: GoalSegment.trance,
        ),
      ],
      selected: selected != null ? {selected} : <GoalSegment>{},
      onSelectionChanged: (value) {
        ref.read(goalSegmentProvider.notifier).state = value as GoalSegment?;
      },
    );
  }
}
