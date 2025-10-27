import 'package:flutter/material.dart';

import '../../core/helper/database.dart';
import '../data/model/datamodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _editFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _saveFormKey = GlobalKey<FormState>();
  DatabaseHelper dbHelper = DatabaseHelper();
  bool isLoading = false;
  List<Datamodel> tasks = [];
  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    tasks = await dbHelper.getTasks();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> insertData(Datamodel datamodel) async {
    await dbHelper.insert(datamodel);
    await loadData();
  }

  Future<void> deleteData(int id) async {
    await dbHelper.delete(id);
    await loadData();
  }

  Future<void> updateData(Datamodel datamodel) async {
    await dbHelper.update(datamodel);
    await loadData();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Todo List'),
        backgroundColor: colorScheme.primaryContainer,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : tasks.isEmpty
                ? const Center(child: Text('No Tasks Added'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      var task = tasks[index];
                      return Card(
                        elevation: 4,
                        child: ListTile(
                          title: Text(task.title),
                          subtitle: task.description.isEmpty
                              ? null
                              : Text(task.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                color: colorScheme.onPrimaryContainer,
                                onPressed: () {
                                  titleController.text = task.title;
                                  descriptionController.text = task.description;
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Edit Task'),
                                        content: Form(
                                          key: _editFormKey,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: titleController,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText: 'Task Title'),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.trim().isEmpty) {
                                                    return 'Title cannot be empty';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              const SizedBox(height: 8),
                                              TextFormField(
                                                controller:
                                                    descriptionController,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            'Task description'),
                                              ),
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              if (_editFormKey.currentState!
                                                  .validate()) {
                                                await updateData(Datamodel(
                                                  id: task.id,
                                                  title: titleController.text,
                                                  description:
                                                      descriptionController
                                                          .text,
                                                ));
                                                if (mounted) setState(() {});
                                              }
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text('Delete Task'),
                                        content: const Text(
                                            'Are you sure you want to delete this task?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(
                                                foregroundColor: Colors.red),
                                            onPressed: () async {
                                              Navigator.of(context).pop();
                                              await deleteData(task.id!);
                                              if (mounted) setState(() {});
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: colorScheme.primaryContainer,
        onPressed: () {
          titleController.clear();
          descriptionController.clear();
          addTaskDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> addTaskDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Form(
            key: _saveFormKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  validator: (value) =>
                      value!.isEmpty ? 'Title cannot be empty' : null,
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: 'Task Title',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Task description',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_saveFormKey.currentState!.validate()) {
                  insertData(Datamodel(
                    title: titleController.text,
                    description: descriptionController.text,
                  ));
                  if (mounted) setState(() {});
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
