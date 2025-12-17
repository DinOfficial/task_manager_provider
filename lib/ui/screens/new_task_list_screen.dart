import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/data/models/task_count_list_model.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/providers/new_task_list_provider.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager_app/ui/widgets/show_snackbar_message.dart';
import '../widgets/task_card.dart';
import 'add_new_task_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _getTaskCountListInProgress = false;
  List<TaskCountListModel> _taskCountList = [];

  // _taskCountOnTap(int index){
  //   if(_taskCountList[index].id.toString() == 'Progress'){
  //     return Navigator.pushNamedAndRemoveUntil(context, ProgressTaskListScreen().name, (predicate)=>false);
  //   }else if(_taskCountList[index].id.toString() == 'Cancelled'){
  //     return Navigator.pushNamedAndRemoveUntil(context, CancelTaskListScreen().name, (predicate)=>false);
  //   }else if(_taskCountList[index].id.toString() == 'Completed') {
  //     return Navigator.pushNamedAndRemoveUntil(
  //         context, CompletedTaskListScreen().name, (predicate) => false);
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _getTaskCountList();
    Provider.of<NewTaskListProvider>(context, listen: false).getTaskList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final newTaskList = context.watch<NewTaskListProvider>().getTaskList();

    return Scaffold(
      body: Column(
        children: [
          Visibility(
            visible: !_getTaskCountListInProgress,
            replacement: CenteredCircularProgressIndicator(),
            child: SizedBox(
              height: 90,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: _taskCountList.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: 100,
                    child: ListTile(
                      title: Text(
                        _taskCountList[index].sum.toString(),
                        style: textTheme.titleMedium?.copyWith(color: Colors.black87),
                      ),
                      subtitle: Text(
                        _taskCountList[index].id.toString(),
                        style: textTheme.labelSmall?.copyWith(color: Colors.grey),
                      ),
                    ),
                  ).animate().slide(duration: 700.ms).fadeIn(duration: 700.ms);
                },
              ),
            ),
          ),
          Expanded(
            child: Consumer<NewTaskListProvider>(
              builder: (context, newTaskListProvider, _) {
                return Visibility(
                  visible: !newTaskListProvider.getTaskListInProgress,
                  replacement: SizedBox(height: 300, child: CenteredCircularProgressIndicator()),
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    itemCount: newTaskListProvider.taskList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskListModel: newTaskListProvider.taskList[index],
                        refreshList: () {
                          newTaskListProvider.taskList;
                          _getTaskCountList();
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        elevation: 0,
        onPressed: _onTapAddIcon,
        child: Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }

  void _onTapAddIcon() {
    Navigator.pushNamed(context, AddNewTaskScreen().name);
  }

  Future<void> _getTaskCountList() async {
    _getTaskCountListInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetWorkCaller().getRequest(Urls.taskCountList);

    if (response.isSuccess) {
      List<TaskCountListModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskCountListModel.fromJson(jsonData));
      }
      _taskCountList = list;
    } else {
      showSnackbarMessage(context, response.errorMessage.toString());
    }

    _getTaskCountListInProgress = false;
    setState(() {});
  }
}
