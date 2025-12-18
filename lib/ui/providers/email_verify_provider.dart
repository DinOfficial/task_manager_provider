import 'package:flutter/material.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class EmailVerifyProvider extends ChangeNotifier {
  bool _emailVerifyInProgress = false;
  String? _errorMessage;

  bool get getEmailVerifyInProgress => _emailVerifyInProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> emailVerify(String email) async {
    bool isSuccess = false;

    _emailVerifyInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetWorkCaller().getRequest(
      Urls.emailVerify(email.trim()),
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      response.errorMessage.toString();
    }

    _emailVerifyInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
