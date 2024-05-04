import '../../models/dwell_menu_item.dart';
import 'package:flutter/material.dart';

class DwellMenu extends StatefulWidget {
  final List<DwellMenuItem> items;
  final String buttonText;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final ValueChanged<DwellMenuItem> onChange;

  const DwellMenu({
    Key? key,
    required this.items,
    required this.buttonText,
    required this.borderRadius,
    this.backgroundColor = const Color(0xFFF67C0B9),
    this.textColor = Colors.black,
    required this.onChange,
  }) : super(key: key);
  @override
  _SimpleAccountMenuState createState() => _SimpleAccountMenuState();
}

class _SimpleAccountMenuState extends State<DwellMenu>
    with SingleTickerProviderStateMixin {
  late GlobalKey _key;
  bool isMenuOpen = false;
  // Offset buttonPosition;
  // Size buttonSize;
  late OverlayEntry _overlayEntry;
  /*  BorderRadius _borderRadius; */
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
    /*  _borderRadius = widget.borderRadius ?? BorderRadius.circular(4); */
    _key = LabeledGlobalKey("button_icon");
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /* findButton() {
    RenderBox renderBox = _key.currentContext.findRenderObject();
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  } */

  void closeMenu() {
    _overlayEntry.remove();
    _animationController.reverse();
    setState(() => isMenuOpen = !isMenuOpen);
  }

  void openMenu() {
    // findButton();
    _animationController.forward();
    _overlayEntry = _overlayEntryBuilder();
    Overlay.of(context)?.insert(_overlayEntry);
    setState(() => isMenuOpen = !isMenuOpen);
  }

  @override
  Widget build(BuildContext context) {
    double btnOffsetX = -10;

    return Container(
      key: _key,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        /*  borderRadius: _borderRadius, */
      ),
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(btnOffsetX, 4),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                widget.buttonText,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: Colors.white),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(btnOffsetX - 16, 10),
            child: TextButton(
              onPressed: () {
                if (isMenuOpen) {
                  closeMenu();
                } else {
                  openMenu();
                }
              },
              child: Row(
                children: [
                  Text(
                    widget.items.firstWhere((element) => element.selected).name,
                    style: TextStyle(color: Colors.white),
                  ),
                  Icon(
                    isMenuOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  OverlayEntry _overlayEntryBuilder() {
    final s = MediaQuery.of(context).size;
    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          onTap: () => closeMenu(),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            height: s.height,
            width: s.width,
            child: Positioned(
              top: 100,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: widget.backgroundColor),
                ),
                constraints: BoxConstraints(maxWidth: 100),
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        widget.onChange(widget.items[index]);
                        closeMenu();
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(30, 10, 8, 8),
                        decoration: BoxDecoration(
                          color: widget.items[index].selected
                              ? widget.backgroundColor
                              : Colors.white,
                        ),
                        width: 100,
                        height: 40,
                        child: Text(
                          widget.items[index].name,
                          style: TextStyle(
                              color: widget.items[index].selected
                                  ? widget.textColor
                                  : Colors.black,
                              fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    );
                  },
                  itemCount: widget.items.length,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
