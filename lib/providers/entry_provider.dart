import 'dart:async';

import 'package:Kuluma/config.dart';
import 'package:Kuluma/models/apartment.dart';
import 'package:Kuluma/screens/consumption/tools/config.dart';
import 'package:Kuluma/screens/consumption/tools/selected_bar.dart';
import 'package:Kuluma/tools/common.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import '../tools/utils.dart';
import '../tools/consumption_functions.dart';
import '../tools/format_date.dart';
import '../tools/logging.dart';
import '../models/entry_avg.dart';
import '../models/entry_compute.dart';
import 'user_provider.dart';

class EntryProvider extends ChangeNotifier {
  late User _user;
  // late Box<dynamic> _db;

  List<BarChartGroupData>? _barChart;

  late int _chartMaxX;
  late int _chartMinX;
  late bool _toggle;

  late TimeFrame _timeFrame;
  late DateTime _dateTimeEnd;

  late bool loading;
  late double chartMaxValue;
  late double chartMaxY;
  late Sensors selectedSensor;
  late bool notifyRequired;
  bool error = false;
  SelectedBarData? selectedBarData;

  List<Apartment> apartments = [];
  Apartment? selectedApartmentAsAdmin;

  EntryProvider() {
    _chartMaxX = 23;
    _chartMinX = 0;
    _toggle = false;

    _timeFrame = TimeFrame.hourly;
    _dateTimeEnd = DateTime.now().subtract(Duration(days: 1));
    loading = true;
    chartMaxValue = 0;
    chartMaxY = 100;
    selectedSensor = ConsumptionConfig.initiallySelectedSensor;
    notifyRequired = false;
    Log.info("init entryprovider");
  }

  // User provider
  void update(user) {
    _user = user;
    // _db = user.db;
  }

  set selectApartment(Apartment a) {
    selectedApartmentAsAdmin = a;
    Log.info(a.id);
    _initAndFetch(_dateTimeEnd);
  }

  List<Apartment>? get userApartments {
    if (_user.role == Role.admin.asString() && apartments.isNotEmpty) {
      return apartments;
    }
    return null;
  }

  double get chartMaxX {
    // Log.info("maxx", _chartMaxX.toDouble(), _chartMaxX.toDouble() == null);
    // if (_chartMaxX == null) return 0;
    return _chartMaxX.toDouble();
  }

  double get chartMinX {
    // Log.info("minx", _chartMinX.toDouble(), _chartMinX.toDouble() == null);
    // if (_chartMinX == null) return 0;
    return _chartMinX.toDouble();
  }

  DateTime get selectedEnd => _dateTimeEnd;
  int get getBy {
    // Log.info(_timeFrame.index);
    return _timeFrame.index;
  }

  TimeFrame get getTimeFrame => _timeFrame;
  int get generatedLength {
    // Log.info(_chartMaxX - _chartMinX + 1);
    return _chartMaxX - _chartMinX + 1;
  }

  bool get switchStatus => _toggle;

  DateTime get end => FormatDate.comparableIntAsDaysToDate(chartMaxX.toInt());
  DateTime get start => FormatDate.comparableIntAsDaysToDate(chartMinX.toInt());

  set maxX(int val) => _chartMaxX = val;
  set minX(int val) => _chartMinX = val;
  set maxY(double val) =>
      chartMaxY = val.floorToDouble() + (val.floorToDouble() * 0.1);
  set avgOfAllCheck(bool val) {
    _initAndFetch(_dateTimeEnd);
  }

  set end(DateTime end) {
    _dateTimeEnd = end;
    _initAndFetch(_dateTimeEnd);
  }

  set by(int by) {
    error = false;
    if (_dateTimeEnd.isBefore(_user.leaseStart)) {
      _dateTimeEnd = _user.leaseStart;
    }
    _timeFrame = TimeFrame.values[by];
    _initAndFetch(_dateTimeEnd);
  }

  void setByAndEnd([DateTime? newEnd]) {
    if (selectedBarData == null)
      throw Exception("selectedBarData can't be null in setByAndEnd");

    _dateTimeEnd = newEnd != null ? newEnd : selectedBarData!.date();

    _timeFrame =
        _timeFrame == TimeFrame.yearly ? TimeFrame.monthly : TimeFrame.hourly;

    _initAndFetch(_dateTimeEnd);
  }
/* 
  bool isEndInFuture({DateTime? date}) {
    date ??= _dateTimeEnd;

    date = date.add(Consumption.duration(_timeFrame, date: date));
    return date.isAfter(FormatDate.initDateTimeToNextDay0000(DateTime.now()));
  } */

