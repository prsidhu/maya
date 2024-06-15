import 'package:flutter/material.dart';
import 'package:morpheus/src/utils/stringUtils.dart';

class ChoreoListItem extends StatelessWidget {
  final String title;
  final int totalDuration;
  final bool hasMusic;
  final VoidCallback onTap;

  const ChoreoListItem({
    Key? key,
    required this.title,
    required this.totalDuration,
    required this.hasMusic,
    required this.onTap,
  }) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(8.0), // Apply padding around the Container
  //     child: Container(
  //       decoration: BoxDecoration(
  //         color: Theme.of(context)
  //             .colorScheme
  //             .surfaceDim, // Set the background color of the Container
  //         borderRadius: BorderRadius.circular(10.0), // Set rounded corners
  //       ),
  //       child: ListTile(
  //         leading: Image.asset('assets/images/sleep.webp'),
  //         onTap: onTap,
  //         subtitle: Text(formatDuration(totalDuration)),
  //         title: Text(title),
  //         trailing: hasMusic ? const Icon(Icons.music_note) : null,
  //       ),
  //     ),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100, // Optional: Define a fixed height for consistency
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
                child: Image.asset(
                  'assets/images/sleep.webp',
                  fit: BoxFit.fill,
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
                        title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        formatDuration(totalDuration),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 16.0, top: 8.0, bottom: 8.0),
                child: hasMusic
                    ? const Icon(Icons.music_note)
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
