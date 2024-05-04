import '../../models/dwell_menu_item.dart';
import 'package:flutter/material.dart';

class DwellDropDownMenu extends StatefulWidget {
  final List<DwellMenuItem> dropdownItems;
  final Color titleColor;
  final String titleText;
  final Function(DwellMenuItem) onChanged;

  DwellDropDownMenu({
    required this.dropdownItems,
    required this.titleColor,
    required this.titleText,
    required this.onChanged,
  });

  @override
  _DwellDropDownMenuState createState() =>
      _DwellDropDownMenuState(dropdownItems);
}

class _DwellDropDownMenuState extends State<DwellDropDownMenu> {
  late final List<DwellMenuItem> dropdownItems;
  _DwellDropDownMenuState(this.dropdownItems);

  late List<DropdownMenuItem<DwellMenuItem>> _dropdownMenuItems;
  late DwellMenuItem _selectedItem;

  void initState() {
    super.initState();
    _dropdownMenuItems = buildDropDownMenuItems(dropdownItems);
    _selectedItem = _dropdownMenuItems[0].value!;
  }

  List<DropdownMenuItem<DwellMenuItem>> buildDropDownMenuItems(
      List<DwellMenuItem> listItems) {
    List<DropdownMenuItem<DwellMenuItem>> items = listItems.map((e) {
      return DropdownMenuItem(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Transform.scale(
                    scale: 1.18,
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: constraints.maxWidth,
                      height: 48,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(e.name),
                      ),
                      color: e.selected ? Colors.grey : Colors.white,
                    ),
                  ),
                )
              ],
            );
          },
        ),
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
            selectedItemBuilder: (context) {
              return _dropdownMenuItems
                  .map<Widget>((DropdownMenuItem<DwellMenuItem> item) {
                return Container(
                  width: 130,
                  padding: EdgeInsets.all(0.0),
                  child: Center(
                    child: Text(
                      widget.titleText,
                      style: TextStyle(
                          color: widget.titleColor,
                          fontSize: 26,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Sofia Pro'),
                    ),
                  ),
                );
              }).toList();
            },
            dropdownColor: Colors.transparent,
            iconSize: 34,
            icon: Icon(Icons.arrow_drop_down),
            iconEnabledColor: Colors.white,
            value: _selectedItem,
            items: _dropdownMenuItems,
            elevation: 0,
            onChanged: (DwellMenuItem? value) {
              if (value != null) widget.onChanged(value);
              setState(() {
                _dropdownMenuItems =
                    buildDropDownMenuItems(dropdownItems.map((element) {
                  element.selected = element.sortBy == value?.sortBy;
                  return element;
                }).toList());

                _selectedItem = value!;
              });
            }),
      ),
    );
  }
}
