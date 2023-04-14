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
      {super.key, required this.taskListIndex, required this.taskListName});

  final int taskListIndex;
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
    // todo (Currently moves all items, not just selected. Needs to be fixed when real model is available.)
    _stateController.pantryList
        .addAll(_stateController.shoppingLists[widget.taskListIndex]);
    _stateController.shoppingLists[widget.taskListIndex].clear();
  }

  _deselectAll() {
    // todo

    taskController.tasksListRemove.value?.clear();
  }

  final taskController = Get.put(TaskController());

  List<int> indicesToRemove = [1, 0];

  void _addNewItem() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: NewShoppingListItemForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
          title: AppLocalizations.of(context)!.shoppingListScreen,
          addFunction: _addNewItem,
          addIcon: Icons.add_shopping_cart,
          helpFunction: _addNewItem,
        ),
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
                      itemCount: taskController.tasksList.value?.items?.length,
                      padding: EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ShoppingListItem(
                              itemName:
                                  '${taskController.tasksList.value?.items?[index].title}',
                              itemDescription: 'Additional descriptionsss',
                              indexToRemove: index,
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
                  onPressed: () {
                    // taskController.tasksListRemove.value
                    //     ?.sort((a, b) => b.compareTo(a));
                    taskController.tasksListRemove.value?.forEach((element) {
                      print('pp  $element');
                    });
                  },
                  child: Text('Remove Items From List'),
                ),
                OutlinedButton(
                  // onPressed: _moveSelectedItemsToPantry,
                  onPressed: () {
                    // taskController.tasksListRemove.value
                    //     ?.sort((a, b) => b.compareTo(a));

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
