import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  static final DateFormat _timeFormat = DateFormat('hh:mm a');
  static final DateFormat _shortDate = DateFormat('d MMM yyyy');

  static String formatDate(DateTime dt) => _dateFormat.format(dt);
  static String formatTime(DateTime dt) => _timeFormat.format(dt);
  static String formatShort(DateTime dt) => _shortDate.format(dt);

  static String formatDayAndMonth(DateTime dt) {
    return DateFormat('EEEE, d MMMM', 'es').format(dt);
  }

  static String formatFullWithTime(DateTime dt) {
    return '${formatShort(dt)} a las ${formatTime(dt)}';
  }

  static String getRelativeTimeSpan(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final targetDay = DateTime(dt.year, dt.month, dt.day);

    final differenceInDays = targetDay.difference(today).inDays;

    if (differenceInDays == 0) {
      return 'Hoy a las ${formatTime(dt)}';
    } else if (differenceInDays == 1) {
      return 'Mañana a las ${formatTime(dt)}';
    } else if (differenceInDays == -1) {
      return 'Ayer a las ${formatTime(dt)}';
    } else if (differenceInDays > 1 && differenceInDays < 7) {
      return 'En $differenceInDays días (${formatTime(dt)})';
    } else {
      return formatFullWithTime(dt);
    }
  }
}
