import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maya/src/models/choreo.dart';
import 'package:maya/src/widgets/strobo_therapy.dart';

class ChoreoDetailsScreen extends ConsumerStatefulWidget {
  final Choreo choreo;

  const ChoreoDetailsScreen({super.key, required this.choreo});

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text(widget.choreo.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    )),
            centerTitle: false,
            backgroundColor:
                Colors.transparent, // Makes the AppBar background transparent
            elevation: 0, // Removes shadow under the AppBar
            iconTheme: IconThemeData(
              color: Theme.of(context)
                  .colorScheme
                  .primary, // Change this color as needed
            ),
          ),
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Aligns towards the bottom
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StroboTherapyWidget(
                    choreography: widget.choreo,
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
