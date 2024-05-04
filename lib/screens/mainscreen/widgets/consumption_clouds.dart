import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/screens/consumption/consumption_screen.dart';
import 'package:Kuluma/screens/consumption/widgets/consumption_clouds_loading.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../../../config.dart';
import '../../../models/consumption_collection.dart';
import '../../../providers/user_provider.dart';

enum Side { right, left }

class ConsumptionCloudsMainScreen extends StatefulWidget {
  const ConsumptionCloudsMainScreen({Key? key}) : super(key: key);

  @override
  _ConsumptionCloudsMainScreenState createState() =>
      _ConsumptionCloudsMainScreenState();
}

class _ConsumptionCloudsMainScreenState
    extends State<ConsumptionCloudsMainScreen> {
  @override
  void initState() {
    super.initState();
  }

  _ConsumptionCloudsMainScreenState();

  @override
  Widget build(BuildContext context) {
    User userProvider = Provider.of<User>(context, listen: false);
    return Container(
      height: 200,
      child: AppConfig.useDummyData
          ? Builder(builder: (context) {
              userProvider.consumptionCloudData =
                  ConsumptionCollection.createDummy();
              return ConsumptionCloudsReady(
                collection: userProvider.consumptionCloudData!,
              );
            })
          : FutureBuilder(
              builder: (ctx, snap) {
                if (snap.hasData &&
                    snap.connectionState == ConnectionState.done &&
                    userProvider.consumptionCloudData == null) {
                  userProvider.consumptionCloudData =
                      ConsumptionCollection.fromJson(
                          snap.data as Map<String, dynamic>);
                  return ConsumptionCloudsReady(
                    collection: userProvider.consumptionCloudData!,
                  );
                }
                return userProvider.consumptionCloudData != null
                    ? ConsumptionCloudsReady(
                        collection: userProvider.consumptionCloudData!)
                    : ConsumptionCloudsError();
              },
              future:
                  Provider.of<User>(context, listen: false).fetchCloudData(),
            ),
    );
  }
}

