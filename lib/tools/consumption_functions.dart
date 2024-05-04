import 'package:Kuluma/config.dart';
import 'package:Kuluma/models/entry.dart';
import 'package:Kuluma/tools/common.dart';
import 'package:Kuluma/tools/utils.dart';

import '../models/entry_avg.dart';
import '../models/entry_compute.dart';
import 'format_date.dart';

class Consumption {
  static Duration duration(TimeFrame timeFrame, {date}) {
    switch (timeFrame) {
      case TimeFrame.hourly:
        return Duration(days: 1);
      case TimeFrame.weekly:
        return Duration(days: 6);

      case TimeFrame.monthly:
        return Duration(days: FormatDate.daysInMonth(date));

      case TimeFrame.yearly:
        {
          return Duration(days: 365);
        }

      default:
        return Duration(days: 1);
    }
  }

  static Map<String, dynamic> avgDataFormat(EntryCompute avgData) {
    double maxValue = 0;
    List raw = (avgData.rawAvg as List);
    Map<int, Entry> entries = {};

    for (int i = 0; i < raw.length; i++) {
      Entry entry = Entry.fromJson(raw[i]);
      entries.addAll({entry.getIndexByTimeFrame(avgData.timeFrame): entry});
    }

    List<Avg> avg = List<Avg>.generate(avgData.generatedLength, (int i) {
      i = i + 1;
      if (AppConfig.useDummyData) {
        Avg dummy = Avg.initToTimeFrame(
          avgData.timeFrame,
          avgData.date,
          avgData.chartMinX + i - 1,
        ).randomBasedOnTimeFrame();

        if (dummy.change > maxValue) maxValue = dummy.change;

        return dummy;
      }
      try {
        if (!entries.containsKey(i) /*  && i - 1 != 0 */)
          return Avg.initToTimeFrame(
            avgData.timeFrame,
            avgData.date,
            avgData.chartMinX + i - 1,
          );

        double change = entries[i]!.change;

        if (change > maxValue) maxValue = change;

        return Avg(
          ts: entries[i]!.ts,
          change: change,
          timeFrame: avgData.timeFrame.index,
        );
      } catch (err) {
        return Avg.initToTimeFrame(
          avgData.timeFrame,
          avgData.date,
          avgData.chartMinX + i - 1,
        );
      }
    });

    return ({'avg': avg, 'y': maxValue});
  }
}

extension DummyData on Avg {
  Avg randomBasedOnTimeFrame() {
    List<double> c = [
      Utils.doubleInRange(6, 123),
      Utils.doubleInRange(0, 250),
      Utils.doubleInRange(0, 250),
      Utils.doubleInRange(2000, 4000)
    ];

    this.change = c[this.timeFrame];

    return this;
  }
}
