import 'package:flutter/material.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class OtpVerifyProvider extends ChangeNotifier {
  bool _otpVerifyInProgress = false;
  String? _errorMessage;

  bool get getOtpVerifyInProgress => _otpVerifyInProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> otpVerify(String email, String otp) async {
    bool isSuccess = false;

    _otpVerifyInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetWorkCaller().getRequest(
      Urls.emailVerifyOTP(email, otp),
    );
    _otpVerifyInProgress = false;
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
