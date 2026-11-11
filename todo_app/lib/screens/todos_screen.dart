
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import 'add_todo_screen.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  State<TodosScreen> createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<TodoProvider>().loadTodos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todos'),

        actions: [
          // context.select for completed count
          Padding(
            padding: const EdgeInsets.all(16),

            child: Center(
              child: Text(
                'Done: ${context.select<TodoProvider, int>(
                  (provider) => provider.completedCount,
                )}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          IconButton(
            tooltip: 'View Posts',
            icon: const Icon(Icons.article_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),

      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.todos.isEmpty) {
            return const Center(
              child: Text('No todos found'),
            );
          }

          return ListView.builder(
            itemCount: provider.todos.length,

            itemBuilder: (context, index) {
              final todo = provider.todos[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),

                child: ListTile(
                  leading: Icon(
                    todo.completed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,

                    color: todo.completed
                        ? Colors.green
                        : Colors.grey,

                    size: 28,
                  ),

                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),

                  subtitle: Text(
                    'User ID: ${todo.userId} | Todo ID: ${todo.id}',
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddTodoScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
