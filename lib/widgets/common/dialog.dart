/* import 'dart:ui';

// import '../../locale/locales.dart';
// import '../../providers/message_provider.dart';
import 'package:Kuluma/config.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../widgets/common/dwell_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DwellDialog {
  /* Future confirmation({
    required BuildContext ctx,
    required String title,
    required String text,
    required onConfirm,
    required HasId item,
  }) {
    return showDialog(
        context: ctx,
        builder: (BuildContext _) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[Text(text)],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  try {
                    Navigator.of(ctx).pop();
                  } catch (e) {}
                },
                child: Text(AppLocalizations.of(ctx).close),
              ),
              FlatButton(
                onPressed: () {
                  onConfirm();
                  Navigator.of(ctx).pop();
                },
                child: Text('OK'),
              )
            ],
          );
        });
  } */

  Future<Widget> dwellDialogCard({
    required BuildContext ctx,
    required String title,
    required String text,
    required Function onConfirm,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext ctx) {
        return SingleChildScrollView(
          child: DwellCarouselSliderIntro(
            ctx: ctx,
            onConfirm: onConfirm,
          ),
        );
        /* Container(
            padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
            child: Card(
              elevation: 6,
              margin: EdgeInsets.only(bottom: height * 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          onConfirm();
                          Navigator.of(ctx).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          size: lerpDouble(30, 30, 1),
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      DwellTitle(
                        title: title,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              color: const Color.fromRGBO(17, 65, 74, 1),
            ),
          ),
        ) */
      },
    );
  }
}

class DwellCarouselSliderIntro extends StatelessWidget {
  const DwellCarouselSliderIntro({Key? key, this.ctx, this.onConfirm}) : super(key: key);

  final BuildContext ctx;
  final Function onConfirm;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return CarouselSlider(
      items: DwellIntro.list.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return SingleChildScrollView(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(color: DwellColors.background, borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            child: GestureDetector(
                              onTap: () {
                                onConfirm();
                                Navigator.of(ctx).pop();
                              },
                              child: Icon(
                                Icons.close,
                                size: lerpDouble(30, 30, 1),
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Image.asset(
                        item.img,
                        scale: 3,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 30, 16, 0),
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 24.0,
                            color: DwellColors.textWhite,
                            decoration: TextDecoration.none,
                            fontFamily: "Sofia Pro",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
                        child: Text(
                          item.text,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: DwellColors.textWhite,
                            decoration: TextDecoration.none,
                            fontFamily: "Sofia Pro",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(
        height: height * 0.8,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}

class DwellIntro {
  static final List<DwellIntroItem> list = [
    DwellIntroItem(
      'assets/images/intro1_2.png',
      'Katso?',
      'Kuinkas paljon menee viikossa vettä ja sähköä? Voit verrata omaa menekkiä talon lukemiin. Tarkempaa dataa löytyy myös, jos sellainen kiinnostaa.',
    ),
    DwellIntroItem(
      'assets/images/intro2_2.png',
      'Löydä!',
      'Keskustelupalstalta voi löytyä ideoita, ajan viettoa tai vaikkapa polkupyörä. Kysy kommentoi ja äänestä. Voit näin vaikuttaa.',
    ),
    DwellIntroItem(
      'assets/images/intro3_2.png',
      'Valitse.',
      'Millainen olento heiluu ruudussa? Valitse ja nimeä se. Siinäpä se tällä kertaa. Kerro keskustelupalstalla mitä pidät sovelluksesta ja erityisesti mistä et pidä!',
    ),
  ];
}

class DwellIntroItem {
  final String img;
  final String title;
  final String text;

  DwellIntroItem(this.img, this.title, this.text);
}
 */
