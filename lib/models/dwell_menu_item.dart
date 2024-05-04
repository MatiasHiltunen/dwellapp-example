import '../tools/common.dart';

class DwellMenuItem {
  final String name;
  final int? val;
  final String sortBy;
  final DwellMenuAction? action;
  bool selected;

  DwellMenuItem({
    required this.name,
    this.val,
    required this.sortBy,
    this.selected = false,
    this.action,
  });
}
