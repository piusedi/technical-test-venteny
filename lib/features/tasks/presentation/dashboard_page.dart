import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../domain/entities/task.dart';
import '../task_provider.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String searchQuery = "";
  TaskStatus? selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                ),
                DropdownButton<TaskStatus?>(
                  value: selectedFilter,
                  hint: Text('Filter by status'),
                  onChanged: (TaskStatus? newValue) {
                    setState(() {
                      selectedFilter = newValue;
                    });
                  },
                  items: [null, ...TaskStatus.values].map((TaskStatus? status) {
                    return DropdownMenuItem<TaskStatus?> (
                      value: status,
                      child: Text(status == null ? 'All' : status.toString().split('.').last),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<TaskProvider>(context, listen: false).initTasks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading tasks'));
          }
          return Consumer<TaskProvider>(
            builder: (context, provider, child) {
              final filteredTasks = provider.tasks.where((task) {
                final matchesSearch = task.title.toLowerCase().contains(searchQuery);
                final matchesFilter = selectedFilter == null || task.status == selectedFilter;
                return matchesSearch && matchesFilter;
              }).toList();

              if (filteredTasks.isEmpty) {
                return Center(child: Text('No tasks available'));
              }
              return ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description ?? 'No description'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(task.status.toString().split('.').last),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDeleteTask(context, provider, task),
                        ),
                      ],
                    ),
                    onTap: () {
                      _showTaskDialog(context, provider, task);
                    },
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showTaskDialog(context, Provider.of<TaskProvider>(context, listen: false));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _confirmDeleteTask(BuildContext context, TaskProvider provider, Task task) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                provider.deleteTask(task);
                Navigator.pop(context);
              },
              child: Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showTaskDialog(BuildContext context, TaskProvider provider, [Task? task]) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descriptionController = TextEditingController(text: task?.description ?? '');
    DateTime selectedDate = task?.dueDate ?? DateTime.now();
    TaskStatus selectedStatus = task?.status ?? TaskStatus.pending;
    final formKey = GlobalKey<FormState>();

    String formatDate(DateTime date) {
      return DateFormat('yyyy-MM-dd').format(date);
    }
    
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(task == null ? 'Add Task' : 'Edit Task'),
              content: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                      maxLength: 50,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Title is required';
                        } else if (value.length > 50) {
                          return 'Title cannot exceed 50 characters';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    ListTile(
                      title: Text('Due Date: ${formatDate(selectedDate)}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                    DropdownButton<TaskStatus>(
                      value: selectedStatus,
                      onChanged: (TaskStatus? newStatus) {
                        setState(() {
                          selectedStatus = newStatus!;
                        });
                      },
                      items: TaskStatus.values.map((TaskStatus status) {
                        return DropdownMenuItem<TaskStatus>(
                          value: status,
                          child: Text(status.toString().split('.').last),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      if (task == null) {
                        final newTask = Task(
                          id: DateTime.now().toString(),
                          title: titleController.text,
                          description: descriptionController.text,
                          dueDate: selectedDate,
                          status: selectedStatus,
                        );
                        Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
                      } else {
                        task.title = titleController.text;
                        task.description = descriptionController.text;
                        task.dueDate = selectedDate;
                        task.status = selectedStatus;
                        Provider.of<TaskProvider>(context, listen: false).updateTask(task);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(task == null ? 'Add' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
