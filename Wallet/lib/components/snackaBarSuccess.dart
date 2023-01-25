import 'package:dinari_wallet/components/responsive.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';

snackBarSuccessWidget(context, text) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.green,
      content: Text(
        text,
        style: Responsive.isMobile(context)
            ? bodyWhiteMobileStyle
            : bodyWhiteTabletStyle,
      ),
      duration: const Duration(milliseconds: 2750),
    ),
  );
}