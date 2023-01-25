import 'package:dinari_wallet/components/alertDialog.dart';
import 'package:dinari_wallet/components/form_decoration.dart';
import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/models/verification.dart';
import 'package:dinari_wallet/provider/auth.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Verification extends StatefulWidget {
  const Verification({Key key, @required this.email}) : super(key: key);
  final String email;
  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpcontroller = TextEditingController();
  bool submitValid = false;
  bool isLoading = false;
  @override
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
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
              'Verify Yourself',
              style: TextStyle(fontSize: 16),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: TextFormField(
                controller: _otpcontroller,
                style: const TextStyle(fontSize: 13),
                decoration: decoration(
                  label: 'Enter verification code',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 50,
                width: double.infinity,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Pallete.colorOrange),
                          onPressed: (() async {
                                                          authProvider.setLoading(true);
                            if (_formKey.currentState.validate()) {
                              authProvider.setLoading(false);
                              _formKey.currentState.save();
                              await authProvider.verification(
                                  _otpcontroller.text, context);
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
                      child: (isLoading)
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
                )),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'if you have not received the code \nrequest it again here',
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                  Center(
                      child: SizedBox(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Pallete.colorOrange),
                        onPressed: () async {
                          var response = await http.get(
                            Uri.parse(
                                'http://104.236.104.29/dinari/public/api/send/email/${widget.email}'),
                            headers: {
                              'Accept': 'application/json',
                            },
                          );
                          if (response.statusCode == 200) {
                            VerifyEmail verificationData =
                                verifyEmailFromJson(response.body);
                            await DbHelper.updateUserOtp(verificationData.otp);
                            alertDialog(context, 'sent');
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            'go',
                            style: TextStyle(
                                color: Pallete.colorWhite, fontSize: 15),
                          ),
                        )),
                  )),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
