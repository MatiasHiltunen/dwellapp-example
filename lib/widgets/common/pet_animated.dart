import 'package:flutter/material.dart';

class PetAnimated extends StatefulWidget {
  final Widget child;

  const PetAnimated({Key? key, required this.child}) : super(key: key);

  @override
  _PetAnimatedState createState() => _PetAnimatedState();
}

class _PetAnimatedState extends State<PetAnimated> {
  // double _angle = 0;
  double _dx = 0;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
        onTap: () {
          setState(() {
            _dx = _dx == 200 ? 0 : 200;
          });
        },
        child: Container(
          width: 300,
          height: 400,
          child: AnimatedContainer(
            child: widget.child,
            margin: EdgeInsets.only(left: _dx),
            duration: Duration(seconds: 4),
            curve: Curves.easeInCirc,
            onEnd: () {
              setState(() {
                _dx = _dx == 200 ? 0 : 200;
              });
            },
          ),
        ),
      ),
    ]);
  }
}
