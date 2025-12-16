import 'package:date_time_format/date_time_format.dart';

class TaskListModel {
  String id;
  String title;
  String description;
  String status;
  String email;
  String createdDate;

  TaskListModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.email,
    required this.createdDate,
  });

  factory TaskListModel.fromJson(Map<String, dynamic> jsonData) {
    return TaskListModel(
      id: jsonData['_id'],
      title: jsonData['title'],
      description: jsonData['description'],
      status: jsonData['status'],
      email: jsonData['email'],
      createdDate: DateTimeFormat.format(
        DateTime.parse(jsonData['createdDate']),
        format: DateTimeFormats.american,
      ),
    );
  }
}
