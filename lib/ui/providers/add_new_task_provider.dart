import 'package:flutter/material.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class AddNewTaskProvider extends ChangeNotifier {
  bool _addNewTaskInProgress = false;
  String? _errorMessage;

  bool get getAddNewTaskInProgress => _addNewTaskInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> addTask(String title, String description) async {
    bool isSuccess = false;
    _addNewTaskInProgress = true;
    notifyListeners();

    Map<String, dynamic> responseBody = {
      "title": title,
      "description": description,
      "status": "New",
    };

    NetworkResponse response = await NetWorkCaller().postRequest(
      Urls.createTask,
      body: responseBody,
    );
    _addNewTaskInProgress = false;
    notifyListeners();

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }
    return isSuccess;
  }
}
