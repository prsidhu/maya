import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/providers/torch_light_controller.dart';

class StroboTherapyWidget extends ConsumerWidget {
  StroboTherapyWidget({super.key});
  List<Map<String, int>> choreography = [
    {'frequency': 10, 'duration': 60}, // Frequency in Hz, duration in seconds
    {'frequency': 20, 'duration': 60},
    {'frequency': 5, 'duration': 60},
  ];

  Timer? _timer;
  bool _isTorchOn = false;
  final int _totalDuration = 180;

  void startTherapy(Function enableTorch, Function disableTorch) {
    int choreographyIndex = 0;
    Map<String, int> currentStep = choreography[choreographyIndex];
    int totalDuration = currentStep['duration']!;
    int frequency = currentStep['frequency']!;
    int halfPeriod =
        (1000 ~/ (frequency * 2)); // Calculate half period in milliseconds

    _timer = Timer.periodic(Duration(milliseconds: halfPeriod), (timer) {
      if (_isTorchOn) {
        // FlutterTorch.disableTorch();
        // How to use TorchLight widget here to enable/disable torch
        disableTorch();
        _isTorchOn = false;
      } else {
        // FlutterTorch.enableTorch();
        enableTorch();
        _isTorchOn = true;
      }

      totalDuration--;

      if (totalDuration <= 0) {
        choreographyIndex++;
        if (choreographyIndex >= choreography.length) {
          timer.cancel(); // Stop the timer if choreography is completed
        } else {
          currentStep = choreography[choreographyIndex];
          totalDuration = currentStep['duration']!;
          frequency = currentStep['frequency']!;
          halfPeriod = (1000 ~/ (frequency * 2));
        }
      }
    });
  }

  void stopTherapy(Function disableTorch) {
    _timer?.cancel();
    disableTorch();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TorchLightState torchLightState =
        ref.watch(torchLightControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stroboscopic Light Therapy'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _timer != null ? '${_totalDuration}' : '',
              style: const TextStyle(color: Colors.black),
            ),
            ElevatedButton(
              onPressed: torchLightState.isAvailable
                  ? () {
                      final controller =
                          ref.read(torchLightControllerProvider.notifier);
                      startTherapy(
                          controller.enableTorch, controller.disableTorch);
                    }
                  : null,
              child: const Text('Start Therapy'),
            ),
            ElevatedButton(
              onPressed: torchLightState.isAvailable
                  ? () {
                      final controller =
                          ref.read(torchLightControllerProvider.notifier);
                      stopTherapy(controller.disableTorch);
                    }
                  : null,
              child: const Text('Stop Therapy'),
            ),
          ],
        ),
      ),
    );
  }
}
