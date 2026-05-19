import 'package:flutter/material.dart';
import 'package:store/core/utils/functions/reg_exp.dart';
 

class AppValidators {
  static String? validateFillFields(BuildContext context, String? name) {
    if (name == null || name.isEmpty) {
      return "fill_field";
    }
    return null;
  }

  static String? validatePasswordFields(
      BuildContext context, String? password) {
    if (password == null || password.isEmpty) {
      return "fill_field";
    } else if (AppRegexp.passwordRegex.hasMatch(password) == false) {
      return "password_regexp";
    }
    return null;
  }

  static String? validateRepeatPasswordFields(
      BuildContext context, String? password, String? repeatedPassword) {
    if (repeatedPassword == null || repeatedPassword.isEmpty) {
      return "fill_field";
    }
    if (password != repeatedPassword) {
      return "must_same_password";
    }
    return null;
  }

  static String? validateEmailFields(BuildContext context, String? email) {
    if (email == null || email.isEmpty) {
      return "fill_field";
    } else if (AppRegexp.emailRegexp.hasMatch(email) == false) {
      return "email_regexp";
    }
    return null;
  }

  static String? validatePhoneFields(BuildContext context, String? phone) {
    if (phone == null || phone.isEmpty) {
      return "fill_field";
    }
    if (AppRegexp.phoneRegexp.hasMatch(phone) == false) {
      return "phone_regexp";
    }
    return null;
  }
}
