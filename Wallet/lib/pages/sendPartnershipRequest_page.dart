import 'dart:async';
import 'dart:typed_data';
// import 'dart:html';

import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/pages/drawer.dart';
import 'package:dinari_wallet/pages/trustPartnership_page.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:dinari_wallet/provider/partnership.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SendPartnershipRequest extends StatefulWidget {
  final Map<String, ConnectionInfo> endpointMap;
  const SendPartnershipRequest({Key key, this.endpointMap}) : super(key: key);

  @override
  State<SendPartnershipRequest> createState() => _SendPartnershipRequestState();
}

class _SendPartnershipRequestState extends State<SendPartnershipRequest> {
  
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final Strategy strategy = Strategy.P2P_CLUSTER;
  // Map<String, ConnectionInfo> endpointMap;
  final TextEditingController _dest_address = TextEditingController();
  Timer timer;

  String sender_address;
  

  @override
  void initState() {
    super.initState();
    print('widget.endpointMap');
    print(widget.endpointMap);
    // timerDelay();

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        var acc = Provider.of<GenerateAccountProvider>(context, listen: false);
        acc.getAccount();
        acc.getCurrentAccount();
        //  await Nearby().checkLocationEnabled();
        await Nearby().enableLocationServices();
      },
    );
  }

  // Future<void> timerDelay() async {
  //   timer = Timer.periodic(Duration(seconds: 180), (timer) async {
  //     await Nearby().stopAllEndpoints();
  //   });
  // }

  // void getLocation() async {
  //   print('mlangali location');
  //   var permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {

  //       return Future.error('Location permissions are denied');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final accountList = Provider.of<GenerateAccountProvider>(context);
    final partnership = Provider.of<PartnershipTrustProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const TrustPartnership();
                })),
            icon: Icon(
              Icons.arrow_back_ios,
              color: Pallete.colorBlue,
              size: 20,
            )),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                 Text(
                  AppLocalizations.of(context).partnershipRequest,
                  style: TextStyle(fontSize: 22, color: Pallete.colorBlue),
                ),
                const SizedBox(
                  height: 22,
                ),
                Row(
                  children: [
                     Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        AppLocalizations.of(context).from,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                        width: 250,
                        child: Text(
                          accountList.currentAccount.address,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 28.0),
                          child: TextFormField(
                            controller: _dest_address,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).enterDestination,
                              labelStyle: const TextStyle(fontSize: 10),
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Pallete.colorBlue),
                            onPressed: (() async {
                              print(widget.endpointMap);
                              widget.endpointMap.forEach((key, value) async {
                                print(key);
                                showSnackbar("Sending ${_dest_address.text}");
                                await Nearby().sendBytesPayload(
                                    key,
                                    Uint8List.fromList(
                                        _dest_address.text.codeUnits));
                                
                              });
                              receivePayloadData;
                              //   try {
                              //     setState(() {
                              //       sender_address = accountList.currentAccount.address;
                              //     });
                              //     bool a = await Nearby().startAdvertising(
                              //       accountList.currentAccount.address,
                              //       strategy,
                              //       onConnectionInitiated:
                              //           onConnectionInit, // Called whenever a discoverer requests connection
                              //       onConnectionResult: (id, status) {
                              //         showSnackbar('${status}');
                              //         print("patner status");
                              //         print(status.name);
                              //         print(accountList.currentAccount.address);
                              //         print(endpointMap[id].endpointName);

                              //         partnership.sendPartnershipRequest(
                              //           address:
                              //               accountList.currentAccount.address,
                              //           partnerAddress: _dest_address.text,
                              //               // endpointMap[id].endpointName,
                              //           status: status.name,
                              //         );
                              //         print('SUCCESSFULLY MLANGALI');
                              //       }, // Called when connection is accepted/rejected
                              //       onDisconnected: (id) {
                              //         showSnackbar(
                              //             "Disconnected: ${endpointMap[id].endpointName}, id $id");
                              //         setState(() {
                              //           endpointMap.remove(id);
                              //         });
                              //       },
                              //       serviceId:
                              //           "com.example.dinari_wallet", // uniquely identifies your app
                              //     );
                              //     showSnackbar("ADVERTISING: " + a.toString());
                              //   } catch (exception) {
                              //     showSnackbar(exception);
                              //   }
                            }),
                            child: Text(
                              AppLocalizations.of(context).send,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.white, fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                    ),
                  ),
                ),
              ],
            ),
          ),
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
  void onConnectionInit(String id, ConnectionInfo info) async {
    receivePayloadData(id, info);
  }

  void receivePayloadData(String id, info) {
    print('receiving');
    Nearby().acceptConnection(id, onPayLoadRecieved: (endid, payload) async {
      print('receiving in');
      if (payload.type == PayloadType.BYTES) {
        String str = String.fromCharCodes(payload.bytes);
        showSnackbar(endid + ": " + str);
        // if(await checkDestinationAddress(str)) {
          showBottomSheet(id, info);
        // }

        if (str.contains(':')) {
          // used for file payload as file payload is mapped as
          // payloadId:filename
          int payloadId = int.parse(str.split(':')[0]);
          String fileName = (str.split(':')[1]);
        }
      } else if (payload.type == PayloadType.FILE) {
        showSnackbar(endid + ": File transfer started");
      }
    });
  }

  void showBottomSheet(String id, info) async {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Center(
          child: Column(
            children: <Widget>[
              // Text("id: " + id),
              // Text("Token: " + info.authenticationToken),
              Text(
                info.endpointName,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              Text("Incoming: " + info.isIncomingConnection.toString()),
              ElevatedButton(
                child: Text("Accept Connection"),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    widget.endpointMap[id] = info;
                  });

                  Nearby().acceptConnection(
                    id,
                    onPayLoadRecieved: (endid, payload) async {
                      if (payload.type == PayloadType.BYTES) {
                        String str = String.fromCharCodes(payload.bytes);
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
                    onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
                      if (payloadTransferUpdate.status ==
                          PayloadStatus.IN_PROGRESS) {
                        print(payloadTransferUpdate.bytesTransferred);
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.FAILURE) {
                        print("failed");
                        showSnackbar(endid + ": FAILED to transfer file");
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.SUCCESS) {
                        showSnackbar(
                            "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");
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
                    showSnackbar(e);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  checkDestinationAddress(String address) async {
    final data = await DbHelper.checkAddress(address);
    if(data == 1) {
      return true;
    } else {
      return false;
    }
  }
}
