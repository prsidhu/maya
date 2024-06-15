String formatDuration(int totalSeconds) {
  int minutes = totalSeconds ~/ 60;
  int seconds = totalSeconds % 60;
  return "${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s";
}
