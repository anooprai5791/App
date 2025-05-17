import 'dart:io';
import 'package:flutter/material.dart';

class EditProfileProvider extends ChangeNotifier {
  File? profileImage;
  String name = '';
  String mobile = '';
  String address = '';

  String? nameError;
  String? phoneError;
  String? addressError;

  void updateImage(File image) {
    profileImage = image;
    notifyListeners();
  }

  void updateName(String value) {
    name = value;
    nameError = null;
    notifyListeners();
  }

  void updateMobile(String value) {
    mobile = value;
    phoneError = null;
    notifyListeners();
  }

  void updateAddress(String value) {
    address = value;
    addressError = null;
    notifyListeners();
  }

  bool validateFields() {
    bool isValid = true;

    if (name.isEmpty) {
      nameError = 'Please enter your name';
      isValid = false;
    }

    if (mobile.isEmpty || mobile.length != 10) {
      phoneError = 'Enter a valid 10-digit number';
      isValid = false;
    }

    if (address.isEmpty) {
      addressError = 'Address cannot be empty';
      isValid = false;
    }

    notifyListeners();
    return isValid;
  }

  void resetErrors() {
    nameError = null;
    phoneError = null;
    addressError = null;
    notifyListeners();
  }
}
