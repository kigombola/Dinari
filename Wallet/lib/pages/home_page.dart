// ignore_for_file: missing_return

import 'dart:async';
import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:dinari_wallet/components/bottomsheet.dart';
import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/pages/drawer.dart';
import 'package:dinari_wallet/pages/receiveTransaction.dart';
import 'package:dinari_wallet/pages/sendtransaction.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:dinari_wallet/provider/transaction.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:nearby_connections/nearby_connections.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var name;
  var address;
  var balance;
  var accountId;
  var netName;
  var transaAmount;
  var transaStatus;
  var transaTime;
  var netWorkName = '';
  String updatedTime;
  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        getLocation();
        // await Nearby().checkLocationEnabled();
        // await Nearby().enableLocationServices();
        // await Nearby().askLocationPermission();
        await Nearby().askExternalStoragePermission();

        SharedPreferences pref = await SharedPreferences.getInstance();
        var accId = (pref.getString('account_id'));
        var account = await DbHelper.getSingleAccount(accId);
        Provider.of<TransactionProvider>(context, listen: false)
            .showTransactions(account['address']);
        var acc = Provider.of<GenerateAccountProvider>(context, listen: false);
        Timer.periodic(Duration(seconds: 5), (timer) async {
          await acc.getAccount();
          await acc.getCurrentAccount();
          await acc.updateAccounts();
          final SharedPreferences sp = await SharedPreferences.getInstance();
          setState(() {
            name = acc.currentAccount.name;
            balance = acc.currentAccount.balance;
            address = acc.currentAccount.address;
            accountId = acc.currentAccount.id;
            netWorkName = sp.getString('network_name');
          });
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

  void getLocation() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
  }

  String subAddress(String addrs) {
    int length = addrs.length;
    String first = addrs.substring(0, 15);
    String last = addrs.substring(length - 15, length);
    String text = '$first........$last';
    return text;
  }

  String subAddress2(String addrs) {
    int length = addrs.length;
    String first = addrs.substring(0, 5);
    String last = addrs.substring(length - 5, length);
    String text = '$first........$last';
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final accountList = Provider.of<GenerateAccountProvider>(context);
    final currentAccount = Provider.of<GenerateAccountProvider>(context);
    final trans = Provider.of<TransactionProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Pallete.colorBlue),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(right: 60),
          child: Center(
            child: SizedBox(
              height: 30,
              width: 35,
              child: Image(image: AssetImage('assets/images/logo.png')),
            ),
          ),
        ),
      ),
      drawer: const HomeDrawer(),
      body: currentAccount.currentAccount == null
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blue),
            )
          : RefreshIndicator(
              onRefresh: () async {
                return Future.delayed(
                  const Duration(seconds: 1),
                  () {
                    refreshBalance();
                  },
                );
              },
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${AppLocalizations.of(context).connectedTo}: ",
                            style: const TextStyle(fontSize: 19),
                          ),
                          Text(
                            netWorkName,
                            style: TextStyle(fontSize: 19),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      GestureDetector(
                        onTap: () async {
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 160),
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
                                            itemCount:
                                                accountList.accountItem.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return GestureDetector(
                                                onTap: () async {
                                                  accountList.setCurrentAccount(
                                                      accountList
                                                          .accountItem[index]
                                                          .id);
                                                  trans.showTransactions(
                                                      accountList
                                                          .accountItem[index]
                                                          .address);
                                                  // setState(() {
                                                  //   // trans.showTransactions(
                                                  //   //     accountList
                                                  //   //         .accountItem[index]
                                                  //   //         .address);
                                                  //   name = accountList
                                                  //       .accountItem[index]
                                                  //       .name;
                                                  //   balance = accountList
                                                  //       .accountItem[index]
                                                  //       .balance;
                                                  //   address = accountList
                                                  //       .accountItem[index]
                                                  //       .address;

                                                  //   accountId = accountList
                                                  //       .accountItem[index].id;
                                                  // });
                                                  Navigator.pop(context);
                                                },
                                                child: ListTile(
                                                    leading: Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Pallete
                                                                  .colorBlue,
                                                              width: 1),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30)),
                                                      child: const CircleAvatar(
                                                        radius: 15,
                                                        backgroundColor:
                                                            Colors.grey,
                                                        child: Icon(
                                                          Icons.person,
                                                        ),
                                                      ),
                                                    ),
                                                    title: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                      child: Text(accountList
                                                          .accountItem[index]
                                                          .name),
                                                    ),
                                                    subtitle: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          subAddress(accountList
                                                              .accountItem[
                                                                  index]
                                                              .address),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 12),
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                accountList
                                                                    .accountItem[
                                                                        index]
                                                                    .balance
                                                                    .toString(),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            12),
                                                              ),
                                                              const Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5),
                                                                child: Text(
                                                                  'DNR',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    trailing: accountList
                                                                .accountItem[
                                                                    index]
                                                                .id ==
                                                            accountList
                                                                .currentAccount
                                                                .id
                                                        ? const CircleAvatar(
                                                            radius: 10,
                                                            backgroundColor:
                                                                Pallete
                                                                    .colorBlue,
                                                            child: Icon(
                                                              Icons.check,
                                                              color:
                                                                  Colors.white,
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
                                            child: Stack(
                                              children: [
                                                Center(
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            primary: Pallete
                                                                .colorBlue),
                                                    onPressed: (() async {
                                                      accountList.loading =
                                                          false;
                                                      accountList.generateKey();
                                                      accountList.loading =
                                                          true;
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  const HomePage()));
                                                      showSheet(context);
                                                    }),
                                                    child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .addAccount,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 30,
                                                  bottom: 0,
                                                  top: 0,
                                                  child: (accountList.isLoading)
                                                      ? Center(
                                                          child: SizedBox(
                                                            height: 10,
                                                            width: 10,
                                                            child: Theme(
                                                              data: ThemeData(
                                                                primaryColor:
                                                                    const Color(
                                                                        0xFFFFFFFF),
                                                              ),
                                                              child:
                                                                  const CircularProgressIndicator(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  Pallete
                                                                      .colorBlue,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                )
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                )),
                              );
                            },
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              // name ?? '',
                              currentAccount.currentAccount.name,
                              style: const TextStyle(
                                  fontSize: 20, color: Pallete.colorBlue),
                            ),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              currentAccount.currentAccount.balance,
                              style: const TextStyle(
                                fontSize: 28,
                                color: Colors.grey,
                              ),
                            ),
                            const Text(
                              'DNR',
                              style: TextStyle(
                                fontSize: 28,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      GestureDetector(
                        onTap: () {
                          FlutterClipboard.copy(
                                  currentAccount.currentAccount.address)
                              .then(
                            (value) {
                              showModalBottomSheet(
                                  backgroundColor: Colors.black,
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          Icons.check,
                                          size: 150,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 8),
                                          child: Text(
                                            'Address copied',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                          );
                        },
                        child: Container(
                          width: 110,
                          height: 23,
                          decoration: BoxDecoration(
                            // border: Border.all(
                            //     ),
                            borderRadius: BorderRadius.circular(50),
                            color: Color.fromARGB(255, 68, 142, 202),
                          ),
                          child: Center(
                            child: Text(
                              subAddress2(accountList.currentAccount.address),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(97, 250, 245, 245),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: CircleAvatar(
                                  radius: 20,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_downward,
                                    ),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const ReceivePayment();
                                      }));
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                AppLocalizations.of(context).receive,
                                style: const TextStyle(
                                    color: Pallete.colorBlue, fontSize: 16),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: CircleAvatar(
                                  radius: 20,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.arrow_upward,
                                    ),
                                    onPressed: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return const SendPayment();
                                      }));
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                AppLocalizations.of(context).send,
                                style: const TextStyle(
                                    color: Pallete.colorBlue, fontSize: 16),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Text(
                              AppLocalizations.of(context).recentTransa,
                              style: const TextStyle(fontSize: 18),
                            ),
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      trans.transactions.isEmpty
                          ? SizedBox(
                              height: 150,
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context).noTransa,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            )
                          : trans.transactions == null
                              ? SizedBox(
                                  height: 150,
                                  child: Center(
                                      child: CircularProgressIndicator()),
                                )
                              : SizedBox(
                                  height: 500,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: trans.transactions.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        var inputDate = DateTime.parse(trans
                                            .transactions[index]
                                            .confirmationTime);
                                        var outputFormat =
                                            DateFormat('dd/MM/yyyy hh:mm:ss a');
                                        var outputDate =
                                            outputFormat.format(inputDate);
                                        var receivedTime1 = DateTime.parse(
                                            trans.transactions[index].receivedTime);
                                        var receivedTime2 =
                                            outputFormat.format(receivedTime1);

                                        return ListTile(
                                          leading: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Pallete.colorBlue,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(30)),
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.grey,
                                              child: trans.transactions[index]
                                                          .address ==
                                                      currentAccount
                                                          .currentAccount
                                                          .address
                                                  ? Icon(
                                                      Icons.arrow_upward,
                                                    )
                                                  : Icon(
                                                      Icons.arrow_downward,
                                                    ),
                                            ),
                                          ),
                                          title: trans.transactions[index]
                                                      .address ==
                                                  currentAccount
                                                      .currentAccount.address
                                              ? Text(
                                                  trans.transactions[index]
                                                          .amount
                                                          .toString() +
                                                      ' ' +
                                                      "DNR",
                                                  style: const TextStyle(
                                                      color: Pallete.colorRed,
                                                      fontSize: 13),
                                                )
                                              : Text(
                                                  trans.transactions[index]
                                                          .amount
                                                          .toString() +
                                                      ' ' +
                                                      "DNR",
                                                  style: const TextStyle(
                                                      color: Pallete.colorGreen,
                                                      fontSize: 13),
                                                ),
                                          subtitle: Column(
                                            children: [
                                              // Text(
                                              //   trans.transactions[index]
                                              //               .address ==
                                              //           currentAccount
                                              //               .currentAccount
                                              //               .address
                                              //       ? 'sent'
                                              //       : "receive",
                                              //   style: const TextStyle(
                                              //       fontSize: 10,
                                              //       color:
                                              //           Pallete.colorBlack,
                                              //       fontStyle:
                                              //           FontStyle.italic),
                                              // ),
                                              Row(
                                                children: [
                                                  Text('Path: ',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Pallete.colorBlack,
                                                      )),
                                                  Text(
                                                      trans.transactions[index]
                                                          .channel,
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Pallete
                                                              .colorBlack,
                                                          fontStyle:
                                                              FontStyle.italic))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('Sent: ',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Pallete.colorBlack,
                                                      )),
                                                  Text(outputDate ?? '',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Pallete
                                                              .colorBlack,
                                                          fontStyle:
                                                              FontStyle.italic))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('Received: ',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Pallete.colorBlack,
                                                      )),
                                                  Text(receivedTime2 ?? '',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Pallete
                                                              .colorBlack,
                                                          fontStyle:
                                                              FontStyle.italic))
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Text('Recipient: ',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Pallete.colorBlack,
                                                      )),
                                                  Text(trans.transactions[index].otherEndAddress ?? '',
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Pallete
                                                              .colorBlack,
                                                          fontStyle:
                                                              FontStyle.italic))
                                                ],
                                              ),
                                              // Padding(
                                              //   padding:
                                              //       EdgeInsets.only(right: 7),
                                              //   child: Text(
                                              //     outputDate,
                                              //     style: TextStyle(
                                              //         fontSize: 10,
                                              //         color: Pallete.colorBlack,
                                              //         fontStyle:
                                              //             FontStyle.italic),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          // trailing: Text(
                                          //   trans.transactions[index].channel,
                                          //   style: TextStyle(
                                          //       fontSize: 7,
                                          //       fontStyle: FontStyle.italic),
                                          // ),
                                        );
                                      }),
                                ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
