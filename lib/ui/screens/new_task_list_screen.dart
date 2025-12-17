import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/ui/providers/new_task_list_provider.dart';
import 'package:task_manager_app/ui/providers/task_list_count_provider.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import '../widgets/task_card.dart';
import 'add_new_task_screen.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<NewTaskListProvider>(context, listen: false).getTaskList();
    Provider.of<TaskListCountProvider>(context, listen: false).getTaskCountList();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final taskListCountProvider = context.read<TaskListCountProvider>();
    return Scaffold(
      body: ListView(
        children: [
          Consumer<TaskListCountProvider>(
            builder: (context, taskCountListProvider, _) {
              return Visibility(
                visible: !taskCountListProvider.getTaskListInProgress,
                replacement: CenteredCircularProgressIndicator(),
                child: SizedBox(
                  height: 90,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    scrollDirection: Axis.horizontal,
                    itemCount: taskCountListProvider.taskCountList.length,
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
                            taskCountListProvider.taskCountList[index].sum.toString(),
                            style: textTheme.titleMedium?.copyWith(color: Colors.black87),
                          ),
                          subtitle: Text(
                            taskCountListProvider.taskCountList[index].id.toString(),
                            style: textTheme.labelSmall?.copyWith(color: Colors.grey),
                          ),
                        ),
                      ).animate().slide(duration: 700.ms).fadeIn(duration: 700.ms);
                    },
                  ),
                ),
              );
            },
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
                          taskListCountProvider.taskCountList;
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
}
