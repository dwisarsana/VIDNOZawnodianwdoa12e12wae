import 'package:intl/intl.dart';

class NumberUtils {
  static String formatToken(int amount) {
    return NumberFormat.decimalPattern().format(amount);
  }

  static String formatCompact(int amount) {
    return NumberFormat.compact().format(amount);
  }
}
