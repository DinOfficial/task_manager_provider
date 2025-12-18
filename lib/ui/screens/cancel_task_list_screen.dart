import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/ui/providers/cancel_task_list_provider.dart';
import 'package:task_manager_app/ui/widgets/centered_circular_progress_indicator.dart';
import '../widgets/task_card.dart';

class CancelTaskListScreen extends StatefulWidget {
  const CancelTaskListScreen({super.key});

  final String name = 'cancelled-task-list';

  @override
  State<CancelTaskListScreen> createState() => _CancelTaskListScreenState();
}

class _CancelTaskListScreenState extends State<CancelTaskListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CancelTaskListProvider>(context, listen: false).getCancelTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Consumer<CancelTaskListProvider>(
            builder: (context, cancelTaskListProvider, _) {
              return Visibility(
                visible: !context.watch<CancelTaskListProvider>().getCancelTaskListInProgress,
                replacement: SizedBox(height: 300, child: CenteredCircularProgressIndicator()),
                child: Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    itemCount: cancelTaskListProvider.taskList.length,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskListModel: cancelTaskListProvider.taskList[index],
                        refreshList: () {
                          cancelTaskListProvider.getCancelTaskList();
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
