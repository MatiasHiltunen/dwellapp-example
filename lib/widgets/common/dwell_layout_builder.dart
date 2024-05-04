import 'package:flutter/material.dart';
import '../../config.dart';

class DwellLayoutBuilder extends StatelessWidget {
  const DwellLayoutBuilder({
    Key? key,
    required this.child,
    this.optionalHeight,
  }) : super(key: key);

  final Widget child;
  final double? optionalHeight;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: OrientationBuilder(
          builder: (context, orientation) {
            return Container(
              color: DwellColors.background,
              height: Orientation.portrait == orientation
                  ? optionalHeight != null
                      ? optionalHeight
                      : constraints.maxHeight < 500
                          ? 500
                          : constraints.maxHeight
                  : 1200,
              child: child,
            );
          },
        ),
      ),
    );
  }
}
