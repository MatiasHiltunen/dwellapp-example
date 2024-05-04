import 'package:Kuluma/config.dart';
import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/models/apartment.dart';
import 'package:Kuluma/models/dwell_menu_item.dart';
import 'package:Kuluma/providers/user_provider.dart';
import 'package:Kuluma/screens/consumption/tools/config.dart';
import 'package:Kuluma/screens/consumption/tools/consumption_render_properties.dart';
import 'package:Kuluma/screens/consumption/tools/selected_bar.dart';
import 'package:Kuluma/tools/common.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../tools/format_date.dart';

import '../../../providers/entry_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DailyConsumptionChart extends StatefulWidget {
  DailyConsumptionChart({
    Key? key,
  }) : super(key: key);

  @override
  _DailyConsumptionChartState createState() => _DailyConsumptionChartState();
}

class _DailyConsumptionChartState extends State<DailyConsumptionChart> {
  final Color color1 = DwellColors.primaryBlue;
  final Color color2 = DwellColors.primaryYellow;

  Iterable<int> count(int min, int max) sync* {
    while (min <= max) yield min++;
  }

  int? touchedIndex;

  List<BarChartGroupData>? barGroups;
  List<BarChartGroupData>? barGroupsOriginal;

  double calcInterval(double maxY) {
    double interval = maxY / 5;
    if (interval.toStringAsFixed(0).length < 3) {
      interval = interval < 10 ? 5 : interval - (interval % 10);
    } else
      interval = interval - (interval % 100);

    if (interval == 0) {
      interval = 20;
    }

    return interval;
  }

  void toggleColorSelected(int index, bool switchStatus) {
    if (barGroups == null) return;

    barGroups?.asMap().forEach((i, e) {
      if (i == index) {
        barGroups?[i] = barGroups![i].copyWith(barRods: [
          barGroups![i]
              .barRods[0]
              .copyWith(colors: [DwellColors.boardBackground.withOpacity(0.6)]),
          barGroups![i].barRods[1].copyWith(colors: [
            switchStatus
                ? DwellColors.primaryYellow.withOpacity(0.80)
                : DwellColors.primaryBlue.withOpacity(0.90)
          ]),
        ]);
      } else {
        barGroups![i] = barGroups![i].copyWith(barRods: [
          barGroups![i].barRods[0].copyWith(
            colors: [
              DwellColors.textWhite.withOpacity(0.2),
            ],
          ),
          barGroups![i].barRods[1].copyWith(
            colors: [
              switchStatus
                  ? DwellColors.primaryYellow.withOpacity(0.40)
                  : DwellColors.primaryBlue.withOpacity(0.40)
            ],
          )
        ]);
      }
    });
  }

