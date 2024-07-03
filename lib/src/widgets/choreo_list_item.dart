import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/utils/stringUtils.dart';
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
        height: 90, // Define a fixed height for consistency
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
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      if (choreo.mediaName != null &&
                          choreo.mediaName!.isNotEmpty) ...[
                        Row(
                          children: [
                            Icon(
                              Icons.music_note,
                              size: 12.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            Text(choreo.mediaName!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary))
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 16.0, top: 8.0, bottom: 8.0),
                child: Text(countdownFormatDuration(choreo.totalDuration ?? 0),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
