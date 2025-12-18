import 'package:flutter/material.dart';
import '../../data/models/user_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/auth_controller.dart';
import '../../data/utils/urls.dart';

class LoginProvider extends ChangeNotifier {
  bool _loginInProgress = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;

  bool get getLoginInProgress => _loginInProgress;

  String? get errorMessage => _errorMessage;

  bool get getIsPasswordShow => _isPasswordVisible;

  get togglePassword {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;
    _loginInProgress = true;
    notifyListeners();

    Map<String, dynamic> responseBody = {"email": email, "password": password};

    NetworkResponse response = await NetWorkCaller().postRequest(Urls.signIn, body: responseBody);

    _loginInProgress = false;
    notifyListeners();

    if (response.isSuccess) {
      UserModel userModel = UserModel.fromJson(response.body['data']);
      String accessToken = response.body['token'];
      await AuthController.saveUserToken(accessToken, userModel);
      _errorMessage = null;
      isSuccess = true;
    } else {
      response.errorMessage.toString();
    }
    return isSuccess;
  }
}
