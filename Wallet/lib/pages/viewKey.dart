import 'dart:ui';

import 'package:clipboard/clipboard.dart';
import 'package:dinari_wallet/components/alertDialog.dart';
import 'package:dinari_wallet/components/bottomsheet.dart';
import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/pages/drawer.dart';
import 'package:dinari_wallet/pages/home_page.dart';
import 'package:dinari_wallet/pages/receiveTransaction.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ViewKey extends StatefulWidget {
  const ViewKey({Key key}) : super(key: key);

  @override
  State<ViewKey> createState() => _ViewKeyState();
}

class _ViewKeyState extends State<ViewKey> {
  final _formKey = GlobalKey<FormState>();
  FocusNode _pinFocusNode;
  TextEditingController _pincontroller = TextEditingController();
  bool isLoading = false;
  var name;
  var address;
  var balance;
  var accountId;
  @override
  void initState() {
    super.initState();
    _pinFocusNode = FocusNode();
    _pincontroller = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        var acc = Provider.of<GenerateAccountProvider>(context, listen: false);

        await acc.getCurrentAccount();
        await acc.getAccount();
        await acc.getPrivatekey();

        setState(() {
          name = acc.currentAccount.name;
          balance = acc.currentAccount.balance;
          address = acc.currentAccount.address;
          accountId = acc.currentAccount.id;
        });
      },
    );
  }

  @override
  void dispose() {
    _pinFocusNode.dispose();
    _pincontroller.dispose();
    super.dispose();
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                                      .accountItem[index]
                                                      .balance;
                                                  address = accountList
                                                      .accountItem[index]
                                                      .address;

                                                  accountId = accountList
                                                      .accountItem[index].id;
                                                  //  currentAccount
                                                  // .getSingleAccount(accountList.accountItem[index].id);
                                                });
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
                                                                .circular(30)),
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
                                                            .accountItem[index]
                                                            .address),
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      Row(
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
                                                            padding:
                                                                EdgeInsets.only(
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
                                                              .accountItem[
                                                                  index]
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
                      child: Row(
                        children: [
                          Text(
                            accountList.currentAccount.name,
                            style: const TextStyle(
                                fontSize: 18, color: Pallete.colorBlue),
                          ),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.grey,
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Address',
                    style: TextStyle(fontSize: 15, color: Pallete.colorBlack),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                      width: 200,
                      child: Text(
                        accountList.currentAccount.address,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Pallete.colorBlue),
                          onPressed: (() {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const ReceivePayment();
                            }));
                          }),
                          child: Text(
                             AppLocalizations.of(context).share,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Private key',
                    style: TextStyle(fontSize: 15, color: Pallete.colorBlack),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 190,
                        height: 40,
                        child: TextFormField(
                          controller: _pincontroller,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context).enterpintoview,
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
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: 40,
                            width: 80,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Pallete.colorBlue),
                              onPressed: (() async {
                                if (_pincontroller.text.isEmpty) {
                                  alertDialog(context, AppLocalizations.of(context).pleaseenterpin);
                                } else {
                                  isLoading = true;
                                  await DbHelper.getLoginUser(
                                          _pincontroller.text)
                                      .then((userData) {
                                    if (userData != null) {
                                      _pincontroller.clear();
                                      isLoading = false;
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (builder) {
                                            return Container(
                                              height: 420.0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(
                                                        10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal:
                                                                  40),
                                                      child: Text(
                                                        accountList
                                                            .currentAccount
                                                            .privateKey
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color: Pallete
                                                                .colorGreen,fontSize: 18),
                                                      ),
                                                    ),
                                                    SizedBox(height: 20,),
                                                    SizedBox(
                                                      height: 200,
                                                      width: 200,
                                                      child: QrImage(
                                                          data: accountList
                                                              .currentAccount
                                                              .privateKey),
                                                    ),
                                                                SizedBox(height: 60,),
                                                    GestureDetector(
                                                      onTap: () {
                                                        FlutterClipboard.copy(
                                                                accountList
                                                                    .pkey
                                                                    .privateKey)
                                                            .then(
                                                          (value) {
                                                            alertDialog(
                                                                context,
                                                                'private key Copied');
                                                          },
                                                        );
                                                      },
                                                      child: Container(
                                                        height: 30,
                                                        width: 180,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Pallete
                                                              .colorBlue,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                        ),
                                                        child:
                                                             Center(
                                                          child: Text(
                                                            AppLocalizations.of(context).copy,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                    } else {
                                      isLoading = false;
                                      alertDialog(
                                          context, "${AppLocalizations.of(context).error}: ${AppLocalizations.of(context).unauthorized}");
                                    }
                                  }).catchError((error) {
                                    print(error);
                                    alertDialog(context, "${AppLocalizations.of(context).error}:${AppLocalizations.of(context).fail}");
                                  });
                                }
                              }),
                              child: Text(
                                AppLocalizations.of(context).go,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 30,
                            bottom: 0,
                            top: 0,
                            child: (isLoading)
                                ? Center(
                                    child: SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: Theme(
                                        data: ThemeData(
                                          primaryColor: const Color(0xFFFFFFFF),
                                        ),
                                        child: const CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Pallete.colorBlue,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                          )
                        ],
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
