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

  List<int> indicesToRemove = [1, 0];

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
            itemCount: taskController.shoppingListItem.value?.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Text(
                    '${taskController.shoppingListItem.value?[index].title}'),
                title: IconButton(
                    onPressed: () {
                      taskController.editTask(
                          'newKitsain$index',
                          'new Des',
                          widget.taskListId,
                          '${taskController.shoppingListItem.value?[index].id}',
                          index);
                    },
                    icon: Icon(Icons.edit)),
                trailing: IconButton(
                    onPressed: () {
                      indicesToRemove.sort((a, b) => b.compareTo(a));

                      // indicesToRemove.forEach((element) {
                      //   print(element);
                      //   taskController.deleteTask(
                      //       widget.taskListId,
                      //       '${taskController.tasksList.value?.items?[element].id}',
                      //       indicesToRemove[element]);
                      // });

                      for (int ind = 0; ind < indicesToRemove.length; ind++) {
                        print(indicesToRemove[ind]);

                        taskController.deleteTask(
                            widget.taskListId,
                            '${taskController.shoppingListItem.value?[indicesToRemove[ind]].id}',
                            indicesToRemove[ind]);
                      }

                      // for (var i = 0; i < 2; i++) {
                      //   taskController.deleteTask(
                      //       widget.taskListId,
                      //       '${taskController.tasksList.value?.items?[index].id}',
                      //       index);
                      // }
                    },
                    icon: Icon(Icons.delete)),
                onTap: () {
                  print('ok');
                  print('${taskController.shoppingListItem.value?[index].id}');
                },
              );
            });
      }),
    );
  }
}
