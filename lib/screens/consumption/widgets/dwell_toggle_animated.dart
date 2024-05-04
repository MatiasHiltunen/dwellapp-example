import 'package:flutter/material.dart';

class DwellToggle extends StatefulWidget {
  final Function status;
  final Color left;
  final Color rigth;
  final bool initialState;

  const DwellToggle(
      {Key? key,
      required this.status,
      required this.left,
      required this.rigth,
      required this.initialState})
      : super(key: key);

  @override
  _DwellToggleState createState() => _DwellToggleState(left, initialState);
}

class _DwellToggleState extends State<DwellToggle> {
  double dx = 0;
  bool _toggle = false;
  Color _color;
  final bool initialState;

  _DwellToggleState(this._color, this.initialState);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _toggle = initialState;
      widget.status(_toggle);
      _color = _toggle ? widget.rigth : widget.left;
      dx = _toggle ? 22 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Center(
        child: GestureDetector(
          onTap: () {
            setState(() {
              _toggle = !_toggle;
              widget.status(_toggle);
              _color = _toggle ? widget.rigth : widget.left;
              dx = _toggle ? 22 : 0;
            });
          },
          child: Container(
            width: 44,
            height: 22,
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black38,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: AnimatedContainer(
                  padding: EdgeInsets.fromLTRB(dx, 0, 0, 0),
                  child: Row(
                    children: [
                      ClipOval(
                        child: Container(
                          color: _color,
                          height: 18,
                          width: 18,
                        ),
                      ),
                    ],
                  ),
                  duration: Duration(milliseconds: 400),
                  curve: Curves.fastLinearToSlowEaseIn,
                ),
              ),
            ]),
          ),
        ),
      ),
    ]);
  }
}
