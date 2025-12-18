import 'package:flutter/material.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class CompleteTaskListProvider extends ChangeNotifier {
  bool _completeTaskListInProgress = false;
  List<TaskListModel> _taskList = [];
  String? _errorMessage;

  bool get getCompleteTaskListInProgress => _completeTaskListInProgress;

  List<TaskListModel> get taskList => _taskList;

  String? get errorMessage => _errorMessage;

  Future<bool> getCompleteTaskList() async {
    bool isSuccess = false;
    _completeTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetWorkCaller().getRequest(Urls.completedTaskList);

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

    _completeTaskListInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
