import 'package:Kuluma/config.dart';
import 'package:Kuluma/generated/l10n.dart';
import 'package:Kuluma/models/account.dart';
import 'package:Kuluma/providers/user_provider.dart';
import 'package:Kuluma/screens/user/widgets/delete_account.dart';
import 'package:Kuluma/screens/user/widgets/password_reset_screen.dart';
import 'package:Kuluma/screens/user/widgets/email_change_screen.dart';
import 'package:Kuluma/screens/user/widgets/name_change_screen.dart';

import 'package:provider/provider.dart';

import '../screen_root.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  static const routeName = '/user';

  @override
  Widget build(BuildContext context) {
    return ScreenRoot(
      title: S.of(context).drawerUserInfo,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            color: DwellColors.background,
            child: DwellAccountData(),
          );
        },
      ),
    );
  }
}

class DwellAccountData extends StatefulWidget {
  const DwellAccountData({
    Key? key,
  }) : super(key: key);

  @override
  _DwellAccountDataState createState() => _DwellAccountDataState();
}

class _DwellAccountDataState extends State<DwellAccountData> {
  UserInformation userInformation = UserInformation([
    UserInformationItem(
        'Käyttäjätunnus (sähköposti)', '...', EditUserInfoAction.none),
    UserInformationItem('Salasana', '***********', EditUserInfoAction.none),
    UserInformationItem('Nimi', "...", EditUserInfoAction.none),
    UserInformationItem('Talo', 'DAS Kelo', EditUserInfoAction.none),
    UserInformationItem('Asunto', '...', EditUserInfoAction.none),
    UserInformationItem('Tyhjennä välimuisti',
        'Uudelleen kirjautuminen vaaditaan', EditUserInfoAction.clearStorage),
    UserInformationItem('Poista käyttäjätili',
        'Poista käyttäjätilisi ja omat tietosi tästä', EditUserInfoAction.none),
  ]);

  @override
  Widget build(BuildContext context) {
    return FocusScope.of(context).hasPrimaryFocus
        ? FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                Account data = snapshot.data as Account;
                userInformation = UserInformation([
                  UserInformationItem('Käyttäjätunnus (sähköposti)',
                      data.userName, EditUserInfoAction.userName),
                  UserInformationItem(
                      'Salasana', '***********', EditUserInfoAction.password),
                  UserInformationItem(
                      'Nimi',
                      "${data.firstName} ${data.lastName}",
                      EditUserInfoAction.name),
                  UserInformationItem(
                      'Talo', 'DAS Kelo', EditUserInfoAction.none),
                  if (data.apartment != null)
                    UserInformationItem(
                        'Asunto',
                        AppConfig.useDummyData ? "demo" : data.apartment,
                        EditUserInfoAction.none),
                  UserInformationItem(
                      'Tyhjennä välimuisti',
                      'Uudelleen kirjautuminen vaaditaan',
                      EditUserInfoAction.clearStorage),
                  UserInformationItem(
                      'Poista käyttäjätili',
                      'Poista käyttäjätilisi ja omat tietosi tästä',
                      EditUserInfoAction.delete),
                ]);
                return ListView.builder(
                  itemBuilder: (_, index) => UserScreenListViewItem(
                      item: userInformation.items[index]),
                  itemCount: userInformation.items.length,
                );
              }

              return ListView.builder(
                itemBuilder: (_, index) =>
                    UserScreenListViewItem(item: userInformation.items[index]),
                itemCount: userInformation.items.length,
              );
            },
            future: Provider.of<User>(context, listen: false)
                .account(refresh: true),
          )
        : SizedBox.shrink();
  }
}

enum EditUserInfoAction {
  userName,
  password,
  email,
  name,
  delete,
  none,
  clearStorage
}

class UserInformationItem {
  final String title;
  final EditUserInfoAction? action;
  String? value;

  UserInformationItem(this.title, [this.value, this.action]);
}

class UserInformation {
  final List<UserInformationItem> items;

  UserInformation(this.items);
}

/* {
  "account": {
    "_id": "5fbe0f9112d259097e7e2c7f",
    "active": true,
    "apartment": "5e566839982a83f03c0b84a5",
    "first_name": "Testaaja",
    "last_name": "A",
    "lease": {
      "_id": "5fa3c4701df21b291167b2ef",
      "apartment": null,
      "registration_code": [
        {
          "code": "vbxxdkmd",
          "code_type": "primary",
          "valid_from": 1604488185,
          "valid_until": 1605092985
        }
      ],
      "resident": null,
      "valid_from": 1604488185,
      "valid_until": null
    },
    "pet": {
      "character": 1,
      "name": "Otus"
    },
    "role": "resident",
    "username": "A"
  }
} */

class UserScreenListViewItem extends StatelessWidget {
  const UserScreenListViewItem(
      {Key? key, required UserInformationItem this.item})
      : super(key: key);
  final UserInformationItem item;

  void _clearStorage(BuildContext context) {
    context.read<User>().resetDataBase();
    context.read<User>().logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  void action(EditUserInfoAction action, BuildContext context) {
    switch (action) {
      case EditUserInfoAction.password:
        Navigator.of(context).pushNamed(PasswordResetScreen.routeName);
        break;
      case EditUserInfoAction.userName:
        Navigator.of(context).pushNamed(EmailChangeScreen.routeName);
        break;
      case EditUserInfoAction.name:
        Navigator.of(context).pushNamed(NameChangeScreen.routeName);
        break;
      case EditUserInfoAction.delete:
        Navigator.of(context).pushNamed(AccountDelete.routeName);
        break;
      case EditUserInfoAction.clearStorage:
        _clearStorage(context);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      height: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  item.title,
                  style: TextStyle(
                    color: DwellColors.primaryOrange,
                    fontSize: 20,
                    fontFamily: 'Sofia Pro',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.65,
                  child: Text(
                    item.value ?? '',
                    style: TextStyle(
                      color: DwellColors.textWhite,
                      fontSize: 18,
                      fontFamily: 'Sofia Pro',
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ],
          ),
          if (item.action != EditUserInfoAction.none)
            IconButton(
              icon: item.action == EditUserInfoAction.delete ||
                      item.action == EditUserInfoAction.clearStorage
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Icon(
                        Icons.delete_forever_outlined,
                        size: 32,
                        color: DwellColors.primaryOrange,
                      ),
                    )
                  : Image.asset(
                      'assets/images/edit.png',
                      scale: 1.5,
                    ),
              onPressed: () {
                action(item.action ?? EditUserInfoAction.none, context);
              },
            )
        ],
      ),
    );
  }
}
