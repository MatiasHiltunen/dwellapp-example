import 'dart:io';

import 'package:flutter/foundation.dart';

import '../config.dart';

class Log {
  static String _trace() => CustomTrace(StackTrace.current).trace;

  /// Takes one argument and five additional positional arguments and casts toString() method on them,
  /// then prints them to console with success (green) color.
  static void success(dynamic data, [data1, data2, data3, data4, data5]) {
    if (!AppConfig.loggingEnabled) return;
    _template('\u001b[32m', data, data1, data2, data3, data4, data5);
  }

  /// Takes one argument and five additional positional arguments and casts toString() method on them,
  /// then prints them to console with info (blue) color.
  static void info(dynamic data, [data1, data2, data3, data4, data5]) {
    if (!AppConfig.loggingEnabled) return;
    _template('\u001b[34m', data, data1, data2, data3, data4, data5);
  }

  /// Takes one argument and five additional positional arguments and casts toString() method on them,
  /// then prints them to console with error (red) color.
  static void error(dynamic data, [data1, data2, data3, data4, data5]) {
    if (!AppConfig.loggingEnabled) return;
    _template('\u001b[31m', data, data1, data2, data3, data4, data5, true);
  }

  /// Takes one argument and five additional positional arguments and casts toString() method on them,
  /// then prints them to console with warning (yellow) color.
  static void warn(
    dynamic data, [
    dynamic data1,
    dynamic data2,
    dynamic data3,
    dynamic data4,
    dynamic data5,
  ]) {
    if (!AppConfig.loggingEnabled) return;
    _template('\u001b[33m', data, data1, data2, data3, data4, data5, true);
  }

  static void _template(String color, dynamic data,
      [data1, data2, data3, data4, data5, bool trace = false]) {
    List<String> args = [];
    String consoleWhite = '\x1B[0m';

    if (kIsWeb) {
      print('$data\n$data1\n$data2\n$data3\n$data4\n$data5');
      return;
    }

    Platform.isAndroid
        ? print(color + data.toString() + consoleWhite)
        : print(data.toString());

    if (data1 != null) args.add(data1.toString());
    if (data2 != null) args.add(data2.toString());
    if (data3 != null) args.add(data3.toString());
    if (data4 != null) args.add(data4.toString());
    if (data5 != null) args.add(data5.toString());
    if (args.isEmpty) return;
    args.forEach((d) =>
        Platform.isAndroid ? print(color + '\t' + d + consoleWhite) : print(d));
    if (trace)
      Platform.isAndroid
          ? print(color + '\t' + _trace() + consoleWhite)
          : print('\t' + _trace());
  }
}

class CustomTrace {
  late final StackTrace _trace;

  late String fileName;
  late int lineNumber;
  late int columnNumber;

  CustomTrace(this._trace) {
    _parseTrace();
  }

  void _parseTrace() {
    /* The trace comes with multiple lines of strings, we just want the first line, which has the information we need */
    String traceString = this._trace.toString().split("\n")[3];

    /* Search through the string and find the index of the file name by looking for the '.dart' regex */
    int indexOfFileName = traceString.indexOf(RegExp(r'[A-Za-z_]+.dart'));

    String fileInfo = traceString.substring(indexOfFileName);

    List<String> listOfInfos = fileInfo.split(":");

    this.fileName = listOfInfos[0];
    this.lineNumber = int.parse(listOfInfos[1]);
    var columnStr = listOfInfos[2];
    columnStr = columnStr.replaceFirst(")", "");
    this.columnNumber = int.parse(columnStr);
  }

  get trace {
    return 'Line: ' +
        lineNumber.toString() +
        ':' +
        columnNumber.toString() +
        ', file: ' +
        fileName.toString();
  }
}
