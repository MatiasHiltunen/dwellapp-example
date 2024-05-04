import 'package:flutter/material.dart';

class HattaratLogin extends StatelessWidget {
  const HattaratLogin({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.scale(
        scale: 0.55,
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: const Offset(465, -160),
              child: Container(
                width: 250, //382.0,
                height: 360, //519.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/Hattara2.png'),
                    fit: BoxFit.fill,
                    colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.dstIn,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(-310, 600),
              child: Container(
                width: 382.0,
                height: 519.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/Hattara2.png'),
                    fit: BoxFit.fill,
                    colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.dstIn,
                    ),
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
