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

// Write a function that takes name as parameter and returns the name after capitalizing first letter of every word
// Example: capitalizeName('john doe') => 'John Doe'
String capitalizeName(String name) {
  return name
      .split(' ')
      .map((word) => word[0].toUpperCase() + word.substring(1))
      .join(' ');
}
