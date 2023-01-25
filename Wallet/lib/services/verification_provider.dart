// import 'dart:convert';

// import 'package:dinari_wallet/models/verification_model.dart';
// import 'package:dinari_wallet/services/auth_provider.dart';
// import 'package:dinari_wallet/utils/api.dart';
// import 'package:dinari_wallet/utils/shared_pref_helper.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:http/http.dart' as http;

// class VerificationProvider with ChangeNotifier {
//   AuthProvider? _authProvider;

//   void update({required AuthProvider authProvider}) {
//     _authProvider = authProvider;
//   }

//   late VerifiedUser _verifiedUser;
//   bool _userExists = false;

//   final SharedPref _sharedPref = SharedPref();

// // getters
//   VerifiedUser get verifiedUser => _verifiedUser;

//   ///////////////verify user//////////////////
//   Future<bool> verifyUser({required String otp}) async {
//     bool isVerified = false;
//     final response = await http.post(
//       Uri.parse("${api}verifyUser/${_authProvider!.currentUser!.user.id}"),
//       headers: {'accept': 'application/json'},
//       body: {'otp': otp},
//     );
//     if (response.statusCode == 200) {
//       final temp = jsonDecode(response.body);
//       _sharedPref.save('verified', temp);
//       VerifiedUser verifiedUser = VerifiedUser.fromJson(temp);
//       _verifiedUser = verifiedUser;
//       notifyListeners();
//       isVerified = true;
//     }
//     return isVerified;
//   }
// }
