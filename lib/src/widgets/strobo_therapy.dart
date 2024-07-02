import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/providers/audioFileProvider.dart';
import 'package:morpheus/src/providers/countdown.dart';
import 'package:morpheus/src/providers/torch_light_controller.dart';
import 'package:morpheus/src/utils/stringUtils.dart';
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
  bool isPlaying = false;

  void startTherapy() async {
    print("start");
    // Reset any ongoing therapy
    stopTherapy();
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
      await Future.delayed(const Duration(seconds: 1));
    }

    int choreographyIndex = 0;
    isPlaying = true;
    _startStep(
      ref: ref,
      enableTorch: ref.read(torchLightControllerProvider.notifier).enableTorch,
      disableTorch:
          ref.read(torchLightControllerProvider.notifier).disableTorch,
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
      stopTherapy();
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

  void stopTherapy() {
    print("stop");
    _timer?.cancel();
    ref.read(torchLightControllerProvider.notifier).disableTorch();
    ref.read(therapyTimeProvider.notifier).state =
        calculateTotalDuration(widget.choreography.sequence); // Reset the timer
    ref.read(countdownProvider.notifier).reset(); // Reset the countdown
    isPlaying = false;
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
    super.initState(); // Call super.initState() first.
    Future.delayed(Duration.zero, () {
      final TherapyTimeNotifier therapyTimer = ref.read(
          therapyTimeProvider.notifier); // Use ref.read for initialization.
      try {
        int totalDuration =
            calculateTotalDuration(widget.choreography.sequence);
        therapyTimer.state = totalDuration;
      } catch (e) {
        // Handle or log the error as needed
        print("Error initializing therapy timer: $e");
      }
    });
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
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Text('Torch light is not available on this device.'),
        ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      countdown > 0 ? '$countdown' : '',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      widget.choreography.title,
                      style: Theme.of(context).textTheme.headlineLarge,
                    )),
                Text(
                    'Media Name: ${widget.choreography.mediaName ?? 'Media unavailable'}'),
                Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 40.0),
                    child: Center(
                      child: FloatingActionButton.extended(
                        backgroundColor: Theme.of(context).primaryColor,
                        onPressed: countdown > 0
                            ? null
                            : () {
                                isPlaying ? stopTherapy() : startTherapy();
                              },
                        label: Text(
                          countdownFormatDuration(remainingTime),
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        icon: Icon(
                          countdown > 0
                              ? Icons.more_horiz
                              : isPlaying
                                  ? Icons.stop
                                  : Icons.play_arrow,
                          size: 40.0,
                        ),
                        shape: const StadiumBorder(),
                      ),
                    )),
                if (url.isNotEmpty)
                  AudioPlayerWidget(filePath: url, isPlaying: isPlaying)
              ],
            ),
          );
        });
  }
}
