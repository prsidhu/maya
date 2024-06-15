class Choreo {
  final String id;
  final String title;
  final List<Sequence> sequence;
  final String? mediaName;
  final int? totalDuration;

  Choreo(
      {required this.id,
      required this.title,
      required this.sequence,
      this.mediaName = '',
      this.totalDuration = 0});

  Choreo.fromMap(Map<String, dynamic> data, this.id)
      : title = data['title'],
        mediaName = data['media_name'],
        sequence = (data['sequence'] as List)
            .map((e) => Sequence(
                  duration: e['duration'],
                  frequency: e['frequency'],
                ))
            .toList(),
        totalDuration = (data['sequence'] as List).fold(
            0,
            (prev, element) =>
                (prev! + (element['duration'] ?? 0).toInt()).toInt());
}

class Sequence {
  final int duration;
  final int frequency;

  Sequence({required this.duration, required this.frequency});
}
