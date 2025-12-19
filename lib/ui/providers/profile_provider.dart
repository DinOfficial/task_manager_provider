import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/models/user_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/auth_controller.dart';
import '../../data/utils/urls.dart';

class ProfileUpdateProvider extends ChangeNotifier {
  bool _profileUpdateInProgress = false;
  String? _errorMessage;
  bool _isPasswordVisible = false;
  final ImagePicker imagePick = ImagePicker();
  XFile? pickedImage;

  Future<void> imagePicker() async {
    final image = await imagePick.pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage = image;
      notifyListeners();
    }
  }

  bool get getProfileUpdateInProgress => _profileUpdateInProgress;

  String? get errorMessage => _errorMessage;

  bool get isPasswordVisible => _isPasswordVisible;

  void togglePassword() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  Future<bool> profileUpdate(
    String email,
    String firstName,
    String lastName,
    String mobile,
    String password,
  ) async {
    bool isSuccess = false;

    _profileUpdateInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
    };

    if (password.isNotEmpty) {
      requestBody['password'] = password;
    }

    if (pickedImage != null) {
      Uint8List imageByte = await pickedImage!.readAsBytes();
      requestBody['photo'] = base64Encode(imageByte);
    }

    final NetworkResponse response = await NetWorkCaller().postRequest(
      Urls.updateProfile,
      body: requestBody,
    );

    if (response.isSuccess) {
      UserModel updateUser = UserModel(
        id: AuthController.user!.id,
        email: email,
        firsName: firstName,
        lastName: lastName,
        mobile: mobile,
        photo: response.body?['data']?['photo'] ?? AuthController.user?.photo,
      );
      await AuthController.updateUserData(updateUser);
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage ?? 'Profile update failed.';
    }
    _profileUpdateInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
