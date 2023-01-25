// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:ui';

import 'package:dinari_wallet/components/bottomsheet.dart';
import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/models/transaction.dart';
import 'package:dinari_wallet/pages/drawer.dart';
import 'package:dinari_wallet/pages/home_page.dart';
import 'package:dinari_wallet/pages/sendPartnershipRequest_page.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:dinari_wallet/provider/partnership.dart';
import 'package:dinari_wallet/provider/routing.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrustPartnership extends StatefulWidget {
  const TrustPartnership({Key key}) : super(key: key);

  @override
  State<TrustPartnership> createState() => _TrustPartnershipState();
}

class _TrustPartnershipState extends State<TrustPartnership> {
  final Strategy strategy = Strategy.P2P_CLUSTER;
  Map<String, ConnectionInfo> endpointMap = Map();
  var name;
  var address;
  var balance;
  var accountId;
  var privateKey;
  bool isSwitched = false;
  String destination_address;
  String connected_devices = '0';
  @override
  void initState() {
    super.initState();
    // getLocation();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await Nearby().askLocationPermission();
        var acc = Provider.of<GenerateAccountProvider>(context, listen: false);
        var routing = Provider.of<RoutingProvider>(context, listen: false);
        var patnership =
            Provider.of<PartnershipTrustProvider>(context, listen: false);
        await patnership.showPartnerships();
        await acc.getCurrentAccount();
        await acc.getAccount();

        // await Nearby().checkLocationEnabled();
        // await Nearby().enableLocationServices();
        setState(() {
          name = acc.currentAccount.name;
          balance = acc.currentAccount.balance;
          address = acc.currentAccount.address;
          accountId = acc.currentAccount.id;
          privateKey = acc.currentAccount.privateKey;

          isSwitched = patnership.isPatnershipOn;
          connected_devices = routing.endPointMap?.length.toString();
        });
      },
    );
  }

  refreshBalance() async {
    var acc = Provider.of<GenerateAccountProvider>(context, listen: false);
    await acc.getCurrentAccount();

    setState(() {
      balance = acc.currentAccount.balance;
    });
  }

  String subAddress(String addrs) {
    int length = addrs.length;
    String first = addrs.substring(0, 15);
    String last = addrs.substring(length - 15, length);

    String text = '$first........$last';

    return text;
  }

  @override
  Widget build(BuildContext context) {
    final accountList = Provider.of<GenerateAccountProvider>(context);
    final patnership = Provider.of<PartnershipTrustProvider>(context);
    final routing = Provider.of<RoutingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Pallete.colorBlue),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(left: 103),
          child: SizedBox(
            height: 35,
            width: 35,
            child: Image(image: AssetImage('assets/images/logo.png')),
          ),
        ),
      ),
      drawer: const HomeDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text(
                  AppLocalizations.of(context).trustPartner,
                  style: TextStyle(fontSize: 23),
                ),
                Transform.scale(
                  scale: 1,
                  child: Switch(
                    value: isSwitched,
                    onChanged: (value) async {
                      setState(() {
                        isSwitched = value;
                        patnership.switchPatnership(value);
                        print(value);
                      });

                      if (isSwitched) {
                        // start advertising
                        try {
                          bool a = await Nearby().startAdvertising(
                            accountList.currentAccount.address,
                            strategy,
                            onConnectionInitiated:
                                onConnectionInit, // Called whenever a discoverer requests connection
                            onConnectionResult: (id, status) {
                              setState(() {
                                if (status.name == 'CONNECTED') {
                                  // connected_devices =
                                  //     endpointMap.length.toString();
                                  stopBroadcasting();
                                }
                              });
                              showSnackbar('${status}');
                              print("patner status");
                              print(status.name);
                              print('endpointmap weeeeeee ');
                              print(endpointMap);
                              print(accountList.currentAccount.address);
                              print(endpointMap[id].endpointName);
                              routing.setEndpointMap(endpointMap);
                              setState(() {
                                endpointMap = endpointMap;
                              });

                              print('SUCCESSFULLY MLANGALI');
                            }, // Called when connection is accepted/rejected
                            onDisconnected: (id) {
                              showSnackbar(
                                  "Disconnected: ${endpointMap[id].endpointName}, id $id");
                              setState(() {
                                endpointMap.remove(id);
                                // connected_devices =
                                //     endpointMap.length.toString();
                              });
                            },
                            serviceId:
                                "com.example.dinari_wallet", // uniquely identifies your app
                          );
                          showSnackbar("ADVERTISING: " + a.toString());
                        } catch (exception) {
                          showSnackbar(exception);
                        }

                        // start discovery
                        try {
                          bool a = await Nearby().startDiscovery(
                            accountList.currentAccount.address,
                            strategy,
                            onEndpointFound: (id, name, serviceId) async {
                              // called when an advertiser is found
                              Nearby().requestConnection(
                                // accountList.currentAccount.address,
                                name,
                                id,
                                onConnectionInitiated: (id, info) {
                                  onConnectionInit(id, info);
                                },
                                onConnectionResult: (id, status) async {
                                  setState(() {
                                    if (status.name == 'CONNECTED') {
                                      // connected_devices =
                                      //     endpointMap.length.toString();
                                      stopBroadcasting();
                                    }
                                  });
                                  print("status 22");
                                  print(status);
                                  print('endpointmap weeeeeee ');
                                  print(endpointMap);
                                  print(accountList.currentAccount.address);
                                  print(endpointMap[id].endpointName);
                                  routing.setEndpointMap(endpointMap);
                                  // setState(() {
                                  //   endpointMap = endpointMap;
                                  // });

                                  showSnackbar(status);
                                  if (status != null) {
                                    // patnership.savePartnership(
                                    //   address:
                                    //       accountList.currentAccount.address,
                                    //   partnerAddress:
                                    //       endpointMap[id].endpointName,
                                    //   status: status.name == 'CONNECTED'
                                    //       ? 'paired'
                                    //       : 'not paired',
                                    //   pairing_time:
                                    //       DateTime.now().toIso8601String(),
                                    // );
                                  }
                                },
                                onDisconnected: (id) {
                                  setState(() {
                                    endpointMap.remove(id);
                                    // connected_devices =
                                    //     endpointMap.length.toString();
                                  });
                                  showSnackbar(
                                      "Disconnected from: ${endpointMap[id].endpointName}, id $id");
                                },
                              );
                            },
                            onEndpointLost: (id) {
                              showSnackbar(
                                  "Lost discovered Endpoint: ${endpointMap[id].endpointName}, id $id");
                            },
                            serviceId: "com.example.dinari_wallet",
                          );

                          showSnackbar("DISCOVERING: " + a.toString());
                        } catch (e) {
                          showSnackbar(e);
                        }
                      } else {
                        await Nearby().stopAllEndpoints();
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 250,
                        child: Center(
                            child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 160),
                              child: GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Divider(
                                  endIndent: 5,
                                  color: Colors.grey[300],
                                  thickness: 2,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: 180,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: accountList.accountItem.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return GestureDetector(
                                        onTap: () {
                                          accountList.setCurrentAccount(
                                              accountList
                                                  .accountItem[index].id);
                                          setState(() {
                                            print(accountList
                                                .accountItem[index].id);
                                            name = accountList
                                                .accountItem[index].name;
                                            balance = accountList
                                                .accountItem[index].balance;
                                            address = accountList
                                                .accountItem[index].address;

                                            accountId = accountList
                                                .accountItem[index].id;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: ListTile(
                                            leading: Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Pallete.colorBlue,
                                                      width: 1),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                              child: const CircleAvatar(
                                                radius: 15,
                                                backgroundColor: Colors.grey,
                                                child: Icon(
                                                  Icons.person,
                                                ),
                                              ),
                                            ),
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5),
                                              child: Text(accountList
                                                  .accountItem[index].name),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  subAddress(accountList
                                                      .accountItem[index]
                                                      .address),
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      accountList
                                                          .accountItem[index]
                                                          .balance
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 12),
                                                    ),
                                                    const Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5),
                                                      child: Text(
                                                        'DNR',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            trailing: accountList
                                                        .accountItem[index]
                                                        .id ==
                                                    accountId
                                                ? const CircleAvatar(
                                                    radius: 10,
                                                    backgroundColor:
                                                        Pallete.colorBlue,
                                                    child: Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 15,
                                                    ),
                                                  )
                                                : const Text('')),
                                      );
                                    }),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 5),
                                child: SizedBox(
                                  height: 30,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Pallete.colorBlue),
                                    onPressed: (() async {
                                      accountList.generateKey();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const HomePage()));
                                      showSheet(context);
                                    }),
                                    child: Text(
                                      AppLocalizations.of(context).addAccount,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                      );
                    },
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      Text(
                        accountList.currentAccount.name ?? '',
                        style: const TextStyle(
                            fontSize: 18, color: Pallete.colorBlue),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      )
                    ],
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    SizedBox(
                      height: 35,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Pallete.colorBlue),
                        onPressed: (() {
                          print('endpointMap is: ');
                          print(routing.endPointMap);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return SendPartnershipRequest(
                              endpointMap: routing.endPointMap,
                            );
                          }));
                        }),
                        child: Text(
                          AppLocalizations.of(context).newRequest,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Colors.white, fontSize: 17),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                          "Number of connected devices: ${routing.endPointMap != null ? routing.endPointMap.length.toString() : '0'}"),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            patnership.partners.isEmpty
                ? Center(
                    child: Text(
                      AppLocalizations.of(context).noPaired,
                      style:
                          TextStyle(fontSize: 9, fontStyle: FontStyle.italic),
                    ),
                  )
                : patnership.partners == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: patnership.partners.length,
                            itemBuilder: (BuildContext context, int index) {
                              var inputDate = DateTime.parse(
                                  patnership.partners[index].pairingTime);
                              var outputFormat = DateFormat('dd/MM/yyyy hh:mm');
                              var outputDate = outputFormat.format(inputDate);
                              return ListTile(
                                leading: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Pallete.colorBlue, width: 1),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: const CircleAvatar(
                                    radius: 15,
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                                title: Text(
                                  patnership.partners[index].partnerAddress ??
                                      '',
                                  style: TextStyle(
                                      color: Pallete.colorGreen, fontSize: 13),
                                ),
                                subtitle: Row(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 7),
                                      child: Text(
                                        patnership.partners[index].status ?? '',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Pallete.colorBlack,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 7),
                                      child: Text(
                                        outputDate ?? '',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Pallete.colorBlack,
                                            fontStyle: FontStyle.italic),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
          ],
        ),
      ),
    );
  }

  void showSnackbar(dynamic a) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(a.toString()),
    ));
  }

  /// Called upon Connection request (on both devices)
  /// Both need to accept connection to start sending/receiving
  void onConnectionInit(String id, ConnectionInfo info) {
    setState(() {
      endpointMap[id] = info;
    });

    Nearby().acceptConnection(
      id,
      onPayLoadRecieved: (endid, payload) async {
        if (payload.type == PayloadType.BYTES) {
          String str = String.fromCharCodes(payload.bytes);
          setState(() {
            destination_address = str;
          });
          showSnackbar(endid + ": " + str);

          if (str.contains(':')) {
            // used for file payload as file payload is mapped as
            // payloadId:filename
            int payloadId = int.parse(str.split(':')[0]);
            String fileName = (str.split(':')[1]);
          }
        } else if (payload.type == PayloadType.FILE) {
          showSnackbar(endid + ": File transfer started");
        }
      },
      onPayloadTransferUpdate: (endid, payloadTransferUpdate) async {
        if (payloadTransferUpdate.status == PayloadStatus.IN_PROGRESS) {
          print(payloadTransferUpdate.bytesTransferred);
        } else if (payloadTransferUpdate.status == PayloadStatus.FAILURE) {
          print("failed");
          showSnackbar(endid + ": FAILED to transfer file");
        } else if (payloadTransferUpdate.status == PayloadStatus.SUCCESS) {
          print('heloooo');
          if (payloadTransferUpdate.totalBytes == 42) {
            print(await checkDestinationAddress(destination_address));
            if (await checkDestinationAddress(destination_address) == true) {
              print('oyaaaaaaa');
              showModalBottomSheet(
                context: context,
                builder: (builder) {
                            final patnership = Provider.of<PartnershipTrustProvider>(context);
                  return Center(
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          child: Text("Accept Request"),
                          onPressed: () {
                            patnership.savePartnership(
                                      address:
                                          address,
                                      partnerAddress:
                                          endpointMap[id].endpointName,
                                      status: 'paired',
                                      pairing_time:
                                          DateTime.now().toIso8601String(),
                                    );
                            Navigator.pop(context);
                            setState(() {});
                          },
                        ),
                        ElevatedButton(
                          child: Text("Reject request"),
                          onPressed: () async {
                            patnership.savePartnership(
                                      address:
                                          address,
                                      partnerAddress:
                                          endpointMap[id].endpointName,
                                      status: 'not paired',
                                      pairing_time:
                                          DateTime.now().toIso8601String(),
                                    );
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          } else {
            print('weweeeeeeeeeeeeeeeeeeee');
            print(payloadTransferUpdate.bytesTransferred);
            // Updating account balance
            var balance = await DbHelper.getSingleAccountBalance(privateKey);
            var newBalance = double.parse(balance) -
                payloadTransferUpdate.bytesTransferred.toDouble();
            await DbHelper.updateBalance(accountId, newBalance.toString());
          }
          final SharedPreferences sp = await SharedPreferences.getInstance();
          final tmodel = TransactionModel(
              address: address,
              otherEndAddress: destination_address,
              amount: payloadTransferUpdate.bytesTransferred.toDouble(),
              confirmationTime: DateTime.now().toIso8601String(),
              transactionType: "sent",
              channel: "off-chain",
              status: 'new',
              accId: accountId,
              userId: sp.getString('user_id'));
          await DbHelper.sendTransaction(tmodel).then((value) {
            print(value);
          });
          showSnackbar(
              "$endid successsssss, total bytes = ${payloadTransferUpdate.totalBytes}");
        }
      },
    );
    // showModalBottomSheet(
    //   context: context,
    //   builder: (builder) {
    //     return Center(
    //       child: Column(
    //         children: <Widget>[
    //           // Text("id: " + id),
    //           // Text("Token: " + info.authenticationToken),
    //           Text(
    //             info.endpointName,
    //             style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    //           ),
    //           Text("Incoming: " + info.isIncomingConnection.toString()),
    //           ElevatedButton(
    //             child: Text("Accept Connection"),
    //             onPressed: () {
    //               Navigator.pop(context);
    //               setState(() {
    //                 endpointMap[id] = info;
    //               });

    //               Nearby().acceptConnection(
    //                 id,
    //                 onPayLoadRecieved: (endid, payload) async {
    //                   if (payload.type == PayloadType.BYTES) {
    //                     String str = String.fromCharCodes(payload.bytes);
    //                     setState(() {
    //                       destination_address = str;
    //                     });
    //                     showSnackbar(endid + ": " + str);

    //                     if (str.contains(':')) {
    //                       // used for file payload as file payload is mapped as
    //                       // payloadId:filename
    //                       int payloadId = int.parse(str.split(':')[0]);
    //                       String fileName = (str.split(':')[1]);
    //                     }
    //                   } else if (payload.type == PayloadType.FILE) {
    //                     showSnackbar(endid + ": File transfer started");
    //                   }
    //                 },
    //                 onPayloadTransferUpdate:
    //                     (endid, payloadTransferUpdate) async {
    //                   if (payloadTransferUpdate.status ==
    //                       PayloadStatus.IN_PROGRESS) {
    //                     print(payloadTransferUpdate.bytesTransferred);
    //                   } else if (payloadTransferUpdate.status ==
    //                       PayloadStatus.FAILURE) {
    //                     print("failed");
    //                     showSnackbar(endid + ": FAILED to transfer file");
    //                   } else if (payloadTransferUpdate.status ==
    //                       PayloadStatus.SUCCESS) {
    //                         print('heloooo');
    //                         print(await checkDestinationAddress(
    //                         destination_address));
    //                     if (await checkDestinationAddress(
    //                         destination_address) == true) {
    //                           print('oyaaaaaaa');
    //                       showModalBottomSheet(
    //                         context: context,
    //                         builder: (builder) {
    //                           return Center(
    //                             child: Column(
    //                               children: <Widget>[
    //                                 ElevatedButton(
    //                                   child: Text("Accept Request"),
    //                                   onPressed: () {
    //                                     Navigator.pop(context);
    //                                     setState(() {});
    //                                   },
    //                                 ),
    //                                 ElevatedButton(
    //                                   child: Text("Reject request"),
    //                                   onPressed: () async {
    //                                     Navigator.pop(context);
    //                                     // try {
    //                                     //   await Nearby().rejectConnection(id);
    //                                     // } catch (e) {
    //                                     //   showSnackbar(e);
    //                                     // }
    //                                   },
    //                                 ),
    //                               ],
    //                             ),
    //                           );
    //                         },
    //                       );
    //                     }
    //                     showSnackbar(
    //                         "$endid successsssss, total bytes = ${payloadTransferUpdate.totalBytes}");
    //                   }
    //                 },
    //               );
    //             },
    //           ),
    //           ElevatedButton(
    //             child: Text("Reject Connection"),
    //             onPressed: () async {
    //               Navigator.pop(context);
    //               try {
    //                 await Nearby().rejectConnection(id);
    //               } catch (e) {
    //                 showSnackbar(e);
    //               }
    //             },
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    // );
  }

  checkDestinationAddress(String address) async {
    final data = await DbHelper.checkAddress(address);

    if (data != 0) {
      return true;
    } else {
      return false;
    }
  }

  void stopBroadcasting() async {
    await Nearby().stopDiscovery();
    // await Nearby().stopAdvertising();
  }

}