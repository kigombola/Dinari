import 'dart:ui';
import 'package:dinari_wallet/components/bottomsheet.dart';
import 'package:dinari_wallet/components/form_decoration.dart';
import 'package:dinari_wallet/pages/Authentication/login_page.dart';
import 'package:dinari_wallet/pages/addAccount.dart';
import 'package:dinari_wallet/pages/change_network.dart';
import 'package:dinari_wallet/pages/notebookAddressPage.dart';
import 'package:dinari_wallet/pages/home_page.dart';
import 'package:dinari_wallet/pages/trustPartnership_page.dart';
import 'package:dinari_wallet/pages/viewKey.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:dinari_wallet/provider/locale_provider.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:dinari_wallet/utils/locale_helper.dart';
import 'package:dinari_wallet/utils/shared_pref_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  var name;
  var address;
  var balance;
  var accountId;
  bool isLoading = false;
  final TextEditingController _emailaddressController = TextEditingController();

  //////get user id from shared pref/////
  getUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('user_id');
  }

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
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Drawer(
      backgroundColor: Pallete.colorWhite,
      child: accountList.currentAccount == null
          ? const Center(
              child: Text('please wait..'),
            )
          : ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 10),
                const Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 55,
                    width: 60,
                    child: Image(
                      image: AssetImage(
                        'assets/images/logo.png',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SizedBox(
                    height: kToolbarHeight + 105,
                    child: DrawerHeader(
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
                                                itemCount: accountList
                                                    .accountItem.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      accountList
                                                          .setCurrentAccount(
                                                              accountList
                                                                  .accountItem[
                                                                      index]
                                                                  .id);
                                                      setState(() {
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
                                                            .accountItem[index]
                                                            .id;
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
                                                          child:
                                                              const CircleAvatar(
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
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 5),
                                                          child: Text(
                                                              accountList
                                                                  .accountItem[
                                                                      index]
                                                                  .name),
                                                        ),
                                                        subtitle: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              subAddress(
                                                                accountList
                                                                    .accountItem[
                                                                        index]
                                                                    .address,
                                                              ),
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  accountList
                                                                      .accountItem[
                                                                          index]
                                                                      .balance
                                                                      .toString(),
                                                                  style: const TextStyle(
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
                                                                  color: Colors
                                                                      .white,
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
                                                  AppLocalizations.of(context)
                                                      .addAccount,
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
                        //                     fontSize: 17, color: Pallete.colorBlue),
                        //               ),
                        //             ))
                        //         .toList(),
                        //     onChanged: (item) => setState(() {
                        //       seletedAccount = item!;
                        //     }),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          subAddress(accountList.currentAccount.address),
                          style:
                              const TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              accountList.currentAccount.balance,
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey),
                            ),
                            const Text(
                              'DNR',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: SizedBox(
                                height: 30,
                                width: 80,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Pallete.colorBlue),
                                  onPressed: (() {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const ViewKey();
                                    }));
                                  }),
                                  child: Text(
                                    AppLocalizations.of(context).view,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 1),
                              child: SizedBox(
                                height: 30,
                                width: 80,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Pallete.colorBlue),
                                  onPressed: (() {
                                    showDialog(
                                        context: context,
                                        builder:
                                            (BuildContext context) =>
                                                AlertDialog(
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    contentPadding:
                                                        EdgeInsets.zero,
                                                    clipBehavior: Clip
                                                        .antiAliasWithSaveLayer,
                                                    content: Builder(
                                                      builder: (context) {
                                                        var width =
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                50;
                                                        return Container(
                                                          width: width,
                                                          child: Form(
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .topCenter,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(AppLocalizations.of(context)
                                                                            .secureyourcredentials),
                                                                        SizedBox(
                                                                          height:
                                                                              8,
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 13),
                                                                          child:
                                                                              Text(
                                                                            AppLocalizations.of(context).storecredential,
                                                                            style:
                                                                                TextStyle(fontSize: 10),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )),
                                                                ListTile(
                                                                    title: Text(
                                                                        'Private key'),
                                                                    subtitle:
                                                                        Container(
                                                                      padding: const EdgeInsets
                                                                              .all(
                                                                          10.0),
                                                                      decoration: BoxDecoration(
                                                                          border:
                                                                              Border.all(color: Colors.grey),
                                                                          borderRadius: BorderRadius.circular(5)),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.visibility_off,
                                                                            color:
                                                                                Colors.red,
                                                                          ),
                                                                          Text(
                                                                            AppLocalizations.of(context).enclosure,
                                                                            style:
                                                                                TextStyle(color: Colors.red),
                                                                          ),
                                                                          Visibility(
                                                                            visible:
                                                                                false,
                                                                            child:
                                                                                Text(accountList.currentAccount.privateKey),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )),
                                                                ListTile(
                                                                  title: Text(
                                                                      'Address'),
                                                                  subtitle:
                                                                      Container(
                                                                    padding: const EdgeInsets
                                                                            .all(
                                                                        10.0),
                                                                    decoration: BoxDecoration(
                                                                        border: Border.all(
                                                                            color: Colors
                                                                                .grey),
                                                                        borderRadius:
                                                                            BorderRadius.circular(5)),
                                                                    child: Text(accountList
                                                                        .currentAccount
                                                                        .address),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 5,
                                                                ),
                                                                ListTile(
                                                                  title:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            5),
                                                                    child: Text(
                                                                        AppLocalizations.of(context)
                                                                            .enterEmail),
                                                                  ),
                                                                  subtitle:
                                                                      TextFormField(
                                                                    controller:
                                                                        _emailaddressController,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .emailAddress,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                    autofocus:
                                                                        true,
                                                                    decoration:
                                                                        decoration(
                                                                      label: AppLocalizations.of(
                                                                              context)
                                                                          .emailAddress,
                                                                    ),
                                                                    validator: (value) => value
                                                                            .isEmpty
                                                                        ? AppLocalizations.of(context)
                                                                            .enterEmail
                                                                        : null,
                                                                  ),
                                                                ),
                                                                ButtonBar(
                                                                  children: [
                                                                    ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        primary:
                                                                            const Color(0xFFE53935),
                                                                      ),
                                                                      child: Text(
                                                                          AppLocalizations.of(context)
                                                                              .exit),
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        _emailaddressController
                                                                            .clear();
                                                                      },
                                                                    ),
                                                                    ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Pallete.colorBlue,
                                                                        ),
                                                                        child: Text(AppLocalizations.of(context)
                                                                            .send),
                                                                        onPressed: () =>
                                                                            launchEmail(to: _emailaddressController.text, subject: "Dinari credentials", message: "Address:${accountList.currentAccount.address},\nPrivate_key:${accountList.currentAccount.privateKey}").then((value) {
                                                                              Navigator.pop(context);
                                                                              _emailaddressController.clear();
                                                                            })),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    )));
                                  }),
                                  child: Text(
                                    AppLocalizations.of(context).secure,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    size: 18,
                  ),
                  title: Text(
                    AppLocalizations.of(context).home,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    size: 18,
                  ),
                  title: Text(
                    AppLocalizations.of(context).addAccount,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddAccount(),
                        ));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.people,
                    size: 18,
                  ),
                  title: Text(
                    AppLocalizations.of(context).trustPartner,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrustPartnership(),
                        ));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.wifi,
                    size: 18,
                  ),
                  title: Text(
                    AppLocalizations.of(context).selectNet,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChangeNetwork(),
                        ));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.language,
                    size: 18,
                  ),
                  title: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context).changeLang,
                        style: const TextStyle(color: Colors.black),
                      ),
                      PopupMenuButton(
                          onSelected: (value) =>
                              localeProvider.changeLanguage(value),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          icon: const Icon(Icons.arrow_drop_down),
                          itemBuilder: (BuildContext context) {
                            return <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                  value: 'en',
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      CircleAvatar(
                                        radius: 9,
                                        backgroundImage: AssetImage(
                                            'assets/images/usflag.png'),
                                      ),
                                      Text(
                                        'English',
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  )),
                              const PopupMenuDivider(
                                height: 0,
                              ),
                              PopupMenuItem<String>(
                                  value: 'sw',
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: const [
                                      CircleAvatar(
                                        radius: 9,
                                        backgroundImage: AssetImage(
                                            'assets/images/tanzaniaflag.png'),
                                      ),
                                      Text(
                                        'Swahili',
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  )),
                            ];
                          }),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.contacts,
                    size: 18,
                  ),
                  title: Text(
                    AppLocalizations.of(context).contacts,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Contacts(),
                        ));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    size: 18,
                  ),
                  title: Text(
                    AppLocalizations.of(context).logout,
                    style: const TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    final SharedPref sharedPref = SharedPref();
                    sharedPref.remove('user_id');
                    sharedPref.remove('first_login');
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const Login()),
                        (route) => false);
                  },
                )
              ],
            ),
    );
  }

  Future launchEmail({String to, String subject, String message}) async {
    final url =
        'mailto:$to?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
