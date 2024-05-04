import 'package:Kuluma/tools/format_date.dart';
import 'package:Kuluma/tools/logging.dart';
import 'package:fl_chart/fl_chart.dart';
import 'config.dart';
import 'consumption_render_properties.dart';

class SelectedBarData {
  final double? own;
  final double? avg;
  final bool switchStatus;
  final ConsumptionConfig config;
  final int by;
  final int x;
  DateTime selectedEnd;
  BarChartGroupData? group;

  SelectedBarData({
    required this.own,
    required this.avg,
    required this.switchStatus,
    required this.config,
    required this.by,
    required this.x,
    required this.selectedEnd,
    this.group,
  });

  String get selectedTime {
    try {
      if (by == 0) {
        return ConsumptionVisualizationTools.timeRangeToStringForHourlyData(x);
      } else if (by == 1) {
        return [
          "maanantai",
          "tiistai",
          "keskiviikko",
          "torstai",
          "perjantai",
          "lauantai",
          "sunnuntai"
        ][FormatDate.comparableIntAsDaysToDate(x).weekday - 1];
      } else if (by == 2) {
        DateTime date = FormatDate.comparableIntAsDaysToDate(x);

        return "${date.day}. ${config.monthsFull[date.month - 1]}";
      } else if (by == 3) {
        return [
          "tammikuu",
          "helmikuu",
          "maaliskuu",
          "huhtikuu",
          "toukokuu",
          "kesäkuu",
          "heinäkuu",
          "elokuu",
          "syyskuu",
          "lokakuu",
          "marraskuu",
          "joulukuu",
        ][x - 1];
      } else {
        return ConsumptionRenderProperties(by, config, x).title;
      }
    } catch (err) {
      Log.error("selection failed", err);
      rethrow;
    }
  }

  DateTime date() {
    if (by == 1 || by == 2) {
      return FormatDate.comparableIntAsDaysToDate(x);
    }
    if (by == 3) {
      return selectedEnd;
    }
    throw Exception("Not implemented yet selected_bar.dart date()");
  }

  String unit() => switchStatus ? ' Wh' : ' L';
  String unitK() => switchStatus ? ' kWh' : ' m³';

  String get one {
    if (by == 3)
      return own != null
          ? 'Oma ' + (own! / 1000).toStringAsFixed(2) + unitK()
          : 'Oma 0' + unitK();

    return own != null
        ? 'Oma ' + own!.toInt().toString() + unit()
        : 'Oma 0' + unit();
  }

  String get two {
    if (by == 3)
      return avg != null
          ? 'Kelon ka. ' + (avg! / 1000).toStringAsFixed(2) + unitK()
          : 'Kelon ka. 0' + unitK();

    return avg != null
        ? 'Kelon ka. ' + avg!.toInt().toString() + unit()
        : 'Kelon ka. 0' + unit();
  }
}
