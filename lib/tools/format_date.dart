import 'logging.dart';

abstract class FormatDate {
  static final DateTime fixed = DateTime(2000, 1, 1);

  /// Specified datetime to begin from 00:00
  static DateTime initDateTimeToUtc0000(DateTime date) {
    final DateTime utc = date /* .toUtc() */;
    final int year = utc.year;
    final int month = utc.month;
    final int day = utc.day;

    return DateTime.utc(year, month, day);
  }

  /// Specified datetime day to 00:00 of next day
  static DateTime initDateTimeToNextDay0000(DateTime date) {
    final DateTime utc = date /* .toUtc(). */ .add(Duration(days: 1));

    final int year = utc.year;
    final int month = utc.month;
    final int day = utc.day;

    return DateTime.utc(year, month, day);
  }

  /// Substract by time which should atleast give one extra datapoint for comparison.
  /// One hour substraction is not always enough
  static DateTime adjustTimeToGetExtraDataPoints(DateTime date) =>
      date.subtract(Duration(hours: 3));

  /// Substract by day which should atleast give one extra datapoint for comparison.
  static DateTime adjustTimeToGetExtraDataPointsByDay(DateTime date) =>
      date.subtract(Duration(days: 1));

  /// Substract exactly n amount of days from the provided date
  static DateTime substractFromDateByNumberOfDays(DateTime date, int days) =>
      date.subtract(
        Duration(days: days),
      );

  /// DateTime provided will be the start of the range in resulting string as UTC.
  /// Return value is in format 'start=${start}&end=${end}'.
  /// Conversion from the cumulative value to value change requires additional
  /// datapoint to be fetched to get the comparable value for specified timeframe.
  /// To achieve that we add so much time to starting value that it fetches the
  /// previous datapoint for specified timeframe.
  static RangeDataForQueryString createRangeForDayFromDate(DateTime date) =>
      _timeToMap(
        initDateTimeToUtc0000(date),
        initDateTimeToNextDay0000(date),
        'hour',
      );

  /// DateTime provided will be the start of the range in resulting string as UTC.
  /// Return value is in format 'start=${start}&end=${end}'
  static Map<String, String> createRangeForLastSevenDaysFromDate(
      DateTime date) {
    /*  Log.warn("Date in createRangeForLastSevenDaysFromDate", date); */

    return _timeToMapString(
      initDateTimeToUtc0000(substractFromDateByNumberOfDays(date, 7)),
      initDateTimeToNextDay0000(date),
      'day',
    );
  }

  /// Create range for the current week by given dateTime as UTC
  /// monday 00:00 - next week monday 00:00
  static RangeDataForQueryString createRangeForCurrentWeek(DateTime date) {
    final DateTime utc = date.toUtc();

    DateTime to0000 = initDateTimeToUtc0000(utc);
    DateTime monday = to0000.subtract(Duration(days: to0000.weekday - 1));
    DateTime sunday = monday.add(Duration(days: 7));
    return _timeToMap(monday, sunday, 'day');
  }

  /// DateTime provided will be the start of the range in resulting string.
  /// Return value is in format 'start=${start}&end=${end}'
  static RangeDataForQueryString createRangeForMonthFromDate(DateTime date) {
    final DateTime start = DateTime.utc(date.year, date.month, 1);
    final DateTime end =
        initDateTimeToNextDay0000(DateTime(date.year, date.month + 1, 0));
    return _timeToMap(
      start,
      end,
      'day',
    );
  }

  /// DateTime provided will be the start of the range in resulting string.
  /// Return value is in format 'start=${start}&end=${end}'
  /// Add extra month for the comparable datapoint
  static RangeDataForQueryString createRangeForYearFromDate(DateTime date) =>
      _timeToMap(
        DateTime.utc(date.year, 1, 1),
        initDateTimeToNextDay0000(DateTime(date.year, 13, 0)),
        'month',
      );

