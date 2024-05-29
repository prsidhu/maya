import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/providers/torch_light_controller.dart';
import 'package:morpheus/src/widgets/strobo_therapy.dart';

class ChoreoDetailsScreen extends ConsumerStatefulWidget {
  final Choreo choreo;

  ChoreoDetailsScreen({required this.choreo});

  @override
  _ChoreoDetailsScreenState createState() => _ChoreoDetailsScreenState();
}

class _ChoreoDetailsScreenState extends ConsumerState<ChoreoDetailsScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TorchLightState torchLightState =
        ref.watch(torchLightControllerProvider);
    final totalDuration = widget.choreo.sequence
        .fold(0, (prev, element) => prev + element.duration);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.choreo.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Duration: $totalDuration seconds'),
            Text(
                'Media Name: ${widget.choreo.mediaName ?? 'Media unavailable'}'),
            if (!torchLightState.isAvailable)
              const Text('Torch light is not available on this device.'),
            if (torchLightState.isAvailable) ...[
              StroboTherapyWidget(
                choreography: widget.choreo,
              )
            ]
          ],
        ),
      ),
    );
  }
}
