import 'package:hooks_riverpod/hooks_riverpod.dart';

final therapyTimeProvider =
    StateNotifierProvider.autoDispose<TherapyTimeNotifier, int>((ref) {
  return TherapyTimeNotifier();
});

class TherapyTimeNotifier extends StateNotifier<int> {
  TherapyTimeNotifier() : super(0);

  void increment() => state++;

  void decrement() => state--;

  void reset() => state = 0;

  void set(int value) => state = value;

  @override
  void dispose() {
    reset();
    super.dispose();
  }
}
