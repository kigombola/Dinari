import 'package:flutter/material.dart';

const InputBorder inputBorder =
    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey));



InputDecoration decoration({@required String label}){
  return InputDecoration(
    isDense: true,
    labelText: label,
    labelStyle:const TextStyle(
      color: Colors.black54 ,
         ),
border: inputBorder,
enabledBorder: inputBorder,
focusedBorder: inputBorder
  );
}

