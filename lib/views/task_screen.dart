import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/controller/task_controller.dart';
import 'package:kitsain_frontend_spring2023/controller/tasklist_controller.dart';

class TaskScreen extends StatefulWidget {
  String taskListId;

  TaskScreen({super.key, required this.taskListId});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('tasks'), actions: [
        IconButton(
            onPressed: () {
              taskController.createTask(
                  'newtask', 'descrip', widget.taskListId);
            },
            icon: Icon(Icons.add)),
      ]),
      body: Obx(() {
        return ListView.builder(
            itemCount: taskController.tasksList.value?.items?.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text(
                    '${taskController.tasksList.value?.items?[index].title}'),
                title: IconButton(
                    onPressed: () {
                      taskController.editTask(
                          'newKitsain',
                          'new Des',
                          widget.taskListId,
                          '${taskController.tasksList.value?.items?[index].id}',
                          index);
                    },
                    icon: Icon(Icons.edit)),
                trailing: IconButton(
                    onPressed: () {
                      taskController.deleteTask(
                          widget.taskListId,
                          '${taskController.tasksList.value?.items?[index].id}',
                          index);
                    },
                    icon: Icon(Icons.delete)),
                onTap: () {
                  print('ok');
                  print('${taskController.tasksList.value?.items?[index].id}');
                },
              );
            });
      }),
    );
  }
}
