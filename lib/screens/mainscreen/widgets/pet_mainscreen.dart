import '../../../providers/user_provider.dart';
import '../../../widgets/common/pets_flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PetMainScreen extends StatelessWidget {
  const PetMainScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Stack(children: [
      Transform.translate(
        offset: Offset(0, deviceSize.height * 0.15),
        child: Pets(
          heigth: deviceSize.height,
          width: deviceSize.width,
          selected: Provider.of<User>(context)
              .pet /* != null
              ? Provider.of<User>(context).pet
              : -1 */ // dafuq?
          ,
          state: Provider.of<User>(context, listen: false).petState,
        ),
      )
    ]);
  }
}
/* Transform.translate(
          offset: Offset(20, deviceSize.height * 0.7),
          child: Text(
            'Hattara',
            style: TextStyle(
              fontFamily: 'Sofia Pro',
              fontSize: 26,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(20, deviceSize.height * 0.7 + 35),
          child: Text(
            'Tasaisen tappavaa kulutusta.',
            style: TextStyle(
              fontFamily: 'Sofia Pro',
              fontSize: 16,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w400,
            ),
          ),
        ), */
