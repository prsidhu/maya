import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:maya/src/config/events.dart';
import 'package:maya/src/models/choreo.dart';
import 'package:maya/src/providers/audioFileProvider.dart';
import 'package:maya/src/providers/countdown.dart';
import 'package:maya/src/providers/torch_light_controller.dart';
import 'package:maya/src/utils/stringUtils.dart';
import 'package:maya/src/widgets/audio_player.dart';
import 'package:maya/src/widgets/choreo_image.dart';
import 'package:maya/src/widgets/text/author_text.dart';
import 'package:maya/src/widgets/text/onboarding_text.dart';
import 'package:wakelock/wakelock.dart';
import 'package:maya/src/providers/therapy_time_provider.dart';

class StroboTherapyWidget extends ConsumerStatefulWidget {
  final Choreo choreography;

  const StroboTherapyWidget({super.key, required this.choreography});

  @override
  _StroboTherapyWidgetState createState() => _StroboTherapyWidgetState();
}

class _StroboTherapyWidgetState extends ConsumerState<StroboTherapyWidget> {
  Timer? _timer;
  bool isTorchOn = false;
  int timerFirings = 0;
  bool isPlaying = false;

  void startTherapy() async {
    // Reset any ongoing therapy
    stopTherapy();
    Wakelock.enable(); // Enable wakelock to keep the screen on
    Events().startTherapyEvent(widget.choreography.id,
        widget.choreography.title, widget.choreography.totalDuration ?? 0);
    final TherapyTimeNotifier therapyTimer =
        ref.watch(therapyTimeProvider.notifier);
    int totalDuration = calculateTotalDuration(widget.choreography.sequence);
    therapyTimer.state = totalDuration;

    // Start the countdown
    final Countdown countdown = ref.watch(countdownProvider.notifier);
    countdown.set(3); // Start the countdown from 3 seconds
    Timer.periodic(const Duration(seconds: 1), (timer) {
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

  Widget _buildButton(BuildContext context, int countdown, remainingTime) {
    return Padding(
      padding: const EdgeInsets.only(
          top: 30.0, bottom: 40.0, left: 40.0, right: 40.0),
      child: Center(
        child: SizedBox(
          width: double.infinity, // Make the button full width
          height: 56.0, // Standard height for buttons
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: const StadiumBorder(), // Rounded edges
            ),
            onPressed: countdown > 0
                ? null
                : () {
                    if (isPlaying) {
                      Events().stopTherapyEvent(widget.choreography.id,
                          widget.choreography.title, remainingTime);
                      stopTherapy();
                    } else {
                      Events().startTherapyEvent(widget.choreography.id,
                          widget.choreography.title, remainingTime);
                      startTherapy();
                    }
                  },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the content
              children: <Widget>[
                Icon(
                  countdown > 0
                      ? Icons.more_horiz
                      : isPlaying
                          ? Icons.stop_outlined
                          : Icons.play_arrow_outlined,
                  size: 30.0,
                  color: Theme.of(context).colorScheme.surfaceDim,
                ),
                const SizedBox(width: 8), // Space between icon and text
                Text(
                  '${countdown > 0 ? 'Starting' : isPlaying ? 'Stop' : 'Start'} / ${countdownFormatDuration(remainingTime)}',
                  textAlign: TextAlign.center, // Center the text
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.surfaceDim,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
    final int countdown = ref.watch(countdownProvider);

    final audioFileAsyncValue =
        ref.watch(audioFileProvider(widget.choreography.mediaName ?? ""));

    return audioFileAsyncValue.when(
        loading: () {
          return const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          );
        },
        error: (err, stack) => const Text('Failed to load the audio file.'),
        data: (String url) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  // Use Center widget to center the image container in the screen
                  child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Column(
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Text(
                                widget.choreography.title,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              )),
                          if (countdown > 0) ...[
                            Container(
                              height:
                                  140.0, // Set a fixed height that accommodates both widgets
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                '$countdown',
                                style:
                                    Theme.of(context).textTheme.displayMedium,
                              ),
                            )
                          ] else ...[
                            Container(
                              height: 140.0, // Same fixed height as above
                              alignment: Alignment.bottomCenter,
                              child: const OnboardingText(),
                            )
                          ]
                        ],
                      )),
                ),
                if (!torchLightState.isAvailable) ...[
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Text(
                        'Torch light is not available on this device.',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Colors.red,
                            ),
                      ),
                    ),
                  )
                ],
                if (torchLightState.isAvailable) ...[
                  _buildButton(context, countdown, remainingTime),
                  if (url.isNotEmpty)
                    AudioPlayerWidget(filePath: url, isPlaying: isPlaying)
                ]
              ],
            ),
          );
        });
  }
}
