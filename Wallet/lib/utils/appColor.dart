import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Pallete {
  static const colorOrange = Color(0xFFF57C00);
  static const colorBlue = Color(0xFF2196F3);
  static const colorRed = Color(0xFFF44336);
  static const colorGreen = Color(0xFF66BB6A);
  static const colorWhite = Color(0xFFFFFFFF);
  static const colorBlack = Color(0xFF000000);
}

//white
const bodyWhiteMobileStyle=TextStyle(fontSize:16.0 ,color: Colors.white,fontFamily: 'small',);
const titleWhiteMobileStyle=TextStyle(fontSize:18,color: Colors.white,fontFamily: 'bold',);
const bodywhiteMobileStyle=TextStyle(fontSize:16.0 ,color: Colors.white,fontFamily: 'small',);

//white
const bodyWhiteTabletStyle=TextStyle(fontSize:22.0 ,color: Colors.white,fontFamily: 'small',);
const titleWhiteTabletStyle=TextStyle(fontSize:24.0, color: Colors.white,fontFamily: 'bold',);

ThemeData defaultTheme(BuildContext context) {
  return ThemeData(
      colorScheme: const ColorScheme.light(
          primary: Pallete.colorBlue, secondary: Pallete.colorBlack),
          textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).copyWith(
            headline1: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white
            )
          ),
          );
}
