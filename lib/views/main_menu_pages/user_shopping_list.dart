import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app-localizations.dart';
import 'package:kitsain_frontend_spring2023/assets/shopping_list_item.dart';
import 'package:kitsain_frontend_spring2023/assets/top_bar.dart';
import 'package:kitsain_frontend_spring2023/controller/task_controller.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';
import 'package:kitsain_frontend_spring2023/views/add_new_shopping_list_item_form.dart';

class UserShoppingList extends StatefulWidget {
  const UserShoppingList(
      {super.key, required this.taskListIndex, required this.taskListId, required this.taskListName});

  final int taskListIndex;
  final String taskListId;
  final String taskListName;

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
    _stateController.pantryList
        .addAll(_stateController.shoppingLists[widget.taskListIndex]);
    _stateController.shoppingLists[widget.taskListIndex].clear();
  }

  _deselectAll() {
    taskController.tasksListRemove.value?.forEach(
          (element) {
        taskController.shoppingListItem.value?[element].checkBox = false;
        print('$element' +
            '${taskController.shoppingListItem.value?[element].checkBox}');
      },
    );

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

  void _addNewItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1.0,
          child: NewShoppingListItemForm(taskListId: widget.taskListId,),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // these are here so that the buttons on the bottom will never overflow off screen
    double fullWidth = MediaQuery.of(context).size.width;
    double paddingWidth = fullWidth * 0.08;
    double bottomButtonWidth = (fullWidth - (3 * paddingWidth)) / 2;

    return Scaffold(
      appBar: TopBar(
        title: 'SHOPPING LISTS',
        //title: AppLocalizations.of(context)!.shoppingListScreen,
        addFunction: _addNewItem,
        addIcon: Icons.add_shopping_cart,
        helpFunction: _addNewItem,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(paddingWidth),
        child: Column(
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
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
                const SizedBox(width: 2),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,                                                     // TODO: base this on the font size of surrounding text
                                                                                // TODO: e.g., fontsize 16 => icon size 16
                ),
                const SizedBox(width: 2),
                Text(widget.taskListName),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => _deselectAll(),
                    child: Text('DESELECT ALL'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    )),
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
                                itemId:
                                    '${taskController.shoppingListItem.value?[index].id}',
                                itemName:
                                    '${taskController.shoppingListItem.value?[index].title}',
                                itemDescription:
                                    '${taskController.shoppingListItem.value?[index].description}',
                                itemIndex: index,
                                listId: widget.taskListId,
                              ),
                            ),
                            const SizedBox(
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
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: bottomButtonWidth,
                  child: OutlinedButton(
                    // onPressed: _moveSelectedItemsToPantry,
                    onPressed: () async {
                      taskController.tasksListRemove.value?.forEach(
                        (element) async {
                          taskController.shoppingListItem.value?[element]
                              .checkBox = false;
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
                    child: Text(
                      'Remove Items From List',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  width: bottomButtonWidth,
                  child: OutlinedButton(
                    // onPressed: _moveSelectedItemsToPantry,
                    onPressed: () {
                      // taskController.tasksListRemove.value
                      //     ?.sort((a, b) => b.compareTo(a));

                      /*taskController.createTask(
                          'newtask', 'descrip', widget.taskListId);

                      print(taskController.tasksListRemove.value?.length);
                      taskController.tasksListRemove.value?.forEach((element) {
                        print('pp  $element');
                      });*/
                    },
                    child: Text(
                      'ADD ITEMS TO PANTRY',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
