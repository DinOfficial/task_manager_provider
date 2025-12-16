class TaskCountListModel{
  final String id;
  final int sum;

  TaskCountListModel({required this.id, required this.sum});

  factory TaskCountListModel.fromJson(Map<String, dynamic> jsonData) {
    return TaskCountListModel(id: jsonData['_id'], sum: jsonData['sum']);
  }

}