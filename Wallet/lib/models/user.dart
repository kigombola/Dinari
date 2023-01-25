import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String email;
  final String password;

  User({
    @required this.id,
    @required this.email,
    @required this.password,
  });

  User.fromMap(Map<String, dynamic> res)
      : id = res["rowid"].toString(),
        email = res["email"],
        password = res["password"];

  Map<String, dynamic> toMap() {
    return {
      'rowid': id,
      'email': email,
      'password': password,
    };
  }
}
