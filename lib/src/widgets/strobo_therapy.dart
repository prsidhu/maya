import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/providers/audioFileProvider.dart';
import 'package:morpheus/src/providers/countdown.dart';
import 'package:morpheus/src/providers/torch_light_controller.dart';
import 'package:morpheus/src/widgets/audio_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:morpheus/src/providers/therapy_time_provider.dart';

class StroboTherapyWidget extends ConsumerStatefulWidget {
  final Choreo choreography;

  StroboTherapyWidget({Key? key, required this.choreography}) : super(key: key);

  @override
  _StroboTherapyWidgetState createState() => _StroboTherapyWidgetState();
}

class _StroboTherapyWidgetState extends ConsumerState<StroboTherapyWidget> {
  Timer? _timer;
  bool isTorchOn = false;
  int timerFirings = 0;

  void startTherapy(
      WidgetRef ref, Function enableTorch, Function disableTorch) async {
    // Reset any ongoing therapy
    stopTherapy(disableTorch);
    Wakelock.enable(); // Enable wakelock to keep the screen on

    final TherapyTimeNotifier therapyTimer =
        ref.watch(therapyTimeProvider.notifier);
    int totalDuration = calculateTotalDuration(widget.choreography.sequence);
    therapyTimer.state = totalDuration;

    // Start the countdown
    final Countdown countdown = ref.watch(countdownProvider.notifier);
    countdown.set(3); // Start the countdown from 3 seconds
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.state == 0) {
        timer.cancel();
      } else {
        countdown.decrement();
      }
    });

    // Wait for the countdown to finish
    while (countdown.state > 0) {
      await Future.delayed(Duration(seconds: 1));
    }

    int choreographyIndex = 0;

    _startStep(
      ref: ref,
      enableTorch: enableTorch,
      disableTorch: disableTorch,
      choreographyIndex: choreographyIndex,
    );
  }

  void _startStep({
    required WidgetRef ref,
    required Function enableTorch,
    required Function disableTorch,
    required int choreographyIndex,
  }) {
    if (choreographyIndex >= widget.choreography.sequence.length) {
      stopTherapy(disableTorch);
      return;
    }

    final Sequence currentStep =
        widget.choreography.sequence[choreographyIndex];
    int currentStepTimeRemaining = currentStep.duration;
    int frequency = currentStep.frequency;
    int halfPeriod = calculateHalfPeriod(frequency);

    _timer = Timer.periodic(Duration(milliseconds: halfPeriod), (timer) {
      // Throttle the enable/disable events to avoid overloading the torch
      if (frequency <= 10 || timerFirings % (frequency ~/ 10) == 0) {
        toggleTorchState(enableTorch, disableTorch);
      }

      timerFirings++;

      if (timerFirings >= frequency * 2) {
        currentStepTimeRemaining--;
        timerFirings = 0;
        ref.read(therapyTimeProvider.notifier).decrement();
      }

      if (currentStepTimeRemaining <= 0) {
        _timer?.cancel();
        _startStep(
          ref: ref,
          enableTorch: enableTorch,
          disableTorch: disableTorch,
          choreographyIndex: choreographyIndex + 1,
        );
      }
    });
  }

  void toggleTorchState(Function enableTorch, Function disableTorch) {
    if (isTorchOn) {
      disableTorch();
    } else {
      enableTorch();
    }
    isTorchOn = !isTorchOn;
  }

  void stopTherapy(Function disableTorch) {
    _timer?.cancel();
    disableTorch();
    ref.read(therapyTimeProvider.notifier).reset(); // Reset the timer
    ref.read(countdownProvider.notifier).reset(); // Reset the countdown
    Wakelock.disable(); // Allow the screen to turn off
  }

  int calculateTotalDuration(List<Sequence> sequence) {
    return sequence.fold(
        0, (int previousValue, Sequence curr) => previousValue + curr.duration);
  }

  int calculateHalfPeriod(int frequency) {
    return (1000 ~/ (frequency * 2)); // Calculate half period in milliseconds
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    Wakelock.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final torchLightState = ref.watch(torchLightControllerProvider);
    final remainingTime = ref.watch(therapyTimeProvider);
    final countdown = ref.watch(countdownProvider);

    if (!torchLightState.isAvailable) {
      return const Center(
        child: Text('Torch light is not available on this device.'),
      );
    }

    final audioFileAsyncValue =
        ref.watch(audioFileProvider(widget.choreography.mediaName ?? ""));

    return audioFileAsyncValue.when(
        loading: () => const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
              ],
            ),
        error: (err, stack) => const Text('Failed to load the audio file.'),
        data: (String url) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  countdown > 0
                      ? 'Therapy will start in: $countdown seconds'
                      : '',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
                Text(
                  remainingTime > 0 && countdown == 0
                      ? 'Time Remaining: ${remainingTime}s'
                      : '',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: remainingTime == 0
                          ? () {
                              final controller = ref
                                  .read(torchLightControllerProvider.notifier);
                              startTherapy(ref, controller.enableTorch,
                                  controller.disableTorch);
                            }
                          : null,
                      child: const Icon(Icons.play_arrow),
                    ),
                    const SizedBox(
                        width: 20), // Add some space between the buttons
                    ElevatedButton(
                      onPressed: remainingTime > 0
                          ? () {
                              final controller = ref
                                  .read(torchLightControllerProvider.notifier);
                              stopTherapy(controller.disableTorch);
                            }
                          : null,
                      child: const Icon(Icons.stop),
                    )
                  ],
                ),
                if (url.isNotEmpty)
                  AudioPlayerWidget(
                      filePath: url,
                      isPlaying: ref.watch(therapyTimeProvider) != 0)
              ],
            ),
          );
        });
  }
}
