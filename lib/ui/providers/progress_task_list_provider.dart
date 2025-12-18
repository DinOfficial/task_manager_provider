import 'package:flutter/material.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class ProgressTaskListProvider extends ChangeNotifier {
  bool _progressTaskListInProgress = false;
  List<TaskListModel> _taskList = [];
  String? _errorMessage;

  bool get getProgressTaskListInProgress => _progressTaskListInProgress;

  List<TaskListModel> get taskList => _taskList;

  String? get errorMessage => _errorMessage;

  Future<bool> getProgressTaskList() async {
    bool isSuccess = false;
    _progressTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetWorkCaller().getRequest(Urls.progressTaskList);

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

    _progressTaskListInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
