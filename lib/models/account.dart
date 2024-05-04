import 'package:Kuluma/tools/common.dart';

class Account {
  final String? apartment;
  final String firstName;
  final String lastName;
  final DateTime activeFrom;
  final DateTime activeTo;
  // final String code;
  final String petName;
  final String userName;
  final String role;
  final int selectedPet;

  Account(
    this.apartment,
    this.firstName,
    this.lastName,
    this.activeFrom,
    this.activeTo,
    // this.code,
    this.petName,
    this.userName,
    this.role,
    this.selectedPet,
  );

  Account.fromJson(json)
      : this.apartment = json['apartment'] ?? 'no apartment found',
        this.firstName = json['first_name'],
        this.lastName = json['last_name'],
        this.activeFrom = json['lease'] == null &&
                json['lease']?['valid_from'] == null &&
                json['role'] == Role.admin.asString()
            ? DateTime(2000)
            : DateTime.fromMillisecondsSinceEpoch(
                json['lease']['valid_from'] * 1000),
        this.activeTo =
            json['lease'] == null || json['lease']['valid_until'] == null
                ? DateTime(2100)
                : DateTime.fromMillisecondsSinceEpoch(
                    json['lease']['valid_until'] * 1000),
        // this.code = json['lease']['registration_code']['code'],
        this.petName = json['role'] == Role.admin.asString()
            ? 'admin_pet'
            : json['pet']['name'] ?? '',
        this.userName = json['username'],
        this.role = json['role'],
        this.selectedPet = json['role'] == Role.admin.asString()
            ? 0
            : json['pet']['character'] ?? 1;
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

/* Admin data */
/* "account": {
    "_id": "61274208b68216143b166071",
    "active": true,
    "apartment": null,
    "first_name": "Matias",
    "last_name": "Hiltunen",
    "lease": null,
    "pet": null,
    "role": "admin",
    "username": "matias.hiltunen@lapinamk.fi"
  } */