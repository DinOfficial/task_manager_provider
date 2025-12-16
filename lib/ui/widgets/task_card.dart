import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/task_list_model.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utils/urls.dart';
import 'package:task_manager_app/ui/widgets/show_snackbar_message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.taskListModel,
    required this.refreshList,
  });

  final TaskListModel taskListModel;
  final VoidCallback refreshList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _taskStatusChangeInProgress = false;
  bool _taskDeleteInProgress = false;

  @override
  Widget build(BuildContext context) {
    Color statusTagColor() {
      if (widget.taskListModel.status == 'New') {
        return Colors.blue;
      } else if (widget.taskListModel.status == 'Progress') {
        return Colors.amber;
      } else if (widget.taskListModel.status == 'Cancelled') {
        return Colors.red;
      } else {
        return Colors.green;
      }
    }

    void changeTaskStatus() {
      showDialog(
        context: context,
        builder: (ctx) {
          bool isCurrentStatus(String status) {
            return widget.taskListModel.status == status;
          }

          Future<void> changeTaskStatusFetch(String status) async {
            _taskStatusChangeInProgress = true;
            setState(() {});

            NetworkResponse response = await NetWorkCaller().getRequest(
              Urls.updateTaskStatus(widget.taskListModel.id, status),
            );

            if (response.isSuccess) {
              widget.refreshList();
            } else {
              _taskStatusChangeInProgress = false;
              setState(() {});
              showSnackbarMessage(context, response.errorMessage.toString());
            }
          }

          void _onTapTaskChangeHandle(String status) {
            if (isCurrentStatus(status)) return;
            Navigator.pop(context);
            changeTaskStatusFetch(status);
          }

          return AlertDialog(
            backgroundColor: Colors.green.shade200,
            title: Text('Change Status'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  selected: isCurrentStatus('New') ? true : false,
                  selectedColor: Colors.black87,
                  selectedTileColor: Colors.white60,
                  title: Text('New'),
                  trailing: isCurrentStatus('New') ? Icon(Icons.done) : null,
                  onTap: () {
                    _onTapTaskChangeHandle('New');
                  },
                ),
                ListTile(
                  selected: isCurrentStatus('Progress') ? true : false,
                  selectedColor: Colors.black87,
                  selectedTileColor: Colors.white60,
                  title: Text('Progress'),
                  trailing: isCurrentStatus('Progress')
                      ? Icon(Icons.done)
                      : null,
                  onTap: () {
                    _onTapTaskChangeHandle('Progress');
                  },
                ),
                ListTile(
                  selected: isCurrentStatus('Cancelled') ? true : false,
                  selectedColor: Colors.black87,
                  selectedTileColor: Colors.white60,
                  title: Text('Cancelled'),
                  trailing: isCurrentStatus('Cancelled')
                      ? Icon(Icons.done)
                      : null,
                  onTap: () {
                    _onTapTaskChangeHandle('Cancelled');
                  },
                ),
                ListTile(
                  selected: isCurrentStatus('Completed') ? true : false,
                  selectedColor: Colors.black87,
                  selectedTileColor: Colors.white60,
                  title: Text('Completed'),
                  trailing: isCurrentStatus('Completed')
                      ? Icon(Icons.done)
                      : null,
                  onTap: () {
                    _onTapTaskChangeHandle('Completed');
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    void deleteTaskDialog() {
      showDialog(
        context: context,
        builder: (ctx) {
          Future<void> deleteTask(String taskId) async {
            _taskDeleteInProgress = true;
            setState(() {});

            NetworkResponse response = await NetWorkCaller().getRequest(
              Urls.deleteTask(taskId),
            );

            _taskDeleteInProgress = false;
            setState(() {});

            if (response.isSuccess) {
              showSnackbarMessage(context, 'Task Delete Successfully');
              widget.refreshList();
            } else {
              showSnackbarMessage(
                context,
                response.errorMessage.toString(),
                true,
              );
            }
          }

          return AlertDialog(
            backgroundColor: Colors.green.shade200,
            title: Text(
              'Do you want to delete this task ?',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    deleteTask(widget.taskListModel.id);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Okay',
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        title: Text(
          widget.taskListModel.title,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(widget.taskListModel.description),
            const SizedBox(height: 4),
            Text('Date:${widget.taskListModel.createdDate}'),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: statusTagColor(),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.taskListModel.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Spacer(),
                Visibility(
                  visible: !_taskStatusChangeInProgress,
                  replacement: CircularProgressIndicator(),
                  child: IconButton(
                    onPressed: () {
                      changeTaskStatus();
                    },
                    icon: Icon(Icons.edit, color: Colors.blue, size: 20),
                  ),
                ),
                Visibility(
                  visible: !_taskDeleteInProgress,
                  replacement: CircularProgressIndicator(),
                  child: IconButton(
                    onPressed: () {
                      deleteTaskDialog();
                    },
                    icon: Icon(Icons.delete, color: Colors.red, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