class ConsumptionCloudsError extends StatelessWidget {
  const ConsumptionCloudsError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 0.8,
          child: Container(
            constraints: BoxConstraints(maxWidth: 200),
            width: w / 2,
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ConsumptionCloudLoading(
                cloud: 'assets/images/water_cloud.png',
                color: Colors.white,
              ),
            ),
          ),
        ),
        Spacer(),
        Transform.scale(
          scale: 0.8,
          child: Container(
            constraints: BoxConstraints(maxWidth: 200),
            width: w / 2,
            child: AspectRatio(
              aspectRatio: 1.5,
              child: ConsumptionCloudLoading(
                cloud: 'assets/images/energy_cloud.png',
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ConsumptionCloudsReady extends StatelessWidget {
  const ConsumptionCloudsReady({Key? key, required this.collection})
      : super(key: key);

  final ConsumptionCollection collection;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
                ConsumptionScreen.routeName,
                arguments: Side.left);
          },
          child: Transform.scale(
            scale: 0.8,
            child: Container(
              constraints: BoxConstraints(maxWidth: 200),
              width: w / 2,
              child: AspectRatio(
                aspectRatio: 1.5,
                child: ConsumptionCloudWithAnimation(
                  item: 'assets/images/droplet.png',
                  cloud: 'assets/images/water_cloud.png',
                  side: Side.left,
                  housingData: collection.joinedWaterBuilding,
                  personalData: collection.joinedWaterTenant,
                ),
              ),
            ),
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed(
                ConsumptionScreen.routeName,
                arguments: Side.right);
          },
          child: Transform.scale(
            scale: 0.8,
            child: Container(
              constraints: BoxConstraints(maxWidth: 200),
              width: w / 2,
              child: AspectRatio(
                aspectRatio: 1.5,
                child: ConsumptionCloudWithAnimation(
                  item: 'assets/images/lamp.png',
                  cloud: 'assets/images/energy_cloud.png',
                  side: Side.right,
                  housingData: collection.energyBuilding,
                  personalData: collection.energyTenant,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ConsumptionCloudWithAnimation extends StatefulWidget {
  const ConsumptionCloudWithAnimation({
    Key? key,
    required this.item,
    required this.cloud,
    required this.side,
    required this.housingData,
    required this.personalData,
  }) : super(key: key);

  final String item;
  final String cloud;
  final Side side;
  final double housingData;
  final double personalData;

  @override
  _ConsumptionCloudWithAnimationState createState() =>
      _ConsumptionCloudWithAnimationState(
          item, cloud, side, housingData, personalData);
}

class _ConsumptionCloudWithAnimationState
    extends State<ConsumptionCloudWithAnimation>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late Animation<double> animation2;
  late AnimationController controller1;

  final String item;
  final String cloud;
  final Side side;
  final double housingData;
  final double personalData;
  final double adjustment = 10;

  _ConsumptionCloudWithAnimationState(
    this.item,
    this.cloud,
    this.side,
    this.housingData,
    this.personalData,
  );

  @override
  void initState() {
    super.initState();
    controller1 =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);

    dwellAnimate();
  }

  void dwellAnimate() async {
    animation = Tween<double>(
            begin: -30,
            end: side == Side.left ? housingData / 5 : housingData / 50)
        .animate(controller1)
      ..addStatusListener((status) {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });

    animation2 = Tween<double>(
            begin: -30,
            end: side == Side.left ? personalData / 5 : personalData / 50)
        .animate(controller1)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });

    controller1.forward();
  }

  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          // Kelo
          Transform.translate(
            offset: Offset(77, animation.value + 15 + adjustment),
            child: Image.asset(item),
          ),

          //br ? 1.2 : 0.8,
          side == Side.left
              // Kelo left
              ? Transform.translate(
                  offset: Offset(-70, animation.value + 75 + adjustment),
                  child: const LineDotted())
              // Kelo right
              : Transform.translate(
                  offset: Offset(120, animation.value + 75 + adjustment),
                  child: const LineDotted()),

          // User
          Transform.translate(
            offset: Offset(45, animation2.value + 15 + adjustment),
            child: Image.asset(item),
          ),

          side == Side.left
              // User left
              ? Transform.translate(
                  offset: Offset(-164, animation2.value + 75 + adjustment),
                  child: const LineDotted())
              // User right
              : Transform.translate(
                  offset: Offset(10, animation2.value + 75 + adjustment),
                  child: const LineDotted()),

          // User
          TextWithConsumptionCloud(
            animation: animation2,
            x: 30,
            y: 140 + adjustment,
            value: personalData,
            colored: true,
            side: side,
            clouds: ConsumptionClouds.user,
          ),
          // Dwell
          TextWithConsumptionCloud(
            animation: animation,
            x: 155,
            y: 140 + adjustment,
            value: animation.value,
            side: side,
            clouds: ConsumptionClouds.housing,
          ),
          Transform.translate(
            offset: Offset(10, -40),
            child: Container(
              width: 170,
              height: 100,
              color: DwellColors.background,
            ),
          ),
          Image.asset(cloud),
        ],
      ),
    );
  }
}

enum ConsumptionClouds { user, housing }

class LineDotted extends StatelessWidget {
  const LineDotted({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverflowBox(
      maxWidth: 250,
      child: DottedLine(
        dashLength: 3,
        dashColor: Colors.white38,
        dashGapLength: 2,
        dashRadius: 10,
      ),
    );
  }
}

class TextWithConsumptionCloud extends StatelessWidget {
  const TextWithConsumptionCloud({
    Key? key,
    required this.animation,
    required this.x,
    required this.y,
    this.colored = false,
    required this.side,
    required this.value,
    required this.clouds,
  }) : super(key: key);

  final Animation<double> animation;
  final double x;
  final double y;
  final bool colored;
  final Side side;
  final double value;
  final double fontSize = 18;
  final ConsumptionClouds clouds;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(
          x - (side == Side.left && clouds == ConsumptionClouds.user ? 38 : 50),
          animation.value + y - 35),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            colored
                ? S.of(context).mainscreenConsumptionCloudIndicatorsOwn
                : 'Kelo',
            style: TextStyle(
                color: colored
                    ? side == Side.left
                        ? const Color(0xFF1AA7AC)
                        : const Color(0xFFEDBD4C)
                    : Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: fontSize),
          ),
          Row(
            children: [
              Text(
                side == Side.left
                    ? (animation.value * 5).roundToDouble().toString()
                    : (animation.value * 50).roundToDouble().toString(),
                style: TextStyle(
                  color: colored
                      ? side == Side.left
                          ? const Color(0xFF1AA7AC)
                          : const Color(0xFFEDBD4C)
                      : Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
              Text(
                side == Side.left ? ' L' : ' Wh',
                style: TextStyle(
                  color: colored
                      ? side == Side.left
                          ? const Color(0xFF1AA7AC)
                          : const Color(0xFFEDBD4C)
                      : Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
