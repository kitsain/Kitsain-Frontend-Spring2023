import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kitsain_frontend_spring2023/assets/shopping_list_item.dart';
import 'package:kitsain_frontend_spring2023/controller/task_controller.dart';
import 'package:kitsain_frontend_spring2023/item_controller.dart';

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
  }
  final taskController = Get.put(TaskController());

  List<int> indicesToRemove = [1, 0];

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
                      itemCount: taskController.tasksList.value?.items?.length,
                      padding: EdgeInsets.all(15),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ShoppingListItem(
                              itemName: 'name $index',
                              itemDescription: 'Additional descriptionsss',
                              indexToRemove: index,
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
            OutlinedButton(
              // onPressed: _moveSelectedItemsToPantry,
              onPressed: () {
                taskController.tasksListRemove.value
                    ?.sort((a, b) => b.compareTo(a));
                taskController.tasksListRemove.value?.forEach((element) {
                  print('pp  $element');
                });
              },
              child: Text('ADD ITEMS TO PANTRY'),
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
