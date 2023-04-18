import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:kitsain_frontend_spring2023/assets/top_bar.dart';
import 'package:kitsain_frontend_spring2023/LoginController.dart';
import 'package:kitsain_frontend_spring2023/controller/task_controller.dart';
import 'package:kitsain_frontend_spring2023/controller/tasklist_controller.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/user_shopping_list.dart';
import 'package:kitsain_frontend_spring2023/views/edit/edit_shopping_list.dart';
import 'package:kitsain_frontend_spring2023/views/add_forms/add_new_shopping_list_form.dart';

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

  final loginController = Get.put(LoginController());

  void _editList(String listId, int listIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: EditShoppingListForm(listId: listId, listIndex: listIndex),
        );
      },
    );
  }

  _receiveItem(int index, String data) {
    String taskListId = '${taskListController.taskLists.value?.items?[index].id}';
    String title = data;

    taskController.createTask(title, '', taskListId);

    setState(
          () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$data")));
      },
    );

    _openShoppingList(index);
  }

  _openShoppingList(index) async {
    print(
        '${taskListController.taskLists.value?.items?[index].id}');
    await taskController.getTasksList(
        '${taskListController.taskLists.value?.items?[index].id}');

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) =>
                UserShoppingList(
                  taskListIndex: index,
                  taskListId:
                  '${taskListController.taskLists.value?.items?[index].id}',
                  taskListName:
                  '${taskListController.taskLists.value?.items?[index].title}',
                ))));
  }

  void _addNewItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return const FractionallySizedBox(
          heightFactor: 1.0,
          child: NewShoppingListForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'SHOPPING LISTS',
        //title: AppLocalizations.of(context)!.shoppingListsScreen,
        addFunction: _addNewItem,
        addIcon: Icons.post_add,
        helpFunction: _addNewItem,
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: taskListController.taskLists.value?.items?.length,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(15),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  DragTarget<String>(
                    onAccept: (data) => _receiveItem(index, data),
                    builder: (context, candidateData, rejectedData) {
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            width: candidateData.isNotEmpty ? 4 : 1,
                            color: candidateData.isNotEmpty
                                ? Color.fromRGBO(63, 85, 65,
                                    1) //TODO: use the universal style color here instead
                                : Colors.black38,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 5, right: 0, top: 5, bottom: 5),
                          child: ListTile(
                              title: Row(
                                children: [
                                  Text(
                                      '${taskListController.taskLists.value?.items?[index].title}'),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      taskListController.deleteTaskLists(
                                          '${taskListController.taskLists.value?.items?[index].id}',
                                          index);
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                  IconButton(
                                    onPressed: () => _editList(
                                        '${taskListController.taskLists.value?.items?[index].id}',
                                        index),
                                    icon: Icon(Icons.edit),
                                  ),
                                ],
                              ),
                              onTap: () => _openShoppingList(index)
                              /*async {
                                  // print('ok');
                                  print(
                                      '${taskListController.taskLists.value?.items?[index].id}');
                                  await taskController.getTasksList(
                                      '${taskListController.taskLists.value?.items?[index].id}');

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              UserShoppingList(
                                                taskListIndex: index,
                                                taskListId:
                                                    '${taskListController.taskLists.value?.items?[index].id}',
                                                taskListName:
                                                    '${taskListController.taskLists.value?.items?[index].title}',
                                              ))));
                                },*/
                              ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}