  /// Calculate days from fixed date [fixed] and make the date comparable integer
  static int dateToComparableIntAsDays(DateTime d) {
    int data = d.difference(fixed).inDays;
    return data;
  }

  /// DateTime from days [int] with [fixed]
  static DateTime comparableIntAsDaysToDate(int days) {
    return fixed.add(Duration(days: days));
  }

  /// Returns provided DateTime millisecondsSinceEpoch as String
  static String ts(DateTime date) => date.millisecondsSinceEpoch.toString();

/*   // Returns provided locale DateTime millisecondsSinceEpoch converted to UTC
  static String tsAsUTC(DateTime date) =>
      date.toUtc().millisecondsSinceEpoch.toString(); */

  /// Converts timestamp from double to DateTime
  static DateTime numberToEpochToDateTime(ts) {
    try {
      if (ts is int)
        return DateTime.fromMillisecondsSinceEpoch(ts, isUtc: true);
      if (ts is double)
        return DateTime.fromMillisecondsSinceEpoch(ts.toInt(), isUtc: true);

      throw Exception("Tried to convert number to date, received: " +
          ts.runtimeType.toString());
    } catch (e) {
      Log.error(e, ts.runtimeType.toString());
      rethrow;
    }
  }

  /// Days in month within DateTime object
  static int daysInMonth(DateTime date) {
    Log.info(DateTime(date.year, date.month + 1, 0).day);
    return DateTime(date.year, date.month + 1, 0).day;
  }

  /// Converts provided DateTime to last day of the week as UTC (as DateTime, 00:00)
  static DateTime lastDayOfTheWeek(DateTime date) =>
      initDateTimeToUtc0000(date.add(Duration(days: 7 - date.weekday)));

  /// Creates querystring start/end part for DWELL API
  static RangeDataForQueryString _timeToMap(
      DateTime s, DateTime e, String avgBy) {
    return RangeDataForQueryString(s, e, avgBy);
  }

  /// Creates querystring start/end part for DWELL API
  static Map<String, String> _timeToMapString(
      DateTime s, DateTime e, String avgBy) {
    return {'start': ts(s), 'end': ts(e), 'by': avgBy};
  }

  /// Return DateTime.now() as 00:00 for current date as UTC
  static DateTime today0000() => initDateTimeToUtc0000(DateTime.now());

/*   static int daysInYear(DateTime date) =>
      dateToComparableIntAsDays(date) -
      dateToComparableIntAsDays(DateTime(date.year, date.month, 1));
 */
  static int weekOfYear(DateTime date) {
    DateTime monday = weekStart(date);
    DateTime first = weekYearStartDate(monday.year);

    int week = 1 + (monday.difference(first).inDays / 7).floor();

    if (week == 53 && DateTime(monday.year, 12, 31).weekday < 4) week = 1;

    return week;
  }

  static DateTime weekStart(DateTime date) {
    // This is ugly, but to avoid problems with daylight saving
    DateTime monday = DateTime.utc(date.year, date.month, date.day);
    monday = monday.subtract(Duration(days: monday.weekday - 1));

    return monday;
  }

  static DateTime weekEnd(DateTime date) {
    // This is ugly, but to avoid problems with daylight saving
    // Set the last microsecond to really be the end of the week
    DateTime sunday =
        DateTime.utc(date.year, date.month, date.day, 23, 59, 59, 999, 999999);
    sunday = sunday.add(Duration(days: 7 - sunday.weekday));

    return sunday;
  }

  static DateTime weekYearStartDate(int year) {
    final firstDayOfYear = DateTime.utc(year, 1, 1);
    final dayOfWeek = firstDayOfYear.weekday;

    return firstDayOfYear.add(
        Duration(days: (dayOfWeek <= DateTime.thursday ? 1 : 8) - dayOfWeek));
  }
}

class RangeDataForQueryString {
  DateTime start;
  DateTime end;
  String by;

  RangeDataForQueryString(this.start, this.end, this.by);
}
