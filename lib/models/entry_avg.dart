import 'package:Kuluma/tools/common.dart';
import 'package:hive/hive.dart';
import '../tools/format_date.dart';

part 'entry_avg.g.dart';

@HiveType(typeId: 3)
class Avg {
  @HiveField(0)
  DateTime ts;
  @HiveField(1)
  double change;
  @HiveField(2)
  int timeFrame;

  Avg({required this.ts, required this.change, required this.timeFrame});

  Avg.initToHour(DateTime date, int hour)
      : this.ts = DateTime.utc(date.year, date.month, date.day, hour + 1),
        this.change = 0,
        this.timeFrame = TimeFrame.hourly.index;

  Avg.initToDayForWeek(DateTime date, int day)
      : this.ts = FormatDate.comparableIntAsDaysToDate(day),
        this.change = 0,
        this.timeFrame = TimeFrame.weekly.index;

  Avg.initToDayForMonth(DateTime date, int day)
      : this.ts = FormatDate.comparableIntAsDaysToDate(day + 1),
        this.change = 0,
        this.timeFrame = TimeFrame.monthly.index;

  Avg.initToMonth(DateTime date, int month)
      : this.ts = DateTime(date.year, month + 1, 1),
        this.change = 0,
        this.timeFrame = TimeFrame.yearly.index;

  factory Avg.initToTimeFrame(TimeFrame a, DateTime date, int val) {
    switch (a) {
      case TimeFrame.hourly:
        return Avg.initToHour(date, val);
      case TimeFrame.weekly:
        return Avg.initToDayForWeek(date, val);
      case TimeFrame.monthly:
        return Avg.initToDayForMonth(date, val);
      case TimeFrame.yearly:
        return Avg.initToMonth(date, val);
      default:
        throw Exception("Unknown init to timeframe");
    }
  }

  @HiveField(4)
  DateTime get date {
    return ts;
  }

  @HiveField(5)
  double get hour {
    return ts.hour.toDouble();
  }

  @HiveField(6)
  int get x {
    switch (timeFrame) {
      case 0:
        return ts.hour;
      case 1:
      case 2:
        return FormatDate.dateToComparableIntAsDays(ts);
      case 3:
        return ts.month;
      default:
        throw Exception("Default is not implemented in Avg getter x");
    }
  }
}
