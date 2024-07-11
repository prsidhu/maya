import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maya/src/models/choreo.dart';
import 'package:maya/src/providers/choreo_provider.dart';

class ChoreoDropdown extends ConsumerWidget {
  const ChoreoDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choreoAsyncValue = ref.watch(choreoProvider);

    return choreoAsyncValue.when(
      data: (choreo) {
        return DropdownButton<String>(
          hint: const Text("Select Choreography"),
          items: choreo.map((Choreo item) {
            return DropdownMenuItem<String>(
              value: item.id,
              child: Text(item.title),
            );
          }).toList(),
          onChanged: (String? newValue) {
            ref.read(selectedChoreoProvider.notifier).state = newValue;
          },
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
