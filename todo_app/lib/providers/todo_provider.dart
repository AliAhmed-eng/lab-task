
import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  final TodoService _service = TodoService();

  List<Todo> _todos = [];
  bool _isLoading = false;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;

  // Completed Todo Count
  int get completedCount {
    return _todos
        .where((todo) => todo.completed)
        .length;
  }

  // GET Todos
  Future<void> loadTodos() async {
    _isLoading = true;
    notifyListeners();

    try {
      _todos = await _service.getTodos();
    } catch (e) {
      debugPrint('Error loading todos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // POST New Todo
  Future<void> addTodo(String title) async {
    final todo = Todo(
      userId: 1,
      id: 0,
      title: title,
      completed: false,
    );

    final newTodo = await _service.addTodo(todo);

    _todos = [newTodo, ..._todos];

    notifyListeners();
  }
}
