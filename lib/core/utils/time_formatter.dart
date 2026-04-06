String padTwo(int value) => value.toString().padLeft(2, '0');

String formatDuration(Duration duration) {
  final h = duration.inHours;
  final m = duration.inMinutes.remainder(60);
  final s = duration.inSeconds.remainder(60);
  if (h > 0) {
    return '${padTwo(h)}:${padTwo(m)}:${padTwo(s)}';
  }
  return '${padTwo(m)}:${padTwo(s)}';
}

String formatDurationFull(Duration duration) {
  final h = duration.inHours;
  final m = duration.inMinutes.remainder(60);
  final s = duration.inSeconds.remainder(60);
  return '${padTwo(h)}:${padTwo(m)}:${padTwo(s)}';
}

String formatMilliseconds(Duration duration) {
  return padTwo(duration.inMilliseconds.remainder(1000) ~/ 10);
}

String formatTime(DateTime dt, {bool is24h = true}) {
  final h = is24h ? dt.hour : (dt.hour % 12 == 0 ? 12 : dt.hour % 12);
  final m = dt.minute;
  final s = dt.second;
  return '${padTwo(h)}:${padTwo(m)}:${padTwo(s)}';
}

String formatDate(DateTime dt) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
  final dayName = days[dt.weekday - 1];
  final monthName = months[dt.month - 1];
  return '$dayName, $monthName ${dt.day}, ${dt.year}';
}
