import 'package:flutter/material.dart';
import '../../data/models/task_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class CancelTaskListProvider extends ChangeNotifier {
  bool _cancelTaskListInProgress = false;
  List<TaskListModel> _taskList = [];
  String? _errorMessage;

  bool get getCancelTaskListInProgress => _cancelTaskListInProgress;

  List<TaskListModel> get taskList => _taskList;

  String? get errorMessage => _errorMessage;

  Future<bool> getCancelTaskList() async {
    bool isSuccess = false;
    _cancelTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetWorkCaller().getRequest(Urls.cancelledTaskList);

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

    _cancelTaskListInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
