import 'package:dinari_wallet/utils/validation_helper.dart';
import 'package:dinari_wallet/components/form_input_decoration.dart';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class EmailFormField extends StatelessWidget {
  const EmailFormField({Key key, @required this.controller}) : super(key: key);
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        style:const TextStyle(fontSize: 14.0),
        keyboardType: TextInputType.emailAddress,
        cursorColor: Colors.grey,
        decoration: FormInputDecoration.decoration(
          fieldHintText: 'Email address',
        ).copyWith(
            errorStyle:const TextStyle(fontSize: 12.0),
            hintStyle:const TextStyle(fontSize: 14.0),
            suffixIcon:const Icon(
              Icons.email_outlined,
              color: Colors.grey,
            )),
        validator: MultiValidator(
            ValidationHelper.fieldValidators(Field.Email, context)));
  }
}

class PasswordFormField extends StatefulWidget {
  const PasswordFormField({
    Key key,
    this.onChanged,
    @required this.controller,
    @required this.validator,
    @required this.hintText,
  }) : super(key: key);
  final TextEditingController controller;
  final Function(String) onChanged;
  final dynamic validator;
  final String hintText;

  @override
  // ignore: library_private_types_in_public_api
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _passwordVisibility = false;

  void _togglePasswordVisibility() {
    setState(() {
      _passwordVisibility = !_passwordVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        style:const TextStyle(fontSize: 14.0),
        obscureText: !_passwordVisibility,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: Colors.grey,
        onChanged: widget.onChanged ?? (value) {},
        decoration: FormInputDecoration.decoration(
          fieldHintText: widget.hintText,
        ).copyWith(
            errorStyle:const TextStyle(fontSize: 12.0),
            hintStyle:const TextStyle(fontSize: 14.0),
            suffixIcon: IconButton(
              splashColor: Colors.white,
              highlightColor: Colors.white,
              onPressed: _togglePasswordVisibility,
              icon: Icon(
                _passwordVisibility
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey,
              ),
            )),
        validator: widget.validator);
  }
}