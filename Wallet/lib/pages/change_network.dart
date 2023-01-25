import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:dinari_wallet/components/alertDialog.dart';
import 'package:dinari_wallet/components/bottomsheet.dart';
import 'package:dinari_wallet/components/form_decoration.dart';
import 'package:dinari_wallet/pages/drawer.dart';
import 'package:dinari_wallet/pages/home_page.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:dinari_wallet/provider/network_provider.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeNetwork extends StatefulWidget {
  const ChangeNetwork({Key key}) : super(key: key);

  @override
  State<ChangeNetwork> createState() => _ChangeNetworkState();
}

class _ChangeNetworkState extends State<ChangeNetwork> {
  var name;
  var address;
  var balance;
  var accountId;
  var networkname;
  var networkStatus;
  var networkAddress;
  var networkPort;
  var networkChain;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  //TextEditing controller
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _chainController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        var net = Provider.of<NetworkProvider>(context, listen: false);
        var acc = Provider.of<GenerateAccountProvider>(context, listen: false);
        await net.showNetworks();
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

  bool isSwitched = true;
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
    final networks = Provider.of<NetworkProvider>(context);

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
            Center(
              child: Text(
                AppLocalizations.of(context).networkTitle,
                style: TextStyle(fontSize: 20),
              ),
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
                        accountList.currentAccount.name,
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
            networks.networks == null
                ? const Center(child: CircularProgressIndicator())
                : SizedBox(
                    height: 400,
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: networks.networks.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              networks.setCurrentNetwork(
                                  networks.networks[index].id.toString());
                              setState(() {
                                networkname = networks.networks[index].name;
                                networkAddress = networks.networks[index].ipAddress;
                                networkChain = networks.networks[index].chain;
                                networkPort = networks.networks[index].portNo;
                                networkStatus = networks.networks[index].status;
                              });
                            },
                            child: ListTile(
                              leading: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Pallete.colorBlue, width: 1),
                                    borderRadius: BorderRadius.circular(30)),
                                child: const CircleAvatar(
                                  radius: 15,
                                  child: Icon(Icons.network_wifi),
                                ),
                              ),
                              title: Text(
                                networks.networks[index].name,
                                style: const TextStyle(
                                    color: Pallete.colorGreen, fontSize: 13),
                              ),
                              trailing: Text(
                                networks.networks[index].status,
                                style: TextStyle(
                                    fontSize: 10, color: Pallete.colorGreen),
                              ),
                            ),
                          );
                        }),
                  ),
            SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: SizedBox(
                    height: 40,
                    width: 150,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Pallete.colorBlue),
                      onPressed: (() {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            backgroundColor: Colors.white,
                            title: Center(
                                child: Text(
                                    AppLocalizations.of(context).addNetwork)),
                            insetPadding: EdgeInsets.zero,
                            contentPadding: EdgeInsets.zero,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            content: Builder(
                              builder: (context) {
                                var width =
                                    MediaQuery.of(context).size.width - 50;
                                return Container(
                                  width: width,
                                  child: Form(
                                    key: _formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          TextFormField(
                                            controller: _nameController,
                                            keyboardType: TextInputType.text,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                            autofocus: true,
                                            decoration: decoration(
                                                label:
                                                    AppLocalizations.of(context)
                                                        .networkName),
                                            validator: (value) => value.isEmpty
                                                ? AppLocalizations.of(context)
                                                    .enternetwork
                                                : null,
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          TextFormField(
                                            controller: _addressController,
                                            keyboardType: TextInputType.text,
                                            style:
                                                TextStyle(color: Colors.black),
                                            autofocus: true,
                                            decoration: decoration(
                                              label:
                                                  AppLocalizations.of(context)
                                                      .ipaddress,
                                            ),
                                            validator: (value) => value.isEmpty
                                                ? AppLocalizations.of(context)
                                                    .enteripaddress
                                                : null,
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          TextFormField(
                                            controller: _portController,
                                            keyboardType: TextInputType.text,
                                            style:
                                                TextStyle(color: Colors.black),
                                            autofocus: true,
                                            decoration: decoration(
                                              label:
                                                  AppLocalizations.of(context)
                                                      .portno,
                                            ),
                                            validator: (value) => value.isEmpty
                                                ? AppLocalizations.of(context)
                                                    .enterportnumber
                                                : null,
                                          ),
                                          SizedBox(
                                            height: 3,
                                          ),
                                          TextFormField(
                                            controller: _chainController,
                                            keyboardType: TextInputType.number,
                                            style:
                                                TextStyle(color: Colors.black),
                                            autofocus: true,
                                            decoration: decoration(
                                              label:
                                                  AppLocalizations.of(context)
                                                      .chainid,
                                            ),
                                            validator: (value) => value.isEmpty
                                                ? AppLocalizations.of(context)
                                                    .enterchainid
                                                : null,
                                          ),
                                          ButtonBar(
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  primary:
                                                      const Color(0xFFE53935),
                                                ),
                                                child: Text(
                                                    AppLocalizations.of(context)
                                                        .cancel),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _nameController.clear();
                                                  _addressController.clear();
                                                  _portController.clear();
                                                  _chainController.clear();
                                                },
                                              ),
                                              Stack(
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary:
                                                          Pallete.colorBlue,
                                                    ),
                                                    child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .submit),
                                                    onPressed: () {
                                                      isLoading = true;
                                                      if (_formKey.currentState
                                                              .validate() ??
                                                          false) {
                                                        networks
                                                            .insertNewNetwork(
                                                                name:
                                                                    _nameController
                                                                        .text,
                                                                ipaddress:
                                                                    _addressController
                                                                        .text,
                                                                port:
                                                                    _portController
                                                                        .text,
                                                                chain:
                                                                    _chainController
                                                                        .text)
                                                            .then(
                                                          (value) {
                                                            isLoading = false;
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            alertDialog(
                                                                context,
                                                                AppLocalizations.of(
                                                                        context)
                                                                    .networkadded);
                                                            _nameController
                                                                .clear();
                                                            _addressController
                                                                .clear();
                                                            _portController
                                                                .clear();
                                                            _chainController
                                                                .clear();
                                                          },
                                                        );
                                                      }
                                                    },
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
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      }),
                      child: Text(
                        AppLocalizations.of(context).addNetwork,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
