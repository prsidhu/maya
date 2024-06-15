import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/providers/choreo_provider.dart';
import 'package:morpheus/src/widgets/bottom_curve_clipper.dart';
import 'package:morpheus/src/widgets/choreo_detail.dart';
import 'package:morpheus/src/widgets/choreo_list_item.dart';

class HomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Choreo>> choreoAsyncValue = ref.watch(choreoProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: ClipPath(
                clipper: BottomCurveClipper(), // Use the custom clipper
                child: Image.asset(
                  'assets/images/background.webp',
                  fit: BoxFit.cover,
                ),
              ),
              title: const Text('Yume choreographies'),
            ),
            floating: true,
            pinned: true,
          ),
          choreoAsyncValue.when(
            data: (List<Choreo> choreos) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    final Choreo choreo = choreos[index];
                    return ChoreoListItem(
                      hasMusic: choreo.mediaName != null &&
                          choreo.mediaName!.isNotEmpty,
                      title: choreo.title,
                      totalDuration: choreo.totalDuration ?? 0,
                      onTap: () {
                        // ref.read(currentChoreoProvider).state = choreo;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ChoreoDetailsScreen(choreo: choreo)),
                        );
                      },
                    );
                  },
                  childCount: choreos.length,
                ),
              );
            },
            error: (err, stack) => SliverToBoxAdapter(
              child: Center(child: Text('Error: $err')),
            ),
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
          )
        ],
      ),
    );
  }
}
