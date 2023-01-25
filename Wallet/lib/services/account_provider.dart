// import 'package:dinari_wallet/models/account_model.dart';
// import 'package:dinari_wallet/services/auth_provider.dart';
// import 'package:dinari_wallet/utils/api.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class AccountProvider with ChangeNotifier {
//    AuthProvider? _authProvider;

//   void update({required AuthProvider authProvider}) {
//     _authProvider = authProvider;
//   }

//   Account? _account;
//   List<UserAccount>? _userAccount;

// //////// getters ////////
//   Account? get account => _account;
//   List<UserAccount>? get userAccount => _userAccount;

//   ///////// account details ///////////
//   Future accountDetails() async {
//     Account? fetchedAccount;
//     var client = http.Client();
//     var uri = Uri.parse('${api}account/${_authProvider!.currentUser!.user.id}');
//     final response = await client.get(uri);
//     if (response.statusCode == 200) {
//       var json = response.body;
//       fetchedAccount = accountFromJson(json);
//       _account = fetchedAccount;
//       notifyListeners();
//     }
//     return fetchedAccount;
//   }

// ////////get account names//////////
//   Future userAccountNames() async {
//     List<UserAccount>? fetchedAccount = [];
//     var client = http.Client();
//     var uri =
//         Uri.parse('${api1}user/accounts/${_authProvider!.currentUser!.user.id}');
//     final response = await client.get(uri);
//     if (response.statusCode == 200) {
//       var json = response.body;
//       fetchedAccount = userAccountFromJson(json);
//       _userAccount = fetchedAccount;
//       notifyListeners();
//     }
//     return fetchedAccount;
//   }
// }
