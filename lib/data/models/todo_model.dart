import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required String id,
    required String title,
    String description = '',
    bool isDone = false,
  }) : super(id: id, title: title, description: description, isDone: isDone);

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      isDone: json['isDone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isDone': isDone,
    };
  }
}