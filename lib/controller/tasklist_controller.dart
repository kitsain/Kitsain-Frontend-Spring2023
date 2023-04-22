import 'package:get/get.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:kitsain_frontend_spring2023/LoginController.dart';

class TaskListController extends GetxController {
  var taskLists = Rx<TaskLists?>(null);
  final loginController = Get.put(LoginController());

  getTaskLists() async {
    var tskList =
        await loginController.taskApiAuthenticated.value?.tasklists.list();
    taskLists.value = tskList;
    print(taskLists.value?.items?.length);
  }

  createTaskLists(String name) async {
    // print(tskList?.items?.first.title);
    print(taskLists.value?.items?.length);
    await loginController.taskApiAuthenticated.value!.tasklists
        .insert(TaskList(title: name), $fields: '')
        .then((value) => {
              taskLists.value?.items?.add(value),
              taskLists.refresh(),
              print(taskLists.value?.items?.length),
            });
  }

  deleteTaskLists(String id, int index) async {
    await loginController.taskApiAuthenticated.value!.tasklists
        .delete(id)
        .then((value) => {
              print('done'),
              taskLists.value?.items?.removeAt(index),
              taskLists.refresh(),
            });
  }

  editTaskLists(String name, String id, int index) async {
    var newTaskList = TaskList(title: name, id: id);
    print(id);
    await loginController.taskApiAuthenticated.value!.tasklists
        .update(newTaskList, id)
        .then((value) {
      print('done');
      taskLists.value?.items?[index] = newTaskList;
      taskLists.refresh();
    });
  }
}
