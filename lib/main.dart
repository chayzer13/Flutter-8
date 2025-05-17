import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/todo_repository_impl.dart';
import 'domain/usecases/get_todos.dart';
import 'domain/usecases/add_todo.dart';
import 'presentation/bloc/todo_bloc.dart';
import 'presentation/bloc/todo_event.dart';
import 'presentation/pages/todo_page.dart';

void main() {
  final repository = TodoRepositoryImpl();
  runApp(MyApp(repository: repository));
}

class DynamicTheme extends InheritedWidget {
  final ThemeMode themeMode;
  final void Function(bool isDark) toggleTheme;

  const DynamicTheme({
    required this.themeMode,
    required this.toggleTheme,
    required super.child,
  }) : super();

  static DynamicTheme of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<DynamicTheme>()!;

  @override
  bool updateShouldNotify(DynamicTheme oldWidget) =>
      oldWidget.themeMode != themeMode;
}

class MyApp extends StatefulWidget {
  final TodoRepositoryImpl repository;
  const MyApp({required this.repository});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      themeMode: _themeMode,
      toggleTheme: _toggleTheme,
      child: MaterialApp(
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: _themeMode,
        home: BlocProvider(
          create: (_) => TodoBloc(
            getTodos: GetTodos(widget.repository),
            addTodo: AddTodo(widget.repository),
            repo: widget.repository,
          )..add(LoadTodos()),
          child: TodoPage(),
        ),
      ),
    );
  }
}
