import 'package:flutter/material.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class SetPasswordProvider extends ChangeNotifier {
  bool _setPasswordInProgress = false;
  String? _errorMessage;

  bool get setPasswordInProgress => _setPasswordInProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> setPassword(String email, String otp, String password) async {
    bool isSuccess = false;

    _setPasswordInProgress = true;
    notifyListeners();

    Map<String, dynamic> responseBody = {"email": email, "OTP": otp, "password": password};

    final NetworkResponse response = await NetWorkCaller().postRequest(
      Urls.recoveryResetPassword,
      body: responseBody,
    );

    _setPasswordInProgress = false;
    notifyListeners();

    if (response.isSuccess && response.body['status'] == 'success') {
      _errorMessage = null;
      isSuccess = true;
    } else {
      response.errorMessage.toString();
    }

    return isSuccess;
  }
}
