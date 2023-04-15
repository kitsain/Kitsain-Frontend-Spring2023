import 'package:get/get.dart';
import 'package:googleapis/tasks/v1.dart';
import 'package:kitsain_frontend_spring2023/controller/task_controller.dart';

class ShoppingListItemModel {
  late String title;
  late String description;
  late bool checkBox;
  late String id;

  ShoppingListItemModel(this.title, this.description, this.checkBox, this.id);

  final taskController = Get.put(TaskController());
}