import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:kitsain_frontend_spring2023/assets/top_bar.dart';
import 'package:kitsain_frontend_spring2023/LoginController.dart';
import 'package:kitsain_frontend_spring2023/controller/task_controller.dart';
import 'package:kitsain_frontend_spring2023/controller/tasklist_controller.dart';
import 'package:kitsain_frontend_spring2023/views/add_new_shopping_list_form.dart';
import 'package:kitsain_frontend_spring2023/views/homepage2.dart';
import 'package:kitsain_frontend_spring2023/views/main_menu_pages/user_shopping_list.dart';
import 'package:kitsain_frontend_spring2023/views/task_screen.dart';
import 'package:kitsain_frontend_spring2023/views/edit/edit_shopping_list.dart';

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

  signOut() async {
    await loginController.googleSignInUser.value?.signOut();

    // loginController.googleUser.close();
    // loginController.googleSignInUser.close();
    // taskController.tasksList.close();
    // taskController.tasksListRemove.close();
    // taskListController.taskLists.close();
    // Navigator.pop(context);

    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage2()), (route) => false);

    // Navigator.push(
    //     context, MaterialPageRoute(builder: ((context) => HomePage2())));
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
          //title: AppLocalizations.of(context)!.shoppingListScreen,
          addFunction: _addNewItem,
          addIcon: Icons.post_add,
          helpFunction: _addNewItem,
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '${loginController.googleUser.value?.email}',
                ),
                Icon(Icons.arrow_forward_ios),

                TextButton(
                  onPressed: () {
                    signOut();
                  },
                  child: Text('LOG OUT'),
                ),
                // todo: change the title to come from the model
              ],
            ),
            Obx(() {
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
                          return ListTile(
                            shape: Border.all(
                                width: 10,
                                color: candidateData.isNotEmpty
                                    ? Colors.red
                                    : Colors.black),
                            leading: Text(
                                '${taskListController.taskLists.value?.items?[index].title}'),
                            title: IconButton(
                                onPressed: () => _editList(
                                    '${taskListController.taskLists.value?.items?[index].id}',
                                    index),
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
                                            taskListId: '${taskListController.taskLists.value?.items?[index].id}',
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
          ],
        ),
      ),
    );
  }
}
