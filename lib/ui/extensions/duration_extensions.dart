extension DurationExtensions on Duration {
  String toUIFormat() {
    final int minutes = inMinutes % 60;
    final int seconds = inSeconds % 60;
    String durationStr = '';
    if (inHours > 0) durationStr = '${inHours}h';
    if (minutes > 0) durationStr += ' ${minutes}m';
    if (seconds > 0) durationStr += ' ${seconds}s';
    return durationStr.isNotEmpty ? durationStr : '0s';
  }
}
