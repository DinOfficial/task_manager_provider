import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/ui/providers/progress_task_list_provider.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import '../widgets/task_card.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  final String name = 'progress-task-list';

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<ProgressTaskListProvider>(context, listen: false).getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Consumer<ProgressTaskListProvider>(
            builder: (context, progressTaskListProvider, _) {
              return Visibility(
                visible: !progressTaskListProvider.getProgressTaskListInProgress,
                replacement: SizedBox(height: 300, child: CenteredCircularProgressIndicator()),
                child: Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    itemCount: progressTaskListProvider.taskList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskListModel: progressTaskListProvider.taskList[index],
                        refreshList: () {
                          progressTaskListProvider.getProgressTaskList();
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