  void next({DateTime? date}) {
    error = false;
    date ??= _dateTimeEnd;
    date = date.add(Consumption.duration(_timeFrame, date: date));
    if (date.isAfter(FormatDate.initDateTimeToNextDay0000(DateTime.now()))) {
      date = DateTime.now();
    }
    _dateTimeEnd = date;
    _initAndFetch(date);
  }

  void previous({DateTime? date}) {
    error = false;
    date ??= _dateTimeEnd;
    if (_timeFrame == TimeFrame.monthly) {
      date = DateTime(date.year, date.month, 0);
    } else if (_timeFrame == TimeFrame.yearly) {
      date = DateTime(date.year, 1, 0);
    } else {
      date = date.subtract(Consumption.duration(_timeFrame, date: date));
    }
    _dateTimeEnd = date;
    _initAndFetch(date);
  }

  void _initAndFetch(date) {
    selectedBarData = null;
    chartMaxY = 0;
    _initBy(date);
    fetchByProviderDateEnd(date);
  }

  Future<List<Avg>> fetchDataAvgWithCache(date, {bool avgOfAll = false}) async {
    try {
      String _queryString =
          createQueryString(selectedSensor, date, avgOfAll: avgOfAll);
      if (_user.id == null)
        throw Exception("UserId can't be null in fetchDataAvgWithCache");
      // int hash = (_queryString + _user.id!).hashCode;
/*       EntryCache? cache = await _db.get(hash); */

/*       if (cache == null || date.isAfter(FormatDate.today0000())) { */
      /*  Log.success("Fetch data", _queryString, hash, FormatDate.today0000()); */

      Map? data;
      Map avgMap;
      if (AppConfig.useDummyData) {
        data = {"avg": ""};

        avgMap = Consumption.avgDataFormat(
          EntryCompute(
            timeFrame: _timeFrame,
            chartMaxX: _chartMaxX,
            chartMinX: _chartMinX,
            date: date,
            generatedLength: generatedLength,
            rawAvg: data['avg'],
            selectedSensor: selectedSensor.id,
          ),
        );
      } else {
        data = await _user.apiGet(endpoint: _queryString);

        if (data['avg'] == null || data['avg'].isEmpty) {
          Log.info('Data fetched from backend with following query is empty:',
              _queryString, 'response: ' + data.toString());
        }
        avgMap = Consumption.avgDataFormat(
          EntryCompute(
            timeFrame: _timeFrame,
            chartMaxX: _chartMaxX,
            chartMinX: _chartMinX,
            date: date,
            generatedLength: generatedLength,
            rawAvg: data['avg'],
            selectedSensor: selectedSensor.id,
          ),
        );
      }

      /* Log.warn("fetch", chartMaxY, avgMap['y']); */
      if (chartMaxY < avgMap['y']) maxY = avgMap['y'];
      List<Avg> avgList = avgMap['avg'];

      /* if (!date.isAfter(FormatDate.today0000()) ||
            !date.isAtSameMomentAs(FormatDate.today0000())) {
          // Log.info("Cache saved", date, FormatDate.today0000());
          await _db.put(
            hash,
            EntryCache(
              hash: hash,
              data: avgList,
              minX: _chartMinX,
              maxX: _chartMaxX,
              maxY: chartMaxY,
            ),
          );
        } */
      return avgList;
      /*     } */
      /*     _chartMaxX = cache.maxX;
      _chartMinX = cache.minX;

      if (chartMaxY < cache.maxY) chartMaxY = cache.maxY;

      return cache.data; */
    } catch (e) {
      error = true;
      notifyListeners();
      Log.error("fetchDataAvgWithCache", e);
      Map avgMap = Consumption.avgDataFormat(
        EntryCompute(
          timeFrame: _timeFrame,
          chartMaxX: _chartMaxX,
          chartMinX: _chartMinX,
          date: date,
          generatedLength: generatedLength,
          rawAvg: [],
          selectedSensor: selectedSensor.id,
        ),
      );
      if (chartMaxY < avgMap['y']) maxY = avgMap['y'];
      List<Avg> avgList = avgMap['avg'];
      return avgList;
    }
  }

