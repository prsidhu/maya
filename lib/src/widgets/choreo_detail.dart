import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/providers/torch_light_controller.dart';
import 'package:morpheus/src/widgets/strobo_therapy.dart';

class ChoreoDetailsScreen extends ConsumerWidget {
  final Choreo choreo;

  ChoreoDetailsScreen({required this.choreo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TorchLightState torchLightState =
        ref.watch(torchLightControllerProvider);
    final totalDuration =
        choreo.sequence.fold(0, (prev, element) => prev + element.duration);

    return Scaffold(
      appBar: AppBar(
        title: Text(choreo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Duration: $totalDuration seconds'),
            Text('Media Name: ${choreo.mediaName ?? 'Media unavailable'}'),
            if (!torchLightState.isAvailable)
              const Text('Torch light is not available on this device.'),
            if (torchLightState.isAvailable) ...[
              StroboTherapyWidget(
                choreography: choreo,
              )
            ]
          ],
        ),
      ),
    );
  }
}
