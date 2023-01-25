import 'package:dinari_wallet/components/form_decoration.dart';
import 'package:dinari_wallet/provider/auth.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecoverPassword extends StatefulWidget {
  const RecoverPassword({Key key}) : super(key: key);

  @override
  State<RecoverPassword> createState() => _RecoverPasswordState();
}

class _RecoverPasswordState extends State<RecoverPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthenticationProvider>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: TextFormField(
                controller: _emailcontroller,
                style: const TextStyle(fontSize: 13),
                decoration: decoration(
                  label: 'Enter your email address',
                ),
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
                    auth.emailCheck(_emailcontroller.text, context);
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
      ),
    );
  }
}
