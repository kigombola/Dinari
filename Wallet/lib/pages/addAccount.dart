import 'dart:ui';

import 'package:dinari_wallet/components/alertDialog.dart';
import 'package:dinari_wallet/pages/drawer.dart';
import 'package:dinari_wallet/pages/home_page.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({Key key}) : super(key: key);

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _private1 = TextEditingController();
  final TextEditingController _private2 = TextEditingController();
  final TextEditingController _name1 = TextEditingController();
  final TextEditingController _name2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        Provider.of<GenerateAccountProvider>(context, listen: false)
            .getCurrentAccount();
      },
    );
  }

  List<String> accounts = ['Account 1', 'Account 2'];
  String seletedAccount = 'Account 1';
  @override
  Widget build(BuildContext context) {
    final _account = Provider.of<GenerateAccountProvider>(context);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
//               const SizedBox(
//                 height: 20,
//               ),
//               Form(
//                 key: _formKey,
//                   child: Column(
//                 children: [
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       AppLocalizations.of(context).enterAddress,
//                       style: const TextStyle(
//                           fontSize: 16, color: Pallete.colorBlack),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     child: TextFormField(
//                           controller: _address,
//                           maxLines: 3,
//                           decoration: InputDecoration(
//                             labelText:
//                                 AppLocalizations.of(context).pasteAddress,
//                             labelStyle: const TextStyle(fontSize: 12),
//                             fillColor: Colors.white,
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               borderSide: const BorderSide(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               borderSide: const BorderSide(
//                                 color: Colors.grey,
//                                 width: 1.0,
//                               ),
//                             ),
//                           ),
//                         ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: Text(
//                       AppLocalizations.of(context).enterAccountPrivateKey,
//                       style: const TextStyle(
//                           fontSize: 16, color: Pallete.colorBlack),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                   SizedBox(
//                     width: MediaQuery.of(context).size.width,
//                     child: TextFormField(
//                           controller: _private1,
//                           maxLines: 3,
//                           decoration: InputDecoration(
//                             labelText:
//                                 AppLocalizations.of(context).pasteAccountPrivateKey,
//                             labelStyle: const TextStyle(fontSize: 12),
//                             fillColor: Colors.white,
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               borderSide: const BorderSide(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               borderSide: const BorderSide(
//                                 color: Colors.grey,
//                                 width: 1.0,
//                               ),
//                             ),
//                           ),
//                         ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Row(
//                     children: [
//                       SizedBox(
//                         width: 210,
//                         height: 40,
//                         child: TextFormField(
//                           controller: _name1,
//                           decoration: InputDecoration(
//                             labelText:
//                                 AppLocalizations.of(context).enterAccName,
//                             labelStyle: const TextStyle(fontSize: 12),
//                             fillColor: Colors.black,
//                             focusedBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               borderSide: const BorderSide(
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(5.0),
//                               borderSide: const BorderSide(
//                                 color: Colors.grey,
//                                 width: 1.0,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(
//                         width: 5,
//                       ),
//                       SizedBox(
//                         height: 40,
//                         width: 75,
//                         child: Stack(
//                           children: [
//                             ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               primary: Pallete.colorBlue),
//                           onPressed: (()async {
//  FocusScope.of(context).requestFocus(FocusNode());
//    if (_address.text.isEmpty) {
//                                   alertDialog(context, "Please Enter addres");
//                                 }
//                             if (!_formKey.currentState.validate()) {
//                               alertDialogWarning(context, 'Error',
//                                   'Problem with entered values');
//                             } else {
//                               // _account.loading = true;
//                               await _account.addExistedAccount(_address.text,_private1.text,_name1.text);
//                                 // ignore: use_build_context_synchronously
//                                  Navigator.push(context,
//                                    MaterialPageRoute(builder: (context) {
//                               return   const HomePage();
//                                }));
//                               // _account.loading = false;
//                                 // ignore: use_build_context_synchronously
//                                 alertDialog(
//                                   context, 'account added successfully');
//                             }
//                           }),
//                           child: Text(
//                             AppLocalizations.of(context).save,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .bodyText2
//                                 .copyWith(color: Colors.white),
//                           ),
//                         ),
//                             Positioned(
//                   right: 30,
//                   bottom: 0,
//                   top: 0,
//                   child: (_account.loading)
//                       ? Center(
//                           child: SizedBox(
//                             height: 25,
//                             width: 25,
//                             child: Theme(
//                               data: ThemeData(
//                                 primaryColor: const Color(0xFFFFFFFF),
//                               ),
//                               child: const CircularProgressIndicator(
//                                 backgroundColor: Colors.white,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   Pallete.colorBlue,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )
//                       : Container(),
//                 )
//                           ],
//                         )
//                       ),
//                     ],
//                   ),
//                 ],
//               )),
//               const SizedBox(
//                 height: 20,
//               ),
//               const Center(
//                   child: Text(
//                 'OR',
//                 style: TextStyle(fontSize: 30, color: Pallete.colorBlack),
//               )),
//               const SizedBox(
//                 height: 20,
//               ),
              Text(
                AppLocalizations.of(context).importNewAccount,
                style: const TextStyle(fontSize: 20, color: Pallete.colorBlack),
              ),
              const SizedBox(
                height: 8,
              ),
              Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: TextFormField(
                              controller: _private2,
                              maxLines: 3,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context).pastePrivate,
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
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 240,
                            height: 40,
                            child: TextFormField(
                              controller: _name1,
                              decoration: InputDecoration(
                                labelText:
                                    AppLocalizations.of(context).enterAccName,
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
                          SizedBox(
                              height: 50,
                              width: 85,
                              child: Stack(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Pallete.colorBlue),
                                    onPressed: (() async {
                                      if (_private2.text.isEmpty) {
                                        alertDialog(context,
                                           AppLocalizations.of(context).pleaseEnterprivatekey);
                                      }
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      if (!_formKey2.currentState.validate()) {
                                        alertDialogWarning(context, AppLocalizations.of(context).error,
                                            AppLocalizations.of(context).problemwithenteredvalues);
                                      } else {
                                        // _account.loading = true;
                                        await _account.importAccount(
                                            _private2.text, _name1.text);
                                        // _account.loading = false;
                                        // ignore: use_build_context_synchronously
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const HomePage();
                                        }));
                                        // ignore: use_build_context_synchronously
                                        alertDialog(context,
                                            AppLocalizations.of(context).accountimportedsuccessfully);
                                      }
                                    }),
                                    child: Text(
                                      AppLocalizations.of(context).save,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                  Positioned(
                                    right: 30,
                                    bottom: 0,
                                    top: 0,
                                    child: (_account.loading)
                                        ? Center(
                                            child: SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: Theme(
                                                data: ThemeData(
                                                  primaryColor:
                                                      const Color(0xFFFFFFFF),
                                                ),
                                                child:
                                                    const CircularProgressIndicator(
                                                  backgroundColor: Colors.white,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    Pallete.colorBlue,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ],
                  )),
              SizedBox(
                height: 25,
              ),
              const Center(
                  child: Text(
                'OR',
                style: TextStyle(fontSize: 30, color: Pallete.colorBlack),
              )),
              SizedBox(
                height: 25,
              ),
              Text(
                AppLocalizations.of(context).createNewAccount,
                style: const TextStyle(fontSize: 20, color: Pallete.colorBlack),
              ),
              SizedBox(
                height: 10,
              ),
              Form(
                  child: Column(
                children: [
                  SizedBox(
                    width: 325,
                    height: 40,
                    child: TextFormField(
                      controller: _name2,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context).enterAccName,
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
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 325,
                    height: 40,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Pallete.colorBlue),
                      onPressed: (() async {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Center(
                                  child: new Text("${AppLocalizations.of(context).createanaccountTitle}!!!")),
                              actions: <Widget>[
                                new TextButton(
                                  child: new Text(
                                    AppLocalizations.of(context).no,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                new TextButton(
                                  child: new Text(
                                    AppLocalizations.of(context).yes,
                                    style: TextStyle(
                                        color: Colors.green.shade400,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  onPressed: () {
                                    _account.addAccount(_name2.text);
                                    _name2.clear();
                                       Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return const HomePage();
                                        }));
                                    alertDialog(
                                        context, AppLocalizations.of(context).accountsuccessfullyCreated);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }),
                      child: Text(
                        AppLocalizations.of(context).addAccount,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ))
              // SizedBox(
              //   width: MediaQuery.of(context).size.width,
              //   child: ElevatedButton(
              //     style: ElevatedButton.styleFrom(primary: Pallete.colorBlue),
              //     onPressed: (() async {
              //       _account.generateKey();
              //       Navigator.push(context, MaterialPageRoute(builder: (context) {
              //         return const HomePage();
              //       }));
              //       // ignore: use_build_context_synchronously
              //       alertDialog(context, 'account added successfully');
              //     }),
              //     child: Text(
              //       AppLocalizations.of(context).addAccount,
              //       style: Theme.of(context)
              //           .textTheme
              //           .bodyText1
              //           .copyWith(color: Colors.white),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
