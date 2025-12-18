import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/ui/providers/complete_task_list_provider.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import '../widgets/task_card.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  final String name = 'completed-task-list';

  @override
  State<CompletedTaskListScreen> createState() => _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CompleteTaskListProvider>(context, listen: false).getCompleteTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Consumer<CompleteTaskListProvider>(
            builder: (context, completeTaskListProvider, _) {
              return Visibility(
                visible: !completeTaskListProvider.getCompleteTaskListInProgress,
                replacement: SizedBox(height: 300, child: CenteredCircularProgressIndicator()),
                child: Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    itemCount: completeTaskListProvider.taskList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskListModel: completeTaskListProvider.taskList[index],
                        refreshList: () {
                          completeTaskListProvider.getCompleteTaskList();
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
