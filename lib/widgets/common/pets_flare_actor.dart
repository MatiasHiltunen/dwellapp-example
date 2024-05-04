import 'package:Kuluma/config.dart';

import '../../models/pet_character.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Pets extends StatelessWidget {
  final double heigth;
  final double width;
  final int? _selected;
  final String _state;
  static final List<Character> characters = [
    Character(name: "Naatti_testi", offset: Offset(30, 0)),
    Character(name: "Hattara_withentrance"),
    Character(name: "VALLE_animations", scale: 0.65)
  ];

  Pets({
    Key? key,
    required this.heigth,
    required this.width,
    required int? selected,
    required String state,
  })   : _selected = selected,
        _state = state,
        super(key: key);

  static List<Widget> initPets({
    String state = 'NEUTRAL',
  }) {
    return List.generate(3, (i) {
      return Transform.translate(
        offset: characters[i].offset,
        child: Transform.scale(
          scale: characters[i].scale,
          child: FlareActor(
            characters[i].asset,
            animation: 'ANIMATION',
            artboard: state,
            fit: BoxFit.contain,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: heigth * 0.65,
          width: width,
          child: _selected == null
              ? SizedBox.shrink()
              : _selected != -1
                  ? initPets(state: _state)[_selected!] /* pets[_selected] */
                  : SizedBox.shrink(),
        ),
      ],
    );
  }

  static ListView petsSelection(
      {required double heigth,
      required double width,
      required Function changeAnimation,
      required int sel}) {
    return ListView.builder(
      itemBuilder: (ctx, i) {
        return InkWell(
            onTap: () => changeAnimation(i),
            child: i == sel
                ? ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      DwellColors.primaryBlue /* Color(0xFF1AA7AC) */,
                      BlendMode.modulate,
                    ),
                    child: Container(
                        height: heigth * 0.2,
                        width: width * 0.3,
                        child: initPets(
                          state: 'NEUTRAL',
                        )[i]),
                  )
                : Container(
                    height: heigth * 0.2,
                    width: width * 0.3,
                    child: initPets(
                      state: 'NEUTRAL',
                    )[i]));
      },
      itemCount: initPets(state: 'GOOD').length,
      scrollDirection: Axis.horizontal,
    );
  }

  static Future<void> warmUpFlare() async {
    for (final c in characters) {
      await cachedActor(AssetFlare(bundle: rootBundle, name: c.asset));
      await Future<void>.delayed(const Duration(milliseconds: 16));
    }
  }
}
