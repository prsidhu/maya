import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maya/src/config/events.dart';
import 'package:maya/src/config/goal_segment.dart';
import 'package:maya/src/models/choreo.dart';
import 'package:maya/src/providers/choreo_provider.dart';
import 'package:maya/src/providers/goal_segment_provider.dart';
import 'package:maya/src/widgets/choreo_detail.dart';
import 'package:maya/src/widgets/choreo_list_item.dart';
import 'package:maya/src/widgets/goalSegment/goal_segment_widget.dart';
import 'package:maya/src/widgets/maya_app_bar.dart';
import 'package:maya/src/widgets/text/logo_text.dart';
import 'package:maya/src/widgets/text/primary_title.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  GoalSegment? selectedGoalSegment;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _animationTriggered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: -1.0).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Choreo>> choreoAsyncValue = ref.watch(choreoProvider);
    final GoalSegment? selected = ref.watch(goalSegmentProvider);

    if (selected != null && selected != selectedGoalSegment) {
      setState(() {
        selectedGoalSegment = selected;
      });

      if (!_animationTriggered) {
        // Step 3: Conditionally trigger animation
        _animationController.forward().then((value) {
          if (mounted) {
            _animationController.reset();
            _animationTriggered =
                true; // Step 2: Update the flag after animation
          }
        });
      }
    }

    return Scaffold(
      appBar: MayaAppBar(), // Use MayaAppBar as the default app bar
      body: Column(
        children: [
          buildGoalHeader(), // Add the sticky goal segment header
          Expanded(
            child: choreoAsyncValue.when(
              data: (List<Choreo> choreos) {
                final filteredChoreos = choreos
                    .where((choreo) =>
                        choreo.segments.contains(selectedGoalSegment?.name))
                    .toList();
                return ListView.builder(
                  itemCount: filteredChoreos.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Choreo choreo = filteredChoreos[index];
                    return ChoreoListItem(
                      choreo: choreo,
                      onTap: () {
                        Events().choreoClickedEvent(choreo.id, choreo.title);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChoreoDetailsScreen(choreo: choreo)),
                        );
                      },
                    );
                  },
                );
              },
              error: (err, stack) => Center(
                child: Text('Error: $err'),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
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
                    Events().choreoClickedEvent(choreo.id, choreo.title);
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

  Widget buildGoalHeader() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildHeaderText(),
        const GoalSegmentWidget(),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: PrimaryTitle(
            text: "Today's Therapies",
          ),
        ),
      ],
    );
  }

  Padding buildHeaderText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Text(
        "Stroboscopic light therapies use specially designed choreographies of flickering light to cleanse, refresh and rejuvenate your mind.",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.8,
            ),
      ),
    );
  }
}
