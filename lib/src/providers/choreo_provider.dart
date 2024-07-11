import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:maya/src/models/choreo.dart';

const String choreoCollection = 'choreo';

final choreoProvider = StreamProvider<List<Choreo>>((ref) {
  return FirebaseFirestore.instance
      .collection(choreoCollection)
      .snapshots()
      .map((snapshot) {
    return snapshot.docs
        .map((doc) => Choreo.fromMap(doc.data(), doc.id))
        .toList();
  });
});

final choreoByIdProvider = FutureProvider<Choreo?>((ref) async {
  final String? selectedId = ref.watch(selectedChoreoProvider);
  if (selectedId == null || selectedId.isEmpty) {
    return null;
  }
  final doc = await FirebaseFirestore.instance
      .collection(choreoCollection)
      .doc(selectedId)
      .get();
  if (doc.data() != null) {
    return Choreo.fromMap(doc.data()!, doc.id);
  } else {
    return null;
  }
});

final selectedChoreoProvider = StateProvider<String?>((ref) => null);
