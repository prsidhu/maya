import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/providers/torch_light_controller.dart';

class TorchLightWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torchLightState = ref.watch(torchLightControllerProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Torch light'),
            const SizedBox(height: 20),
            Text(
              torchLightState.isAvailable
                  ? 'Torch is available'
                  : 'Torch is not available',
              style: TextStyle(
                color: torchLightState.isAvailable ? Colors.green : Colors.red,
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: torchLightState.isAvailable
                  ? () async {
                      ref
                          .read(torchLightControllerProvider.notifier)
                          .toggleTorch();
                    }
                  : null,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color:
                      torchLightState.isAvailable ? Colors.blue : Colors.grey,
                ),
              ),
              child: const Text('Toggle Torch'),
            ),
          ],
        ),
      ),
    );
  }
}
