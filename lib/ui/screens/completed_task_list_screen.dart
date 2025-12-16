import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import '../widgets/task_card.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});
  final String name = 'completed-task-list';

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {

  bool _completedTaskListInProgress = false;
  List<TaskListModel> _completeTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTaskData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _getCompletedTaskData,
        child: ListView(
          children: [
            Visibility(
              visible: !_completedTaskListInProgress,
              replacement: SizedBox(height:300,child: CenteredCircularProgressIndicator()),
              child: Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  itemCount: _completeTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(taskListModel: _completeTaskList[index], refreshList: () {
                      _getCompletedTaskData();
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

  Future<void> _getCompletedTaskData ()async{
    _completedTaskListInProgress = true;
    setState(() {});

    NetworkResponse response = await NetWorkCaller().getRequest(Urls.completedTaskList);

    if(response.isSuccess){
      List<TaskListModel> list = [];
      for(Map<String, dynamic> jsonData in response.body['data']){
        list.add(TaskListModel.fromJson(jsonData));
      }
      _completeTaskList = list;
    }
    _completedTaskListInProgress = false;
    setState(() {});
  }
}