  void touch(BarTouchResponse? barTouchResponse) {
    if (barTouchResponse == null) return;
    setState(() {
      if (barTouchResponse.spot != null) {
        touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;

        return;
      } else {
        touchedIndex = -1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ConsumptionConfig config = ConsumptionConfig(S.of(context));

    final List<DwellMenuItem> menuItems = List.generate(
      config.listItems.length,
      (index) =>
          DwellMenuItem(name: config.listItems[index], val: index, sortBy: ''),
    );

    EntryProvider entryProviderListenFalse =
        Provider.of<EntryProvider>(context, listen: false);

    void showSelectedBarData(SelectedBarData data) {
      // setState in touch function!
      entryProviderListenFalse.selectedBarData = data;
    }

    if (entryProviderListenFalse.chartDataReady == false) {
      entryProviderListenFalse.barChart();
    }

    void setBy(int val) {
      entryProviderListenFalse.by = val;
    }

    bool byEqual(int by) {
      /*     Log.error(entryProviderListenFalse.getTimeFrame.index == null); */
      return entryProviderListenFalse.getTimeFrame.index == by;
    }

    void changeBy(double velocity) {
      if (velocity > 0) {
        if (byEqual(0)) return setBy(3);
        if (byEqual(1)) return setBy(0);
        if (byEqual(2)) return setBy(1);
        if (byEqual(3)) return setBy(2);
      }
      if (byEqual(0)) return setBy(1);
      if (byEqual(1)) return setBy(2);
      if (byEqual(2)) return setBy(3);
      if (byEqual(3)) return setBy(0);
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /* Provider.of<EntryProvider>(context).loading
              ? LinearProgressIndicator(
                  backgroundColor:
                      entryProviderListenFalse.switchStatus ? color2 : color1,
                  minHeight: 2,
                  
                )
              : SizedBox.shrink(), */
          if (context.select(
                  (User value) => value.role == Role.admin.asString()) &&
              entryProviderListenFalse.userApartments != null)
            Row(
              children: [
                PopupMenuButton(
                  child: Row(
                    children: [
                      Text(
                        "Asunto",
                        style: TextStyle(
                            color: DwellColors.textWhite, fontSize: 18),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: DwellColors.textWhite,
                      ),
                    ],
                  ),
                  itemBuilder: (context) =>
                      entryProviderListenFalse.userApartments!.map((e) {
                    return PopupMenuItem<Apartment>(
                      child: Text(e.name),
                      value: e,
                    );
                  }).toList(),
                  onSelected: (Apartment val) =>
                      entryProviderListenFalse.selectApartment = val,
                ),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DateControls(color1, color2),
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: PopupMenuButton(
                  child: Row(
                    children: [
                      Text(
                        menuItems[entryProviderListenFalse.getBy].name,
                        style: TextStyle(
                            color: DwellColors.textWhite, fontSize: 18),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: DwellColors.textWhite,
                      ),
                    ],
                  ),
                  itemBuilder: (context) => menuItems.map((e) {
                    return PopupMenuItem(
                      child: Text(e.name),
                      value: e.val,
                    );
                  }).toList(),
                  onSelected: (int val) => entryProviderListenFalse.by = val,
                ),
              )
            ],
          ),
          if (!context.select((EntryProvider value) => value.loading))
            LayoutBuilder(
              builder: (context, constraints) {
                barGroups = entryProviderListenFalse.barChart();

                return GestureDetector(
                  onHorizontalDragEnd: (details) {
                    if (details.primaryVelocity!.abs() > 500) {
                      if (details.primaryVelocity! > 0) {
                        if (context
                            .select((EntryProvider value) => value.error))
                          return;
                        else
                          entryProviderListenFalse.previous();
                      } else {
                        entryProviderListenFalse.next();
                      }
                    }
                  },
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity!.abs() > 500)
                      changeBy(details.primaryVelocity!);
                  },
                  child: Center(
                    child: Container(
                        constraints:
                            BoxConstraints(minWidth: 500, maxWidth: 600),
                        height: 300,
                        decoration:
                            const BoxDecoration(color: DwellColors.background),
                        padding: EdgeInsets.only(right: 30, left: 20, top: 30),
                        child: !context.select((EntryProvider e) => e.error)
                            ? BarChart(
                                BarChartData(
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: bottomTitles(
                                      entryProviderListenFalse.getBy,
                                      entryProviderListenFalse.switchStatus,
                                      config,
                                    ),
                                    leftTitles: leftTitles(
                                        entryProviderListenFalse.getBy,
                                        entryProviderListenFalse.switchStatus,
                                        entryProviderListenFalse.chartMaxY),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: barGroups,
                                  barTouchData: buildBarTouchData(
                                      touch,
                                      entryProviderListenFalse.getBy,
                                      entryProviderListenFalse.switchStatus,
                                      config,
                                      showSelectedBarData,
                                      toggleColorSelected,
                                      context.select((EntryProvider value) =>
                                          value.selectedEnd)
                                      /* entryProviderListenFalse.selectedEnd, */
                                      ),
                                  maxY: entryProviderListenFalse.chartMaxY < 3
                                      ? 4
                                      : entryProviderListenFalse.chartMaxY,
                                  gridData: FlGridData(
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: DwellColors.textBlack,
                                        strokeWidth: 0.5,
                                      );
                                    },
                                    drawHorizontalLine: true,
                                    horizontalInterval: calcInterval(
                                        entryProviderListenFalse.chartMaxY),
                                  ),
                                ),
                                swapAnimationDuration:
                                    Duration(microseconds: 0),
                              )
                            : Container(
                                height: 300,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 200,
                                        child: Image.asset(
                                          "assets/images/error.png",
                                          fit: BoxFit.contain,
                                          scale: 0.5,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Kulutustietoja ei ole saatavilla valitulle ajalle",
                                          style: TextStyle(
                                              color: DwellColors.textWhite,
                                              fontFamily: 'Sofia Pro'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ))),
                  ),
                );
              },
            )
          else
            Container(
              height: 300,
              child: SpinKitChasingDots(
                color: DwellColors.disabled,
              ),
            ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  entryProviderListenFalse.switchStatus
                      ? config.unitsEnergy[entryProviderListenFalse.getBy]
                      : config.unitsWater[entryProviderListenFalse.getBy],
                  style: TextStyle(color: Colors.white60),
                ),
              ),
            ],
          ),
          ConsumptionSelectedBarDataVisualization(
            selectedBarData: entryProviderListenFalse.selectedBarData,
            setByAndEnd: entryProviderListenFalse.setByAndEnd,
            switchStatus: entryProviderListenFalse.switchStatus,
          )
        ],
      ),
    );
  }

  BarTouchData buildBarTouchData(
      Function touch,
      int by,
      bool? switchStatus,
      ConsumptionConfig config,
      Function(SelectedBarData) test,
      Function(int, bool) toggleSelected,
      DateTime selectedEnd) {
    return BarTouchData(
      touchTooltipData: BarTouchTooltipData(
          // fitInsideHorizontally: true,
          tooltipBgColor: Colors.transparent,
          // tooltipRoundedRadius: 20,
          // tooltipPadding: EdgeInsets.fromLTRB(12, 7, 12, 0),
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            /*      Log.error(group.x == null); */
            if (switchStatus != null) {
              SelectedBarData sel = SelectedBarData(
                avg: group.barRods[0].y,
                own: group.barRods[1].y,
                switchStatus: switchStatus,
                config: config,
                by: by,
                x: group.x,
                selectedEnd: selectedEnd,
              );

              toggleSelected(groupIndex, switchStatus);
              test(sel);
            }
            return BarTooltipItem('', TextStyle(fontSize: 16));
            /*    
            if (by == 0) {
              String str =
                  ConsumptionVisualizationTools.timeRangeToStringForHourlyData(
                      group.x);

              if (rodIndex == 1) {
                return BarTooltipItem(
                  "OMA\n" + str + ' ' + rod.y.toString(),
                  TextStyle(
                      color: switchStatus
                          ? DwellColors.textBlack
                          : DwellColors.textWhite,
                      fontWeight: FontWeight.normal),
                );
              } else {
                /* group.barRods[0] = BarChartRodData(
                  y: group.barRods[0].y,
                  colors: [
                    DwellColors.primaryBlue,
                    Colors.limeAccent,
                  ],
                ); */

                return BarTooltipItem(
                  str,
                  /* +
                      '\n' +
                      rod.y.toString() +
                      ' ' +
                      (switchStatus ? 'Wh' : 'litraa'), */
                  TextStyle(
                      color: switchStatus
                          ? DwellColors.backgroundLight
                          : DwellColors.textWhite,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                );
              }
            }

            if (by == 1) {
              String str = config.weekdays[
                  FormatDate.comparableIntAsDaysToDate(group.x).weekday - 1];
              /* if (str.length > 1) {
                str = "$str:00";
              } else {
                str = "0$str:00";
              } */

              if (rodIndex == 1) {
                return BarTooltipItem(
                  "OMA\n" + str + ' ' + rod.y.toString(),
                  TextStyle(
                      color: switchStatus
                          ? DwellColors.textBlack
                          : DwellColors.textWhite,
                      fontWeight: FontWeight.bold),
                );
              } else {
                return BarTooltipItem(
                  "KELO\n" + str + ' ' + rod.y.toString(),
                  TextStyle(
                      color: switchStatus
                          ? DwellColors.textBlack
                          : DwellColors.textWhite,
                      fontWeight: FontWeight.bold),
                );
              }
            }

            return BarTooltipItem(
              rod.y.toString() +
                  ' - ' +
                  DateFormat('d.MM.')
                      .format(FormatDate.comparableIntAsDaysToDate(group.x))
                      .toString(),
              TextStyle(color: Colors.white),
            ); */
          }),
      touchCallback: (barTouchResponse) => touch(barTouchResponse),
    );
  }

  SideTitles bottomTitles(
    int by,
    bool switchStatus,
    ConsumptionConfig config,
  ) {
    return SideTitles(
      rotateAngle: by == 2 || by == 3 ? -90.0 : 0,
      showTitles: true,
      reservedSize: 25,
      getTextStyles: (BuildContext context, double val) => TextStyle(
        color: switchStatus ? color2 : color1,
        fontWeight: FontWeight.normal,
        fontSize: by == 3 ? 14 : 12,
      ),
      getTitles: (double val) {
        /* Log.success("val in bottom tiles", val); */
        if (by == 2) val = val + 1;
        return ConsumptionRenderProperties(by, config, val.toInt()).title;
      },
      margin: by == 3 ? 30 : 22,
    );
  }

  SideTitles leftTitles(int by, bool switchStatus, double maxY) {
    double interval = calcInterval(maxY);

    return SideTitles(
      margin: 20,
      showTitles: true,
      interval: interval < 5 ? 1 : interval,
      getTextStyles: (BuildContext context, double val) => TextStyle(
        color: Colors.white60,
        fontSize: 14,
      ),
      getTitles: (double value) {
        /*  Log.warn(value, value == null); */
        if (switchStatus && by == 3) return (value ~/ 1000).toString();

        return value.toInt().toString();
      },
      /* reservedSize: 60, */
    );
  }
}

