import 'package:dinari_wallet/provider/account.dart';
import 'package:dinari_wallet/provider/auth.dart';
import 'package:dinari_wallet/provider/notebookAddress_provider.dart';
import 'package:dinari_wallet/provider/locale_provider.dart';
import 'package:dinari_wallet/provider/routing.dart';
import 'package:dinari_wallet/provider/network_provider.dart';
import 'package:dinari_wallet/provider/partnership.dart';
import 'package:dinari_wallet/provider/transaction.dart';
import 'package:dinari_wallet/route/route_generator.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:dinari_wallet/utils/device_connectivity_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => PartnershipTrustProvider()),
    ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
    ChangeNotifierProvider(create: (_) => NotebookAddressProvider()),
    ChangeNotifierProvider(create: (_) => GenerateAccountProvider()),
     ChangeNotifierProxyProvider<GenerateAccountProvider, TransactionProvider>(
            create: (_) => TransactionProvider(),
            update: (_, accountProvider, transactionProvider) =>
                transactionProvider..update(accProvider: accountProvider),
          ),
    ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ChangeNotifierProvider(create: (_) => DeviceConnectivityService()),
    ChangeNotifierProvider(create: (_) => NetworkProvider()),
    ChangeNotifierProxyProvider3<GenerateAccountProvider, TransactionProvider, PartnershipTrustProvider, RoutingProvider>(
            create: (_) => RoutingProvider(),
            update: (_, accountProvider, transactionProvider, partnership, routingProvider) =>
                routingProvider..update(accountProvider: accountProvider, transactionProvider: transactionProvider, partnership: partnership),
          ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Provider.of<LocaleProvider>(context, listen: false).getLocale();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, value, child) {
        return MaterialApp(
          title: 'dinari',
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          theme: defaultTheme(context),
          initialRoute: '/',
          locale: value.locale,
          onGenerateRoute: RouteGenerator.generateRoute,
        );
      },
    );
  }
}
