import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/providers/torch_light_controller.dart';
import 'package:morpheus/src/utils/stringUtils.dart';
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
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage(
                    "path/to/your/fullscreen/image.jpg"), // Specify your image path
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7), // Dark overlay
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Aligns towards the bottom
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        widget.choreo.title,
                        style: Theme.of(context).textTheme.headlineLarge,
                      )),
                  Text(
                      'Media Name: ${widget.choreo.mediaName ?? 'Media unavailable'}'),
                  Text(
                      'Total Duration: ${formatDuration(totalDuration)} seconds'),
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
          ),
        ],
      ),
    );
  }
}
