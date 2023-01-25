import 'package:flutter/foundation.dart';

class PartnerTrustModel {
  PartnerTrustModel(
      {@required this.address,
      @required this.partnerAddress,
      // @required this.recipientMessage,
      @required this.id,
      @required this.status});

  String address;
  String partnerAddress;
  String recipientMessage;
  String id;
  String status;

  factory PartnerTrustModel.fromMap(Map<String, dynamic> json) =>
      PartnerTrustModel(
          address: json["address"],
          partnerAddress: json["partnership_address"],
          // recipientMessage: json["recipient_message"],
          id: json["rowid"],
          status: json['status']);

  Map<String, dynamic> toMap() => {
        "address": address,
        "partnership_address": partnerAddress,
        // "recipient_message": recipientMessage,
        "rowid": id,
        "status":status
      };
}
