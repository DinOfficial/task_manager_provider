import 'package:flutter/material.dart';
import '../../data/models/task_count_list_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class TaskListCountProvider extends ChangeNotifier {
  bool _taskListCountInProgress = false;
  List<TaskCountListModel> _taskCountList = [];
  String? _errorMessage;

  bool get getTaskListInProgress => _taskListCountInProgress;

  List<TaskCountListModel> get taskCountList => _taskCountList;

  String? get errorMessage => _errorMessage;

  Future<bool> getTaskCountList() async {
    bool isSuccess = false;
    _taskListCountInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetWorkCaller().getRequest(Urls.taskCountList);

    if (response.isSuccess) {
      List<TaskCountListModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskCountListModel.fromJson(jsonData));
      }
      _taskCountList = list;

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _taskListCountInProgress = false;
    notifyListeners();
    return isSuccess;
  }
}
