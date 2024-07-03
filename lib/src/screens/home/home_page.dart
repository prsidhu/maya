import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/config/goal_segment.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/providers/choreo_provider.dart';
import 'package:morpheus/src/providers/goal_segment_provider.dart';
import 'package:morpheus/src/widgets/choreo_detail.dart';
import 'package:morpheus/src/widgets/choreo_list_item.dart';
import 'package:morpheus/src/widgets/goalSegment/goal_segment_widget.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  GoalSegment? selectedGoalSegment;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Choreo>> choreoAsyncValue = ref.watch(choreoProvider);
    final GoalSegment? selected = ref.watch(goalSegmentProvider);

    if (selected != null && selected != selectedGoalSegment) {
      selectedGoalSegment = selected;
    }

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.flutter_dash), // Replace with your app's logo
        title: const Text('Maya'), // Replace with your app's name
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          if (selectedGoalSegment != null)
            SliverPersistentHeader(
              delegate: _StickyGoalSegmentHeader(selectedGoalSegment!),
              pinned: true,
            ),
          if (selectedGoalSegment == null)
            const SliverFillRemaining(
              child: Center(
                child: GoalSegmentWidget(),
              ),
            ),
          ..._buildChoreoList(choreoAsyncValue),
        ],
      ),
    );
  }

  List<Widget> _buildChoreoList(AsyncValue<List<Choreo>> choreoAsyncValue) {
    return [
      choreoAsyncValue.when(
        data: (List<Choreo> choreos) {
          final filteredChoreos = choreos
              .where((choreo) =>
                  choreo.segments.contains(selectedGoalSegment?.name))
              .toList();
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final Choreo choreo = filteredChoreos[index];
                return ChoreoListItem(
                  choreo: choreo,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ChoreoDetailsScreen(choreo: choreo)),
                    );
                  },
                );
              },
              childCount: filteredChoreos.length,
            ),
          );
        },
        error: (err, stack) => SliverToBoxAdapter(
          child: Center(child: Text('Error: $err')),
        ),
        loading: () => const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
    ];
  }
}

class _StickyGoalSegmentHeader extends SliverPersistentHeaderDelegate {
  final GoalSegment goalSegment;

  _StickyGoalSegmentHeader(this.goalSegment);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return const GoalSegmentWidget(); // Adjust this widget as needed
  }

  @override
  double get maxExtent => 200;

  @override
  double get minExtent => 70;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
