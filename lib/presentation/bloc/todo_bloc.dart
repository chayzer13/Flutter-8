import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/add_todo.dart';
import 'todo_event.dart';
import 'todo_state.dart';
import '../../data/repositories/todo_repository_impl.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final TodoRepositoryImpl repo;

  TodoBloc({required this.getTodos, required this.addTodo, required this.repo})
      : super(TodoInitial()) {
    on<LoadTodos>((event, emit) async {
      emit(TodoLoading());
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    });

    on<AddTodoEvent>((event, emit) async {
      await addTodo(event.todo);
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    });

    on<RemoveTodoEvent>((event, emit) async {
      await repo.removeTodo(event.id);
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    });

    on<ToggleTodoEvent>((event, emit) async {
      await repo.toggleTodo(event.id);
      final todos = await getTodos();
      emit(TodoLoaded(todos));
    });
  }
}

