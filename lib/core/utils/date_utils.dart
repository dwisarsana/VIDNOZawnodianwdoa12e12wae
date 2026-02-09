import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  static String formatDateTime(DateTime date) {
    return DateFormat('MMM dd, HH:mm').format(date);
  }

  static String formatDuration(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final int min = seconds ~/ 60;
    final int sec = seconds % 60;
    return '${min}m ${sec}s';
  }
}
