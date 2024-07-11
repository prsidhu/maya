import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:morpheus/src/models/choreo.dart';
import 'package:morpheus/src/widgets/choreo_dropdown.dart';
import 'package:morpheus/src/widgets/choreo_list.dart';

final currentChoreoProvider = StateProvider<Choreo?>((ref) => null);

class TherapyPage extends ConsumerWidget {
  const TherapyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yume'),
      ),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChoreoDropdown(),
          SizedBox(height: 40),
          ChoreosListScreen(),
        ],
      ),
    );
  }
}
