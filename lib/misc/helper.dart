import 'day_of_week.dart';
import 'month.dart';

class Helper {
  static String toHumanDate(String date) {
    var datetime = DateTime.parse(date);
    return DayOfWeek.short[datetime.weekday - 1] +
        ', ' +
        Month.short[datetime.month - 1] +
        ' ' +
        datetime.day.toString() +
        ', ' +
        datetime.year.toString();
  }
}
