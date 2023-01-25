import 'dart:typed_data';
import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:dinari_wallet/provider/partnership.dart';
import 'package:dinari_wallet/provider/transaction.dart';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:path_provider/path_provider.dart';

class RoutingProvider extends ChangeNotifier {
  GenerateAccountProvider account;
  TransactionProvider transaction;
  PartnershipTrustProvider partnership;

  void update(
      {@required GenerateAccountProvider accountProvider,
      @required TransactionProvider transactionProvider,
      @required PartnershipTrustProvider partnership}) {
    account = accountProvider;
    transaction = transactionProvider;
    partnership = partnership;
  }

  RoutingProvider({this.account, this.transaction});

  final Strategy strategy = Strategy.P2P_CLUSTER;
  Map<String, ConnectionInfo> _endpointMap;
  String tempFileUri; //reference to the file currently being transferred
  Map<int, String> map = Map();

  // trust partnership request
  tpRequest(String addressA, String addressB) async {
    var check = await checkEligibility();
    if (check == 0) {
      return false;
    } else {
      var reqst = await partnership.sendRequest(
          address: addressA,
          partnershipAddress: addressB,
          recipientMessage: 'recipientMessage');

      if (reqst) {
        return true;
      } else {
        return false;
      }
    }
  }

  Map<String, ConnectionInfo> get endPointMap => _endpointMap;

  void setEndpointMap(Map<String, ConnectionInfo> endpointMap) {
    _endpointMap = endpointMap;
    print('wohooooooooooo');
    print(_endpointMap);
    notifyListeners();
  }

  // checking eligibility
  checkEligibility() async {
    var eligibility = account.currentAccount.eligibility;
    var current = 1.0; // if eligibility is null set it to 1
    if (eligibility != null) {
      current = num.tryParse(eligibility)?.toDouble();
      if (current == null) {
        current = 0;
      }
    }
    var successTpRequest = await pastTpRequestRate(account.currentAccount.address);
    var successTnxRate = await pastTnxRequestRate(account.currentAccount.address);
    var eligible = (0.3 * current + (0.3 * successTpRequest + 0.4 * successTnxRate) * 0.01).toStringAsFixed(0);
    return eligible;
  }

  pastTpRequestRate(address) async {
    var total = await DbHelper.getSuccessTpRequests(address);

    var rate = total * 0.01;
    return rate;
  }

  pastTnxRequestRate(address) async {
    var total = await DbHelper.getSuccessTransactions(address);

    var rate = total * 0.01;
    return rate;
  }

  // transaction request
  txRequest(String addressB, amount, context) async {
    String addressA = account.currentAccount.address;
    var balance = await account.getBalance();
    if (double.parse(balance) > 0) {
      bool resp = await DbHelper.verifyPartners(addressA, addressB);
      print(resp);
      if (resp) {
        print('endpointmapppppp');
        print(_endpointMap);
        _endpointMap.forEach((key, value) async {
          print('elizaaaaaaaaaaaa');
          print(key);
          String a = amount.toString();

          showSnackbar(
              "Sending $a to ${value.endpointName}, id: $key", context);

          // Sending transaction through p2p
          await Nearby().sendBytesPayload(key, Uint8List.fromList(a.codeUnits));
          
          
        });

        // Sending transaction through blockchain
        transaction.sendTransaction(addressB, double.parse(amount), context);
      } else {
        // Sending transaction through blockchain
        await transaction.sendTransaction(addressB, double.parse(amount), context);

        // Updating account balance
        var balance = await account
            .getSpecificAccountBalance(account.currentAccount.privateKey);
        var newBalance = balance - amount;
        await DbHelper.updateBalance(
            account.currentAccount.id, newBalance.toString());
      }
    } else {
      return 'failed';
    }
  }

  void showSnackbar(dynamic a, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

    checkDestinationAddress(String address) async {
    final data = await DbHelper.checkAddress(address);

    if (data != 0) {
      return true;
    } else {
      return false;
    }
  }

}
