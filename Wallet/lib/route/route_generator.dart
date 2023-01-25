import 'package:dinari_wallet/pages/Authentication/login_page.dart';
import 'package:dinari_wallet/pages/Authentication/register_page.dart';
import 'package:dinari_wallet/pages/Authentication/verification_page.dart';
import 'package:dinari_wallet/pages/home_page.dart';
// import 'package:dinari_wallet/pages/trustPartnership_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Login());
      case '/signinPage':
        return MaterialPageRoute(builder: (_) => const Login());
      case '/signupPage':
        return MaterialPageRoute(builder: (_) => const Register());
      case '/verificationPage':
        return MaterialPageRoute(builder: (_) => const Verification());
        //  case '/trustpartnerHome':
        // return MaterialPageRoute(builder: (_) => const TrustPartnership());
         case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('No Route'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'Oops no route found',
            style: TextStyle(color: Colors.red, fontSize: 18.0),
          ),
        ),
      );
    });
  }
}
