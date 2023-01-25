// ignore_for_file: avoid_print
import 'package:dinari_wallet/components/alertDialog.dart';
import 'package:dinari_wallet/db/db_helper.dart';
import 'package:dinari_wallet/models/user.dart';
import 'package:dinari_wallet/models/verification.dart';
import 'package:dinari_wallet/pages/Authentication/login_page.dart';
import 'package:dinari_wallet/pages/Authentication/secondrecoverypassword_page.dart';
import 'package:dinari_wallet/pages/Authentication/verification_page.dart';
import 'package:dinari_wallet/pages/home_page.dart';
import 'package:dinari_wallet/provider/account.dart';
import 'package:dinari_wallet/provider/network_provider.dart';
import 'package:dinari_wallet/provider/partnership.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthenticationProvider extends ChangeNotifier {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  bool loading = false;

//////get user id from shared pref/////
  getUserData() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    return sp.getString('user_id');
  }

///////save user id to shared pref
  Future setSP(String id, int first_login) async {
    final SharedPreferences sp = await _pref;
    sp.setString("user_id", id);
    sp.setString("first_login", first_login.toString());
    // sp.setString("account_id",id);

    // var accounts = await DbHelper.getAccount(sp.getString("user_id"));
    // int val = 0;
    // for (var i in accounts) {
    //   if (val == 0) {
    //     print(i.id);
    //     sp.setString('account_id', i.id);
    //   }
    //   val++;
    // }
  }

  bool get isLoading => loading;

  void setLoading(bool value) {
    loading = value;
    notifyListeners();
  }

///////login user//////
  login(String passwd, int remember, context) async {
    var patnership = Provider.of<PartnershipTrustProvider>(context, listen: false);
    patnership.switchPatnership(false);
    if (passwd.isEmpty) {
      alertDialog(context, "Please Enter pin");
    } else {
      loading = true;
      notifyListeners();
      await DbHelper.getLoginUser(passwd).then((userData) async {
        if (userData != null) {
          setSP(userData.id, remember);
          loading = false;
          notifyListeners();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
              (route) => false);
        } else {
          loading = false;
          notifyListeners();
          alertDialog(context, "Error: Wallet Not Found");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error: Login Fail");
      });
    }
  }

  ///////login user//////
  emailCheck(String email, context) async {
    if (email.isEmpty) {
      alertDialog(context, "Please Enter your email");
    } else {
      loading = true;
      setLoading(false);
      notifyListeners();
      await DbHelper.checkUserEmail(email).then((userData) async {
        if (userData != null) {
          loading = false;
          setLoading(false);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const SecondRecoveryPasswordPage()));
        } else {
          loading = false;
          setLoading(false);
          notifyListeners();
          alertDialog(context, "Error: Email Not Found");
        }
      }).catchError((error) {
        print(error);
        alertDialog(context, "Error:Fail");
      });
    }
  }

/////////pin recover//////////
  updatePin(String pin, context) async {
    loading = true;
    setLoading(true);
    notifyListeners();
    await DbHelper.updatepin(pin).then((value) {
      if (value != null) {
        loading = false;
        setLoading(false);
        notifyListeners();
        alertDialog(context, "Password successfully Saved");
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const Login()));
      } else {
        loading = false;
        setLoading(false);
        notifyListeners();
        alertDialog(context, "Error: problem on pin");
      }
    }).catchError((error) {
      print(error);
      alertDialog(context, "Error:Fail");
    });
  }

  /////////////verification///////////
  verification(String otp, context) async {
    loading = true;
    setLoading(true);
    notifyListeners();
    await DbHelper.verify(otp).then((value) {
      if (value != 0) {
        loading = false;
        setLoading(false);
        notifyListeners();
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const Login()));
      } else {
        loading = false;
        setLoading(false);
        notifyListeners();
        alertDialog(context, "Error: Wrong verification code");
      }
    }).catchError((error) {
      print(error);
      alertDialog(context, "Error:Fail");
    });
  }

///////create user//////
  signUp(String email, String passwd, context) async {
    var account = Provider.of<GenerateAccountProvider>(context, listen: false);
    var networks = Provider.of<NetworkProvider>(context, listen: false);
    User uModel = User(email: email, password: passwd);
    await DbHelper.saveData(uModel).then((userData) async {
      loading = true;
      if (userData != null) {
        loading = false;
        setSP(userData.toString(), 0);
        setLoading(false);
        account.generateKey();
        networks.insertDefaultNetwork();
        var response = await http.get(
          Uri.parse(
              'http://104.236.104.29/dinari/public/api/send/email/${email}'),
          headers: {
            'Accept': 'application/json',
          },
        );
        if (response.statusCode == 200) {
          VerifyEmail verificationData = verifyEmailFromJson(response.body);
          await DbHelper.updateUserOtp(verificationData.otp);
          notifyListeners();
        }
        notifyListeners();
        alertDialog(context,
            "Successfully Saved, please verify your email before login");
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => Verification(email: email)));
        notifyListeners();
      } else {
        setLoading(false);
        alertDialog(context, "email or password exist");
        notifyListeners();
      }
    }).catchError((error) {
      print(error);
      setLoading(false);
      alertDialog(context, "Error: Data Save Fail");
      notifyListeners();
    });
  }
}
