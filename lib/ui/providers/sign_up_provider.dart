import 'package:flutter/material.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class SignUpProvider extends ChangeNotifier {
  bool _signUpInProgress = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;

  bool get getSignUpInProgress => _signUpInProgress;

  String? get errorMessage => _errorMessage;

  bool get isPasswordVisible => _isPasswordVisible;

  void togglePassword() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<bool> signUp(
    String email,
    String firstName,
    String lastName,
    String mobile,
    String password,
  ) async {
    bool isSuccess = false;
    _signUpInProgress = true;
    notifyListeners();

    Map<String, dynamic> responseBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    };

    NetworkResponse response = await NetWorkCaller().postRequest(
      Urls.registration,
      body: responseBody,
    );

    _signUpInProgress = false;
    notifyListeners();

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      response.errorMessage.toString();
    }
    return isSuccess;
  }
}
