/// Date helper utility for date/time conversions and formatting
class DateHelper {
  /// WIB Time Zone offset (UTC+7)
  static const Duration wibOffset = Duration(hours: 7);

  /// Convert UTC DateTime to WIB (Western Indonesia Time, UTC+7)
  static DateTime toWib(DateTime utcDateTime) {
    return utcDateTime.toUtc().add(wibOffset);
  }

  /// Convert local DateTime to UTC
  static DateTime toUtc(DateTime localDateTime) {
    return localDateTime.toUtc().subtract(wibOffset);
  }

  /// Get current time in WIB
  static DateTime nowWib() {
    return DateTime.now().toUtc().add(wibOffset);
  }

  /// Format date to readable string in WIB
  /// Example: "15 Feb 2026"
  static String formatDateWib(DateTime dateTime) {
    final wibDate = toWib(dateTime);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${wibDate.day} ${months[wibDate.month - 1]} ${wibDate.year}';
  }

  /// Format date with time in WIB
  /// Example: "15 Feb 2026, 14:30"
  static String formatDateTimeWib(DateTime dateTime) {
    final wibDate = toWib(dateTime);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = wibDate.hour.toString().padLeft(2, '0');
    final minute = wibDate.minute.toString().padLeft(2, '0');
    return '${wibDate.day} ${months[wibDate.month - 1]} ${wibDate.year}, $hour:$minute';
  }

  /// Format date with time and AM/PM in WIB
  /// Example: "Due 15 Feb 2026, 02:30 PM"
  static String formatDueDateWib(DateTime dateTime) {
    final wibDate = toWib(dateTime);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = wibDate.hour > 12 ? wibDate.hour - 12 : wibDate.hour;
    final hourStr = hour.toString().padLeft(2, '0');
    final minute = wibDate.minute.toString().padLeft(2, '0');
    final amPm = wibDate.hour >= 12 ? 'PM' : 'AM';
    return 'Due ${wibDate.day} ${months[wibDate.month - 1]} ${wibDate.year}, $hourStr:$minute $amPm';
  }

  /// Format time only in WIB
  /// Example: "14:30" or "02:30 PM"
  static String formatTimeWib(DateTime dateTime, {bool useAmPm = false}) {
    final wibDate = toWib(dateTime);
    if (useAmPm) {
      final hour = wibDate.hour > 12 ? wibDate.hour - 12 : wibDate.hour;
      final hourStr = hour.toString().padLeft(2, '0');
      final minute = wibDate.minute.toString().padLeft(2, '0');
      final amPm = wibDate.hour >= 12 ? 'PM' : 'AM';
      return '$hourStr:$minute $amPm';
    } else {
      final hour = wibDate.hour.toString().padLeft(2, '0');
      final minute = wibDate.minute.toString().padLeft(2, '0');
      return '$hour:$minute';
    }
  }

  /// Get month name in WIB
  /// Example: "February 2026"
  static String formatMonthYearWib(DateTime dateTime) {
    final wibDate = toWib(dateTime);
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[wibDate.month - 1]} ${wibDate.year}';
  }

  /// Check if date is today in WIB
  static bool isTodayWib(DateTime dateTime) {
    final wibDate = toWib(dateTime);
    final now = nowWib();
    return wibDate.year == now.year &&
        wibDate.month == now.month &&
        wibDate.day == now.day;
  }

  /// Check if date is yesterday in WIB
  static bool isYesterdayWib(DateTime dateTime) {
    final wibDate = toWib(dateTime);
    final yesterday = nowWib().subtract(const Duration(days: 1));
    return wibDate.year == yesterday.year &&
        wibDate.month == yesterday.month &&
        wibDate.day == yesterday.day;
  }

  /// Format date with relative time (Today, Yesterday, or date)
  static String formatRelativeDateWib(DateTime dateTime) {
    if (isTodayWib(dateTime)) {
      return 'Today, ${formatTimeWib(dateTime, useAmPm: true)}';
    } else if (isYesterdayWib(dateTime)) {
      return 'Yesterday, ${formatTimeWib(dateTime, useAmPm: true)}';
    } else {
      return formatDateTimeWib(dateTime);
    }
  }
}
