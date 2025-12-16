import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/show_snackbar_message.dart';
import '../widgets/task_card.dart';
import 'add_new_task_screen.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});
  final String name = 'progress-task-list';

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  bool _taskInProgressInProgress = false;
  List<TaskListModel> _inProgressList = [];

@override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _getProgressTaskList,
        child: ListView(
          children: [
            Visibility(
              visible: !_taskInProgressInProgress,
              replacement: SizedBox(height:300,child: CenteredCircularProgressIndicator()),
              child: Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  itemCount: _inProgressList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(taskListModel: _inProgressList[index], refreshList: () {
                      _getProgressTaskList();
                    },);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getProgressTaskList() async{
    _taskInProgressInProgress = true;
    setState(() {});

    NetworkResponse response = await NetWorkCaller().getRequest(Urls.progressTaskList);

    if(response.isSuccess){
      List<TaskListModel> list = [];
      for(Map<String, dynamic> jsonData in response.body['data']){
        list.add(TaskListModel.fromJson(jsonData));
      }
      _inProgressList = list;
    }else{
      showSnackbarMessage(context, response.errorMessage.toString() , true);
    }

    _taskInProgressInProgress = false;
    setState(() {});
  }
}

