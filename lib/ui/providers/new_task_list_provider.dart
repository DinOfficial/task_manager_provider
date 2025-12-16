import 'package:flutter/material.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class NewTaskListProvider extends ChangeNotifier {
  bool _getTaskListInProgress = false;
  List<TaskListModel> _taskList = [];
  String? _errorMessage;

  bool get getTaskListInProgress => _getTaskListInProgress;

  List<TaskListModel> get taskList => _taskList;

  String? get errorMessage => _errorMessage;

  Future<bool> getTaskList() async {
    bool isSuccess = false;
    _getTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetWorkCaller().getRequest(Urls.newTaskList);

    if (response.isSuccess) {
      List<TaskListModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskListModel.fromJson(jsonData));
      }
      _taskList = list;


      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getTaskListInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
