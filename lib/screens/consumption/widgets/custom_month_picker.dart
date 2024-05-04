/* import 'package:dwellapp/providers/entry_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

class CustomMonthPicker extends StatelessWidget {
  const CustomMonthPicker({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<EntryProvider>(
      builder: (ctx, entryProvider, _) => Builder(
        builder: (context) => RaisedButton(
          onPressed: () {
            showMonthPicker(
              context: context,
              firstDate: DateTime(2020, 2),
              lastDate: DateTime(
                DateTime.now().year,
                DateTime.now().month + 1,
                0,
              ),
              initialDate: entryProvider.selectedMonth ?? DateTime.now(),
              locale: Locale("fi"),
            ).then((date) {
              if (date != null) {
                entryProvider.selectedMonth = date;
                entryProvider.rangeFromMonth();
              }
            });
          },
          child: Icon(Icons.calendar_today),
        ),
      ),
    );
  }
} */
