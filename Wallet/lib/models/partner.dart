import 'package:flutter/foundation.dart';

class PartnerModel {
    PartnerModel({
       @required this.address,
       @required this.partnerAddress,
       @required this.pairingTime,
       @required this.status,
       @required this.id,
    });

    String address;
    String partnerAddress;
    String pairingTime;
    String status;
    int id;

    factory PartnerModel.fromMap(Map<String, dynamic> json) => PartnerModel(
        address: json["address"],
        partnerAddress: json["partner_address"],
        pairingTime: json["pairing_time"],
        status:json["status"],
        id: json["rowid"],
    );

    Map<String, dynamic> toMap() => {
        "address": address,
        "partner_address": partnerAddress,
        "pairing_time": pairingTime,
        "status": status,
        "rowid": id,
    };
}
