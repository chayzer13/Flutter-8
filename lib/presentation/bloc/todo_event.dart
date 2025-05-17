import '../../domain/entities/todo.dart';

abstract class TodoEvent {}

class LoadTodos extends TodoEvent {}

class AddTodoEvent extends TodoEvent {
  final Todo todo;
  AddTodoEvent(this.todo);
}

class RemoveTodoEvent extends TodoEvent {
  final String id;
  RemoveTodoEvent(this.id);
}

class ToggleTodoEvent extends TodoEvent {
  final String id;
  ToggleTodoEvent(this.id);
}