class ConsumptionSelectedBarDataVisualization extends StatelessWidget {
  const ConsumptionSelectedBarDataVisualization({
    required this.selectedBarData,
    required this.setByAndEnd,
    required this.switchStatus,
    Key? key,
  }) : super(key: key);

  final SelectedBarData? selectedBarData;
  final Function([DateTime?]) setByAndEnd;
  final bool switchStatus;

  @override
  Widget build(BuildContext context) {
    return selectedBarData != null
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                selectedBarData?.by == 0
                    ? _SelectedBarDataIndicator(
                        data: selectedBarData!.selectedTime,
                      )
                    : GestureDetector(
                        onTap: () {
                          if (selectedBarData!.by == 3) {
                            setByAndEnd(DateTime(
                                selectedBarData!.selectedEnd.year,
                                selectedBarData!.x,
                                1));
                          } else {
                            setByAndEnd();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: DwellColors.backgroundDark,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                          child: _SelectedBarDataIndicator(
                            data: selectedBarData!.selectedTime,
                          ),
                        ),
                      ),
                Row(
                  children: [
                    _CircleIndicator(
                      color: switchStatus
                          ? DwellColors.primaryYellow
                          : DwellColors.primaryBlue,
                    ),
                    _SelectedBarDataIndicator(
                      data: selectedBarData!.one,
                    ),
                  ],
                ),
                Row(
                  children: [
                    _CircleIndicator(
                      color: DwellColors.textWhite.withOpacity(0.2),
                    ),
                    _SelectedBarDataIndicator(
                      data: selectedBarData!.two,
                    ),
                  ],
                )
              ],
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                _SelectedBarDataIndicator(
                  data: "(ei valintaa)",
                ),
                Row(
                  children: [
                    _CircleIndicator(
                      color: switchStatus
                          ? DwellColors.primaryYellow
                          : DwellColors.primaryBlue,
                    ),
                    _SelectedBarDataIndicator(
                      data: "Oma",
                    ),
                  ],
                ),
                Row(
                  children: [
                    _CircleIndicator(
                      color: DwellColors.textWhite.withOpacity(0.2),
                    ),
                    _SelectedBarDataIndicator(
                      data: "Kelon keskiarvo",
                    ),
                  ],
                ),
                Container(color: DwellColors.background)
              ],
            ),
          );
  }
}