  String createQueryString(
    Sensors sensor,
    DateTime date, {
    bool avgOfAll = false,
  }) {
    List<RangeDataForQueryString Function(DateTime)> createRange = [
      FormatDate.createRangeForDayFromDate,
      FormatDate.createRangeForCurrentWeek,
      FormatDate.createRangeForMonthFromDate,
      FormatDate.createRangeForYearFromDate,
    ];

    RangeDataForQueryString range = createRange[_timeFrame.index](date);

    if (_user.role != Role.admin.asString()) {
      if (range.start.isBefore(_user.leaseStart)) {
        range.start = _user.leaseStart;
      }

      if (range.end.isAfter(_user.leaseEnd)) {
        range.end = _user.leaseEnd;
      }
    }

    Map<String, String> r = {
      "start": FormatDate.ts(range.start),
      "end": FormatDate.ts(range.end),
      "by": range.by,
    };

    return Utils.queryParams(
      endpoint: avgOfAll ? 'entry/preaggregated' : 'entry/avg',
      params: avgOfAll
          ? {'sensors': sensor.id, ...r}
          : {
              'apartments': selectedApartmentAsAdmin != null &&
                      _user.role == Role.admin.asString()
                  ? selectedApartmentAsAdmin!.id
                  : _user.apartment,
              'sensors': sensor.id,
              "debug": "1",
              ...r
            },
    );
  }

  Future<void> fetchByProviderDateEnd(date) async {
    try {
      if (_user.role == Role.admin.asString() && apartments.isEmpty) {
        var res = await _user.apiGet(endpoint: 'apartment');

        apartments = (res['apartments'] as List)
            .map((e) => Apartment.fromJson(e))
            .toList();
      }

      if (notifyRequired) {
        loading = true;
        notifyListeners();
      } else {
        notifyRequired = true;
      }
/* 


  goal: get cold and warm water if selected
        -> other must be selected at all time
        OR
        -> implement selection to energy aswell, possibility to see only avg then
        
        get avg of all always! toggle and logic can be removed for this.

        avgOfAll will be replaced with sensor selection as avgOfAll is always fetched
        sensors can be toggled. 

        combine data to same chartbars
        
        water ------- energy 

sensors: 0-2           0-1

1. fix yearly data.
2. fix daily chart for avg
3. implement sensor based toggling to ui





 */
      /*  if (_avgOfAllSelected) { */
      final List<List<Avg>> resList = await Future.wait([
        fetchDataAvgWithCache(date),
        fetchDataAvgWithCache(date, avgOfAll: true),
      ]);

      _barChart = resList[0]
          .map<BarChartGroupData>((item) => _makeGroupData(
                item.x,
                item.change,
                avgOfAll: resList[1],
              ))
          .toList();

      /* } else {
        final List<Avg> avg = await fetchDataAvgWithCache(date);
        _barChart = avg
            .map<BarChartGroupData>((item) =>
                _makeGroupData(item.daysFromFixed.toInt(), item.change))
            .toList();
      } */

      loading = false;
      notifyListeners();
    } catch (e) {
      Log.warn("Error in fetchByProviderDateEnd", e);
      _user.notification(errorMessage: e.toString());
    }
  }

  BarChartGroupData _makeGroupData(
    int x,
    double y, {
    List<Avg>? avgOfAll,
    bool isTouched = false,
  }) {
    double? allAvg;

    try {
      if (avgOfAll != null && avgOfAll.isNotEmpty) {
        Avg avg = avgOfAll.firstWhere((element) {
          return element.x == x;
        }, orElse: () {
          return Avg.initToTimeFrame(_timeFrame, _dateTimeEnd, x);
        });

        /*  if (avg == null) throw new Exception('Avg data missing'); */
        allAvg = avg.change;
      }
    } catch (err) {
      Log.error("error in firstwhere", err);
      allAvg = 0;
    }

    if (allAvg != null && allAvg > chartMaxY) {
      maxY = allAvg;
    }

    return BarData(
      allAvg: allAvg ?? 0,
      by: _timeFrame.index,
      isTouched: isTouched,
      switchStatus: switchStatus,
      x: x,
      y: y,
    ).create();
  }

  List<BarChartGroupData> barChart() {
    if (_barChart != null) return _barChart!;
    _initAndFetch(_dateTimeEnd);
    return [_makeGroupData(0, 0)];
  }

  bool get chartDataReady {
    return _barChart != null;
  }

  void _initYearly() {
    minX = 0;
    maxX = 11;
  }

  void _initMonth(DateTime date) {
    minX =
        FormatDate.dateToComparableIntAsDays(DateTime(date.year, date.month));
    maxX = FormatDate.dateToComparableIntAsDays(
        DateTime(date.year, date.month + 1, 0));
  }

