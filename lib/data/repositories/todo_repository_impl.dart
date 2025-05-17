import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  static const String key = 'todo_list';

  @override
  Future<List<Todo>> getTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      return list.map((item) => TodoModel.fromJson(item)).toList();
    }
    return [];
  }

  @override
  Future<void> addTodo(Todo todo) async {
    final todos = await getTodos();
    final updated = [...todos, todo];
    await _saveToPrefs(updated);
  }

  Future<void> removeTodo(String id) async {
    final todos = await getTodos();
    final updated = todos.where((todo) => todo.id != id).toList();
    await _saveToPrefs(updated);
  }

  Future<void> toggleTodo(String id) async {
    final todos = await getTodos();
    final updated = todos.map((todo) {
      return todo.id == id ? todo.copyWith(isDone: !todo.isDone) : todo;
    }).toList();
    await _saveToPrefs(updated);
  }

  Future<void> _saveToPrefs(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(todos.map((e) => TodoModel(
      id: e.id,
      title: e.title,
      isDone: e.isDone,
    ).toJson()).toList());
    await prefs.setString(key, raw);
  }
}
