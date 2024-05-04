import 'dart:math';

import 'package:flutter/material.dart';

class WhiteClouds extends StatelessWidget {
  const WhiteClouds({
    Key? key,
  }) : super(key: key);

  static Random rand = Random();

  Future<Widget> createCloud(d) async {
    await new Future.delayed(
      Duration(seconds: rand.nextInt(10)),
    );

    return WhiteCloudAnimation(d: d.width);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        FutureBuilder(
          builder: (ctx, snap) =>
              snap.connectionState == ConnectionState.waiting
                  ? SizedBox.shrink()
                  : snap.data as Widget,
          future: createCloud(deviceSize),
        ),
        FutureBuilder(
          builder: (ctx, snap) =>
              snap.connectionState == ConnectionState.waiting
                  ? SizedBox.shrink()
                  : snap.data as Widget,
          future: createCloud(deviceSize),
        ),
        FutureBuilder(
          builder: (ctx, snap) =>
              snap.connectionState == ConnectionState.waiting
                  ? SizedBox.shrink()
                  : snap.data as Widget,
          future: createCloud(deviceSize),
        ),
        FutureBuilder(
          builder: (ctx, snap) =>
              snap.connectionState == ConnectionState.waiting
                  ? SizedBox.shrink()
                  : snap.data as Widget,
          future: createCloud(deviceSize),
        ),
      ],
    );
  }
}

class WhiteCloudAnimation extends StatefulWidget {
  const WhiteCloudAnimation({
    required this.d,
    Key? key,
  }) : super(key: key);

  final double d;

  @override
  _WhiteCloudAnimationState createState() => _WhiteCloudAnimationState(d);
}

class _WhiteCloudAnimationState extends State<WhiteCloudAnimation>
    with SingleTickerProviderStateMixin {
  final double d;

  _WhiteCloudAnimationState(this.d);

  late AnimationController _controller;

  static Random rand = Random();
  static double doubleInRange(Random source, double start, double end) =>
      source.nextDouble() * (end - start) + start;

  late double _randomY;
  late double _r;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
      lowerBound: 0,
      upperBound: d,
    );
    _controller.addListener(() {
      setState(() {});
    });
    _controller.repeat();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    _randomY = _controller.value < 10 ? rand.nextDouble() : _randomY;
    _r = _controller.value < 10 ? doubleInRange(rand, 4, 7) : _r;

    return Transform.scale(
      scale: 0.6,
      child: Transform.translate(
        offset: Offset(
            -((_controller.value * _r) - d * 2), deviceSize.height * _randomY),
        child: Transform.rotate(
          angle: 3.14,
          child: Image.asset("assets/images/cloud.png"),
        ),
      ),
    );
  }
}
