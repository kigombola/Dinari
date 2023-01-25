import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

enum Field { Email, Password, Pin }

class ValidationHelper {
  static fieldValidators(Field field, BuildContext context) {
    var emailRegex =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    var passwordRegex = r'(?=.?[#?!@$%^&-])';
    var numberRegex = r'^(0|[1-9][0-9]*)$';

    List<FieldValidator<dynamic>> fieldValidators = [];

    if (field == Field.Email) {
      fieldValidators.addAll([
        RequiredValidator(
            errorText:'Email address required'),
        PatternValidator(emailRegex,
            errorText: 'Please enter valid email'),
      ]);
    }

    if (field == Field.Password) {
      fieldValidators.addAll([
        RequiredValidator(
            errorText: 'Password required'),
        MinLengthValidator(4,
            errorText:
                'pin\'s too short,minimum 4 numbers'),
                MaxLengthValidator(4, errorText: 'pin\'s too large,maximun 4 numbers'),
        PatternValidator(numberRegex,
            errorText: 'Enter pin(number)'),
      ]);
    }

    if (field == Field.Pin) {
      fieldValidators.addAll([
        RequiredValidator(
            errorText: 'pin required'),
        PatternValidator(numberRegex,
            errorText:'Pattern pin error'),
        MinLengthValidator(4,
            errorText: 'Incomplete pin error'),
      ]);
    }

    return fieldValidators;
  }
}