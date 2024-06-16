import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/widgets/choreo_image.dart';

class ChoreoListItem extends ConsumerWidget {
  final Choreo choreo;
  final onTap;

  ChoreoListItem({Key? key, required this.choreo, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100, // Define a fixed height for consistency
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceDim,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadiusDirectional.only(
                    topStart: Radius.circular(10.0),
                    bottomStart: Radius.circular(10.0)),
                child: Image(
                  width: 100, // Define a width for the image
                  height:
                      100, // Use the same height as the container to fill the space
                  fit: BoxFit.cover,
                  image: ChoreoImageProvider.getImageProvider(choreo, ref),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        choreo.title,
                        style: Theme.of(context).textTheme.headlineSmall,
                        // Ensure the rest of your widget code follows here
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
