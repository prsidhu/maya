import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maya/src/models/choreo.dart';
import 'package:maya/src/widgets/choreo_image.dart';
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
    final double imageWidth = MediaQuery.of(context).size.width * 0.85;

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
            extendBodyBehindAppBar: false,
            appBar: AppBar(
              title: Text(widget.choreo.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
            body: LayoutBuilder(
              builder: (context, constraints) {
                final double availableHeight =
                    constraints.maxHeight - kToolbarHeight;
                double imageHeight = min(availableHeight * 0.45, imageWidth);
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // Aligns towards the bottom
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Container(
                          width:
                              imageWidth, // Set width to 50% of the screen width
                          height:
                              imageHeight, // Keep the height as is or adjust as needed
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: ChoreoImageProvider.getImageProvider(
                                  widget.choreo, ref),
                              fit: BoxFit.cover,
                              colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.darken,
                              ),
                            ),
                          ),
                        )),
                        StroboTherapyWidget(
                          choreography: widget.choreo,
                        )
                      ],
                    ),
                  ),
                );
              },
            )));
  }
}
