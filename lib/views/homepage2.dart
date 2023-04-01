import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:kitsain_frontend_spring2023/controller/tasklist_controller.dart';
import 'package:kitsain_frontend_spring2023/google_sign_in.dart';
import 'package:kitsain_frontend_spring2023/views/tasklists_screen.dart';

class HomePage2 extends StatelessWidget {
  HomePage2({super.key});

  final loginController = Get.put(LoginController());
  final taskListController = Get.put(TaskListController());

  var username = 'Test';

  TaskList taskList1 = TaskList(title: 'testtle');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 150,
              ),
              loginController.googleUser.value == null
                  ? Text(username)
                  : Text(loginController.googleUser.value!.email),
              ElevatedButton(
                onPressed: () async {
                  await loginController.googleLogin();
                  await taskListController.getTaskLists();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => TaskListsScreen())));
                },
                child: const Text('Google Sign In'),
              ),
              ElevatedButton(
                onPressed: () async {
                  loginController.googleSignInUser.value
                      ?.signOut()
                      .whenComplete(() => print('done'));
                },
                child: const Text('Google Sign OUT'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await taskListController.createTaskLists('name');

                  ///creating taskList

                  // await loginController.taskApiAuthenticated.value!.tasklists
                  //     .insert(TaskList(title: 'kitsaintest'), $fields: '')
                  //     .whenComplete(() => print("done"));

                  //// creating task
                  await loginController.taskApiAuthenticated.value!.tasks
                      .insert(
                          Task(
                              title: 'kitsain task',
                              deleted: false,

                              // status: 'completed',
                              notes: 'notes describing taskss'),
                          'MDQzNDg5NjY4OTE0NzE0ODQwMjM6MDow')
                      .whenComplete(() => print('done'));
                },
                child: const Text('Create Task'),
              ),
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                      itemCount: loginController.googleUser.value == null
                          ? 0
                          : taskListController.taskLists.value?.items?.length,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        return Column(
                          children: [
                            Text(
                                '${taskListController.taskLists.value?.items?[index].title}'),
                            Text(
                                '${taskListController.taskLists.value?.items?[index].id}'),
                          ],
                        );
                      }));
                }),
              ),
            ],
          );
        }),
      ),
    );
  }
}
