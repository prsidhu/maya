import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maya/src/models/choreo.dart';
import 'package:maya/src/providers/image_provider.dart';

class ChoreoImageProvider {
  static ImageProvider<Object> getImageProvider(Choreo choreo, WidgetRef ref) {
    if (choreo.imageName == null || choreo.imageName!.isEmpty) {
      return const AssetImage('assets/images/sleep.webp');
    }

    final imageAsyncValue = ref.watch(imageProvider(choreo.imageName!));

    // Since we cannot directly return an ImageProvider from an async value in a synchronous method,
    // we default to a placeholder if the image is not immediately available.
    // Consider fetching and caching the image beforehand if you need to avoid this.
    return imageAsyncValue.maybeWhen(
      data: (data) => MemoryImage(data),
      orElse: () => const AssetImage('assets/images/sleep.webp'),
    );
  }
}
