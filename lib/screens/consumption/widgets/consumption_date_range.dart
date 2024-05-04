/* import 'package:dwellapp/providers/entry_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConsumptionDateRange extends StatelessWidget {
  const ConsumptionDateRange({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EntryProvider>(
      builder: (ctx, entryProvider, _) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            child: Text(
              entryProvider.dateTimeStart != null
                  ? entryProvider.startDate
                  : 'Start date',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              entryProvider.getDate(start: true, ctx: context);
            },
          ),
          FlatButton(
            child: Text(
              entryProvider.dateTimeEnd != null
                  ? entryProvider.endDate
                  : 'End date',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              entryProvider.getDate(start: false, ctx: context);
            },
          ),
        ],
      ),
    );
  }
} */
