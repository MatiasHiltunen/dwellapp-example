import 'package:Kuluma/tools/common.dart';

class EntryCompute {
  final TimeFrame timeFrame;
  final int chartMaxX;
  final int chartMinX;
  final int generatedLength;
  final String selectedSensor;
  final DateTime date;
  final dynamic rawAvg;

  EntryCompute({
    required this.timeFrame,
    required this.chartMaxX,
    required this.chartMinX,
    required this.date,
    required this.generatedLength,
    required this.rawAvg,
    required this.selectedSensor,
  });
}
