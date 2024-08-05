import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maya/src/models/choreo.dart';
import 'package:maya/src/widgets/choreo_image.dart';

class ChoreoListItem extends ConsumerWidget {
  final Choreo choreo;
  final VoidCallback onTap;

  const ChoreoListItem({super.key, required this.choreo, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.surface,
            width: 1.0,
          ),
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              _ChoreoImage(choreo: choreo, ref: ref),
              const SizedBox(width: 10),
              _ChoreoDetails(choreo: choreo),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChoreoImage extends StatelessWidget {
  final Choreo choreo;
  final WidgetRef ref;

  const _ChoreoImage({required this.choreo, required this.ref});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadiusDirectional.only(
        topStart: Radius.circular(10.0),
        bottomStart: Radius.circular(10.0),
      ),
      child: Image(
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        image: ChoreoImageProvider.getImageProvider(choreo, ref),
      ),
    );
  }
}

class _ChoreoDetails extends StatelessWidget {
  final Choreo choreo;

  const _ChoreoDetails({required this.choreo});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  choreo.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                )),
            if (choreo.description != null && choreo.description!.isNotEmpty ||
                true)
              Text(
                choreo.description ??
                    'lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet lorem ipsum dolor sit amet',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w400),
              ),
          ],
        ),
      ),
    );
  }
}
