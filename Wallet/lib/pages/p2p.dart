



// import 'dart:math';
// import 'dart:typed_data';

// import 'package:dinari_wallet/provider/account.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:nearby_connections/nearby_connections.dart';
// import 'package:provider/provider.dart';

// class Peer_Communication extends StatefulWidget {
  
//   // const Peer_Communication({Key key}) : super(key: key);

//   @override
//   State<Peer_Communication> createState() => _Peer_CommunicationState();
// }

// class _Peer_CommunicationState extends State<Peer_Communication> {
//   final Strategy strategy = Strategy.P2P_CLUSTER;
//   Map<String, ConnectionInfo> endpointMap = Map();

//   String tempFileUri; //reference to the file currently being transferred
//   Map<int, String> map =
//       Map();
      
//   @override
//   Widget build(BuildContext context) {
//      final accountList = Provider.of<GenerateAccountProvider>(context);
//     return Center(
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ListView(
//         children: <Widget>[
         
//           // Divider(),
//           Text("User Name: " + accountList.currentAccount.address),
//           Wrap(
//             children: <Widget>[
//               ElevatedButton(
//                 child: Text("Sending DNR"),
//                 onPressed: () async {
//                   try {
//                     bool a = await Nearby().startAdvertising(
//                       accountList.currentAccount.address,
//                       strategy,
//                       onConnectionInitiated: onConnectionInit,
//                       onConnectionResult: (id, status) {
//                         showSnackbar(status);
//                       },
//                       onDisconnected: (id) {
//                         showSnackbar(
//                             "Disconnected: ${endpointMap[id].endpointName}, id $id");
//                         setState(() {
//                           endpointMap.remove(id);
//                         });
//                       },
//                       serviceId: "com.example.dinari_wallet",
//                     );
//                     showSnackbar("ADVERTISING: " + a.toString());
//                   } catch (exception) {
//                     showSnackbar(exception);
//                   }
//                 },
//               ),
//               ElevatedButton(
//                 child: Text("Stop Advertising"),
//                 onPressed: () async {
//                   await Nearby().stopAdvertising();
//                 },
//               ),
//             ],
//           ),
//           Wrap(
//             children: <Widget>[
//               ElevatedButton(
//                 child: Text("Receiving DNR"),
//                 onPressed: () async {
//                   try {
//                     bool a = await Nearby().startDiscovery(
//                       accountList.currentAccount.address,
//                       strategy,
//                       onEndpointFound: (id, name, serviceId) {
//                         // show sheet automatically to request connection
//                         showModalBottomSheet(
//                           context: context,
//                           builder: (builder) {
//                             return Center(
//                               child: Column(
//                                 children: <Widget>[
//                                   Text("id: " + id),
//                                   Text("Name: " + name),
//                                   Text("ServiceId: " + serviceId),
//                                   ElevatedButton(
//                                     child: Text("Request Connection"),
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                       Nearby().requestConnection(
//                                         accountList.currentAccount.address,
//                                         id,
//                                         onConnectionInitiated: (id, info) {
//                                           onConnectionInit(id, info);
//                                         },
//                                         onConnectionResult: (id, status) {
//                                           showSnackbar(status);
//                                         },
//                                         onDisconnected: (id) {
//                                           setState(() {
//                                             endpointMap.remove(id);
//                                           });
//                                           showSnackbar(
//                                               "Disconnected from: ${endpointMap[id].endpointName}, id $id");
//                                         },
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         );
//                       },
//                       onEndpointLost: (id) {
//                         showSnackbar(
//                             "Lost discovered Endpoint: ${endpointMap[id].endpointName}, id $id");
//                       },
//                       serviceId: "com.example.dinari_wallet",
//                     );
                    
//                     showSnackbar("DISCOVERING: " + a.toString());
//                   } catch (e) {
//                     showSnackbar(e);
//                   }
//                 },
//               ),
//               ElevatedButton(
//                 child: Text("Stop Discovery"),
//                 onPressed: () async {
//                   await Nearby().stopDiscovery();
//                 },
//               ),
//             ],
//           ),
//           Text("Number of connected devices: ${endpointMap.length}"),
//           ElevatedButton(
//             child: Text("Stop All Endpoints"),
//             onPressed: () async {
//               await Nearby().stopAllEndpoints();
//               setState(() {
//                 endpointMap.clear();
//               });
//             },
//           ),
//           Divider(),
//           Text(
//             "Sending Data",
//           ),
//           ElevatedButton(
//             child: Text("Send Random DNR Payload"),
//             onPressed: () async {
//               endpointMap.forEach((key, value) {
//                 String a = Random().nextInt(100).toString();

//                 showSnackbar("Sending $a to ${value.endpointName}, id: $key");
//                 Nearby()
//                     .sendBytesPayload(key, Uint8List.fromList(a.codeUnits));
//               });
//             },
//           ),
          
//         ],
//       ),
//     ),
//   );
//   }

//   void showSnackbar(dynamic a) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(a.toString()),
//     ));
//   }

//   Future<bool> moveFile(String uri, String fileName) async {
//     // String parentDir = (await getExternalStorageDirectory()).absolute.path;
//     // final b =
//         // await Nearby().copyFileAndDeleteOriginal(uri, '$parentDir/$fileName');

//     // showSnackbar("Moved file:" + b.toString());
//     // return b;
//   }
//    /// Called upon Connection request (on both devices)
//   /// Both need to accept connection to start sending/receiving
//   /// 
//   void onConnectionInit(String id, ConnectionInfo info) {
//     showModalBottomSheet(
//       context: context,
//       builder: (builder) {
//         return Center(
//           child: Column(
//             children: <Widget>[
//               Text("id: " + id),
//               Text("Token: " + info.authenticationToken),
//               Text("Name" + info.endpointName),
//               Text("Incoming: " + info.isIncomingConnection.toString()),
//               ElevatedButton(
//                 child: Text("Accept Connection"),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   setState(() {
//                     endpointMap[id] = info;
//                   });
//                   Nearby().acceptConnection(
//                     id,
//                     onPayLoadRecieved: (endid, payload) async {
//                       if (payload.type == PayloadType.BYTES) {
//                         String str = String.fromCharCodes(payload.bytes);
//                         showSnackbar(endid + ": " + str);

//                         if (str.contains(':')) {
//                           // used for file payload as file payload is mapped as
//                           // payloadId:filename
//                           int payloadId = int.parse(str.split(':')[0]);
//                           String fileName = (str.split(':')[1]);

//                           if (map.containsKey(payloadId)) {
//                             if (tempFileUri = null) {
//                               moveFile(tempFileUri, fileName);
//                             } else {
//                               showSnackbar("File doesn't exist");
//                             }
//                           } else {
//                             //add to map if not already
//                             map[payloadId] = fileName;
//                           }
//                         }
//                       } else if (payload.type == PayloadType.FILE) {
//                         showSnackbar(endid + ": File transfer started");
//                         tempFileUri = payload.uri;
//                       }
//                     },
//                     onPayloadTransferUpdate: (endid, payloadTransferUpdate) {
//                       if (payloadTransferUpdate.status ==
//                           PayloadStatus.IN_PROGRESS) {
//                         print(payloadTransferUpdate.bytesTransferred);
//                       } else if (payloadTransferUpdate.status ==
//                           PayloadStatus.FAILURE) {
//                         print("failed");
//                         showSnackbar(endid + ": FAILED to transfer file");
//                       } else if (payloadTransferUpdate.status ==
//                           PayloadStatus.SUCCESS) {
//                         showSnackbar(
//                             "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");

//                         if (map.containsKey(payloadTransferUpdate.id)) {
//                           //rename the file now
//                           String name = map[payloadTransferUpdate.id];
//                           moveFile(tempFileUri, name);
//                         } else {
//                           //bytes not received till yet
//                           map[payloadTransferUpdate.id] = "";
//                         }
//                       }
//                     },
//                   );
//                 },
//               ),
//               ElevatedButton(
//                 child: Text("Reject Connection"),
//                 onPressed: () async {
//                   Navigator.pop(context);
//                   try {
//                     await Nearby().rejectConnection(id);
//                   } catch (e) {
//                     showSnackbar(e);
//                   }
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'dart:typed_data';
import 'package:dinari_wallet/provider/account.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:provider/provider.dart';

class Body extends StatefulWidget {
  @override
  _MyBodyState createState() => _MyBodyState();
}

class _MyBodyState extends State<Body> {
  // final String accountList.currentAccount.address = Random().nextInt(10000).toString();
  
  final Strategy strategy = Strategy.P2P_CLUSTER;
  Map<String, ConnectionInfo> endpointMap = Map();

  String tempFileUri; //reference to the file currently being transferred
  Map<int, String> map =
      Map();
      
          final TextEditingController _partneramountcontroller =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    final accountList = Provider.of<GenerateAccountProvider>(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
           
            Divider(),
            Text("User Account: " + accountList.currentAccount.address),
            Wrap(
              children: <Widget>[
                ElevatedButton(
                  child: Text("Sending DNR"),
                  onPressed: () async {
                    try {
                      bool a = await Nearby().startAdvertising(
                        accountList.currentAccount.address,
                        strategy,
                        onConnectionInitiated: onConnectionInit, // Called whenever a discoverer requests connection 
                        onConnectionResult: (id, status) {
                          showSnackbar(status);
                        },  // Called when connection is accepted/rejected
                        onDisconnected: (id) {
                          showSnackbar(
                              "Disconnected: ${endpointMap[id].endpointName}, id $id");
                          setState(() {
                            endpointMap.remove(id);
                          });
                        },
                        serviceId: "com.example.dinari_wallet",   // uniquely identifies your app
                      );
                      showSnackbar("ADVERTISING: " + a.toString());
                    } catch (exception) {
                      showSnackbar(exception);
                    }
                  },
                ),
                SizedBox(width: 85,),
                ElevatedButton(
                  child: Text("Stop Advertising"),
                  onPressed: () async {
                    await Nearby().stopAdvertising();
                  },
                ),
              ],
            ),
            Wrap(
              children: <Widget>[
                ElevatedButton(
                  child: Text("Receiving DNR"),
                  onPressed: () async {
                    try {
                      bool a = await Nearby().startDiscovery(
                        accountList.currentAccount.address,
                        strategy,
                        onEndpointFound: (id, name, serviceId) { // called when an advertiser is found
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
                                          accountList.currentAccount.address, 
                                          id,
                                          onConnectionInitiated: (id, info) {
                                            onConnectionInit(id, info);
                                          },
                                          onConnectionResult: (id, status) {
                                            showSnackbar(status);
                                          },
                                          onDisconnected: (id) {
                                            setState(() {
                                              // endpointMap.remove(id);
                                            });
                                            showSnackbar(
                                                "Disconnected from: ${endpointMap[id].endpointName}, id $id");
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
                              "Lost discovered Endpoint: ${endpointMap[id].endpointName}, id $id");
                        },
                        serviceId: "com.example.dinari_wallet",
                      );
                      
                      showSnackbar("DISCOVERING: " + a.toString());
                    } catch (e) {
                      showSnackbar(e);
                    }
                  },
                ),
                SizedBox(width: 85,),
                ElevatedButton(
                  child: Text("Stop Discovery"),
                  onPressed: () async {
                    await Nearby().stopDiscovery();
                  },
                ),
              ],
            ),
            Text("Number of connected devices: ${endpointMap.length}"),
            ElevatedButton(
              child: Text("Stop All Endpoints"),
              onPressed: () async {
                await Nearby().stopAllEndpoints();
                setState(() {
                  endpointMap.clear();
                });
              },
            ),
            Divider(),
            Text(
              "Sending Data",
            ),

            //text controller for amount to be sent to partner start here
              Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 25, bottom: 5),
                      child: Text(
                        'Amount',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: 210,
                      child: TextFormField(
                        validator: (value) =>
                            value.isEmpty ? 'amount is required' : null,
                        controller: _partneramountcontroller,
                        decoration: InputDecoration(
                          labelText:
                              "Enter amount here...",
                          labelStyle: const TextStyle(fontSize: 12),
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
                    )
                  ],
                ),
            ElevatedButton(
              child: Text("Send  DNR "),
              onPressed: () async { 
                endpointMap.forEach((key, value) {
                  // String a = Random().nextInt(100).toString();
                  String a = _partneramountcontroller.text; 

                  showSnackbar("Sending $a to ${value.endpointName}, id: $key");
                  Nearby()
                      .sendBytesPayload(key, Uint8List.fromList(a.codeUnits));
                });
              },
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

  Future<bool> moveFile(String uri, String fileName) async {
    String parentDir = (await getExternalStorageDirectory()).absolute.path;
    final b =
        await Nearby().copyFileAndDeleteOriginal(uri, '$parentDir/$fileName');

    showSnackbar("Moved file:" + b.toString());
    return b;
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
              Text("id: " + id),
              Text("Token: " + info.authenticationToken),
              Text("Name" + info.endpointName),
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

                          if (map.containsKey(payloadId)) {
                            if (tempFileUri != null) {
                              moveFile(tempFileUri, fileName);
                            } else {
                              showSnackbar("File doesn't exist");
                            }
                          } else {
                            //add to map if not already
                            map[payloadId] = fileName;
                          }
                        }
                      } else if (payload.type == PayloadType.FILE) {
                        showSnackbar(endid + ": File transfer started");
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
                        showSnackbar(endid + ": FAILED to transfer file");
                      } else if (payloadTransferUpdate.status ==
                          PayloadStatus.SUCCESS) {
                        showSnackbar(
                            "$endid success, total bytes = ${payloadTransferUpdate.totalBytes}");

                        if (map.containsKey(payloadTransferUpdate.id)) {
                          //rename the file now
                          String name = map[payloadTransferUpdate.id];
                          moveFile(tempFileUri, name);
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