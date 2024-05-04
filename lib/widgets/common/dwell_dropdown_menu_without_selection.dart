import 'dart:ui';
import '../../models/dwell_menu_item.dart';
import 'package:flutter/material.dart';

class DwellDropDownMenuWithoutSelection extends StatefulWidget {
  final List<DwellMenuItem> dropdownItems;
  final Color titleColor;
  final String titleText;
  final Function(DwellMenuItem) onChanged;

  DwellDropDownMenuWithoutSelection({
    required this.dropdownItems,
    required this.titleColor,
    required this.titleText,
    required this.onChanged,
  });

  @override
  _DwellDropDownMenuWithoutSelectionState createState() =>
      _DwellDropDownMenuWithoutSelectionState(dropdownItems);
}

class _DwellDropDownMenuWithoutSelectionState
    extends State<DwellDropDownMenuWithoutSelection> {
  late List<DwellMenuItem> dropdownItems;
  _DwellDropDownMenuWithoutSelectionState(this.dropdownItems);

  late List<DropdownMenuItem<DwellMenuItem>> _dropdownMenuItems;
  late DwellMenuItem _selectedItem;

  void initState() {
    super.initState();

    _dropdownMenuItems = buildDropDownMenuItemsWithoutSelection(dropdownItems);
  }

  List<DropdownMenuItem<DwellMenuItem>> buildDropDownMenuItemsWithoutSelection(
      List<DwellMenuItem> listItems) {
    List<DropdownMenuItem<DwellMenuItem>> items = listItems.map((e) {
      return DropdownMenuItem(
        child: Text(e.name),
        value: e,
      );
    }).toList();

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
            dropdownColor: Colors.white,
            iconSize: 34,
            value: _selectedItem,
            items: _dropdownMenuItems,
            elevation: 0,
            onChanged: (DwellMenuItem? value) {
              if (value != null) widget.onChanged(value);
            }),
      ),
    );
  }
}
