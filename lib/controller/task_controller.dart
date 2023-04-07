import 'package:get/get.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:kitsain_frontend_spring2023/google_sign_in.dart';

class TaskController extends GetxController {
  var tasksList = Rx<Tasks?>(null);

  var tasksListRemove = Rx<List<int>?>([]);

  final loginController = Get.put(LoginController());

  getTasksList(String taskListId) async {
    var tskList = await loginController.taskApiAuthenticated.value?.tasks
        .list(taskListId);

    tasksList.value = tskList;
    tasksList.refresh();
  }

  createTask(String title, String description, String taskListId) async {
    var newTask = Task(title: title, notes: description, status: "needsAction");

    await loginController.taskApiAuthenticated.value!.tasks
        .insert(newTask, taskListId)
        .then((value) async {
      // print('ok ${value.id}');

      await getTasksList(taskListId);
      // tasksList.value?.items?.add(value);
      tasksList.refresh();
    });
  }

  editTask(String title, String description, String taskListId, String taskId,
      int index) async {
    var newTask = Task(
        title: title, notes: description, status: "needsAction", id: taskId);

    // print('tlid ' + taskListId + ' tid ' + taskId);

    await loginController.taskApiAuthenticated.value!.tasks
        .update(
      newTask,
      taskListId,
      taskId,
    )
        .then((value) async {
      await getTasksList(taskListId);
      // tasksList.value?.items?[index] = newTask;
      tasksList.refresh();
    });
  }

  deleteTask(String taskListId, String taskId, int index) async {
    // print(' $taskListId    $taskId     $index     ');

    await loginController.taskApiAuthenticated.value!.tasks
        .delete(
      taskListId,
      taskId,
    )
        .then((value) async {
      await getTasksList(taskListId);
      // tasksList.value?.items?.removeAt(index);
      tasksList.refresh();
    });
  }
}
