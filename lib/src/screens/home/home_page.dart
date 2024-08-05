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
import 'package:maya/src/widgets/text/primary_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  GoalSegment? selectedGoalSegment;

  @override
  void initState() {
    super.initState();
    checkFirstTimeOpen();
  }

  @override
  void dispose() {
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

  Future<void> checkFirstTimeOpen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

    if (isFirstTime) {
      // Show toast
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Warning: Do not use this app if you have epilepsy or are prone to seizures.",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            duration:
                const Duration(days: 365), // Effectively makes it persistent
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              textColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        );
      });

      // Set the flag to false
      await prefs.setBool('isFirstTime', false);
    }
  }
}
