class Choreo {
  final String id;
  final String title;
  final List<Sequence> sequence;
  final String? mediaName;

  Choreo(
      {required this.id,
      required this.title,
      required this.sequence,
      this.mediaName = ''});

  Choreo.fromMap(Map<String, dynamic> data, this.id)
      : title = data['title'],
        mediaName = data['media_name'],
        sequence = (data['sequence'] as List)
            .map((e) => Sequence(
                  duration: e['duration'],
                  frequency: e['frequency'],
                ))
            .toList();
}

class Sequence {
  final int duration;
  final int frequency;

  Sequence({required this.duration, required this.frequency});
}
