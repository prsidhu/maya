import 'package:flutter_riverpod/flutter_riverpod.dart';

final countdownProvider =
    StateNotifierProvider<Countdown, int>((ref) => Countdown(0));

class Countdown extends StateNotifier<int> {
  Countdown(super.count);

  void set(int count) {
    state = count;
  }

  void decrement() {
    if (state > 0) {
      state--;
    }
  }

  void reset() {
    state = 0;
  }
}
