import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dinari_wallet/utils/appColor.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

alertDialog(BuildContext context, String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );}

alertDialogWarning(
  BuildContext context,
  String title,
  String desc,
) {
  return AwesomeDialog(
    dialogBackgroundColor: const Color(0xFFfffffa),
    context: context,
    dialogType: DialogType.WARNING,
    animType: AnimType.SCALE,
    headerAnimationLoop: false,
    title: title,
    desc: desc,
    btnOkOnPress: () {},
    btnOkColor: Colors.amber[600],
    btnOkText: '',
    buttonsTextStyle: bodywhiteMobileStyle
  ).show();
}
