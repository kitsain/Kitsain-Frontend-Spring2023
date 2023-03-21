import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:kitsain_frontend_spring2023/google_sign_in.dart';

class HomePage2 extends StatelessWidget {
  HomePage2({super.key});

  final loginController = Get.put(LoginController());

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
                  loginController.googleLogin();
                },
                child: const Text('Google Sign In'),
              ),
              ElevatedButton(
                onPressed: () async {
                  // await loginController.taskApi.value!.tasklists
                  //     .insert(TaskList(title: 'testtle11'), $fields: '')
                  //     .whenComplete(() => print("done"));

// await loginController.taskApi.value!.tasklists.list()

                  await loginController.taskApi.value!.tasks
                      .insert(
                          Task(
                              title: 'testtasktitles',
                              deleted: false,
                              status: 'completed',
                              notes: 'notes describing taskss'),
                          'MDQzNDg5NjY4OTE0NzE0ODQwMjM6MDow')
                      .whenComplete(() => print('done'));
                },
                child: const Text('Create Task'),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: loginController.googleUser.value == null
                        ? 0
                        : loginController.taskLists.value?.items?.length,
                    shrinkWrap: true,
                    itemBuilder: ((context, index) {
                      return Column(
                        children: [
                          Text(
                              '${loginController.taskLists.value?.items?[index].title}'),
                          Text(
                              '${loginController.taskLists.value?.items?[index].id}'),
                        ],
                      );
                    })),
              ),
            ],
          );
        }),
      ),
    );
  }
}
