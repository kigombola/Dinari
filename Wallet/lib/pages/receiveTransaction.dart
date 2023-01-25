import 'dart:ui';

import 'package:dinari_wallet/components/bottomsheet.dart';
import 'package:dinari_wallet/pages/drawer.dart';
import 'package:dinari_wallet/pages/home_page.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ReceivePayment extends StatefulWidget {
  const ReceivePayment({Key key}) : super(key: key);

  @override
  State<ReceivePayment> createState() => _ReceivePaymentState();
}

class _ReceivePaymentState extends State<ReceivePayment> {
  var name;
  var address;
  var balance;
  var accountId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        var acc = Provider.of<GenerateAccountProvider>(context, listen: false);

        await acc.getCurrentAccount();
        await acc.getAccount();

        setState(() {
          name = acc.currentAccount.name;
          balance = acc.currentAccount.balance;
          address = acc.currentAccount.address;
          accountId = acc.currentAccount.id;
        });
      },
    );
  }

  TextEditingController ccc = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  int _genderValue = 1;
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
                                                        color:
                                                            Pallete.colorBlue,
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
              // SizedBox(
              //   width: 130,
              //   child: DropdownButtonFormField<String>(
              //     decoration: const InputDecoration(
              //         enabledBorder: UnderlineInputBorder(
              //             borderSide: BorderSide(color: Colors.white))),
              //     iconEnabledColor: Pallete.colorBlue,
              //     iconSize: 30,
              //     value: seletedAccount,
              //     items: accounts
              //         .map((item) => DropdownMenuItem<String>(
              //               value: item,
              //               child: Text(
              //                 item,
              //                 style: const TextStyle(
              //                     fontSize: 20, color: Pallete.colorBlue),
              //               ),
              //             ))
              //         .toList(),
              //     onChanged: (item) => setState(() {
              //       seletedAccount = item!;
              //     }),
              //   ),
              // ),
               Text(
                '${AppLocalizations.of(context).share} public address',
                style: TextStyle(fontSize: 15, color: Pallete.colorBlack),
              ),
              const SizedBox(
                height: 10,
              ),
               Center(
                  child: Text(
                AppLocalizations.of(context).chooseformat,
                style: TextStyle(fontSize: 15, color: Pallete.colorBlack),
              )),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Radio(
                      activeColor: Colors.black,
                      value: 1,
                      groupValue: _genderValue,
                      onChanged: handleRadio),
                  SizedBox(
                      width: 230,
                      child: Text(
                        accountList.currentAccount.address,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Radio(
                      activeColor: Colors.black,
                      value: 2,
                      groupValue: _genderValue,
                      onChanged: handleRadio),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 100,
                      child:
                          QrImage(data: accountList.currentAccount.address))
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Pallete.colorBlue),
                      onPressed: (() async {
                         _genderValue == 1?Share.share( accountList.currentAccount.address):Share.share(accountList.currentAccount.address);
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
            ],
          )),
        ),
      ),
    );
  }

  void handleRadio(int value) {
    setState(() {
      _genderValue = value;
    });
  }
}
