// import 'package:dinari_wallet/db/db_helper.dart';
// import 'package:dinari_wallet/models/user.dart';
// import 'package:dinari_wallet/provider/account.dart';
// import 'package:dinari_wallet/utils/shared_pref_helper.dart';
// import 'package:flutter/foundation.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AuthProvider with ChangeNotifier {
//   AuthProvider() {
//     autoAuthenticate();
//   }

//   User _user;
//   bool _userExists = false;
//   List<User> _users;
//   final SharedPref _sharedPref = SharedPref();

//   User get currentUser => _user;
//   List<User> get user => _users;
//   bool get userExists => _userExists;


// /////////////login user///////////////
//   // Future<bool> loginUser({required String pin}) async {
//   //   print(pin);
//   //   bool isloggedIn = false;
//   //   final response = await http.post(
//   //     Uri.parse("${api}login"),
//   //     headers: {'accept': 'application/json'},
//   //     body: {'pin': pin},
//   //   );
//   //   print(response.body);
//   //   if (response.statusCode == 200) {
//   //     final temp = jsonDecode(response.body);
//   //     _sharedPref.save('user', temp);
//   //     User authUser = User.fromJson(temp);
//   //     _user = authUser;
//   //     notifyListeners();
//   //     isloggedIn = true;
//   //   }
//   //   return isloggedIn;
//   // }


// ///////////////create account////////////////
//   // Future<bool> createUser({required String email, context}) async {
//   //   bool isSignedUp = false;
//   //   final response = await http.post(
//   //     Uri.parse("${api}register"),
//   //     headers: {'accept': 'application/json'},
//   //     body: {
//   //       'email': email,
//   //     },
//   //   );
//   //   print(response.body);
//   //   if (response.statusCode == 201) {
//   //     final temp = jsonDecode(response.body);
//   //     _sharedPref.save('user', temp);
//   //     User authUser = User.fromJson(temp);
//   //     _user = authUser;
//   //     isSignedUp = true;
//   //     Provider.of<GenerateAccountProvider>(context).generateKey();
//   //     notifyListeners();
//   //   }
//   //   return isSignedUp;
//   // }



// /////////////////autoauthenticate//////////////
//   Future<bool> autoAuthenticate() async {
//     bool isFetchingAuthUser = true;
//     final userCredentials = await _sharedPref.read('user');
//     if (userCredentials != null) {
//       _user = User.fromMap(userCredentials);
//       _userExists = true;
//       notifyListeners();
//     } else {
//       _userExists = false;
//       notifyListeners();
//     }
//     isFetchingAuthUser = false;
//     return isFetchingAuthUser;
//   }
// }
