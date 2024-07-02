import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/providers/torch_light_controller.dart';
import 'package:morpheus/src/utils/stringUtils.dart';
import 'package:morpheus/src/widgets/choreo_image.dart';
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(widget.choreo.title),
            backgroundColor:
                Colors.transparent, // Makes the AppBar background transparent
            elevation: 0, // Removes shadow under the AppBar
          ),
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ChoreoImageProvider.getImageProvider(
                        widget.choreo, ref), // Corrected to widget.choreo
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7),
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
                      if (!torchLightState.isAvailable)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40.0),
                          child: Text(
                            'Torch light is not available on this device.',
                          ),
                        ),
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
        ));
  }
}
