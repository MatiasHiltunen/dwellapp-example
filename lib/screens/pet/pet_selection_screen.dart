import 'package:Kuluma/screens/mainscreen/main_screen.dart';
import 'package:Kuluma/tools/logging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../widgets/common/dwell_text_field.dart';
import '../../widgets/common/dwell_orange_button.dart';
import '../../widgets/common/pets_flare_actor.dart';
import '../../config.dart';
import '../screen_root.dart';

class PetSelectionScreen extends StatefulWidget {
  static const routeName = '/pet_selection';

  PetSelectionScreen({Key? key}) : super(key: key);

  @override
  _PetSelectionScreenState createState() => _PetSelectionScreenState();
}

class _PetSelectionScreenState extends State<PetSelectionScreen> {
  final _petFromKey = GlobalKey<FormState>();
  final _petNameController = TextEditingController();

  @override
  void dispose() {
    _petNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double heigth = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    if (_petNameController.text == '') {
      setState(() {
        _petNameController.text = Provider.of<User>(context).petName;
      });
    }

    return ScreenRoot(
      resizeToAvoidBottomInset: false,
      title: "Lemmikki",
      body: Container(
        color: DwellColors.background,
        height: heigth,
        width: width,
        child: Column(
          children: [
            Form(
              key: _petFromKey,
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8),
                width: width * 0.7,
                child: DwellTextFormField(
                  inputController: _petNameController,
                  hint: 'Nimi',
                  hide: false,
                ),
              ),
            ),
            Stack(
              children: [
                Transform.translate(
                  offset: Offset(width * 0.15, -heigth * 0.1),
                  child: Image.asset(
                    'assets/images/pet_selection.png',
                    height: heigth * 0.6,
                    width: width * 0.7,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Pets(
                    heigth: heigth,
                    width: width,
                    selected: Provider.of<User>(context).pet != null
                        ? Provider.of<User>(context).pet
                        : 0,
                    state: "GOOD",
                  ),
                ),
                Transform.translate(
                  offset: Offset(0, heigth * 0.5),
                  child: Container(
                    height: heigth * 0.2,
                    width: width,
                    padding: EdgeInsets.only(left: 15),
                    child: Pets.petsSelection(
                      heigth: heigth,
                      width: width,
                      changeAnimation:
                          Provider.of<User>(context, listen: false).selectPet,
                      sel: Provider.of<User>(context).pet ?? 0,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DwellOrangeButton(
                formKey: _petFromKey,
                buttonPressed: (val) {
                  Provider.of<User>(context, listen: false)
                      .savePetName(val)
                      .then((value) => Navigator.of(context)
                          .pushReplacementNamed(MainScreenPage.routeName))
                      .catchError((err) {
                    Log.error("Error saving pet data");
                    Navigator.of(context).pop();
                  });
                },
                text: 'Menoksi',
                controller: _petNameController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
