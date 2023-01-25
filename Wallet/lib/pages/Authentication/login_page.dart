import 'dart:async';

import 'package:dinari_wallet/components/formvalidator.dart';
import 'package:dinari_wallet/pages/Authentication/recoverPassword_page.dart';
import 'package:dinari_wallet/pages/Authentication/register_page.dart';
import 'package:dinari_wallet/provider/auth.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:dinari_wallet/utils/device_connectivity_provider.dart';
import 'package:dinari_wallet/utils/validation_helper.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool showvalue = false;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  int remember;
  String _password = '';

  //FocusNodes
  FocusNode _pinFocusNode;
  //TextEditing controller
  TextEditingController _pincontroller = TextEditingController();
  StreamSubscription connectionSubscription;
  //////get user id from shared pref/////
  getUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    var id = sp.getString('user_id');
        var first_login = sp.getString('first_login');

    print('hhhhhhhhhhhhhhhhh');
    print(id);
    if (id != null&&first_login==1) {
      Navigator.of(context).pushNamed('/home');
    }
  }

  @override
  void initState() {
    super.initState();
    connectionSubscription =
        Provider.of<DeviceConnectivityService>(context, listen: false)
            .checkChangeOfDeviceConnectionStatus(context);
    _pinFocusNode = FocusNode();
    _pincontroller = TextEditingController();
    getUserData();
  }

  @override
  void dispose() {
    _pinFocusNode.dispose();
    _pincontroller.dispose();
    connectionSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var auths = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(children: [
            const SizedBox(
              height: 150,
            ),
            const Center(
              child: SizedBox(
                  height: 60,
                  width: 60,
                  child: Image(image: AssetImage('assets/images/logo.png'))),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Dinari',
              style: TextStyle(
                  color: Pallete.colorBlue,
                  fontSize: 32,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Welcome back',
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: PasswordFormField(
                    hintText: 'Pin',
                    controller: _pincontroller,
                    onChanged: (value) => _password = value,
                    validator: (value) => MultiValidator(
                            ValidationHelper.fieldValidators(
                                Field.Password, context))
                        .call(value),
                  ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text(
              //       'Enter pin: ',
              //       style: TextStyle(
              //           fontSize: 14,
              //           fontWeight: FontWeight.bold,
              //           color: Colors.grey),
              //     ),
              //     PinCodeTextField(
              //       controller: _pincontroller,
              //       maxLength: 4,
              //       onTextChanged: (value) {
              //         print(value);
              //       },
              //       pinBoxWidth: 45,
              //       pinBoxHeight: 40,
              //       defaultBorderColor: Colors.grey.shade400,
              //     )
              //   ],
              // )
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Remember me',
                    style: TextStyle(fontSize: 16),
                  ),
                  Transform.scale(
                    scale: 0.65,
                    child: Checkbox(
                        value: showvalue,
                        onChanged: (value) {
                          setState(() {
                            showvalue = value;
                          });
                        }),
                  )
                ],
              ),
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Pallete.colorOrange),
                      onPressed: (() async {
                        if (showvalue == true) {
                          setState(() {
                            remember = 1;
                          });
                        }
                        await auths.login(
                            _pincontroller.text, remember, context);
                      }),
                      child: Text(
                        'Login',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 30,
                  bottom: 0,
                  top: 0,
                  child: (auths.loading)
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
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Pallete.colorBlue,
                                ),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                )
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Center(
                child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Does not have a wallet?',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.of(context).pushNamed('/signupPage'),
                            child: const Text(
                              'Register a wallet',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
            ),
            Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const RecoverPassword();
                      }));
                    },
                    child: const Text(
                      'recover your password',
                      style: TextStyle(decoration: TextDecoration.underline, fontSize: 10,fontWeight: FontWeight.bold),
                    )))
          ]),
        ),
      ),
    );
  }
}
