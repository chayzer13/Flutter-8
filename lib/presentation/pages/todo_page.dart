import '../../../main.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../../domain/entities/todo.dart';
import 'package:uuid/uuid.dart';

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _controller = TextEditingController();
  final uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TodoBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List"),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              // Переключатель темы — логика будет в main.dart
              final theme = Theme.of(context).brightness;
              final isDark = theme == Brightness.dark;
              DynamicTheme.of(context).toggleTheme(!isDark);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<TodoBloc, TodoState>(
              builder: (context, state) {
                if (state is TodoLoading) return Center(child: CircularProgressIndicator());
                if (state is TodoLoaded) {
                  return ListView(
                    children: state.todos.map((todo) {
                      return Dismissible(
                        key: Key(todo.id),
                        background: Container(color: Colors.red),
                        onDismissed: (_) => bloc.add(RemoveTodoEvent(todo.id)),
                        child: ListTile(
                          title: Text(
                            todo.title,
                            style: TextStyle(
                              decoration:
                                  todo.isDone ? TextDecoration.lineThrough : null,
                            ),
                          ),
                          trailing: Checkbox(
                            value: todo.isDone,
                            onChanged: (_) => bloc.add(ToggleTodoEvent(todo.id)),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                return Center(child: Text("No todos"));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Введите задачу',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                FloatingActionButton(
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      final newTodo = Todo(
                        id: uuid.v4(),
                        title: _controller.text.trim(),
                      );
                      bloc.add(AddTodoEvent(newTodo));
                      _controller.clear();
                    }
                  },
                  child: Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
