class Choreo {
  final String? author;
  final String? description;
  final String id;
  final String? imageName;
  final String? mediaName;
  final List<String> segments;
  final List<Sequence> sequence;
  final int? totalDuration;
  final String title;

  Choreo({
    required this.id,
    required this.title,
    required this.sequence,
    required this.segments,
    this.author = '',
    this.description = '',
    this.imageName = '',
    this.mediaName = '',
    this.totalDuration = 0,
  });

  Choreo.fromMap(Map<String, dynamic> data, this.id)
      : author = data['author'] ?? '',
        description = data['description'] ?? '',
        title = data['title'],
        mediaName = data['media_name'],
        imageName = data['image_name'],
        segments = (data['segments'] as List).map((e) => e.toString()).toList(),
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
