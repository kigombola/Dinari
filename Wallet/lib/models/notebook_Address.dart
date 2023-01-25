import 'package:flutter/foundation.dart';

class NotebookAddress {
  NotebookAddress(
      {@required this.id,
      @required this.address,
      @required this.name,
      @required this.userId});

  String address;
  String name;
  String id;
  String userId;

  factory NotebookAddress.fromMap(Map<String, dynamic> json) => NotebookAddress(
        id: json["rowid"].toString(),
        address: json["address"],
        name: json["name"],
        userId: json["user_id"]
      );

  Map<String, dynamic> toMap() => {
        "address": address,
        "name": name,
        'rowid': id,
        'user_id':userId
      };
}
