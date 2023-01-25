import 'dart:async';
// import 'dart:html';

import 'package:dinari_wallet/pages/drawer.dart';
import 'package:dinari_wallet/pages/trustPartnership_page.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:dinari_wallet/provider/partnership.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';

class SendPartnershipRequest extends StatefulWidget {
  const SendPartnershipRequest({Key key}) : super(key: key);

  @override
  State<SendPartnershipRequest> createState() => _SendPartnershipRequestState();
}

class _SendPartnershipRequestState extends State<SendPartnershipRequest> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final Strategy strategy = Strategy.P2P_CLUSTER;
  Map<String, ConnectionInfo> endpointMap = Map();
  final TextEditingController _dest_address =  TextEditingController();
  Timer timer;
  @override
  void initState() {
    super.initState();    
    timerDelay();
    
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async{
        var acc = Provider.of<GenerateAccountProvider>(context, listen: false);
        acc.getAccount();
        acc.getCurrentAccount();
        //  await Nearby().checkLocationEnabled();
        await Nearby().enableLocationServices();
      },
    );
  }

  Future<void> timerDelay() async {
    timer = Timer.periodic(Duration(seconds: 180), (timer) async {
      await Nearby().stopAllEndpoints();
    });
  }

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
                const Text(
                  'Partnership Request',
                  style: TextStyle(fontSize: 22, color: Pallete.colorBlue),
                ),
                const SizedBox(
                  height: 22,
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Text(
                        'from',
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
                    // SizedBox(
                    //   width: 125,
                    //   child: DropdownButtonFormField<String>(
                    //     decoration: InputDecoration(
                    //       enabledBorder: OutlineInputBorder(
                    //           borderSide: const BorderSide(
                    //               color: Colors.grey, width: 1),
                    //           borderRadius: BorderRadius.circular(3)),
                    //     ),
                    //     iconEnabledColor: Pallete.colorBlue,
                    //     value: seletedAccount,
                    //     items: accounts
                    //         .map((item) => DropdownMenuItem<String>(
                    //               value: item,
                    //               child: Text(
                    //                 item,
                    //                 style: const TextStyle(
                    //                     fontSize: 14, color: Pallete.colorBlue),
                    //               ),
                    //             ))
                    //         .toList(),
                    //     onChanged: (item) => setState(() {
                    //       seletedAccount = item!;
                    //     }),
                    //   ),
                    // ),
                  ],
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                // Row(
                //   children: [
                //     const Padding(
                //       padding: EdgeInsets.only(right: 25, bottom: 5),
                //       child: Text(
                //         'to',
                //         style: TextStyle(fontSize: 16),
                //       ),
                //     ),
                //     SizedBox(
                //       width: 210,
                //       child: TextFormField(
                //         validator: (value) =>
                //             value.isEmpty ? 'recepient address required' : null,
                //         controller: _partneraddresscontroller,
                //         decoration: InputDecoration(
                //           labelText:
                //               "Search or paste recepient address here...",
                //           labelStyle: const TextStyle(fontSize: 12),
                //           fillColor: Colors.white,
                //           focusedBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(5.0),
                //             borderSide: const BorderSide(
                //               color: Colors.grey,
                //             ),
                //           ),
                //           enabledBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(5.0),
                //             borderSide: const BorderSide(
                //               color: Colors.grey,
                //               width: 1.0,
                //             ),
                //           ),
                //         ),
                //       ),
                //     )
                //   ],
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                // const Center(
                //     child: Text(
                //   'OR',
                //   style: TextStyle(fontSize: 30, color: Pallete.colorBlack),
                // )),
                // const SizedBox(
                //   height: 20,
                // ),
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 20),
                //     child: SizedBox(
                //       height: 40,
                //       width: double.infinity,
                //       child: ElevatedButton(
                //         style: ElevatedButton.styleFrom(
                //             primary: Pallete.colorBlue),
                //         onPressed: (() {
                //           // Navigator.push(context,
                //           //       MaterialPageRoute(builder: (context) {
                //           //  return   const ();
                //           //   }));
                //         }),
                //         child: Text(
                //           'Scan QR code',
                //           style: Theme.of(context)
                //               .textTheme
                //               .bodyText1
                //               .copyWith(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                // Center(
                //   child: Padding(
                //     padding: const EdgeInsets.symmetric(horizontal: 5),
                //     child: SizedBox(
                //       width: MediaQuery.of(context).size.width,
                //       height: 40,
                //       child: TextFormField(
                //         controller: _messagecontroller,
                //         decoration: InputDecoration(
                //           labelText: "Leave a recepient the message here...",
                //           labelStyle: const TextStyle(fontSize: 10),
                //           fillColor: Colors.white,
                //           focusedBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(5.0),
                //             borderSide: const BorderSide(
                //               color: Colors.grey,
                //             ),
                //           ),
                //           enabledBorder: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(5.0),
                //             borderSide: const BorderSide(
                //               color: Colors.grey,
                //               width: 1.0,
                //             ),
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _dest_address,
                          decoration: InputDecoration(
                            labelText: 'Enter Destination Address',
                            labelStyle:
                                const TextStyle(fontSize: 10),
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(5.0),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                                width: 1.0,
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
                              try {
                                bool a = await Nearby().startAdvertising(
                                  accountList.currentAccount.address,
                                  strategy,
                                  onConnectionInitiated:
                                      onConnectionInit, // Called whenever a discoverer requests connection
                                  onConnectionResult: (id, status) {
                                    showSnackbar('${status}');
                                    print("patner status");
                                    print(status.name);
                                    print(accountList.currentAccount.address); 
                                    print(endpointMap[id].endpointName);  
                                      

                                    partnership.sendPartnershipRequest( 
                                      
                                      address: accountList.currentAccount.address,
                                      partnerAddress: endpointMap[id].endpointName,
                                      status: status.name,
                                    );
                                    print('SUCCESSFULLY MLANGALI');
                                   

                                  }, // Called when connection is accepted/rejected
                                  onDisconnected: (id) {
                                    showSnackbar(
                                        "Disconnected: ${endpointMap[id].endpointName}, id $id");
                                    setState(() {
                                      endpointMap.remove(id);
                                    });
                                  },
                                  serviceId:
                                      "com.example.dinari_wallet", // uniquely identifies your app
                                );
                                showSnackbar("ADVERTISING: " + a.toString());
                              } catch (exception) {
                                showSnackbar(exception);
                              }
                              
                            }),
                            child: Text(
                              'Send',
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
                      // child: ElevatedButton( 
                        // style: ElevatedButton.styleFrom(
                        //     primary: Pallete.colorBlue), 
                        // onPressed: (() async {
                        //   try {
                        //     bool a = await Nearby().startDiscovery( 
                        //       accountList.currentAccount.address,
                        //       strategy,
                        //       onEndpointFound: (id, name, serviceId) { 
                        //         // called when an advertiser is found
                        //         // show sheet automatically to request connection
                        //         showModalBottomSheet(
                        //           context: context,
                        //           builder: (builder) {
                        //             return Center(
                        //               child: Column(
                        //                 children: <Widget>[
                        //                   SizedBox(
                        //                     height: 30,
                        //                   ),
                        //                   Text(
                        //                     "Paired Address",
                        //                     style: TextStyle(
                        //                         fontSize: 12,
                        //                         fontStyle: FontStyle.italic),
                        //                   ),
                        //                   Text(
                        //                     name,
                        //                     style: TextStyle(
                        //                         fontWeight: FontWeight.bold),
                        //                   ),
                        //                   // Text("ServiceId: " + serviceId),
                        //                   SizedBox(
                        //                     height: 20,
                        //                   ),
                        //                   ElevatedButton(
                        //                     child: Text("Request Connection"),
                        //                     onPressed: () {
                                              // to be called by discover whenever an endpoint is found
                                              // callbacks are similar to those in startAdvertising method
                                              // Navigator.pop(context);
                                              // Nearby().requestConnection(
                                                // accountList.currentAccount.address,
                                            //     name,
                                            //     id,
                                            //     onConnectionInitiated:
                                            //         (id, info) {
                                            //       onConnectionInit(id, info);
                                            //     },
                                            //     onConnectionResult:
                                            //         (id, status) {
                                            //       print("status 22");
                                            //       print(status);
                                            //       showSnackbar(status);
                                            //     },
                                            //     onDisconnected: (id) {
                                            //       setState(() {
                                            //         endpointMap.remove(id);
                                            //       });
                                            //       showSnackbar(
                                            //           "Disconnected from: ${endpointMap[id].endpointName}, id $id");
                                            //     },
                                            //   );
                                            // },
                        //                   ),
                        //                 ],
                        //               ),
                        //             );
                        //           },
                        //         );
                        //       },
                        //       onEndpointLost: (id) {
                        //         showSnackbar(
                        //             "Lost discovered Endpoint: ${endpointMap[id].endpointName}, id $id");
                        //       },
                        //       serviceId: "com.example.dinari_wallet",
                        //     );

                        //     showSnackbar("DISCOVERING: " + a.toString());
                        //   } catch (e) {
                        //     showSnackbar(e);
                        //   }
                        // }),
                        // child: Text(
                        //   'Receive request',
                        //   style: Theme.of(context)
                        //       .textTheme
                        //       .bodyText1
                        //       .copyWith(color: Colors.white, fontSize: 15),
                        // ),
                      // ),
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
  void onConnectionInit(String id, ConnectionInfo info) {
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
                    endpointMap[id] = info;
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
  
}



