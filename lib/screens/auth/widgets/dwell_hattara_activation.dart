import 'package:flutter/material.dart';

class DwellHattaraActivation extends StatelessWidget {
  const DwellHattaraActivation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: 3,
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: const Offset(-120, 80),
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/Hattara2.png'),
                    fit: BoxFit.fill,
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.5), BlendMode.dstIn),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
