import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/providers/choreo_provider.dart';
import 'package:morpheus/src/widgets/choreo_detail.dart';

class ChoreosListScreen extends ConsumerWidget {
  const ChoreosListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choreoAsyncValue = ref.watch(choreoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yume choreographies:'),
      ),
      body: choreoAsyncValue.when(
        data: (List<Choreo> choreos) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(choreoProvider);
            },
            child: ListView.builder(
              itemCount: choreos.length,
              itemBuilder: (context, index) {
                final choreo = choreos[index];
                final totalDuration = choreo.sequence
                    .fold(0, (prev, element) => prev + element.duration);
                return ListTile(
                  title: Text(choreo.title),
                  subtitle: Text('$totalDuration seconds'),
                  trailing:
                      choreo.mediaName != null && choreo.mediaName!.isNotEmpty
                          ? const Icon(Icons.music_note)
                          : null,
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
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
