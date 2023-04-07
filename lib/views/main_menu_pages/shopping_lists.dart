import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/controller/task_controller.dart';
import 'package:kitsain_frontend_spring2023/controller/tasklist_controller.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/user_shopping_list.dart';
import 'package:kitsain_frontend_spring2023/views/task_screen.dart';

class ShoppingLists extends StatefulWidget {
  const ShoppingLists({super.key, required this.setActiveShoppingListIndex});

  final Function setActiveShoppingListIndex;

  @override
  State<ShoppingLists> createState() => _ShoppingListsState();
}

class _ShoppingListsState extends State<ShoppingLists> {
  // final _stateController = Get.put(ItemController());

  final taskListController = Get.put(TaskListController());

  final taskController = Get.put(TaskController());

  _openShoppingList(int index) {
    widget.setActiveShoppingListIndex(index);
  }

  _receiveItem(int index, String data) {
    // _stateController.shoppingLists[index].add(data);
    // widget.setActiveShoppingListIndex(index);

    setState(
      () {
        print('index $index  data is $data');
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$data and $index")));
      },
    );

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => TaskScreen(
                  taskListId:
                      '${taskListController.taskLists.value?.items?[index].id}',
                ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: taskListController.taskLists.value?.items?.length,
          padding: EdgeInsets.all(15),
          itemBuilder: (context, index) {
            return Column(
              children: [
                DragTarget<String>(
                  onAccept: (data) => _receiveItem(index, data),
                  builder: (context, candidateData, rejectedData) {
                    return ListTile(
                      shape: Border.all(
                          width: 10,
                          color: candidateData.isNotEmpty
                              ? Colors.red
                              : Colors.black),
                      leading: Text(
                          '${taskListController.taskLists.value?.items?[index].title}'),
                      title: IconButton(
                          onPressed: () {
                            taskListController.editTaskLists(
                                'kitsain$index',
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
                        // print('ok');
                        print(
                            '${taskListController.taskLists.value?.items?[index].id}');
                        await taskController.getTasksList(
                            '${taskListController.taskLists.value?.items?[index].id}');

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => UserShoppingList(
                                      taskListIndex: index,
                                      taskListName:
                                          '${taskListController.taskLists.value?.items?[index].title}',
                                    ))));
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
