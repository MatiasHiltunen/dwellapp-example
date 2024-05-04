import 'package:Kuluma/tools/format_date.dart';

import 'config.dart';

class ConsumptionRenderProperties {
  final int by;
  final int index;
  final ConsumptionConfig config;

  ConsumptionRenderProperties(this.by, this.config, int this.index);

  String get title {
    return [
      () {
        if (index % 4 == 0) {
          String str = index.toString();

          if (str.length > 1) {
            str = "$str:00";
          } else {
            str = "0$str:00";
          }
          return str;
        } else {
          return '';
        }
      },
      () {
        return config
            .weekdays[FormatDate.comparableIntAsDaysToDate(index).weekday - 1];
      },
      () {
        DateTime date = FormatDate.comparableIntAsDaysToDate(index - 1);
        return "${date.day}.${date.month}";
      },
      () {
        return config.months[index - 1];
      }
    ][by]();
  }
}

abstract class ConsumptionVisualizationTools {
  static String timeRangeToStringForHourlyData(int x) {
    String str = x.toString();
    String str2 = (x + 1).toString();

    if (str.length > 1) {
      str = "$str:00";
    } else {
      str = "0$str:00";
    }

    if (str2.length > 1) {
      str2 = "$str2:00";
    } else {
      str2 = "0$str2:00";
    }
    return str + ' - ' + str2;
  }
}
