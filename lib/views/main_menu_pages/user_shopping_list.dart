import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/assets/shopping_list_item.dart';
import 'package:kitsain_frontend_spring2023/controller/task_controller.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';
import 'package:kitsain_frontend_spring2023/models/ShoppingListItemModel.dart';

class UserShoppingList extends StatefulWidget {
  const UserShoppingList(
      {super.key,
      required this.taskListIndex,
      required this.taskListName,
      required this.taskListId});

  final int taskListIndex;
  final String taskListName;
  final String taskListId;

  @override
  State<UserShoppingList> createState() => _UserShoppingListState();
}

class _UserShoppingListState extends State<UserShoppingList> {
  final _stateController = Get.put(ItemController());

  _receiveItem(String data) {
    _stateController.shoppingLists[widget.taskListIndex].add(data);

    setState(
      () {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$data")));
      },
    );
  }

  _moveSelectedItemsToPantry() {
    // todo (Currently moves all items, not just selected. Needs to be fixed when real model is available.)
    _stateController.pantryList
        .addAll(_stateController.shoppingLists[widget.taskListIndex]);
    _stateController.shoppingLists[widget.taskListIndex].clear();
  }

  _deselectAll() {
    // todo

    taskController.tasksListRemove.value?.forEach(
      (element) {
        taskController.shoppingListItem.value?[element].checkBox = false;
        print('$element' +
            '${taskController.shoppingListItem.value?[element].checkBox}');
      },
    );
    taskController.tasksListRemove.value?.clear();
    taskController.shoppingListItem.refresh();
  }

  final taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    taskController.tasksListRemove.value?.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: DragTarget(
                    builder: (
                      BuildContext context,
                      List<dynamic> accepted,
                      List<dynamic> rejected,
                    ) {
                      return Text('SHOPPING LISTS');
                    },
                    onMove: (details) {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Icon(Icons.arrow_forward_ios),
                Text('${widget.taskListName}'),
                // todo: change the title to come from the model
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _deselectAll(),
                  child: Text('DESELECT ALL'),
                ),
                SizedBox(
                  width: 15,
                ),
              ],
            ),
            DragTarget<String>(
              onAccept: (data) => _receiveItem(data),
              builder: (context, candidateData, rejectedData) {
                return Obx(
                  () {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: taskController.shoppingListItem.value?.length,
                      padding: EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                taskController.editTask(
                                    '${taskController.shoppingListItem.value?[index].title}$index',
                                    '${taskController.shoppingListItem.value?[index].description}',
                                    widget.taskListId,
                                    '${taskController.shoppingListItem.value?[index].id}',
                                    index);
                              },
                              child: ShoppingListItem(
                                itemName:
                                    '${taskController.shoppingListItem.value?[index].title}',
                                itemDescription: 'Additional descriptionsss',
                                indexToRemove: index,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  // onPressed: _moveSelectedItemsToPantry,
                  onPressed: () async {
                    taskController.tasksListRemove.value?.forEach(
                      (element) async {
                        taskController
                            .shoppingListItem.value?[element].checkBox = false;
                        // print('$element' +
                        //     '${taskController.shoppingListItem.value?[element].title} ' +
                        //     '${taskController.shoppingListItem.value?.length}');

                        await taskController.deleteTask(
                            widget.taskListId,
                            '${taskController.shoppingListItem.value?[element].id}',
                            element);
                      },
                    );

                    taskController.tasksListRemove.value?.clear();
                  },
                  child: Text('Remove Items From List'),
                ),
                OutlinedButton(
                  // onPressed: _moveSelectedItemsToPantry,
                  onPressed: () {
                    // taskController.tasksListRemove.value
                    //     ?.sort((a, b) => b.compareTo(a));

                    taskController.createTask(
                        'newtask', 'descrip', widget.taskListId);

                    print(taskController.tasksListRemove.value?.length);
                    taskController.tasksListRemove.value?.forEach((element) {
                      print('pp  $element');
                    });
                  },
                  child: Text('ADD ITEMS TO PANTRY'),
                ),
              ],
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
