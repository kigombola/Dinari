import 'package:dinari_wallet/components/formvalidator.dart';
import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/pages/Authentication/recoverPassword_page.dart';
import 'package:dinari_wallet/provider/auth.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:dinari_wallet/utils/validation_helper.dart';
import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  const Register({Key key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _pincontroller = TextEditingController();
  String _password = '';
  bool submitValid = false;
  bool isLoading = false;
  DbHelper dbHelper;
  EmailAuth emailAuth;
  @override
  void initState() {
    super.initState();
    _emailcontroller = TextEditingController();
    _pincontroller = TextEditingController();
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _pincontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var auths = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const SizedBox(
              height: 120,
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
              'Register an account',
              style: TextStyle(fontSize: 16),
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: EmailFormField(
                  controller: _emailcontroller,
                )),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: PasswordFormField(
                hintText: 'Pin',
                controller: _pincontroller,
                onChanged: (value) => _password = value,
                validator: (value) => MultiValidator(
                        ValidationHelper.fieldValidators(
                            Field.Password, context))
                    .call(value),
              ),
            ),
            const SizedBox(
              height: 10,
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
                        if (_formKey.currentState.validate()) {
                          auths.setLoading(true);
                          _formKey.currentState.save();
                          await auths.signUp(_emailcontroller.text,
                              _pincontroller.text, context);
                        }
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
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have a wallet?',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/signinPage'),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
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
                    child: const Text('recover your password',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)))),
                                    Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Unverified account?',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/verificationPage'),
                      child: const Text(
                        'click here..',
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

}
