import 'package:dinari_wallet/components/alertDialog.dart';
import 'package:dinari_wallet/components/form_decoration.dart';
import 'package:dinari_wallet/pages/home_page.dart';
import 'package:dinari_wallet/provider/notebookAddress_provider.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        Provider.of<NotebookAddressProvider>(context, listen: false)
            .getNotebookAddresses();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final addressList = Provider.of<NotebookAddressProvider>(context);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () =>
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const HomePage();
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
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context).contacts,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
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
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Align(
                                              alignment: Alignment.topCenter,
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(AppLocalizations.of(
                                                          context)
                                                      .addAddress),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              )),
                                          ListTile(
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .name),
                                            ),
                                            subtitle: TextFormField(
                                              controller: _nameController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              // Theme.of(context)
                                              //     .textTheme
                                              //     .bodyText2,
                                              autofocus: true,
                                              decoration: decoration(
                                                label:
                                                    AppLocalizations.of(context)
                                                        .name,
                                              ),
                                              validator: (value) => value
                                                      .isEmpty
                                                  ? AppLocalizations.of(context)
                                                      .enterName
                                                  : null,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          ListTile(
                                            title: Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 5),
                                              child: Text(
                                                  AppLocalizations.of(context)
                                                      .address),
                                            ),
                                            subtitle: TextFormField(
                                              controller: _addressController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              style: TextStyle(
                                                  color: Colors.black),
                                              // Theme.of(context)
                                              //     .textTheme
                                              //     .bodyText2,
                                              autofocus: true,
                                              decoration: decoration(
                                                label:
                                                    AppLocalizations.of(context)
                                                        .address,
                                              ),
                                              validator: (value) => value
                                                      .isEmpty
                                                  ? AppLocalizations.of(context)
                                                      .enterAddress
                                                  : null,
                                            ),
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
                                                        .exit),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  _addressController.clear();
                                                  _nameController.clear();
                                                },
                                              ),
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Pallete.colorBlue,
                                                  ),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .send),
                                                  onPressed: () {
                                                    isLoading = true;
                                                    if (_formKey.currentState
                                                            .validate() ??
                                                        false) {
                                                      addressList
                                                          .insertNotebookAddress(
                                                        name: _nameController
                                                            .text,
                                                        address:
                                                            _addressController
                                                                .text,
                                                      )
                                                          .then(
                                                        (value) {
                                                          isLoading = false;
                                                          Navigator.of(context)
                                                              .pop();
                                                          alertDialog(
                                                              context,
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .success);
                                                          _nameController
                                                              .clear();
                                                          _addressController
                                                              .clear();
                                                        },
                                                      );
                                                    }
                                                  }),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )));
                    },
                    icon: Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.green,
                    ))
              ],
            ),
            SizedBox(
              // height: 200,
              child: addressList.notebookAddress == null
                  ? Center(child: CircularProgressIndicator())
                  : addressList.notebookAddress.isEmpty
                      ? SizedBox(
                          height: 300,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context).noData,
                              style: TextStyle(
                                  fontSize: 8, fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.only(right: 30, left: 15),
                            child: Divider(
                              color: Colors.grey,
                            ),
                          ),
                          itemCount: addressList.notebookAddress.length,
                          itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  addressList.notebookAddress[index].name,
                                  style: TextStyle(color: Colors.green),
                                ),
                                Text(
                                    addressList.notebookAddress[index].address),
                              ],
                            ),
                          ),
                        ),
            ),
            // SizedBox(height: 200,),
            // Container(
            //   height: 30,
            //   width: 200,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(primary: Pallete.colorBlue),
            //     onPressed: (() {

            //     }),
            //     child: Text(
            //       'Add',
            //       style: Theme.of(context)
            //           .textTheme
            //           .bodyText1
            //           .copyWith(color: Colors.white),
            //     ),
            //   ),
            // )
          ],
        ));
  }
}
