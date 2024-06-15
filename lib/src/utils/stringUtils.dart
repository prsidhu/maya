String formatDuration(int totalSeconds) {
  int minutes = totalSeconds ~/ 60;
  int seconds = totalSeconds % 60;
  return "${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s";
}

String countdownFormatDuration(int totalSeconds) {
  if (totalSeconds == 0) return "00:00";
  int minutes = totalSeconds ~/ 60;
  int seconds = totalSeconds % 60;
  return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
}
