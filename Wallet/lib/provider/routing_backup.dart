import 'dart:typed_data';

import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/models/account.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:dinari_wallet/provider/partnership.dart';
import 'package:dinari_wallet/provider/transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Map<String, ConnectionInfo> endpointMap = Map();
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
    var successTpRequest =
        await pastTpRequestRate(account.currentAccount.address);
    var successTnxRate =
        await pastTnxRequestRate(account.currentAccount.address);

    var eligible =
        (0.3 * current + (0.3 * successTpRequest + 0.4 * successTnxRate) * 0.01)
            .toStringAsFixed(0);

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
    // await account.getCurrentAccount();
    String addressA = account.currentAccount.address;
    var balance = await account.getBalance();
    if (double.parse(balance) > 0) {
      bool resp = await DbHelper.verifyPartners(addressA, addressB);
      // bool resp = await tpRequest(addressA, addressB);
      print(resp);
      if (resp) {
        try {
          bool a = await Nearby().startDiscovery(
            addressA,
            strategy,
            onEndpointFound: (id, name, serviceId) {
              // called when an advertiser is found
              // show sheet automatically to request connection
              showModalBottomSheet(
                context: context,
                builder: (builder) {
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Text("id: " + id),
                        Text("Name: " + name),
                        Text("ServiceId: " + serviceId),
                        ElevatedButton(
                          child: Text("Request Connection"),
                          onPressed: () {
                            // to be called by discover whenever an endpoint is found
                            // callbacks are similar to those in startAdvertising method
                            Navigator.pop(context);
                            Nearby().requestConnection(
                              addressA,
                              id,
                              onConnectionInitiated: (id, info) {
                                onConnectionInit(id, info, context);
                              },
                              onConnectionResult: (id, status) {
                                showSnackbar(status, context);
                              },
                              onDisconnected: (id) {
                                endpointMap.remove(id);
                                showSnackbar(
                                    "Disconnected from: ${endpointMap[id].endpointName}, id $id",
                                    context);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            onEndpointLost: (id) {
              showSnackbar(
                  "Lost discovered Endpoint: ${endpointMap[id].endpointName}, id $id",
                  context);
            },
            serviceId: "com.example.dinari_wallet",
          );

          showSnackbar("DISCOVERING: " + a.toString(), context);
        } catch (e) {
          showSnackbar(e, context);
        }
        endpointMap.forEach((key, value) async {
          // String a = Random().nextInt(100).toString();
          String a = amount;

          showSnackbar(
              "Sending $a to ${value.endpointName}, id: $key", context);
          await Nearby().sendBytesPayload(key, Uint8List.fromList(a.codeUnits));
          var balance = await DbHelper.getSingleAccountBalance(
              account.currentAccount.privateKey);
          var newBalance = balance - amount;
          await DbHelper.updateBalance(
              account.currentAccount.id, newBalance.toString());
        });
        transaction.sendTransaction(addressB, amount, context);
      } else {
        await transaction.sendTransaction(addressB, amount, context);
        var balance = await account
            .getSpecificAccountBalance(account.currentAccount.privateKey);
        var newBalance = balance - amount;
        await DbHelper.updateBalance(
            account.currentAccount.id, newBalance.toString());
      }
    } else {
      print('failed');
      return 'failed';
    }
  }

  void showSnackbar(dynamic a, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  void onConnectionInit(String id, ConnectionInfo info, context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Center(
          child: Column(
            children: <Widget>[
              Text("id: " + id),
              Text("Token: " + info.authenticationToken),
              Text("Name" + info.endpointName),
              Text("Incoming: " + info.isIncomingConnection.toString()),
              ElevatedButton(
                child: Text("Accept Connection"),
                onPressed: () {
                  Navigator.pop(context);
                  endpointMap[id] = info;
                  Nearby().acceptConnection(
                    id,
                    onPayLoadRecieved: (endid, payload) async {
                      if (payload.type == PayloadType.BYTES) {
                        String str = String.fromCharCodes(payload.bytes);
                        showSnackbar(endid + ": " + str, context);

                        if (str.contains(':')) {
                          // used for file payload as file payload is mapped as
                          // payloadId:filename
                          int payloadId = int.parse(str.split(':')[0]);
                          String fileName = (str.split(':')[1]);

                          if (map.containsKey(payloadId)) {
                            if (tempFileUri != null) {
                              moveFile(tempFileUri, fileName, context);
                            } else {
                              showSnackbar("File doesn't exist", context);
                            }
                          } else {
                            //add to map if not already
                            map[payloadId] = fileName;
                          }
                        }
                      } else if (payload.type == PayloadType.FILE) {
                        showSnackbar(
                            endid + ": File transfer started", context);
                        tempFileUri = payload.uri;
                      }
                    },
                    onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                      if (payloadTransferUpdate.status ==
                          PayloadStatus.IN_PROGRESS) {
                        print(payloadTransferUpdate.bytesTransferred);
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.FAILURE) {
                        print("failed");
                        showSnackbar(
                            endid + ": FAILED to transfer file", context);
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.SUCCESS) {
                        showSnackbar(
                            "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}",
                            context);

                        if (map.containsKey(payloadTransferUpdate.id)) {
                          //rename the file now
                          String name = map[payloadTransferUpdate.id];
                          moveFile(tempFileUri, name, context);
                        } else {
                          //bytes not received till yet
                          map[payloadTransferUpdate.id] = "";
                        }
                      }
                    },
                  );
                },
              ),
              ElevatedButton(
                child: Text("Reject Connection"),
                onPressed: () async {
                  Navigator.pop(context);
                  try {
                    await Nearby().rejectConnection(id);
                  } catch (e) {
                    showSnackbar(e, context);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool> moveFile(String uri, String fileName, context) async {
    String parentDir = (await getExternalStorageDirectory()).absolute.path;
    final b =
        await Nearby().copyFileAndDeleteOriginal(uri, '$parentDir/$fileName');

    showSnackbar("Moved file:" + b.toString(), context);
    return b;
  }
}
