import 'package:flutter/material.dart';

class FormInputDecoration {
  const FormInputDecoration();

  static final outlineInputBorder = OutlineInputBorder(
    borderSide:const BorderSide(color: Colors.grey,width: 0.2),
    borderRadius: BorderRadius.circular(5.0),
  );
  static const InputBorder inputBorder =
    OutlineInputBorder(borderSide: BorderSide(color: Colors.grey));

  static InputDecoration decoration({@required String fieldHintText}) {
    return InputDecoration(
      fillColor: Colors.white,
      filled: true,
      border: inputBorder,
enabledBorder: inputBorder,
focusedBorder: inputBorder,
      errorStyle:const TextStyle(fontSize: 10),
      errorBorder: outlineInputBorder,
      disabledBorder: outlineInputBorder,
      contentPadding: const EdgeInsets.all(16),
      hintText: fieldHintText,
      hintStyle:const TextStyle(
        fontSize: 11,
      ),
    );
  }
}