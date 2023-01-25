import 'package:flutter/cupertino.dart';

class TransactionModel {
  String address;
  String otherEndAddress;
  double amount;
  String transactionType;
  String channel;
  String confirmationTime;
  String receivedTime;
  String status;
  String accId;
  String userId;
  int id;

  TransactionModel(
      {@required this.address,
      @required this.otherEndAddress,
      @required this.amount,
      @required this.transactionType,
      @required this.confirmationTime,
      @required this.receivedTime,
      @required this.channel,
      @required this.status,
      @required this.accId,
      @required this.userId,
      @required this.id});

  TransactionModel.fromMap(Map<String, dynamic> res)
      : address = res["address"],
        otherEndAddress = res["other_end_address"],
        amount = res['amount'],
        channel = res['channel'],
        confirmationTime = res['confirmation_time'],
        receivedTime = res['received_time'],
        transactionType = res['transaction_type'],
        status = res['status'],
        accId = res['account_id'],
        userId = res['user_id'],
        id = res['rowid'];

  Map<String, Object> toMap() {
    return {
      'address': address,
      'other_end_address': otherEndAddress,
      'amount': amount,
      'transaction_type': transactionType,
      'channel': channel,
      'received_time': receivedTime,
      'confirmation_time': confirmationTime,
      'status': status,
      'account_id': accId,
      'user_id': userId,
      'rowid':id
    };
  }
}
