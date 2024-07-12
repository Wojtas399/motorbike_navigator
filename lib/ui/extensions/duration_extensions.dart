extension DurationExtensions on Duration {
  String toUIFormat() {
    final int minutes = inMinutes % 60;
    final int seconds = inSeconds % 60;

    return '${inHours}h ${minutes}min ${seconds}s';
  }
}
