import 'package:Kuluma/tools/common.dart';
import 'package:Kuluma/tools/format_date.dart';

class Entry {
  final DateTime ts;
  final double change;

  Entry({
    required this.ts,
    required this.change,
  });

  Entry.fromJson(entry)
      : this.change = double.parse((entry['change'] * 1000).toStringAsFixed(2)),
        this.ts = FormatDate.numberToEpochToDateTime(entry['ts']).toLocal();

  int getIndexByTimeFrame(TimeFrame timeframe) {
    if (timeframe == TimeFrame.hourly) return ts.hour;
    if (timeframe == TimeFrame.weekly) return ts.weekday;
    if (timeframe == TimeFrame.monthly) return ts.day;
    if (timeframe == TimeFrame.yearly) return ts.month;
    throw Exception("Out of bounds");
  }
}

/* class Entry {
  final String id;
  final String apartment;
  final String location;
  final String sensor;
  final DateTime ts;
  final double value;

  Entry({
    this.id,
    this.apartment,
    this.location,
    this.sensor,
    this.ts,
    this.value,
  });
}
 */
