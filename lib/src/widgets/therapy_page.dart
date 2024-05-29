import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/widgets/choreo_dropdown.dart';
import 'package:morpheus/src/widgets/choreo_list.dart';

final currentChoreoProvider = StateProvider<Choreo?>((ref) => null);

class TherapyPage extends ConsumerWidget {
  TherapyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yume'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChoreoDropdown(),
          const SizedBox(height: 40),
          ChoreosListScreen(),
        ],
      ),
    );
  }
}
