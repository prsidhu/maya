import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/providers/audioFileProvider.dart';
import 'package:morpheus/src/providers/choreo_provider.dart';
import 'package:morpheus/src/providers/torch_light_controller.dart';
import 'package:morpheus/src/widgets/audio_player.dart';
import 'package:wakelock/wakelock.dart';

final therapyTimerProvider = StateProvider<int>((ref) {
  return 0;
});

class StroboTherapyWidget extends ConsumerWidget {
  final Choreo choreography;

  StroboTherapyWidget({Key? key, required this.choreography}) : super(key: key);

  Timer? _timer;

  void startTherapy(
    WidgetRef ref,
    Function enableTorch,
    Function disableTorch,
  ) {
    // Reset any ongoing therapy
    stopTherapy(ref, disableTorch);
    Wakelock.enable(); // Enable wakelock to keep the screen on

    final therapyTimer = ref.read(therapyTimerProvider.state);
    therapyTimer.state = choreography.sequence.fold(
        0, (int previousValue, Sequence curr) => previousValue + curr.duration);

    int choreographyIndex = 0;
    Sequence currentStep = choreography.sequence[choreographyIndex];
    int currentStepTimeRemaining = currentStep.duration;
    int frequency = currentStep.frequency;
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
        if (choreographyIndex < choreography.sequence.length) {
          currentStep = choreography.sequence[choreographyIndex];
          currentStepTimeRemaining = currentStep.duration;
          frequency = currentStep.frequency;
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

    if (!torchLightState.isAvailable) {
      return const Center(
        child: Text('Torch light is not available on this device.'),
      );
    }

    final audioFileAsyncValue =
        ref.watch(audioFileProvider(choreography.mediaName ?? ""));

    return audioFileAsyncValue.when(
        loading: () => const CircularProgressIndicator(),
        error: (err, stack) => const Text('Failed to load the audio file.'),
        data: (String url) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                remainingTime > 0 ? 'Time Remaining: ${remainingTime}s' : '',
                style: const TextStyle(color: Colors.black, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final controller =
                          ref.read(torchLightControllerProvider.notifier);
                      startTherapy(
                          ref, controller.enableTorch, controller.disableTorch);
                    },
                    child: const Icon(Icons.play_arrow),
                  ),
                  const SizedBox(
                      width: 20), // Add some space between the buttons
                  ElevatedButton(
                    onPressed: remainingTime > 0
                        ? () {
                            final controller =
                                ref.read(torchLightControllerProvider.notifier);
                            stopTherapy(ref, controller.disableTorch);
                          }
                        : null,
                    child: const Icon(Icons.stop),
                  )
                ],
              ),
              if (url.isNotEmpty)
                AudioPlayerWidget(
                    filePath: url,
                    isPlaying: ref.watch(therapyTimerProvider) != 0)
            ],
          );
        });
  }
}
