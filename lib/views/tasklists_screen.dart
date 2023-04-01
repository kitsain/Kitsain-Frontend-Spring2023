import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/controller/task_controller.dart';
import 'package:kitsain_frontend_spring2023/controller/tasklist_controller.dart';
import 'package:kitsain_frontend_spring2023/views/task_screen.dart';

class TaskListsScreen extends StatefulWidget {
  const TaskListsScreen({super.key});

  @override
  State<TaskListsScreen> createState() => _TaskListsScreenState();
}

class _TaskListsScreenState extends State<TaskListsScreen> {
  final taskListController = Get.put(TaskListController());

  final taskController = Get.put(TaskController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('tasklists'), actions: [
        IconButton(
            onPressed: () {
              taskListController.createTaskLists('testtasklist');
            },
            icon: Icon(Icons.add)),
      ]),
      body: Obx(() {
        return ListView.builder(
            itemCount: taskListController.taskLists.value?.items?.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text(
                    '${taskListController.taskLists.value?.items?[index].title}'),
                title: IconButton(
                    onPressed: () {
                      taskListController.editTaskLists(
                          'kitsain',
                          '${taskListController.taskLists.value?.items?[index].id}',
                          index);
                    },
                    icon: Icon(Icons.edit)),
                trailing: IconButton(
                    onPressed: () {
                      taskListController.deleteTaskLists(
                          '${taskListController.taskLists.value?.items?[index].id}',
                          index);
                    },
                    icon: Icon(Icons.delete)),
                onTap: () async {
                  print('ok');
                  print(
                      '${taskListController.taskLists.value?.items?[index].id}');
                  await taskController.getTasksList(
                      '${taskListController.taskLists.value?.items?[index].id}');

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => TaskScreen(
                                taskListId:
                                    '${taskListController.taskLists.value?.items?[index].id}',
                              ))));
                },
              );
            });
      }),
    );
  }
}
