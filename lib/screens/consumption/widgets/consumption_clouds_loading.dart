import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConsumptionCloudLoading extends StatelessWidget {
  final String cloud;
  final Color color;

  ConsumptionCloudLoading({required this.cloud, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
          children: [Image.asset(cloud), SpinKitFadingCircle(color: color)]),
    );
  }
}
