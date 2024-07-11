import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:torch_light/torch_light.dart';

final torchLightControllerProvider =
    StateNotifierProvider.autoDispose<TorchLightController, TorchLightState>(
        (ref) {
  return TorchLightController();
});

class TorchLightState {
  final bool isAvailable;
  final bool isTorchOn;

  TorchLightState({required this.isAvailable, required this.isTorchOn});
}

class TorchLightController extends StateNotifier<TorchLightState> {
  TorchLightController()
      : super(TorchLightState(isAvailable: false, isTorchOn: false)) {
    initTorch();
  }

  Future<void> initTorch() async {
    bool isAvailable = await TorchLight.isTorchAvailable();
    if (isAvailable) {
      await disableTorch();
    }
    state = TorchLightState(isAvailable: isAvailable, isTorchOn: false);
  }

  Future<void> enableTorch() async {
    try {
      await TorchLight.enableTorch();
    } on EnableTorchExistentUserException {
      // The camera is in use.
    } on EnableTorchNotAvailableException {
      // Torch was not detected.
    } on EnableTorchException {
      // An unknown error occurred.
    }
  }

  Future<void> disableTorch() async {
    try {
      await TorchLight.disableTorch();
    } on DisableTorchExistentUserException {
      // The camera is in use.
    } on DisableTorchNotAvailableException {
      // Torch was not detected.
    } on DisableTorchException {
      // An unknown error occurred.
    }
  }

  Future<void> toggleTorch() async {
    if (state.isTorchOn) {
      await disableTorch();
    } else {
      await enableTorch();
    }
    state = TorchLightState(
        isAvailable: state.isAvailable, isTorchOn: !state.isTorchOn);
  }

  @override
  void dispose() {
    disableTorch();
    super.dispose();
  }
}
