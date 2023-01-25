import 'package:dinari_wallet/components/form_decoration.dart';
import 'package:dinari_wallet/components/formvalidator.dart';
import 'package:dinari_wallet/pages/Authentication/login_page.dart';
import 'package:dinari_wallet/provider/auth.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:dinari_wallet/utils/validation_helper.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class SecondRecoveryPasswordPage extends StatefulWidget {
  const SecondRecoveryPasswordPage({Key key}) : super(key: key);

  @override
  State<SecondRecoveryPasswordPage> createState() =>
      _SecondRecoveryPasswordPageState();
}

class _SecondRecoveryPasswordPageState
    extends State<SecondRecoveryPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pincontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        child: Column(children: [
          const SizedBox(
            height: 100,
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
            'Recover password',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 15,
          ),
          // const Text(
          //   'Enter your email we will send ',
          //   style: TextStyle(fontSize: 16),
          // ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: PasswordFormField(
                    hintText: 'Enter new pin',
                    controller: _pincontroller,
                    // onChanged: (value) => _password = value,
                    validator: (value) => MultiValidator(
                            ValidationHelper.fieldValidators(
                                Field.Pin, context))
                        .call(value),
                  ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Pallete.colorOrange),
                onPressed: (() {
                  auth.updatePin(_pincontroller.text, context);
                }),
                child: Text(
                  'Submit',
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    ));
  }
}