class _SelectedBarDataIndicator extends StatelessWidget {
  const _SelectedBarDataIndicator({
    Key? key,
    required this.data,
  }) : super(key: key);

  final String data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        data,
        style: TextStyle(color: DwellColors.textWhite),
      ),
    );
  }
}

class _CircleIndicator extends StatelessWidget {
  final Color color;

  const _CircleIndicator({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 17.0,
      height: 17.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class DateControls extends StatelessWidget {
  final Color color1;
  final Color color2;

  DateControls(this.color1, this.color2);
  @override
  Widget build(BuildContext context) {
    EntryProvider entryProviderListenFalse =
        Provider.of<EntryProvider>(context, listen: false);
    DateTime timeEnd = entryProviderListenFalse.selectedEnd;
    String selectedMonth =
        ConsumptionConfig(S.of(context)).monthsFull[timeEnd.month - 1];

    Future<Null> _selectDate(BuildContext context) async {
      final DateTime? picked = (await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime.now(),
      ))!;
      if (picked != null && picked != timeEnd)
        Provider.of<EntryProvider>(context, listen: false).end = picked;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 40,
          width: 198,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: DwellColors.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: entryProviderListenFalse.loading
              ? SpinKitRing(
                  color:
                      entryProviderListenFalse.switchStatus ? color2 : color1,
                  size: 30,
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      child: !context.select((EntryProvider e) => e.error)
                          ? IconButton(
                              icon: Icon(Icons.arrow_left),
                              color: entryProviderListenFalse.switchStatus
                                  ? color2
                                  : color1,
                              onPressed: entryProviderListenFalse.previous,
                            )
                          : IconButton(
                              icon: Icon(Icons.arrow_left),
                              color: DwellColors.backgroundDark,
                              onPressed: () {},
                            ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      child: GestureDetector(
                        onTap: () => _selectDate(context),
                        child: timeControlButtonText(timeEnd, selectedMonth,
                            entryProviderListenFalse, color1, color2),
                      ),
                    ),
                    Container(
                      width: 40,
                      child: IconButton(
                        icon: Icon(Icons.arrow_right),
                        color: entryProviderListenFalse.switchStatus
                            ? color2
                            : color1,
                        onPressed: entryProviderListenFalse.next,
                      ),
                    ),
                  ],
                ),
        )
      ],
    );
  }

  Widget timeControlButtonText(DateTime timeEnd, String selectedMonth,
      EntryProvider entryProvider, Color color1, Color color2) {
    String text;
    String timeText;
    final String locale = Intl().locale;

    switch (entryProvider.getTimeFrame) {
      case TimeFrame.hourly:
        {
          text =
              DateFormat("dd.MM.yy", locale).format(entryProvider.selectedEnd);
          timeText = DateFormat("EEEE", locale).format(timeEnd);
        }
        break;
      case TimeFrame.weekly:
        {
          text = DateFormat("dd.MM.yy", locale).format(entryProvider.start) +
              ' - ' +
              DateFormat("dd.MM.yy", locale).format(entryProvider.end);
          timeText = (locale == 'fi' ? "Viikko " : "Week ") +
              FormatDate.weekOfYear(timeEnd).toString();
        }
        break;
      case TimeFrame.monthly:
        {
          text = DateFormat("dd.MM.yy", locale).format(
                  entryProvider.start.day != 1
                      ? entryProvider.start.add(Duration(days: 1))
                      : entryProvider.start) +
              ' - ' +
              DateFormat("dd.MM.yy", locale).format(entryProvider.start.day != 1
                  ? entryProvider.end.add(Duration(days: 1))
                  : entryProvider.end);
          timeText = DateFormat("MMMM", locale).format(timeEnd);
        }
        break;
      case TimeFrame.yearly:
        {
          timeText = DateFormat("yyyy", locale).format(timeEnd);
          return Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              timeText,
              style: TextStyle(
                  color: entryProvider.switchStatus ? color2 : color1,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          );
        }

      default:
        {
          text = 'no data';
          timeText = '';
        }
    }

    return Column(
      children: [
        Text(
          timeText,
          style: TextStyle(
              color: entryProvider.switchStatus ? color2 : color1,
              fontSize: 14,
              fontWeight: FontWeight.bold),
        ),
        Text(
          text,
          style: TextStyle(
            color: entryProvider.switchStatus ? color2 : color1,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
