import 'dart:async';
import 'dart:ui';
import 'package:dinari_wallet/components/alertDialog.dart';
import 'package:dinari_wallet/components/bottomsheet.dart';
import 'package:dinari_wallet/models/notebook_Address.dart';
import 'package:dinari_wallet/pages/drawer.dart';
import 'package:dinari_wallet/pages/home_page.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:dinari_wallet/provider/notebookAddress_provider.dart';
import 'package:dinari_wallet/provider/partnership.dart';
import 'package:dinari_wallet/provider/routing.dart';
import 'package:dinari_wallet/provider/transaction.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class SendPayment extends StatefulWidget {
  const SendPayment({Key key}) : super(key: key);

  @override
  State<SendPayment> createState() => _SendPaymentState();
}

class _SendPaymentState extends State<SendPayment> {
  final _key = GlobalKey<FormState>();
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _partnerAddressController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  List<NotebookAddress> _search = [];

  bool isLoading = false;
  String amount = '0';
  String total = '0';
  bool showButton = false;

  var name;
  var address;
  var balance;
  var accountId;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        Provider.of<NotebookAddressProvider>(context, listen: false)
            .getNotebookAddresses();
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

  @override
  void dispose() {
    _amountController.dispose();
    _partnerAddressController.dispose();
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
    final transaction = Provider.of<TransactionProvider>(context);
    final routing = Provider.of<RoutingProvider>(context);
    final patnership = Provider.of<PartnershipTrustProvider>(context);
    final addressList =
        Provider.of<NotebookAddressProvider>(context, listen: false);

    // if (_partnerAddressController.text == "") {
    //   addressList.onSearch("");
    // }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Pallete.colorBlue),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title:  Padding(
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
            key: _key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                 Text(
                  AppLocalizations.of(context).sendCoins,
                  style: TextStyle(fontSize: 20, color: Pallete.colorBlue),
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
                                                          .accountItem[index]
                                                          .id);
                                                  setState(() {
                                                    print(accountList
                                                        .accountItem[index].id);
                                                    name = accountList
                                                        .accountItem[index]
                                                        .name;
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
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Text(
                                                                'DNR',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12),
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
                                                  .copyWith(
                                                      color: Colors.white),
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
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formkey,
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 5, bottom: 5),
                        child: Text(
                          'to',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width*4/5,
                        child: TextFormField(
                          onChanged: ((value) {
                            addressList.onSearch(value);
                            setState(() {
                              value.length == 42
                                  ? showButton = true
                                  : showButton = false;
                            });
                          }),
                          controller: _partnerAddressController,
                          decoration: InputDecoration(
                            labelText:
                                "${AppLocalizations.of(context).searchaddress}...",
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                showButton
                    ? TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title:  Text(AppLocalizations.of(context).add),
                              content: Container(
                                height: 90,
                                child: Column(
                                  children: [
                                    Text(
                                      _partnerAddressController.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    TextFormField(
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        labelText: AppLocalizations.of(context).enterName,
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
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    if (_formkey.currentState.validate() ??
                                        false) {
                                      addressList
                                          .insertNotebookAddress(
                                        name: _nameController.text,
                                        address: _partnerAddressController.text,
                                      )
                                          .then(
                                        (value) {
                                          isLoading = false;
                                          Navigator.of(context).pop();
                                          alertDialog(context, AppLocalizations.of(context).saved);
                                          _nameController.text;
                                          // _nameController.clear();
                                          // _partnerAddressController.clear();
                                        },
                                      );
                                    }
                                  },
                                  child: Container(
                                    color: Colors.green,
                                    padding: const EdgeInsets.all(11),
                                    child:  Text(
                                      AppLocalizations.of(context).save,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context).addAddressToNotebook,
                          style: TextStyle(color: Colors.green, fontSize: 16),
                        ))
                    : Text(''),
                addressList.notebookAddress == null
                    ? MediaQuery.of(context).viewInsets.bottom == 0
                    : SizedBox(
                        height: 50,
                        child: ListView.builder(
                          itemCount: addressList.addressToDisplay.length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () => _partnerAddressController.text =
                                addressList.addressToDisplay[index].address,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 3, right: 11),
                                  child: Divider(
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  addressList.addressToDisplay[index].name,
                                  style: TextStyle(
                                      color: Pallete.colorGreen, fontSize: 13),
                                ),
                                Text(
                                    addressList.addressToDisplay[index].address),
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 3,right: 11),
                                //   child: Divider(
                                //     color: Colors.grey,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 12,
                ),
                 Center(
                    child: Text(
                  AppLocalizations.of(context).or,
                  style: TextStyle(fontSize: 30, color: Pallete.colorBlack),
                )),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      height: 40,
                        width: MediaQuery.of(context).size.width*4/5,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Pallete.colorBlue),
                        onPressed: (() {
                          // Navigator.push(context,
                          //       MaterialPageRoute(builder: (context) {
                          //  return   const ScanQrScreen ();
                          //   }));
                        }),
                        child: Text(
                          AppLocalizations.of(context).qrCode,
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
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Padding(
                      padding: EdgeInsets.only(
                        right: 70,
                      ),
                      child: Text(
                        AppLocalizations.of(context).amount,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                      width: 100,
                      child: TextFormField(
                        onChanged: (string) {
                          transaction.getTransaction(
                              _partnerAddressController.text,
                              _amountController.text);
                          setState(() {
                            amount = transaction.gasFee.toStringAsFixed(6);
                            total = (double.parse(_amountController.text) +
                                    double.parse(amount))
                                .toString();
                          });
                        },
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).enterAmount,
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
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        'DNR',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                     Padding(
                      padding: EdgeInsets.only(right: 70),
                      child: Text(
                        AppLocalizations.of(context).estimatedFee,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        amount,
                        style: const TextStyle(
                            fontSize: 16, color: Pallete.colorBlue),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        'DNR',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                     Padding(
                      padding: EdgeInsets.only(right: 130),
                      child: Text(
                        AppLocalizations.of(context).total,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        total,
                        style: const TextStyle(
                            fontSize: 16, color: Pallete.colorBlue),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        'DNR',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Center(
                    child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Pallete.colorBlue),
                          onPressed: (() async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            transaction.loading = false;
                            if (!_key.currentState.validate()) {
                              transaction.loading = false;
                              alertDialog(
                                  context, AppLocalizations.of(context).problemwithenteredvalues);
                            } else {
                              if (patnership.isPatnershipOn) {
                                await routing.txRequest(
                                    _partnerAddressController.text,
                                    _amountController.text,
                                    context);
                              } else {
                                await transaction.sendTransaction(
                                    _partnerAddressController.text,
                                    double.parse(_amountController.text),
                                    context);
                                _amountController.clear();
                                _partnerAddressController.clear();
                              }
                            }
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const HomePage();
                            }));
                          }),
                          child: Text(
                            AppLocalizations.of(context).send,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 30,
                      bottom: 0,
                      top: 0,
                      child: (transaction.loading)
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
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
