import 'package:flutter/foundation.dart';

class Account {
  Account(
      {
        @required this.id,
      @required this.privateKey,
      @required this.publicKey,
      @required this.address,
      @required this.name,
      @required this.balance,
      @required this.userId,
      @required this.eligibility});

  String privateKey;
  String publicKey;
  String address;
  String name;
  String balance;
  String userId;
  String id;
  String eligibility;

  factory Account.fromMap(Map<String, dynamic> json) => Account(
        id : json["rowid"].toString(),
        privateKey: json["private_key"],
        publicKey: json["public_key"],
        address: json["address"],
        name: json["name"],
        balance: json["balance"].toString(),
        userId: json["user_id"].toString(),
        eligibility: json["eligibility"].toString(),
      );

  Map<String, dynamic> toMap() => {
        "private_key": privateKey,
        "public_key": publicKey,
        "address": address,
        "name": name,
        "balance": balance,
        'user_id': userId,
        'rowid':id,
        'eligibility':eligibility,
      };
}
