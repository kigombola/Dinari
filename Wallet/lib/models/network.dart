import 'package:flutter/foundation.dart';

class Network {
  Network(
      {@required this.id,
      @required this.name,
      @required this.ipAddress,
      @required this.chain,
      @required this.portNo,
      @required this.status,
      @required this.userId});
  String name;
  String ipAddress;
  int chain;
  String portNo;
  String status;
  int id;
  String userId;

  factory Network.fromMap(Map<String, dynamic> json) => Network(
        id: json["rowid"],
        name: json["name"],
        ipAddress: json["ip_address"],
        chain: json["chain_id"],
        portNo: json["port_number"],
        status: json["status"],
        userId: json["user_id"]
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "ip_address": ipAddress,
        "chain_id": chain,
        "port_number": portNo,
        "status": status,
        'rowid': id,
        'user_id':userId
      };
}
