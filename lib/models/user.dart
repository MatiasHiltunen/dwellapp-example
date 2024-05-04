import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String userName;
  @HiveField(1)
  final String role;
  @HiveField(2)
  final String id;
  @HiveField(3)
  String accessToken;
  @HiveField(4)
  final String refreshToken;
  @HiveField(5)
  int? authTokenExpires;
  @HiveField(6)
  final String? apartment;
  @HiveField(7)
  int? pet;
  @HiveField(8)
  String? petName;

  UserModel({
    required this.userName,
    required this.role,
    required this.id,
    required this.accessToken,
    required this.refreshToken,
    required this.apartment,
    this.authTokenExpires,
    this.pet,
    this.petName,
  });
}
