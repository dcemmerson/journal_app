import 'day_of_week.dart';
import 'month.dart';

class Helper {
  static String toHumanDate(DateTime date) {
    return DayOfWeek.short[date.weekday - 1] +
        ', ' +
        Month.short[date.month - 1] +
        ' ' +
        date.day.toString() +
        ', ' +
        date.year.toString();
  }

  static String ratingToString(double rating) {
    //Increment rating because rating is 0-indexed.
    rating++;
    if (rating % 1 > 0) {
      //Then we dont need to truncate rating.
      return rating.toString();
    } else {
      return rating.truncate().toString();
    }
  }
}
