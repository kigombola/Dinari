import 'package:flutter/foundation.dart';
import 'dart:convert';

class VerificationModel {
    VerificationModel({
       @required this.id,
       @required this.userId,
       @required this.otp,
    });

    int id;
    String userId;
    String otp;

    factory VerificationModel.fromMap(Map<String, dynamic> json) => VerificationModel(
        id: json["rowid"],
        userId: json["user_id"],
        otp: json["otp"],
    );

    Map<String, dynamic> toMap() => {
        "rowid": id,
        "user_id": userId,
        "otp": otp,
    };
}



VerifyEmail verifyEmailFromJson(String str) => VerifyEmail.fromJson(json.decode(str));

String verifyEmailToJson(VerifyEmail data) => json.encode(data.toJson());

class VerifyEmail {
    VerifyEmail({
        this.email,
        this.otp,
        this.pin,
    });

    String email;
    String otp;
    String pin;

    factory VerifyEmail.fromJson(Map<String, dynamic> json) => VerifyEmail(
        email: json["email"],
        otp: json["otp"],
        pin: json["pin"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "otp": otp,
        "pin": pin,
    };
}