  void _initLast7days(DateTime date) {
    if (date.isAfter(FormatDate.initDateTimeToNextDay0000(DateTime.now()))) {
      _dateTimeEnd = DateTime.now();

      DateTime lastDayOfTheWeek = FormatDate.lastDayOfTheWeek(_dateTimeEnd);

      minX = FormatDate.dateToComparableIntAsDays(
          FormatDate.substractFromDateByNumberOfDays(lastDayOfTheWeek, 6));
      maxX = FormatDate.dateToComparableIntAsDays(lastDayOfTheWeek);
    } else {
      DateTime lastDayOfTheWeek = FormatDate.lastDayOfTheWeek(date);

      minX = FormatDate.dateToComparableIntAsDays(
          FormatDate.substractFromDateByNumberOfDays(lastDayOfTheWeek, 6));
      maxX = FormatDate.dateToComparableIntAsDays(lastDayOfTheWeek);
    }
  }

  void _initHourly() {
    /*  Log.success("Init hourly"); */
    if (_dateTimeEnd
        .isAfter(FormatDate.initDateTimeToNextDay0000(DateTime.now()))) {
      _dateTimeEnd = DateTime.now();
    }
    minX = 0;
    maxX = 23;
  }

  void _initBy(DateTime date) {
    try {
      if (_timeFrame == TimeFrame.hourly)
        _initHourly();
      else if (_timeFrame == TimeFrame.weekly)
        _initLast7days(date);
      else if (_timeFrame == TimeFrame.monthly)
        _initMonth(date);
      else if (_timeFrame == TimeFrame.yearly)
        _initYearly();
      else
        throw Exception("Not implemented yet");
    } catch (e) {
      /*   Log.warn("_initBy", e); */
    }
  }

  void toggleSelectedSensor(bool val) {
    chartMaxY = 0;
    selectedBarData = null;
    _toggle = val;
    selectedSensor = val ? Sensors.energy : Sensors.waterWarm;
    fetchByProviderDateEnd(_dateTimeEnd);
  }

/*   set selection(bool val) {
    chartMaxY = 0;
    _toggle = val;
    selectedSensor = val ? Sensors.energy : Sensors.waterWarm;
    fetchByProviderDateEnd(_dateTimeEnd);
  } */
  /* void toggleSelectedSensor(bool val) {
    _toggle = val;

    // val == true -> energy
    if(val){




    }

    selectedSensor = val ? Sensors.energy : Sensors.waterWarm;
    fetchByProviderDateEnd(_dateTimeEnd);
  } */
}

class BarSize {
  final BorderRadius radius;
  final double barsSpace;
  final double width;

  BarSize(this.radius, this.barsSpace, this.width);
}

mixin BarSizes {
  List<BarSize> sizesList = [
    BarSize(BorderRadius.circular(2), -11, 6),
    BarSize(BorderRadius.circular(3), -24, 16),
    BarSize(BorderRadius.circular(2), -8, 8),
    BarSize(BorderRadius.circular(2), -22, 10),
    BarSize(BorderRadius.circular(2), 2, 8)
  ];
}

class BarData with BarSizes {
  final int x;
  final double y;
  final int by;

  final double allAvg;
  final bool switchStatus;
  bool isTouched = false;

  BarData({
    required this.x,
    required this.y,
    required this.by,
    required this.allAvg,
    required this.isTouched,
    required this.switchStatus,
  });

  BarChartGroupData create() {
    return BarChartGroupData(
      x: x,
      barRods: barRods,
      barsSpace: sizesList[by].barsSpace,
    );
  }

  List<BarChartRodData> get barRods {
    return /* avgOfAllSelected
        ?  */
        [
      BarChartRodData(
        borderRadius: sizesList[by].radius,
        y: isTouched ? allAvg + 1 : allAvg,
        colors: switchStatus
            ? [Color(0xFFFFFFFF).withOpacity(0.3)]
            : [Color(0xFFFFFFFF).withOpacity(0.3)],
        width: sizesList[by].width,
      ),
      BarChartRodData(
        borderRadius: sizesList[by].radius,
        y: isTouched ? y + 1 : y,
        colors: switchStatus
            ? [Color(0xFFEDBF4C).withOpacity(0.90)]
            : [Color(0xFF1AA7AC).withOpacity(0.90)],
        width: sizesList[by].width,
      ),
    ];
    /*
         : [
            BarChartRodData(
              borderRadius: sizesList[by].radius,
              y: isTouched ? y + 1 : y,
              colors: switchStatus
                  ? [Color(0xFFEDBF4C).withOpacity(0.90)]
                  : [Color(0xFF1AA7AC).withOpacity(0.90)],
              width: sizesList[by].width,
            )
          ]; */
  }
}
