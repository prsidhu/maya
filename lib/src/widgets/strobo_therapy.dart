import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/providers/torch_light_controller.dart';
import 'package:wakelock/wakelock.dart';

final therapyTimerProvider = StateProvider<int>((ref) {
  return 0;
});

class StroboTherapyWidget extends ConsumerWidget {
  StroboTherapyWidget({super.key});

  final List<Map<String, int>> choreography1 = [
    {'frequency': 10, 'duration': 60},
    {'frequency': 20, 'duration': 60},
    {'frequency': 5, 'duration': 60},
  ];

  final List<Map<String, int>> choreography2 = [
    {'frequency': 6, 'duration': 120}, // 6 Hz for 2 minutes
    {'frequency': 5, 'duration': 120}, // 5 Hz for 2 minutes
    {'frequency': 4, 'duration': 120}, // 4 Hz for 2 minutes
    {'frequency': 3, 'duration': 120}, // 3 Hz for 2 minutes
    {'frequency': 2, 'duration': 120}, // 2 Hz for 2 minutes
    {'frequency': 1, 'duration': 120}, // 1 Hz for 2 minutes
  ];

  Timer? _timer;

  void startTherapy(WidgetRef ref, Function enableTorch, Function disableTorch,
      List<Map<String, int>> choreography) {
    // Reset any ongoing therapy
    stopTherapy(ref, disableTorch);
    Wakelock.enable(); // Enable wakelock to keep the screen on

    final therapyTimer = ref.read(therapyTimerProvider.state);
    therapyTimer.state = choreography.fold(
        0, (previousValue, element) => previousValue + element['duration']!);

    int choreographyIndex = 0;
    Map<String, int> currentStep = choreography[choreographyIndex];
    int currentStepTimeRemaining = currentStep['duration']!;
    int frequency = currentStep['frequency']!;
    int halfPeriod =
        (1000 ~/ (frequency * 2)); // Calculate half period in milliseconds
    bool isTorchOn = false;

    int timerFirings = 0;

    _timer = Timer.periodic(Duration(milliseconds: halfPeriod), (timer) {
      if (isTorchOn) {
        disableTorch();
        isTorchOn = false;
      } else {
        enableTorch();
        isTorchOn = true;
      }

      timerFirings++;

      // Only decrement currentStepTimeRemaining and therapyTimer.state once per second
      if (timerFirings >= frequency * 2) {
        currentStepTimeRemaining--;
        therapyTimer.state--;
        timerFirings = 0;
      }

      if (currentStepTimeRemaining <= 0) {
        choreographyIndex++;
        if (choreographyIndex < choreography.length) {
          currentStep = choreography[choreographyIndex];
          currentStepTimeRemaining = currentStep['duration']!;
          frequency = currentStep['frequency']!;
          halfPeriod = (1000 ~/ (frequency * 2));
          timerFirings = 0;
        } else {
          stopTherapy(ref, disableTorch);
        }
      }
    });
  }

  void stopTherapy(WidgetRef ref, Function disableTorch) {
    _timer?.cancel();
    disableTorch();
    ref.read(therapyTimerProvider.state).state = 0; // Reset the timer
    Wakelock.disable(); // Disable wakelock
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torchLightState = ref.watch(torchLightControllerProvider);
    final remainingTime = ref.watch(therapyTimerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yume'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              remainingTime > 0 ? 'Time Remaining: ${remainingTime}s' : '',
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: torchLightState.isAvailable
                      ? () {
                          final controller =
                              ref.read(torchLightControllerProvider.notifier);
                          startTherapy(ref, controller.enableTorch,
                              controller.disableTorch, choreography1);
                        }
                      : null,
                  child: const Text('Basic Therapy'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: torchLightState.isAvailable
                      ? () {
                          final controller =
                              ref.read(torchLightControllerProvider.notifier);
                          startTherapy(ref, controller.enableTorch,
                              controller.disableTorch, choreography2);
                        }
                      : null,
                  child: const Text('Sleep Therapy'),
                ),
              ],
            ),
            remainingTime > 0
                ? ElevatedButton(
                    onPressed: () {
                      final controller =
                          ref.read(torchLightControllerProvider.notifier);
                      stopTherapy(ref, controller.disableTorch);
                    },
                    child: const Text('Stop Therapy'),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
